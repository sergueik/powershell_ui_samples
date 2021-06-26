using System;

namespace Win32HooksDemo {
	public class PItem {
		public string ProcessName { get; set; }
		public string Title { get; set; }

		public PItem(string processname, string title) {
			this.ProcessName = processname;
			this.Title = title;
		}

		public override string ToString() {
			return string.IsNullOrEmpty(Title) ? string.Format("{0}", this.ProcessName) : string.Format("{0} ({1})", this.ProcessName, this.Title);
		}
	}
}
