# origin: http://poshcode.org/6321
$VerbosePreference = 'continue'
# Get Start Time
$StartTime = (Get-Date)

<#
  How to create a non blocking Graphical User Interface (GUI) with Windows Presentation Foundation (WPF)
  and how to write Data with PowerShell to GUI controls correctly from a different thread (Runspace).
    
  What you can get with this solution:
    - you can use the Visual designer of the free Visual Studio to create the XAML design-code of the GUI or
      you can write the XAML for the GUI with any Editor and use the XAML with my solution.
    - You can reimport the XAML from PowerShell to Visual Studio (and vice versa) if you have used the Visual Designer from Visual Studio
      so you can modify the GUI in the designer of the free Visual Studio
    - this solution does not need any module or installation and can be easely included into any script by copy and paste.
    
  My goal was to run the GUI in a background thread, so that the main Windows PowerShell runspace thread is free to use like a normal PowerShell script. 
 
  You can even use the Windows PowerShell module ShowUI to create WPF GUI with PowerShell.
  I did not use ShowUI for my WPF GUI work for the following reasons:
    - with all your scripts using ShowUI, you have to ship and install ShowUI
    - ShowUI first run on a system takes long 'compiling' time
    - ShowUI is mostly overkill to the task to show a 'simple' WPF GUI

  The following writing is to help you to understand the what and why of WPF GUI threading.
  
  Windows PowerShell was designed to run inside the console or to doing remote work to other systems.
  	That is why Windows PowerShell has only one execution path, it is a single threaded application.
  In computer programming, single threading is the processing of one command at a time.
  So one command can only run serial one after the other.
  
  Events; the message loop
  
  Applications that have a Graphical User Interface (GUI) must be an event based Application, to have the ability to react on User input and other events.
  Events are messages that the Windows operating system posts or receive to/from a thread of the application.
  
  An application can even send himself messages to do an event based processing.
  A message queue is used to implement an uninterruptible message send and receive process, from and to the Windows operating system.
  A thread which is interested to receive or send event messages has to register (connect) a message queue to the Windows operating system.
  The Windows operating system and the Application are putting messages into the queue (enqueu) or pulling the messages out of the queue (dequeu). 
  Both are doing this in an endless running loop. That is the so called "event loop" or "message pump".

  Normally a application is doing work all the time and it is following his execution thread path. 
  An event based application is idle most of the time in his event loop. The message queue of the application is waiting for an particular event message, it is doing a message subscription.
  If the awaited event message occurs a method bound to the event subscription is processed.
  After finishing the method processing the application returns to the idle state and is waiting for the next event.
  The binding from the event loop message to the execution method is done by an event delegate.
  A delegate is a address pointer which points to the address of the method to invoke. 
  
  Typically Windows PowerShell does not need to react to events.
  So Windows PowerShell is not designed to be an event based Application.
  Console Applications and Windows PowerShell does not have a event message loop!
  
  So if you like to create a Graphical User Interface with Windows PowerShell you have to activate the event message loop manually and you have to do multithreading.
  So be warned!
    Windows PowerShell is not designed to run a GUI.
    Be aware that running a GUI inside of Windows PowerShell can have unexpected side effects! 
  
  If PowerShell creates a Graphical User Interface (GUI) and should do other things (in the background) it
  cannot react on events that are produced by the GUI because it is single threaded.
  If you run the endless event message loop inside the Windows PowerShell thread, the thread is blocked by this loop.
  So creating applications that are responsive to the User takes some careful planning,
  which usually entails having long-running processes work in other threads so that the UI thread is free to keep up with the user. 
  
  Each process which is running inside the Windows operating system has one processing thread (the main thread) by default.
  (you can create even processes without a thread, but this makes no sense.)

  To force PowerShell to do 2 things at the same time you can use PowerShell Jobs or use PowerShell runspaces.
  Each PowerShell Job is running inside his own Windows Process. This is called multi processing.
  Every process running on a Windows operating system, was given a private processing environment from the Windows operating system and the operating system shields on process to another. 
  So Processes can not sharing objects to each other easely.
  A process can have more then one thread inside his execution environment.
  Because the threads are running all inside the process private memory space they can share object mor easely.
  Running more then one execution thread inside a process is called multithreading.
  With multithreading you can have more then one parallel execution paths inside a Windows execution process.

  Each PowerShell pipeline runspaces owns one thread. So a Runspace can be seen as a thread running inside the PowerShell process.
  So we use runspaces to run the GUI on his own thread, inside one Windows PowerShell process.     
  So the word 'thread' and 'runspace' (or 'pipeline') are used sometimes interchangeably here.

  If you like to build responsive GUI interfaces, you have to use 2 threads.
  One thread for which is doing the normal PowerShell non GUI work and one thread which runs the GUI.
  For real all WPF applications start out with two important threads, one for rendering which is responsible for the paint actions and one for managing the user interface.
  The rendering thread is running in the background without interaction, so if we talk about GUI we talk only about the one user interface thread. 
  
  To deal with more then one thread inside a application process is very easy when there is no need to share data between the threads.
  If you have to share data beween threads you have to take care that the data are staying in a consistent state and you have to synchronize the point of time when to transfer the data.
  This sounds easy but multithreaded programs are complex and difficult to debug, even the biggest .NET devolpers are screwed up with that task. 
  
  When you need to access GUI controls from a thread that does not own the GUI controls you have to do cross thread calls.
  This cross thread calls can damage the state of a GUI control and even the state of the whole application.
  Access to GUI controls is not inherently thread safe.
  If you have two or more threads manipulating the state of a control at the same time,
  it is possible to force the control into an inconsistent state.
  Other thread-related bugs are possible as well, including race conditions and deadlocks.
  So you have to manage (to synchronize) the access to your controls and make Shure that the access is done in a thread-safe way.
  The.NET Framework offers some synchronizing primitives to archive this.
  (see: Overview of Synchronization Primitives; https://msdn.microsoft.com/en-us/library/ms228964%28v=vs.110%29.aspx)

  There are some examples that show the use of a synchronized hash table to manage thread safe calls to controls with Windows PowerShell.
  But even enumerating through a synchronized collection is intrinsically not a thread-safe procedure.
  Even when a collection is synchronized, other threads can still modify the collection, which causes the enumerator to throw an exception.
  (see: https://msdn.microsoft.com/en-us/library/system.collections.icollection.issynchronized.aspx)
  Synchronized collections are having an additional processing overhead, that we can avoid.
    

  Microsoft has designed the controls of the Windows Presentation Foundation (WPF) very strict in case of cross thread calls.
  WPF is a Single Thread Appartment (STA) based application.
  The philosophy comes from COM world, where by doing STA, the developer is not worried about threading as the system will guarantee only one thread will execute the code. 
  You cannot update any WPF GUI control from a thread that doesn't own (created) the control.
  You have to use a dispatching proxy mechanism called the dispatcher.
  This solves the cross thread problems. 

  So what is a dispatcher?

  A dispatcher performs the work for the message pump of a thread.
  Each thread can have only one dispatcher.
  The dispatcher waits for and dispatches events or messages for a thread inside a process.
  The WPF dispatcher sits on top of the windows message loop.
  The execution loop in the Dispatcher is called the "Dispatcher Frame". 
  Every Visual (Button, Textbox, Combobox, etc.) inherits from DispatcherObject.
  This object is what allows you to get a hold of the GUI thread's Dispatcher.

  Links:
    Look into the Microsoft Developer Network (MSDN) for documentation of the used classes here!!!!!!!

    An outstanding article about the Windows Presentation Foundation (WPF) threading model you can find here:
    Threading Model
    https://msdn.microsoft.com/en-us/library/ms741870%28v=vs.110%29.aspx

    Dispatcher in WPF: Under the hood by Atul Gupta
    http://www.infosysblogs.com/microsoft/2013/09/dispatcher_in_wpf_under_the_ho.html

    DispatcherFrame. Look in-Depth
    http://www.codeproject.com/Articles/152137/DispatcherFrame-Look-in-Depth

    Launching a WPF Window in a Separate Thread, Part 1
    http://reedcopsey.com/2011/11/28/launching-a-wpf-window-in-a-separate-thread-part-1/

    PowerShell and WPF: Writing Data to a UI From a Different Runspace by Boe Prox
    http://learn-powershell.net/2012/10/14/powershell-and-wpf-writing-data-to-a-ui-from-a-different-runspace/
  
    Build More Responsive Apps With The Dispatcher by Shawn Wildermuth
    https://msdn.microsoft.com/en-us/magazine/cc163328.aspx

    I like to thank Matt Graeber to show how to create a [Func] delegate with PowerShell
    Working with Unmanaged Callback Functions in PowerShell
    http://www.exploit-monday.com/2013/06/PowerShellCallbackFunctions.html
#>

Write-Host "Main Thread ID = $([System.Threading.Thread]::CurrentThread.ManagedThreadId)" -ForegroundColor Cyan

# The Text-XAML representation which describes the WPF GUI, is converted into an System.Xml.XmlDocument
$Xaml = @'
<Window x:Class="WpfApplication1.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        x:Name="Window" Title="Employees Dialog" Height="350" Width="525">
    <Window.Resources>
        <Style x:Key="myListboxStyle">
            <Style.Resources>
                <!-- Background of selected item when focussed -->
                <SolidColorBrush x:Key="{x:Static SystemColors.HighlightBrushKey}" Color="Orange" />
                <!-- Background of selected item when not focussed -->
                <SolidColorBrush x:Key="{x:Static SystemColors.ControlBrushKey}" Color="LightGreen" />
            </Style.Resources>
        </Style>
    </Window.Resources>
    <DockPanel>
        <Grid DockPanel.Dock="Bottom" Height="Auto">
            <Grid.ColumnDefinitions>
                <ColumnDefinition />
                <ColumnDefinition />
            </Grid.ColumnDefinitions>
            <Grid.RowDefinitions>
                <RowDefinition />
            </Grid.RowDefinitions>
            <StackPanel Height="Auto" HorizontalAlignment="Left" Orientation="Horizontal" Grid.Column="0">
                <ProgressBar x:Name="PrgBar" Height="21.96" Width="200"  HorizontalAlignment="Left"/>
                <Label x:Name="LblPrgBar" Content="" HorizontalAlignment="Left" />
            </StackPanel>
            <StackPanel Height="Auto" HorizontalAlignment="Right" Orientation="Horizontal" Grid.Column="1">
                <Button x:Name="BtnOK" Width="80" Margin="3">OK</Button>
                <Button x:Name="BtnCancel" Width="80" Margin="3">Exit</Button>
            </StackPanel>
        </Grid>
        <Grid DockPanel.Dock="Bottom" Height="Auto">
            <Grid.ColumnDefinitions>
                <ColumnDefinition />
                <ColumnDefinition />
            </Grid.ColumnDefinitions>
            <Grid.RowDefinitions>
                <RowDefinition />
                <RowDefinition />
                <RowDefinition Height="11"/>
            </Grid.RowDefinitions>
            <CheckBox x:Name="ChBxDirector" Margin="2" Grid.Row="0" Grid.Column="0" Content="Director"/>
            <RadioButton x:Name="ChBxFemale" Margin="2" Grid.Row="0" Grid.Column="1" Content="Female"/>
            <CheckBox x:Name="ChBxSalaryEarner" Margin="2" Grid.Row="1" Grid.Column="0" Content="Salary earner"/>
            <RadioButton x:Name="ChBxMale" Margin="2" Grid.Row="1" Grid.Column="1" IsChecked="True" Content="Male"/>
        </Grid>
        <Grid>
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="2*" />
                <ColumnDefinition Width="*" />
            </Grid.ColumnDefinitions>
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto" />
                <RowDefinition />
                <RowDefinition Height="11"/>
            </Grid.RowDefinitions>
            <Label x:Name="LblEmployees" Grid.Row="0" Grid.Column="0" Background="Black"              
           Foreground="WhiteSmoke" Content="List of all employees"/>
            <ListBox x:Name="LBxEmployees" Margin="5,5" Grid.Row="1" Background="WhiteSmoke" Style="{StaticResource myListboxStyle}">
                <ListBoxItem Content="Miller, Peter"/>
                <ListBoxItem Content="Fischer, Michael"/>
                <ListBoxItem Content="Willies, Roger"/>
                <ListBoxItem Content="Schwartz, Barack"/>
                <ListBoxItem Content="Mayer, June"/>
            </ListBox>
            <StackPanel Grid.Row="1" Grid.Column="1">
                <Button x:Name="BtnNewEmployee" Margin="5" Content="New ..."/>
                <Button x:Name="BtnRemoveEmployee" Margin="5" Content="Remove"/>
            </StackPanel>
        </Grid>
    </DockPanel>
</Window>
'@

# create the Runspace we need for the Pipeline, the Runspace is bound to the current Host
$Runspace =[System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspace($Host)
# set the options to use with the pipeline execution thread (The GUI thread)
# WPF needs Single Thread Appartment (STA)!
$Runspace.ApartmentState = 'STA'
$Runspace.ThreadOptions = 'ReuseThread'
# open runspace        
$Runspace.Open()

# let the Runspace create a pipeline from a scriptblock for us
$GuiPipelineThread = $Runspace.CreatePipeline({   
 
  # Stop on all Errors occuring in this pipeline thread
  $ErrorActionPreference = 'Stop'
  $VerbosePreference = 'continue'
 
  Try {
 
      Write-Host "GUI Thread ID = $([System.Threading.Thread]::CurrentThread.ManagedThreadId)" -ForegroundColor Cyan
      
      # Import the Assemblies
      Add-Type –assemblyName PresentationFramework
      Add-Type –assemblyName PresentationCore
      Add-Type –assemblyName WindowsBase

      # Create our Dispatcher for the Thread and install it in the current context
      [System.Threading.SynchronizationContext]::SetSynchronizationContext((New-Object -TypeName 'System.Windows.Threading.DispatcherSynchronizationContext' -ArgumentList ([System.Windows.Threading.Dispatcher]::CurrentDispatcher)))
 
      # Create the Application object to make it possible to use WPF rescources (like brushes and so on..)
      # If a Application object is already here a exception is thrown
      $Application = New-Object -TypeName 'System.Windows.Application'

      # Extract the Input from the $input variable
      # because the input is a collection we need a pipeline to extract and to make single
      [XML]$Xaml = $Input | ForEach-Object {$_}
        
      # The the x:class Attribute is added by the Visual Studio designer to connect to the code behind
      # we remove the x:class Attribute wich is not needed inside PowerShell (we have no code behind)
      $XAML.Window.RemoveAttribute('x:Class')

      # Get the names of the desired controls out of the XAML x: namespace
      $XmlNamespace = @{ x = 'http://schemas.microsoft.com/winfx/2006/xaml'}
      $ControlNames = Select-Xml -Xml $Xaml -XPath '//@x:Name' -Namespace $XmlNamespace  | ForEach-Object {$_.node.'#text'}
  
      # Create XmlNodeReader with XML-XAML text
      $XmlNodeReader = (New-Object -TypeName 'System.Xml.XmlNodeReader' -ArgumentList $XAML)
    
      # Create WPF Window from the XML-XAML content of the  XmlNodeReader, with the help of the XamlReader
      # the window MUST be created at this GUI thread
      [System.Windows.Window]$Window = [System.Windows.Markup.XamlReader]::Load($XmlNodeReader)
 
      # you can access some controls only if the window is fully loaded
      # so we must ensure that the window is fully loaded and ready to use.
      # the window has no load function, we are forced to use the Show() method for this
      # between a call to Show() and the fully loaded state, there is a time gap
      # If you call Hide() directly after Show() the window is blinking one time, that is irritating 
      # to 'hide' the window without a blink until the window is fully loaded  
      # we set some values to 'show' the window fully hidden
      
      # save values to restore it later
      $WindowWidth = $Window.Width
      $WindowHeight = $Window.Height
      $WindowStyle = $Window.WindowStyle

      $Window.Width = 0
      $Window.Height = 0
      $Window.WindowStyle = [System.Windows.WindowStyle]::None
      $Window.ShowInTaskbar = $False
      $Window.ShowActivated = $False
     
      # Create the synchronized-hashtable to hold the thread-shared objects
      $GUI = [HashTable]::Synchronized(@{})
      $Gui.Add('Application',$Application) 
 
      $Script:GuiIsReadyToUse = $False

      $Window.add_Loaded({
        
        Write-Verbose 'Windows is Loaded!'

        # we add each named control to the $GUI hashtable to access each control easely over his name
        ForEach($ControlName in $ControlNames){
          $Control = $Window.FindName($ControlName)
          If($Control){
            Write-Verbose "Adding control $ControlName"
        
            $Gui.Add($ControlName,$Control)
          } Else {
            Write-Warning "Control with name: $ControlName not found in Window!"
          }
        }        
               
        $Window.Width = $WindowWidth
        $Window.Height = $WindowHeight
        $Window.WindowStyle = $WindowStyle
        $Window.ShowInTaskbar = $True
        $Window.ShowActivated = $True

        $Script:GuiIsReadyToUse = $True
      })
  
      $Window.Show()

      # we set the timeout to wait for the loading of the window to 3 seconds (60 loops * 50 ms) 
      for ($i = 0; $i -lt 60 ; $i++) { 
        If($Script:GuiIsReadyToUse) {
          Write-Verbose 'Window is loaded and GUI is ready to use'
          break
        }
        Write-Verbose "Waiting Window is Loaded and GUI ready; round: $i" -Verbose
        Start-Sleep -Milliseconds 50
      }
      If(-not $Script:GuiIsReadyToUse) {
        Throw 'Timeout to Load the window, something went wrong!'
        Exit
      }
      Write-Output $GUI

      # The Application is the owner of the Dispatcher 
      # Start the Dispatcher processing through the Application object, to react to UI events and do painting.
      # this makes this thread a UI Thread and occupies this pipeline-thread in a blocking manner
      #[System.Windows.Threading.Dispatcher]::Run()
      $Application.Run()
 
  } Catch {
    Write-Verbose "Catching Error in Runspace $_"
    Write-Output $Error[0]
  } Finally {
    [System.Windows.Threading.Dispatcher]::CurrentDispatcher.BeginInvokeShutdown(([System.Windows.Threading.DispatcherPriority]::Background))
  }
})

# start the GUI thread of the pipeline asynchronous
# the thread waits now for input from the PipelineWriter
# see documentation of the 'System.Management.Automation.Runspaces.Pipeline' class
$GuiPipelineThread.InvokeAsync()
# pass input into the pipeline this input can be found inside the $input variable inside the pipeline
# see documentation of the 'System.Management.Automation.Runspaces.PipelineWriter' class
$Null = $GuiPipelineThread.Input.Write($Xaml)
# as long as we do not close the input writer, the pipeline is waiting for input and is not running! 
$GuiPipelineThread.Input.Close()
# now finally, the pipeline is running....

### the hashtable to hold all GUI objects
#$GuiPipelineOutput = $GuiPipelineThread.Output.Read() #@{}
#
#$GuiPipelineOutput
#
#$GUI = $GuiPipelineOutput


# Try to read 1 objects from the GUI thread pipeline1
for ($i = 0; $i -lt 1; $i++) { 
  # the Output.Read() method waits for an output in the output reader
  # so this thread is blocked until the pipeline puts an object in the output!
  # we use this behavior to do time synchronisation with the GUI thread 
  # see documentation of the 'System.Management.Automation.Runspaces.PipelineReader' class
  $GuiPipelineOutput = $GuiPipelineThread.Output.Read()

  # test for Errors 
  # I did not got the $GuiPipelineThread.Error.Read() ErrorReader to work.
  # So I use a workaround here to test the output if it is an ErrorRecord
  switch ($GuiPipelineOutput)
  {
      {$_ -is [System.Management.Automation.ErrorRecord]} {
          Write-Error $GuiPipelineOutput
          Exit
        }
      {$_ -is [System.Collections.Hashtable]} {
          $Gui = $GuiPipelineOutput
        }
 #     {$_ -is [System.Windows.Application]} {
 #         $Gui.Add('Application',$GuiPipelineOutput)
 #       }
 #     {$_ -is [System.Windows.Threading.DispatcherTimer]} {
 #         $Gui.Add('DispatcherTimer',$GuiPipelineOutput)
 #       }
      Default {
        Write-Error -Message "Unknowen object recieved from runspace thread: $($GuiPipelineOutput.GetType().Fullname) "
        Exit
      }
  }
}

$Gui

# set the content of a GUI control
# because this returns no data we can use the [Action] delegate to do this
# you have to do this through the dispatcher and it is running on the GUI thread
$Gui.BtnCancel.Dispatcher.Invoke('Normal',[Action]{$Gui.BtnCancel.Content='Cancel'})

# Example how to add a scriptblock to  a GUI event
# here we use the click event of the Ok button
# the dispatcher is not needed here because the scriptblock is not executed on the GUI thread
# the GUI is triggering only the scriptblock and it is executed on the current main thread
$Gui.BtnOK.add_Click({Write-Host 'Button OK was clicked!' -ForegroundColor Magenta})

# Example to read something out of a GUI control with a return value
# because this returns data we have to use the [Func[<TypeName>]] delegate to do this
# the <TypeName> can be a universal type name like [Object] or a specific type like [System.String] so you can work strongly typed
# to work strongly typed has more advantages but can throw errors if the type does not fit  
$GUI.LblEmployees.Dispatcher.Invoke([System.Windows.Threading.DispatcherPriority]::Normal,[Func[Object]]{$GUI.LblEmployees.Content})
# do the same as a strongly typed call
$GUI.LblEmployees.Dispatcher.Invoke([System.Windows.Threading.DispatcherPriority]::Normal,[Func[System.String]]{$GUI.LblEmployees.Content})


# complex example to select a listbox item
# define a variable with the text of the item to select
# this value is passed into the scriptblock which is executed by
# the dispatcher + delegate on the GUI thread
$SearchText = 'Schwartz, Barack'

# the index of the selected item is returned into the $SelectedIndex variable
$SelectedIndex = $GUI.LBxEmployees.Dispatcher.Invoke('Normal',[Func[Int32]]{ & {

  param([String]$ItemText)

  for ($i = 0; $i -lt $GUI.LBxEmployees.Items.count; $i++)
  { 
        if(($GUI.LBxEmployees.Items[$i]).content -eq $ItemText)
        {
                $GUI.LBxEmployees.SelectedItem = $GUI.LBxEmployees.Items[$i]
                # return the index integer value to the main thread through the delegate 
                Write-Output $i
                break
        }
  }

}$SearchText})
#
# show the value of the $SelectedIndex variable on the PowerShell Host ($Host)
Write-Host "The index of the selected Item is: $SelectedIndex" -ForegroundColor Magenta

# example to report progress to progressbar
# long running task should NEVER run on the GUI thread
# so we have to report progress to the GUI through the dispatcher
# simulating long running work with a for loop
for ($i = 0; $i -lt 100; $i++)
{ 
  # the dispatcher is very slow :-(
  # so we report only ever tenth to the GUI thread
  If(($i % 10) -eq 0) {
    $GUI.PrgBar.Dispatcher.Invoke([System.Windows.Threading.DispatcherPriority]::Normal,[Action]{$GUI.PrgBar.Value=$i ; $GUI.LblPrgBar.Content="$i%"})
  }
  # simultaneously we show the Progress inside the PowerShell Host ($Host)
  Write-Progress 'Hard work in progress' -status "$i% Complete:" -percentcomplete $i
  # simulate long running task with the sleep command
  Start-Sleep -Milliseconds 10
}
# reset Progressbar
$GUI.PrgBar.Dispatcher.Invoke('Send',[Action]{$GUI.PrgBar.Value=0 ; $GUI.LblPrgBar.Content=''})

# Get End Time
$EndTime = (Get-Date)

# Echo Time elapsed
"Elapsed Time: $(($EndTime-$StartTime).totalseconds) seconds"