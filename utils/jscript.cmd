@set @_C10D20D8_DD85_4BF9_93CD_43DC7B2D627E=1; /*
@set @_C10D20D8_DD85_4BF9_93CD_43DC7B2D627E=
@for /f "tokens=3" %%. in ('echo') do @SET IS_ECHO=%%.
@echo OFF
@goto :COMPILE
REM Embedded JScript.Net
:COMPILE
set msbuildbinpath=%SYSTEMROOT%\MICROSOFT.net\Framework\v2.0.50727
set path=%msbuildbinpath%;%path%
jsc.exe /nologo /r:%msbuildbinpath%\Microsoft.Build.Utilities.dll;%msbuildbinpath%\Microsoft.Build.Framework.dll /t:exe /out:%TEMP%\%~n0.exe %~dpf0

%TEMP%\%~n0.exe %*
if /i "%IS_ECHO%" == "on." echo ON
@goto :eof
*/


import System;
import System.Collections;
import System.Collections.Generic;
import System.IO;
import System.ComponentModel;
import System.Runtime.InteropServices;
import System.Text;
import System.Collections.Specialized;
import System.Text.RegularExpressions;
import System.Threading;
import System.Diagnostics;
import System.Xml;
import System.Xml.XPath;
import System.Net;
import Microsoft.Build.Framework;
import Microsoft.Build.Utilities;
import Microsoft.Build.BuildEngine;



var x : CustomTask.ParameterEcho  = new CustomTask.ParameterEcho();
//x.Param = "123x 456y";
//x.Execute();
var y : CustomTask.MyTask = new CustomTask.MyTask ();
y.Param = System.Environment.CommandLine.ToString();
y.Execute();


package CustomTask {

class ParameterEcho  {

    protected var _Param : String;

 function get Param() : String  {  return this._Param ; }  
          function set Param(s : String) {   this._Param  = s ; }

  function  get Result ( ) : String {return this._Param ;}

    public function Execute() : System.Boolean { 
          Console.WriteLine("\"{0}\"",  this._Param );
          // parameter handling stub.
          return( true );
        }    
   }

     public class MyTask extends Task {
           
              private var  _Servers : Hashtable = new Hashtable(5);
              private var  _Param : String = String.Empty;

              function get Param() : String   { return this._Param; }
              function  set Param (value: String)  { this._Param = value; }
     
              public function Execute() : System.Boolean  { 
              /* In clean and slow C# there isn't any syntactic hashtable constructor?  */
              _Servers .Add("h", "CHPLANB");
              _Servers .Add("o", "FTLPLANB02");
              _Servers .Add("f", "FTLPLANB");
              _Servers .Add("c", "CAMAUTOBLD01");

              var s : String =  '(?:\\s|^)(\\d+)([a-z]?)';
              var  r : Regex = new Regex( s, RegexOptions.IgnoreCase );
              var m : MatchCollection = r.Matches(this._Param) ; //
              if ( m != null ){
                   var _Number : String =  String.Empty;
                   var _Server : String =  String.Empty;
                   var _Letter : String =  String.Empty;
                   for ( var i :  int = 0; i < m.Count; i++ ){
                          _Number  = m[i].Groups[1].Value.ToString(); 
                          _Letter = m[i].Groups[2].Value.ToString().ToLower(); 
                          try {
                              _Server = _Servers [_Letter].ToString();
                          }   catch (e) {Debug.Assert(e != null);
                              _Server = "FTLPLANB";
                     }
                  
                  var  doc : XPathDocument = new XPathDocument(new XmlTextReader(
                  "http://" + _Server + "/planb1.2/rssjobs.pl?"+ _Number ));

                  var  nav : XPathNavigator = doc.CreateNavigator();

                  var iter : XPathNodeIterator = nav.SelectDescendants("item", "", false);

                  while (iter.MoveNext())   {
                      var itemNav : XPathNavigator = iter.Current;

                      var itemIter : XPathNodeIterator = itemNav.SelectChildren(XPathNodeType.Element);
                
                      while (itemIter.MoveNext()){
                       if (itemIter.Current.Name.ToUpper() == "TITLE") {
                       Console.WriteLine("Job: {0} {1}", _Number,  itemIter.Current.Value);}
                      }

                  } 

             }

            } 
         else { /* no matches */
             return; 
         }
        }
    }
}

/* 

QUERYRSS.CMD IS LIKE QUERYJOB -C 


Every Job status is written by Planb 1.2 /1.4  in a xml.
This status is dispatched over port 80 via rsshjobs.pl.

Plabn B monitor uses it.

QUERYRSS.CMD is a stripped down command line version of PlanB monitor, with a familiar syntax.

It features: 

Speed:

C:\all\devsrc2\2777\sergueik\rssmonitor\PlanBMonitor>queryrss.cmd  500o 502o 503
o 504o 507o 510o 512o 514o 516o 532o

C:\all\devsrc2\2777\sergueik\rssmonitor\PlanBMonitor>/*  2>NUL  || goto :COMPILE


C:\all\devsrc2\2777\sergueik\rssmonitor\PlanBMonitor>echo OFF
Job: 500 "Catalyst Ohio Mui (job 500)" at 136588#17623#3405 Finished - SUCCESS
Job: 502 "THFSDK ohio Retail (job 502)" at 106496#128988 Finished - SUCCESS
Job: 503 "CI XTE Ohio win32 retail (job 503)" at 60972#34206#125904 Finished - SUCCESS
Job: 504 "ProdLic Ohio retail (job 504)" at 136612#131483#40748 Finished - SUCCESS
Job: 507 "MPS Ohio retail (job 507)" at 136605#110210#132425#42886 Finished - SUCCESS
Job: 510 "CMC Ohio win32 retail (job 510)" at 35044#132318 Finished - SUCCESS
Job: 512 "CMCPKG Ohio win32 Retail (job 512)" at 132334#35043#42841 Finished - SUCCESS
Job: 514 "IM Ohio wh32 Retail (job 514)" at 17639#132334#109922#41984#133707 Finished - SUCCESS
Job: 516 "CPSSDK Ohio retail (job 516)" at 136511#109612#132350#33669 Finished - SUCCESS
Job: 532 "ACM Pinehurst for Ohio (job 532)" at 136524#64141#39228 Finished - SUCCESS


Reliability: 

>queryrss 922o

Job: 922 "Win64/X64 Client 900 K2 Retail (job 922)" at 110404#32903#34153#83293 Finished - FAILURE

>queryjob 922o -c 
Job: 922 (Win64/X64 Client 900 K2 Retail) currently red at 110404#32903#34153#83293

Simplicity:  <100 lines 

It lacks:  one "detail"  Client View   : ftlbld024p1-mps-ohio_build-x64-retail
*/