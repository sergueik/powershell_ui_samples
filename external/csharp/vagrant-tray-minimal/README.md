### Info
Note: the default setting of `System.Windows.Forms.Browser` is somewhat pathetic. It cannot load grid console page of Selenium __3.x__ due to error in loading  the `jqury.js` library:
```txt
Object doesn't support property or method 'addEventListener'
```
tweaking the `HKEY_CURRENT_USER\SOFTWARE\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION` does not appear to fix this
### See Also

  * https://www.codeproject.com/Tips/627796/Doing-a-NotifyIcon-Program-the-Right-Wayhttps://www.codeproject.com/Articles/7827/Customizing-WinForm-s-System-Menu
  * https://stackoverflow.com/questions/56107/what-is-the-best-way-to-parse-html-in-c
  * https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.datagrid?view=netframework-4.0
  * https://stackoverflow.com/questions/6409839/reading-dataset

  * https://www.benefitagent.com/doc/Rendering%20Issues%20using%20WebBrowser%20Control%20in%20Windows.html
  * https://stackoverflow.com/questions/12216301/object-doesnt-support-property-or-method-webbrowser-control
  * https://github.com/TomRom27/LectioDivina
  * https://csharp.hotexamples.com/examples/mshtml/IHTMLDocument2/-/php-ihtmldocument2-class-examples.html
  * https://newbedev.com/html-how-to-load-html-code-in-web-browser-in-c-vs-code-example 
  * https://social.msdn.microsoft.com/Forums/vstudio/en-US/3875b32a-0a08-4c35-acee-233f14c5057b/parsing-a-html-file-in-a-console-app?forum=vbgeneral
  * https://csharp.hotexamples.com/examples/mshtml/IHTMLDocument2/-/php-ihtmldocument2-class-examples.html
  * https://newbedev.com/html-how-to-load-html-code-in-web-browser-in-c-vs-code-example
