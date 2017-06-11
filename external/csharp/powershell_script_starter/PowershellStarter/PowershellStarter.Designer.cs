namespace PowershellStarter {
	partial class PowershellStarterService {
		private System.ComponentModel.IContainer components = null;

		protected override void Dispose(bool disposing) {
			if (disposing && (components != null)) {
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		private void InitializeComponent() {
			this.eventLog = new System.Diagnostics.EventLog();
			((System.ComponentModel.ISupportInitialize)(this.eventLog)).BeginInit();
			this.eventLog.EntryWritten += new System.Diagnostics.EntryWrittenEventHandler(this.eventLog_EntryWritten);
			this.ServiceName = "PSSvc";
			((System.ComponentModel.ISupportInitialize)(this.eventLog)).EndInit();
		}
		private System.Diagnostics.EventLog eventLog;
	}
}
