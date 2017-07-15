using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Windows.Forms;

namespace Notify
{
    // Dialog style of black background
    public enum BackDialogStyle {None, FadedScreen, FadedApplication }

    public partial class Notifier : Form
    {

        #region GLOBALS
        // Set the type of the Notifier
        public enum Type { INFO, WARNING, ERROR, OK }
        
        // Helper class for handle Notifier position
        class PosXY{
            internal int X;
            internal int Y;
            // Mouse bar drag
            internal Point firstPoint;
            internal bool mouseIsDown = false;

            public PosXY(int x, int y)
            {
                this.X = x;
                this.Y = y;
            }
        }
        static List<PosXY> posXY = new List<PosXY>();

        // Keep a list of the opened Notifiers
        static List<Notifier> Notifiers = new List<Notifier>();
        // Current note ID (used on creations)
        static short ID = 0x00;

        // Base Notifier data
        private String description = "";
        private String title = "Notifier";
        private PosXY myPos;
        Type type = Type.INFO;

        // Dialog data
        bool isDialog;
        BackDialogStyle backDialogStyle = BackDialogStyle.None;
        private Form myCallerApp;
        #endregion

        #region CONSTRUCTOR & DISPLAY
        private Notifier(string dsc, 
            Type type, 
            string tit,
            bool isDialog = false)
        {
            this.isDialog = isDialog;
            this.description = dsc;
            this.type = type;
            this.title = tit;
            ID++;

            InitializeComponent();
        }

        private void OnLoad(object sender, EventArgs e)
        {
            BackColor = Color.Blue;
            TransparencyKey = Color.FromArgb(128, 128, 128);
            FormBorderStyle = FormBorderStyle.None;

            this.Tag = "__Notifier|" + ID.ToString("X4");

            setNotifier(description, type, title);
        }

        private void setNotifier(string _desc, Type noteType, string _title, bool isUpdate = false)
        {
            // Fill the Notifier data
            titleText.Text = _title;
            labelDesc.Text = _desc;
            date.Text = DateTime.Now + "";
            
            // set defaults
            title = _title;
            description = _desc;
            type = noteType;

            #region ADJUST COLORS
            Color Hover = Color.FromArgb(0, 0, 0);
            Color Leave = Color.FromArgb(0, 0, 0);

            switch (noteType)
            {
                case Type.ERROR:
                    icon.Image = global::Notify.Properties.Resources.ko;
                    Leave = Color.FromArgb(200, 60, 70);
                    Hover = Color.FromArgb(240, 80, 90);
                    break;
                case Type.INFO:
                    icon.Image = global::Notify.Properties.Resources.info;
                    Leave = Color.FromArgb(90, 140, 230);
                    Hover = Color.FromArgb(110, 160, 250);
                    break;
                case Type.WARNING:
                    icon.Image = global::Notify.Properties.Resources.warning;
                    Leave = Color.FromArgb(200, 200, 80);
                    Hover = Color.FromArgb(220, 220, 80);
                    break;
                case Type.OK:
                    icon.Image = global::Notify.Properties.Resources.ok;
                    Leave = Color.FromArgb(80, 200, 130);
                    Hover = Color.FromArgb(80, 240, 130);
                    break;
            }

            // Init color
            buttonClose.BackColor = Leave;
            buttonMenu.BackColor = Leave;
            titleText.BackColor = Leave;

            // Mouse over
            this.buttonClose.MouseHover += (s, e) =>
            {
                this.buttonClose.BackColor = Hover;
                this.buttonMenu.BackColor = Hover;
                this.titleText.BackColor = Hover;
            };
            this.buttonMenu.MouseHover += (s, e) =>
            {
                this.buttonMenu.BackColor = Hover;
                this.buttonClose.BackColor = Hover;
                this.titleText.BackColor = Hover;
            }; this.titleText.MouseHover += (s, e) =>
            {
                this.buttonMenu.BackColor = Hover;
                this.buttonClose.BackColor = Hover;
                this.titleText.BackColor = Hover;
            };

            // Mouse leave
            this.buttonClose.MouseLeave += (s, e) =>
            {
                this.buttonClose.BackColor = Leave;
                this.buttonMenu.BackColor = Leave;
                this.titleText.BackColor = Leave;
            };
            this.buttonMenu.MouseLeave += (s, e) =>
            {
                this.buttonMenu.BackColor = Leave;
                this.buttonClose.BackColor = Leave;
                this.titleText.BackColor = Leave;
            };
            this.titleText.MouseLeave += (s, e) =>
            {
                this.buttonMenu.BackColor = Leave;
                this.buttonClose.BackColor = Leave;
                this.titleText.BackColor = Leave;
            };

            if (isDialog)
            {
                // Add Buttons
                Button ok_button = new Button();
                ok_button.FlatStyle = FlatStyle.Flat;
                ok_button.BackColor = Leave;
                ok_button.ForeColor = Color.White;
                this.Size = new Size(this.Size.Width, this.Size.Height + 50);
                ok_button.Size = new Size(80, 40);
                ok_button.Location = new Point(this.Size.Height / 2 + 40, this.Size.Height - 50);
                ok_button.Text = "OK";
                ok_button.Click += onClickButtonOK;
                this.Controls.Add(ok_button);
            }
            #endregion

            #region ADJUST LOCATION
            if (!isUpdate)
            {
                Rectangle rec = Screen.GetWorkingArea(Screen.PrimaryScreen.Bounds);

                // Add position
                // Check for a available Position
                int maxNot = rec.Height / this.Height;
                int x_Pos = rec.Width - this.Width;

                //int x_Shift = this.Width + 5;     // Full visible note (no overlay)
                int x_Shift = 25;                   // Custom overlay
                int n_columns = 0;
                int n_max_columns = rec.Width / x_Shift;
                bool add = false;
                if (!isDialog)
                {
                    myPos = new PosXY(x_Pos, rec.Height - (this.Height * 1));

                    while (!add)
                    {
                        for (int n_not = 1; n_not <= maxNot; n_not++)
                        {
                            myPos = new PosXY(x_Pos, rec.Height - (this.Height * n_not));

                            if (!posXYContains(myPos))
                            {
                                add = true; break;
                            }

                            // X shift if no more column space
                            if (n_not == maxNot)
                            {
                                n_columns++;
                                n_not = 0;
                                x_Pos = rec.Width - this.Width - x_Shift * n_columns;
                            }

                            // Last exit condition: the screen is full of note
                            if (n_columns >= n_max_columns)
                            {
                                add = true; break;
                            }
                        }
                    }
                }
                else
                {
                    // Positioning
                    switch (backDialogStyle)
                    {
                        case BackDialogStyle.FadedScreen:
                        case BackDialogStyle.None:
                            // Center Screen position
                            int X = 0, Y = 0;
                            X = (rec.Width - this.Width) / 2;
                            Y = (rec.Height - this.Height) / 2;
                            myPos = new PosXY(X, Y);
                            break;
                        case BackDialogStyle.FadedApplication:
                            // Center of myCallerApp
                            int px = myCallerApp.Location.X + myCallerApp.Size.Width / 2;
                            int py = myCallerApp.Location.Y + myCallerApp.Size.Height / 2;
                            px = px - this.Width / 2;
                            py = py - this.Height / 2;
                            myPos = new PosXY(px, py);
                            break;
                    }
                }

                // Notifier position
                this.Location = new Point(myPos.X, myPos.Y);

                posXY.Add(myPos);
            #endregion
            }
        }

        // Dialog Only
        private void onClickButtonOK(object sender, EventArgs e)
        {
            buttonClose_Click(null, null);
        }
        #endregion

        #region EVENTS
        private void buttonClose_Click(object sender, EventArgs e)
        {
            if (e == null || ((MouseEventArgs)e).Button != System.Windows.Forms.MouseButtons.Right)
            {
                // Get the closed Notifier
                Notifier NotifierMe = getRemovedNotifier(title, description, type);
                if (NotifierMe != null)
                {
                    Notifiers.Remove(NotifierMe);
                    posXY.Remove(myPos);

                    this.Dispose();
                    this.Close();
                }
            }
        }

        private Notifier getRemovedNotifier(string _title, string _desc, Type _type)
        {
            for (int i = Notifiers.Count - 1; i >= 0; i--)
            {
                // Get the node
                if (Notifiers[i].Tag != null &&
                    Notifiers[i].description == _desc &&
                    Notifiers[i].title == _title &&
                    Notifiers[i].type == _type)
                {
                    return Notifiers[i];
                }
            }
            return null;
        }

        private void buttonMenu_Click(object sender, EventArgs e)
        {
            menu.Show(buttonMenu, new Point(0, buttonMenu.Height));
        }

        private void closeAllToolStripMenuItem_Click(object sender, EventArgs e)
        {
            CloseAll();
        }
        #endregion

        #region HELPERS
        private bool posXYContains(PosXY myPos)
        {
            foreach (PosXY p in posXY)
                if (p.X == myPos.X && p.Y == myPos.Y)
                    return true;
            return false;
        }

        public static void CloseAll()
        {
            for (int i = 0; i < Notifiers.Count; i++)
            {
                if (Notifiers[i].Tag != null &&
                    Notifiers[i].Tag.ToString().Contains("__Notifier|"))
                {
                    Notifiers[i].Dispose();
                }
            }
            Notifiers.Clear();
            posXY.Clear();
            ID = 0;
        }

        // To draw a right side close icon
        private void OnPaint(object sender, PaintEventArgs e)
        {
            var image = Properties.Resources.close;

            if (image != null)
            {
                var g = e.Graphics;
                g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
                g.DrawImage(image,
                    buttonClose.Width - image.Width,
                    buttonClose.Height - image.Height - 2,
                    image.Width,
                    image.Height);
            }
        }
        #endregion

        // Used to get a better MessageBox invocation style
        #region SIMPLE NOTE CREATION AND MODIFY
        // SIMPLE NOTES
        public static short Show(string desc, Type type = Type.INFO, string tit = "Notifier")
        {
            // If there is already a note with the same content, update it and do not create a new one
            short updated_note_id = 0, updated_note_occurency = 0;

            if (NotifierAlreadyPresent(desc, type, tit, out updated_note_id, out updated_note_occurency))
            {
                ID = updated_note_id;
                Update(ID, desc, type, "[" + updated_note_occurency + "] " + tit);
            }
            else
            {
                // Instantiate the Notifier form
                Notifier not = new Notifier(desc, type, tit);
                not.Show();

                // Add to our collection of Notifiers, cause "OpenForms"
                // is currently buggy
                Notifiers.Add(not);
            }

            // Return the current ID of the created Notifier
            return ID;
        }

        private static bool NotifierAlreadyPresent(string desc, Type type, string tit, out short updated_note_id, out short updated_note_occurency)
        {
            updated_note_id = 0;
            updated_note_occurency = 1;
            bool resParse = false;

            for (int i = 0; i < Notifiers.Count; i++)
            {
                short occurency = 1;
                String filteredTitle = Notifiers[i].title;
                int indx = filteredTitle.IndexOf(']');

                // Get occurrency from title
                if(indx > 0)
                {
                    String number_occ = filteredTitle.Substring(0, indx);
                    number_occ = number_occ.Trim(' ', ']', '[');
                    resParse = Int16.TryParse(number_occ, out occurency);
                
                    filteredTitle = filteredTitle.Substring(indx + 1).Trim();
                }

                // Get the node
                if (Notifiers[i].Tag != null &&
                    Notifiers[i].description == desc &&
                    filteredTitle == tit &&
                    Notifiers[i].type == type)
                {
                    // Get Notifier ID
                    String hex_id = Notifiers[i].Tag.ToString().Split('|')[1];
                    short id = Convert.ToInt16(hex_id, 16);

                    updated_note_id = id;

                    //if (resParse)
                    updated_note_occurency = ++occurency;

                    return true;
                }
            }
            return false;
        }

        // Other Fast Generators
        public static void Show(string desc, string tit = "Notifier", Type type = Type.INFO)
        {
            Show(desc, type, tit);
        }
        public static void Show(string desc)
        {
            Show(desc, Type.INFO, "Notifier");
        }

        public static void Update(short ID, string desc, Type noteType, string title)
        {
            for (int i = 0; i < Notifiers.Count; i++)
            {
                // Get the node
                if (Notifiers[i].Tag != null &&
                    Notifiers[i].Tag.Equals("__Notifier|" + ID.ToString("X4")))
                {
                    Notifier myNote = (Notifier)Notifiers[i];
                    myNote.setNotifier(desc, noteType, title, true);
                }
            }
        }
        #endregion

        // DIALOG NOTE - With faded background!!!
        #region DIALOG NOTE CREATION
        public static DialogResult ShowDialog(string desc, Type type = Type.INFO, string tit = "Notifier",
            BackDialogStyle backDialogStyle = BackDialogStyle.FadedScreen,
            Form obscureMe = null)
        {
            if (backDialogStyle == BackDialogStyle.FadedApplication && obscureMe == null)
                backDialogStyle = BackDialogStyle.FadedScreen;

            Form back = new Form();
            back.FormBorderStyle = FormBorderStyle.None;
            back.BackColor = Color.FromArgb(0, 0, 0);
            back.Opacity = 0.6;
            int border = 200;

            // Instantiate the Notifier form
            Notifier not = new Notifier(desc, type, tit, true);
            not.backDialogStyle = backDialogStyle;
            bool orgTopMostSettings = false;
            
            // To draw it on primary screen
            switch (not.backDialogStyle)
            {
                case BackDialogStyle.FadedScreen:
                    back.Location = new System.Drawing.Point(-border, -border);
                    back.Size = new Size(Screen.PrimaryScreen.WorkingArea.Width + border,
                        Screen.PrimaryScreen.WorkingArea.Height + border);
                    back.Show();
                    back.TopMost = true;
                    break;
                case BackDialogStyle.FadedApplication:
                    not.myCallerApp = obscureMe;
                    orgTopMostSettings = obscureMe.TopMost;
                    obscureMe.TopMost = true;
                    Point locationOnForm = obscureMe.PointToScreen(Point.Empty);
                    back.Size = obscureMe.Size;
                    back.Location = obscureMe.Location;
                    back.StartPosition = FormStartPosition.Manual;
                    back.Show();
                    back.TopMost = true;
                    break;
                default:
                    /*back.Location = new System.Drawing.Point(-2, -2);
                    back.Size = new Size(1,1);
                    back.Show();*/
                break;
            }
            // Add to our collection of Notifiers, cause "OpenForms"
            // is currently buggy
            Notifiers.Add(not);

            not.ShowDialog();

            back.Close();
            if (obscureMe != null)
                obscureMe.TopMost = orgTopMostSettings;

            return DialogResult.OK;
        }

        // Other Fast Generators
        public static void ShowDialog(string desc, string tit = "Notifier", Type type = Type.INFO)
        {
            ShowDialog(desc, type, tit);
        }
        public static void ShowDialog(string desc)
        {
            ShowDialog(desc, Type.INFO, "Notifier");
        }
        #endregion

        // To draw the note using the title bar
        #region DRAG NOTE
        private void OnMouseMove(object sender, MouseEventArgs e)
        {
            if (myPos.mouseIsDown)
            {
                // Get the difference between the two points
                int xDiff = myPos.firstPoint.X - e.Location.X;
                int yDiff = myPos.firstPoint.Y - e.Location.Y;

                // Set the new point
                int x = this.Location.X - xDiff;
                int y = this.Location.Y - yDiff;
                this.Location = new Point(x, y);
            }
        }

        private void OnMouseDown(object sender, MouseEventArgs e)
        {
            myPos.firstPoint = e.Location;
            myPos.mouseIsDown = true;
        }

        private void OnMouseUp(object sender, MouseEventArgs e)
        {
            myPos.mouseIsDown = false;
        }
        #endregion

    } /// Close Class
} /// Close NS
