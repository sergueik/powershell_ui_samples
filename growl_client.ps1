using System;
using System.Collections.Generic;
using System.Text;
using Growl.Connector;

public class Test
{
	private GrowlConnector growl;
	private NotificationType notificationType;
	private Growl.Connector.Application application;
	private string sampleNotificationType = "SAMPLE_NOTIFICATION";

	public void Run()
	{
		this.growl = new GrowlConnector();
		this.notificationType = new NotificationType(sampleNotificationType, "Sample Notification");
		Notification notification = new Notification(this.application.Name, this.notificationType.Name, DateTime.Now.Ticks.ToString(), this.textBox2.Text, this.textBox3.Text);
		CallbackContext callbackContext = new CallbackContext("some fake information", "fake data");

		this.growl.Notify(notification, callbackContext);
	}
}
