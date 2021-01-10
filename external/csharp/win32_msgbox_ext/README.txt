Advanced MessageBoxing with the MessageBoxIndirect Wrapper
By Scott McMaster (smcmaste@hotmail.com)
10/01/2004
03/03/2007 (revised)

INTRODUCTION
============
Anyone who has done any Windows Forms programming in the .NET Framework is familiar with the MessageBox class.  However, the managed MessageBox is missing a few capabilities that are available in the Win32 API, including the ability to add a Help button, specify a language to be used in the dialog buttons, and add a custom icon.  In this article, I present a managed wrapper for the MessageBoxIndirect Win32 API function that provides these capabilities.


WINDOWS MESSAGEBOX APIS
=======================
The Win32 API includes three functions for presenting message boxes to the user.  These are MessageBox, MessageBoxEx, and MessageBoxIndirect.  Of the three, MessageBoxIndirect is the most powerful, allowing you to add a Help button, custom icon, and specific language for the button text.  It is also the least programmer-friendly, which often leads people to put a friendly wrapper class around it.  One example of doing that in C++ can be found in this Code Project article (http://www.codeproject.com/dialog/messagebox.asp?msg=459).

Getting access to the MessageBoxIndirect function from the managed world of the .NET Framework means writing some interop code using Platform Invoke (PInvoke).  Since PInvoke code can be somewhat tricky to read and write, you generally want to do it once, get it working, and forget about it.  That means you should wrap it in a reusable class.  Enter the MessageBoxIndirect class.


DESIGN NOTES
============
The MessageBoxIndirect class exposes four key capabilities of the underlying MessageBoxIndirect API:  Choosing different modalities for the alert, specifying a language identifier to be used for the buttons, adding a working help button, and adding a custom icon.  We will discuss each of these in details below, but first I will mention a few design decisions.

Where possible, the MessageBoxIndirect class uses enumerations defined in the existing MessageBox class, such as MessageBoxButtons, MessageBoxDefaultButton, MessageBoxOptions, and DialogResult.

In my opinion, the MessageBox class in the .NET Framework is a great example of not-so-great object-oriented design.  It is a static class.  That is, it just provides a namespace for a few static Show methods.  Twelve static Show methods, to be exact.  Why is this poor design?  Imagine what would happen if Microsoft wanted to add, say, the ability to specify a custom icon for the message box.  How many more Show overloads would that force them to add?  With all of these options, the combinatorics of supporting Show methods for each scenario are really bad for maintenance.  What you should really do in this situation is allow the user to create a class, i.e. "MessageBox mb = new MessageBox()" and set properties on it.  To speed things along, add a few constructor overloads for only the most common options, perhaps text, caption, and buttons.

I adopted the object-oriented model I suggested above for the MessageBoxIndirect class.  To make it easier for you to convert your code to use this class, however, I added constructor overloads that match the signatures of the static Show methods of the built-in MessageBox.  After you have created your MessageBoxIndirect instance and set all desired options, you only need to call the instance method Show (which returns a DialogResult) to present the message box to the user.


THE DEMO PROJECT
================
The included solution, MessageBoxIndirect.sln, contains a Windows Application where the DemoForm form demonstrates a number of different ways to use the MessageBoxIndirect class.  We will now cover these in more detail.  In the demo project, the SetResult method displays the output of the Show method (i.e. what the user selected) in the status bar of the window.


MODALITIES
==========
There are three basic behaviors that a message box can have with respect to what else the user is allowed to do while the message box is up.  These are application-modal, task-modal, and system-modal.  Application-modal message boxes accept an owner window as a parameter and disallow any interaction with the given window until the message box is dismissed.  Task-modal message boxes work the same way, except that the resulting message box window is topmost.  This is intended to indicate a relatively serious situation.  Finally, system-modal message boxes disallow any interaction with all top-level windows from the calling application without requiring you to pass an owner window.

Here is an example of specifying the modality using the MessageBoxIndirect class:

(C#)
MessageBoxIndirect mb = new MessageBoxIndirect( this, "App Modal", "Test" );
mb.Modality = MessageBoxIndirect.MessageBoxExModality.AppModal;
DialogResult dr = mb.Show();		


PASSING A LANGID
================
The MessageBoxIndirect class allows you to specify a language identifier (LangID) indicating the language to use in the default message box buttons.  In the following example, I am actually passing a casted locale identifier (LCID) rather than a LangID, but bits 0-15 of an LCID are, in fact, the LangID, so I can get away with this.  A deeper discussion of LangIDs and LCIDs is beyond the scope of this article, but if you are interested, check out this MSDN topic on Windows national language support (http://msdn.microsoft.com/library/default.asp?url=/library/en-us/intl/nls_9rec.asp).  Note that if you do choose to pass different LangIDs, you'll need to have the appropriate language(s) installed on your system to see the fruits of your efforts.

MessageBoxIndirect mb = new MessageBoxIndirect( "Pass a LangID: " + Thread.CurrentThread.CurrentUICulture.LCID.ToString(), "Test" );
mb.LanguageID = (uint) Thread.CurrentThread.CurrentUICulture.LCID;
DialogResult dr = mb.Show();


ADDING A HELP BUTTON
====================
You can add a Help button to your message box by setting the ShowHelp property to true.  There are two different ways that you can handle the help button.  First, you can provide a delegate of type MsgBoxCallback that gets called when the help button is clicked, as in the following example:

(C#)
MessageBoxIndirect mb = new MessageBoxIndirect( "Help Button", "Test", MessageBoxButtons.YesNoCancel );
mb.ShowHelp = true;
mb.ContextHelpID = 555;
mb.Callback = new MessageBoxIndirect.MsgBoxCallback( this.ShowHelp );
DialogResult result = mb.Show();

The ShowHelp function returns void and accepts a HELPINFO instance.  Most importantly, the dwContextId member of the HELPINFO instance contains the context ID you set into the MessageBoxIndirect class before calling Show (555 in the above example).

The second way to handle help is to request that a WM_HELP message be sent to the parent window.  The following code demonstrates this.  Note that we give the MessageBoxIndirect class an owner window ("this", presumably the parent form) in the constructor to act as a target for the WM_HELP message:

(C#)
MessageBoxIndirect mb = new MessageBoxIndirect( this, "Help Button", "Test", MessageBoxButtons.YesNoCancel );
mb.ShowHelp = true;
mb.ContextHelpID = 444;
DialogResult result = mb.Show();

To handle the WM_HELP message in your form's overridden WndProc, note that Message.LParam points to a HELPINFO instance.  Before you can use the HELPINFO, you have to unmarshal it.  I added a static helper method to the HELPINFO class called UnmarshalFrom to assist you in this process.  Just pass it the LParam and it returns the appropriate HELPINFO for you to use in invoking help.


ADDING A CUSTOM ICON
====================
This was certainly the most difficult and yet in my opinion the most interesting part of my effort to wrap the MessageBoxIndirect API.  If you set the MB_USERICON flag, MessageBoxIndirect attempts to load a resource with the ID given in the lpszIcon member of MSGBOXPARAMS from the module whose instance handle is supplied in the hInstance member.  The problem is that this must be a traditional Win32 resource.  .NET uses a completely different technique for storing and managing resources, and Visual Studio.NET as of version 2003 seems to be incapable of adding Win32 resources to your compiled assemblies (let alone building .rc scripts into .res files in C# or VB.NET projects), save for the application icon.  A discussion of the differences between Win32 and .NET resources is beyond the scope of this article, but suffice to say that to get MessageBoxIndirect to display a custom icon, you must jump through some hoops.  I see three different options for getting your icons into play:

1.  You can use a resource-editing tool after building your assembly to slam your icons in as Win32 resources.  Although .NET doesn't use the same format for resources, it does create standard Win32 binaries, and there's nothing preventing you from adding resources to them.  I do not personally have a tool to recommend to pull this off, so I will not discuss this option further.

2.  You can build using the csc.exe or vbc.exe command-line compilers, which support a /win32res flag that allows you to specify a compiled resource file (.res) to link in as Win32 resources.  Of course, this option means you must abandon Visual Studio as your build environment, which can be a problem particularly in large projects.  Also, the /win32res flag is incompatible with the /win32icon flag for specifying an application icon, so if you choose this route, you'll have to make sure your desired application icon is the lowest-numbered icon resource in your Win32 .res file.

In the sample code, there is a build.bat script that demonstrates this technique using a .res file named Win32Resources.res that I supply.  On the demo form, click the "Custom Icon (This Exe)" button to try it out.  Note that this button will not give you a custom icon unless you compile using the command line and the /win32res flag.

3.  You can dynamically load a resource DLL and pass the resulting instance handle to MessageBoxIndirect.  This is my preferred option.  In the sample project, I supply a DLL consisting of just icon resources called Win32Resources.dll.  In practice, you'll need to create your resource DLL using a tool like Visual C++.  The demo form loads this module up using a PInvoke of LoadLibraryEx and instructs MessageBoxIndirect to use it as the source of a custom icon, as shown in the following code:

(C#)
if( hWin32Resources == IntPtr.Zero )
{
	hWin32Resources = LoadLibraryEx( Application.StartupPath + "\\Win32Resources.dll", IntPtr.Zero, 0 );
	Debug.Assert( hWin32Resources != IntPtr.Zero );
}

// Win32 Resource ID of the icon we want to put in the message box.
const int Smiley = 102;

MessageBoxIndirect mb = new MessageBoxIndirect( "Custom Icon", "Test" );

// Load the icon from the resource DLL that we loaded.
mb.Instance = hWin32Resources;			
mb.UserIcon = new IntPtr(Smiley);
DialogResult result = mb.Show();

If this doesn't work for you, check to make sure that the Win32Resources DLL is in the correct location (next to the application executable).


CUSTOM SYSTEM ICON
==================
When using the SystemModal modality, a system icon appears in the titlebar of the MessageBox window.  It is also possible to assign a custom icon here.  To take advantage of this feature, set the MessageBoxIndirect.SysSmallIcon property to a resource ID.  The resource will be loaded out of the MessageBoxIndirect.Instance module, or the executing assembly's module if none is specified.


INTEROP IMPLEMENTATION NOTES
============================
A detailed discussion of the .NET Interop code to make the MessageBoxIndirect class work would fill an article in itself.  Fortunately, there are many great tutorials on Interop and PInvoke available in MSDN and on the web, so here I will just focus on the highlights specific to calling the MessageBoxIndirect API.

The MessageBoxIndirect API function takes a single parameter which is a structure containing all of the options desired for the resulting message box dialog.  The declaration is:

(C#)
[DllImport("user32", EntryPoint="MessageBoxIndirect")]
private static extern int _MessageBoxIndirect( ref MSGBOXPARAMS msgboxParams );

Note the "ref" decoration indicating that the underlying API accepts a pointer to a structure.

The structure that gets passed to this function has the following managed declaration:

(C#)
[StructLayout(LayoutKind.Sequential)]
public struct MSGBOXPARAMS
{ 
	public uint cbSize; 
	public IntPtr hwndOwner; 
	public IntPtr hInstance;
	public String lpszText; 
	public String lpszCaption; 
	public uint dwStyle;
	public IntPtr lpszIcon; 
	public IntPtr dwContextHelpId; 
	public MsgBoxCallback lpfnMsgBoxCallback; 
	public uint dwLanguageId; 
};

This structure (along with the other declarations that follow) originate in the winuser.h Platform SDK header file.  Note that we use IntPtr for each HANDLE as is the recommended practice.  Also, lpszIcon (which we will discuss more later) is defined as an IntPtr even though it is a LPCTSTR in the API.  That is because the typical value passed to lpszIcon is the result of a call to the MAKEINTRESOURCE macro, which simply does some type-casting to make the number it is passed look like an address.

This structure includes a member, lpfnMsgBoxCallback, which is a callback that gets invoked when the user presses the optional Help button on the message box dialog.  In .NET, callbacks are naturally implemented as delegates, and thus we wrap this callback in the following compatible delegate declaration:

(C#)
public delegate void MsgBoxCallback( HELPINFO lpHelpInfo );

The HELPINFO structure provides some useful information about the specific help request.  Its managed declaration is:

(C#)
[StructLayout(LayoutKind.Sequential)]
public struct HELPINFO 
{ 
	public uint cbSize; 
	public int iContextType;
	public int iCtrlId; 
	public IntPtr hItemHandle; 
	public IntPtr dwContextId; 
	public POINT MousePos; 
};

As discussed above, one way to handle the help button on the message box is to process the WM_HELP message.  To retrieve the HELPINFO while processing WM_HELP, you need to do some unmarshaling, as in the following helper method defined in the HELPINFO class:

(C#)
public static HELPINFO UnmarshalFrom( IntPtr lParam )
{
	return (HELPINFO) Marshal.PtrToStructure( lParam, typeof( HELPINFO ) );
}

Finally, we define a number of message-box-related constants from winuser.h to use in our implementation, along with the following enumeration to represent the various modal behaviors a message box can take:

(C#)
public enum MessageBoxExModality : uint
{
	AppModal = MB_APPLMODAL,
	SystemModal = MB_SYSTEMMODAL,
	TaskModal = MB_TASKMODAL
}

Getting the custom system icon to work was a bit tricky.  In theory, all one has to do is send a WM_SETICON message to the MessageBox window.  The problem is actually getting the window handle to send the message.  To pull this off, I install a hook using SetWindowsHookEx (http://support.microsoft.com/kb/318804) for WH_CBT messages on the executing thread.

(C#)
DialogResult retval = DialogResult.Cancel;
try
{
	// Only hook if we have a reason to, namely, to set the custom icon.
	if( _sysSmallIcon != IntPtr.Zero )
	{
		HookProc CbtHookProcedure = new HookProc(CbtHookProc);
		hHook = SetWindowsHookEx(WH_CBT, CbtHookProcedure, (IntPtr) 0, AppDomain.GetCurrentThreadId());
	}

	retval = (DialogResult) _MessageBoxIndirect( ref parms );
}
finally
{
	if( hHook > 0 )
	{
		UnhookWindowsHookEx(hHook);
		hHook = 0;
	}
}

WH_CBT messages can be handy, particularly when automating aspects of the system.  In this case, I'm interested in the HCBT_CREATEWND message, which appears after the window has been created but before WM_CREATE is broadcast.  When I see it, I verify that it is actually for the MessageBox dialog, load the icon, and send the WM_SETICON message:

(C#)
private int CbtHookProc(int nCode, IntPtr wParam, IntPtr lParam)
{
	if( nCode == HCBT_CREATEWND )
	{
		// Make sure this is really a dialog.
		StringBuilder sb = new StringBuilder();
		sb.Capacity = 100;
		GetClassName( wParam, sb, sb.Capacity );
		string className = sb.ToString();
		if( className == "#32770" )
		{
			// Found it, look to set the icon if necessary.
			if( _sysSmallIcon != IntPtr.Zero )
			{
				EnsureInstance();
				IntPtr hSmallSysIcon = LoadIcon( Instance, _sysSmallIcon );
				if( hSmallSysIcon != IntPtr.Zero )
				{
					SendMessage( wParam, WM_SETICON, new IntPtr(ICON_SMALL), hSmallSysIcon );
				}
			}
		}
	}

	return CallNextHookEx(hHook, nCode, wParam, lParam);
}

When hooking, it is essential to end with a call to CallNextHookEx.  After I show the MessageBox and collect the result, I clean up the hook with UnhookWindowsHookEx.

Most of the rest of the code in the MessageBoxIndirect class is to support all of the different constructors, and to build the dwStyle value from the higher-level properties of the class.


DISCLAIMER AND CONCLUSION
=========================
You are free to use and modify this source as you find necessary.  Just note that:

THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.

Happy Coding,

Scott McMaster

