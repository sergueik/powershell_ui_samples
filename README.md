About
=====

Collection of Powershell scripts that provide the Forms / WPF UI functionality to routine system management tasks.


See Also
--------
See the article at <a href="http://www.codeproject.com/Articles/799161/Dealing-with-Powershell-Inputs-via-Basic-Windows-F">CodeProject</a>

Individual Scripts
==================

There is around 100 individual scripts, most of which are practical and can be easily used for common operations tasks. 

Technical details
=================
Most scripts incorporate
an embedded C# class that implements  the `IWin32Window` method `Win32Window` described in [poshcode](http://poshcode.org/2002) to block execution of the caller while the form is displayed. Some scripts use more advanced techniques like [Powershell Runspaces](https://blogs.technet.microsoft.com/heyscriptingguy/2015/11/26/beginning-use-of-powershell-runspaces-part-1/) to do the same. 

Author
------
[Serguei Kouzmine](kouzmine_serguei@yahoo.com)
