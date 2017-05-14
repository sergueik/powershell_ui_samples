using System;
using System.IO;
using System.Threading;
using System.Windows;
using Windows.UI.Notifications;
using DesktopToastsSample;
using DesktopToastsSample.ShellHelpers;
using Microsoft.Win32;

namespace MyCoolToastApplication
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private string urlProtocol = "my-cool-app";
        private string myAppID = "My Cool Toast Application";

        private string toastString = @"<toast launch=""my-cool-app:"; 

        private string toastStringPart2 = @""" activationType=""protocol"">
            <visual>
                <binding template = ""ToastGeneric"" >
                    <text> My cool app using protocol</text>
                </binding>
            </visual>
        </toast>";

        private static Mutex _mutex = null;
        const string AppName = "myCoolToastApplication";

        public MainWindow()
        {
            bool createdNew;

            // we want to prevent starting a new instance of the application through url protocol launch when our toast is activated and our application is already running
            _mutex = new Mutex(true, AppName, out createdNew);

            if (!createdNew)
            {
                //app is already running! Exiting the application  
                Application.Current.Shutdown();
            }
            else
            {
                InitializeComponent();
                InitializeApplication();
            }
        }

        public void InitializeApplication()
        {
            ProcessStartupArguments();

            var myAppPath = System.Reflection.Assembly.GetExecutingAssembly().Location;
            
            RegisterShortcut(myAppPath);
            RegisterProtocol(myAppPath);
        }

        private void ProcessStartupArguments()
        {
            // check if application was started with arguments and using our URL protocol
            var args = Environment.GetCommandLineArgs();
            if (args.Length == 2)
            {
                if (args[1].StartsWith(urlProtocol))
                {
                    // make sure that you check args properly in sake of security reasons
                    HandleActivation(args[1]);
                }
            }
        }

        /// <summary>
        /// Borowed from https://github.com/WindowsNotifications/desktop-toasts
        /// THIS SAMPLE DOES NOT CLEAN CREATED SHORTCUT 
        /// </summary>
        /// <param name="exePath"></param>
        private void RegisterShortcut(string exePath)
        {
            String shortcutPath = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + "\\Microsoft\\Windows\\Start Menu\\Programs\\My cool toast app.lnk";
            if (!File.Exists(shortcutPath))
            {
                IShellLinkW newShortcut = (IShellLinkW) new CShellLink();
                // Create a shortcut to the exe
                newShortcut.SetPath(exePath);

                // Open the shortcut property store, set the AppUserModelId property
                IPropertyStore newShortcutProperties = (IPropertyStore) newShortcut;

                PropVariantHelper varAppId = new PropVariantHelper();

                varAppId.SetValue(myAppID);
                newShortcutProperties.SetValue(PROPERTYKEY.AppUserModel_ID, varAppId.Propvariant);

                // Commit the shortcut to disk
                IPersistFile newShortcutSave = (IPersistFile) newShortcut;
                newShortcutSave.Save(shortcutPath, true);
            }
        }

        /// <summary>
        /// Register url protocol for your application, 
        /// THIS SAMPLE DOES NOT CLEAN CREATED REGISTRY KEY
        /// </summary>
        private void RegisterProtocol(string exePath)
        {
            // to register this url protocol for all users use LocalMachine instead and elevation of admin rights will be required
            RegistryKey key = Registry.CurrentUser.OpenSubKey("Software\\Clases\\" + urlProtocol);//open myApp protocol's subkey

            if (key == null)  //if the protocol is not registered yet...we register it
            {
                key = Registry.CurrentUser.CreateSubKey("Software\\Classes\\" + urlProtocol);
                key.SetValue(string.Empty, "URL: " + urlProtocol);
                key.SetValue("URL Protocol", string.Empty);

                key = key.CreateSubKey(@"shell\open\command");
                key.SetValue(string.Empty, exePath + " " + "%1");
                //%1 represents the argument - this tells windows to open this program with an argument / parameter
            }

            key.Close();
        }

        private void SendToast_OnClick(object sender, RoutedEventArgs e)
        {
            Windows.Data.Xml.Dom.XmlDocument dom = new Windows.Data.Xml.Dom.XmlDocument();
            dom.LoadXml(toastString + toastArgumentsTextBox.Text + toastStringPart2);

            // Create the toast and attach event listeners
            ToastNotification toast = new ToastNotification(dom);
            
            toast.Activated += Toast_Activated;
            // Show the toast. Be sure to specify the AppUserModelId on your application's shortcut!
            ToastNotificationManager.CreateToastNotifier(myAppID).Show(toast);
        }

        private void Toast_Activated(ToastNotification sender, object args)
        {
            var activation = (ToastActivatedEventArgs) args;
        
            HandleActivation(activation.Arguments);
        }

        private void HandleActivation(string args)
        {
            // remove "urlProtocol:"
            var arguments = args.Remove(0, urlProtocol.Length + 1);
            MessageBox.Show("Toast with arguments: " + arguments + " activated");
        }
    }
}
