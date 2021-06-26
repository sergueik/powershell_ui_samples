using System;
using System.Windows;
using System.Windows.Input;

namespace Win32HooksDemo {
    public partial class HoverControl : Window {
        public HoverControl() {
            InitializeComponent();
        }

        private void rectangle1_MouseDown(object sender, MouseButtonEventArgs e) {
            this.Close();
        }
    }
}
