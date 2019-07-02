<%@ WebService Language="C#" Class="MyAlertsWS" %>

using System;
using System.Web.Services;
using System.IO;

[WebService(Namespace="http://mycompany.com/webservices/")]
public class MyAlertsWS : WebService {

[WebMethod(Description=
	"summary:  Send An Alert<br>" + 
	"param(s):<br>" + 
		"&nbsp;&nbsp;&nbsp;&nbsp;String Message - The Alert Message (must be < 200 characters).<br>" + 
		"&nbsp;&nbsp;&nbsp;&nbsp;String URL - The URL to load when the alert is clicked.<br>" + 
		"&nbsp;&nbsp;&nbsp;&nbsp;String Voice - The Voice in which to alert the user.<br>" + 
		"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Choices Include:<br>" + 
		"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;en-US_female<br>" + 
		"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;en-US_male<br>" + 
		"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;en-UK_female<br>" + 
		"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;en-UK_male<br>" + 
		"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;en-AUS_female<br>" + 
		"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;en-AUS_male<br>" + 
 	"returns:  Boolean"
	)]
   public bool SendAlert(string Message, string URL, string Voice)
   {
      // Append Request To Queue
      writeToQueue(Message+"|"+URL+"|"+Voice);

      return true;
   }

   private bool writeToQueue(string Request)
   {

      Guid myGuid = Guid.NewGuid();
      TextWriter output = File.AppendText("c:\\MyAlerts\\queue\\"+myGuid.ToString("B")+".txt");
      // Append text to file
      output.WriteLine(Request);
      output.Close();

      return true;
   }
	

}


