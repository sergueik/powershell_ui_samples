//
//      Notifier.cs
// 
//      This project was born in the 2009 for a University application.
//      Then it was resurrected in the 2015 to be part of an old system that cannot handle the
//      3.5 framework and grows up to include more features. This is not a professional work, so
//      the code quality it's something like "let's do something quickly".
//      If you are looking for something professional, you can do it by yourself and of course share it!
//      
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Threading;
using System.Windows.Forms;

namespace Notify
{
    public enum BackDialogStyle { None,                                 // Dialog style of black background
                                  FadedScreen, 
                                  FadedApplication } 

    public partial class Notifier : Form
    {

#region GLOBALS      
        public enum Type { INFO, WARNING, ERROR, OK }                   // Set the type of the Notifier

        class NoteLocation                                              // Helper class to handle Note position
        {
            internal int X;
            internal int Y;

            internal Point initialLocation;                             // Mouse bar drag helpers
            internal bool mouseIsDown = false;

            public NoteLocation(int x, int y)
            {
                this.X = x;
                this.Y = y;
            }
        }

        static List<Notifier> notes             = new List<Notifier>(); // Keep a list of the opened Notifiers

        private NoteLocation noteLocation;                              // Note position
        private short ID                        = 0;                    // Note ID
        private string description              = "";                   // Note default Description
        private string title                    = "Notifier";           // Note default Title
        private Type type                       = Type.INFO;            // Note default Type

        private bool isDialog = false;                                  // Note is Dialog
        private BackDialogStyle backDialogStyle = BackDialogStyle.None; // DialogNote default background
        private Form myCallerApp;                                       // Base Application for Dialog Note

        private Color Hover = Color.FromArgb(0, 0, 0, 0);               // Default Color for hover
        private Color Leave = Color.FromArgb(0, 0, 0, 0);               // Default Color for leave

        private int timeout_ms                  = 0;                    // Temporary note: timeout
        private AutoResetEvent timerResetEvent       = null;                 // Temporary note: reset event

        private Form inApp = null;                                      // In App Notifier: the note is binded to the specified container
#endregion

#region CONSTRUCTOR & DISPLAY
        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  Default constructor
        //-------------------------------------------------------------------------------------------------------------------------------
        private Notifier(string dsc,                                    
                         Type type, 
                         string tit,
                         bool isDialog = false,
                         int timeout_ms = 0,
                         Form insideMe = null)
        {
            this.isDialog      = isDialog;
            this.description   = dsc;
            this.type          = type;
            this.title         = tit;
            this.timeout_ms    = timeout_ms;
            this.inApp         = insideMe;
            
            InitializeComponent();                                      // Initializate the form

            foreach (var nt in notes)                                   // Use the latest available ID from the note list
                if (nt.ID > ID)
                    ID = nt.ID;
            ID++;                                                       // Set the Note ID

            if (insideMe != null && !inAppNoteExists())                 // Register the drag and resize events
            {
                insideMe.LocationChanged += inApp_LocationChanged;
                insideMe.SizeChanged     += inApp_LocationChanged;
            }

            foreach (Control c in Controls)                             // Make all the note area draggable
            {
                if (c is Label || c.Name == "icon")
                {
                    c.MouseDown += OnMouseDown;
                    c.MouseUp   += OnMouseUp;
                    c.MouseMove += OnMouseMove;
                }
            }


        }

        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  Handle the drag  drop and resize location of the notes
        //-------------------------------------------------------------------------------------------------------------------------------
        void inApp_LocationChanged(object sender, EventArgs e)          
        {
            foreach (var note in notes)
            {
                if (note.inApp != null)
                {
                    NoteLocation ln = adjustLocation(note);
                    note.Left       = ln.X;
                    note.Top        = ln.Y;
                }
            }
        }

        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  On load form operations
        //-------------------------------------------------------------------------------------------------------------------------------
        private void OnLoad(object sender, EventArgs e)
        {
            BackColor       = Color.Blue;                               // Initial default graphics 
            TransparencyKey = Color.FromArgb(128, 128, 128);            // Initial default graphics 
            FormBorderStyle = FormBorderStyle.None;                     // Initial default graphics 

            this.Tag = "__Notifier|" + ID.ToString("X4");               // Save the note identification in the Tag field

            setNotifier(description, type, title);  
        }

        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  Create the Note and handle its location
        //-------------------------------------------------------------------------------------------------------------------------------
        private void setNotifier(string description, 
                                 Type noteType, 
                                 string title, 
                                 bool isUpdate = false)
        {
            this.title          = title;
            this.description    = description;
            this.type           = noteType;

            noteTitle.Text      = title;                                // Fill the Notifier data title
            noteContent.Text    = description;                          // Fill the Notifier data description
            noteDate.Text       = DateTime.Now + "";                    // Fill the Notifier data Timestamp

#region ADJUST COLORS
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

            buttonClose.BackColor = Leave;                              // Init colors
            buttonMenu.BackColor  = Leave;
            noteTitle.BackColor   = Leave;

            this.buttonClose.MouseHover += (s, e) =>                    // Mouse hover
            {
                this.buttonClose.BackColor = Hover;
                this.buttonMenu.BackColor = Hover;
                this.noteTitle.BackColor = Hover;
            };
            this.buttonMenu.MouseHover += (s, e) =>
            {
                this.buttonMenu.BackColor = Hover;
                this.buttonClose.BackColor = Hover;
                this.noteTitle.BackColor = Hover;
            }; this.noteTitle.MouseHover += (s, e) =>
            {
                this.buttonMenu.BackColor = Hover;
                this.buttonClose.BackColor = Hover;
                this.noteTitle.BackColor = Hover;
            };

            this.buttonClose.MouseLeave += (s, e) =>                    // Mouse leave
            {
                this.buttonClose.BackColor = Leave;
                this.buttonMenu.BackColor = Leave;
                this.noteTitle.BackColor = Leave;
            };
            this.buttonMenu.MouseLeave += (s, e) =>
            {
                this.buttonMenu.BackColor = Leave;
                this.buttonClose.BackColor = Leave;
                this.noteTitle.BackColor = Leave;
            };
            this.noteTitle.MouseLeave += (s, e) =>
            {
                this.buttonMenu.BackColor = Leave;
                this.buttonClose.BackColor = Leave;
                this.noteTitle.BackColor = Leave;
            };
#endregion

#region DIALOG NOTE
            if (isDialog)
            {
                Button ok_button    = new Button();                     // Dialog note comes with a simple Ok button
                ok_button.FlatStyle = FlatStyle.Flat;
                ok_button.BackColor = Leave;
                ok_button.ForeColor = Color.White;
                Size                = new Size(Size.Width,              // Resize the note to contain the button
                                               Size.Height + 50);
                ok_button.Size      = new Size(120, 40);
                ok_button.Location  = new Point(Size.Width / 2 - ok_button.Size.Width / 2, 
                                                Size.Height - 50);
                ok_button.Text      = DialogResult.OK.ToString();
                ok_button.Click     += onOkButtonClick;
                Controls.Add(ok_button);

                noteDate.Location   = new Point(noteDate.Location.X,    // Shift down the date location
                                                noteDate.Location.Y + 44); 


                noteLocation        = new NoteLocation(Left, Top);      // Default Center Location
            }
#endregion

#region NOTE LOCATION
            if (!isDialog && !isUpdate)
            {
                NoteLocation location = adjustLocation(this);           // Set the note location

                Left = location.X;                                      // Notifier position X    
                Top  = location.Y;                                      // Notifier position Y 
            }
#endregion
        }

        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  Find a valid position for the note into the note area:
        //                                  1. Inside the Screen (support multiple screens)
        //                                  2. Inside the father application (if specified)
        //-------------------------------------------------------------------------------------------------------------------------------
        private NoteLocation adjustLocation(Notifier note)
        {
            Rectangle notesArea;
            int nMaxRows    = 0, 
                nColumn     = 0,
                nMaxColumns = 0,
                xShift      = 25;                                                     // Custom note overlay
            //  x_Shift     = this.Width + 5;                                         // Full visible note (no overlay)
            bool add = false;

            if (inApp != null && inApp.WindowState ==  FormWindowState.Normal)        // Get the available notes area, based on the type of note location
            {
                notesArea = new Rectangle(inApp.Location.X, 
                                          inApp.Location.Y, 
                                          inApp.Size.Width, 
                                          inApp.Size.Height);
            }
            else
            {
                notesArea = new Rectangle(Screen.GetWorkingArea(note).Left,
                                          Screen.GetWorkingArea(note).Top,
                                          Screen.GetWorkingArea(note).Width,
                                          Screen.GetWorkingArea(note).Height);
            }

            nMaxRows    = notesArea.Height / Height;                                  // Max number of rows in the available space
            nMaxColumns = notesArea.Width  / xShift;                                  // Max number of columns in the available space

            noteLocation = new NoteLocation(notesArea.Width  +                        // Initial Position X                                        
                                            notesArea.Left   -
                                            Width,
                                            notesArea.Height +                        // Initial Position Y
                                            notesArea.Top    -
                                            Height);

            while (nMaxRows > 0 && !add)                                              // Check the latest available position (no overlap)
            {
                for (int nRow = 1; nRow <= nMaxRows; nRow++)
                {
                    noteLocation.Y =    notesArea.Height +
                                        notesArea.Top    -
                                        Height * nRow;

                    if (!isLocationAlreadyUsed(noteLocation, note))
                    {
                        add = true; break;
                    }

                    if (nRow == nMaxRows)                                            // X shift if no more column space
                    {
                        nColumn++;
                        nRow = 0;

                        noteLocation.X =  notesArea.Width           +
                                          notesArea.Left            - 
                                          Width - xShift * nColumn;
                    }

                    if (nColumn >= nMaxColumns)                                      // Last exit condition: the screen is full of note
                    {
                        add = true; break;
                    }
                }
            }

            noteLocation.initialLocation = new Point(noteLocation.X,                  // Init the initial Location, for drag & drop
                                                     noteLocation.Y);             
            return noteLocation;
        }
#endregion

#region EVENTS

        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  Close event for the note
        //-------------------------------------------------------------------------------------------------------------------------------
        private void onCloseClick(object sender, EventArgs e)
        {
            if (e == null || ((MouseEventArgs)e).Button != System.Windows.Forms.MouseButtons.Right)
            {
                closeMe();
            }
        }

        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  Show the menu (for the menu button) event
        //-------------------------------------------------------------------------------------------------------------------------------
        private void onMenuClick(object sender, EventArgs e)
        {
            menu.Show(buttonMenu, new Point(0, buttonMenu.Height));
        }

        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  Close all the notes event
        //-------------------------------------------------------------------------------------------------------------------------------
        private void onMenuCloseAllClick(object sender, EventArgs e)
        {
            CloseAll();
        }

        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  Dialog note Only (Ok button click event)
        //-------------------------------------------------------------------------------------------------------------------------------
        private void onOkButtonClick(object sender, EventArgs e)          
        {
            onCloseClick(null, null);        // It is the same as the close operation event
        }      
#endregion

#region HELPERS
        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  Close the note event
        //-------------------------------------------------------------------------------------------------------------------------------
        private void closeMe()
        {
            notes.Remove(this);
            this.Close();
      
            if (notes.Count == 0)
                ID = 0;                                                 // Reset the ID counter if no notes is displayed
        }

        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  get the Specified note by the specified content
        //-------------------------------------------------------------------------------------------------------------------------------
        private Notifier getNote(string _title, string _desc, Type _type)
        {
            foreach (var note in notes)
            {
                if (note.description == _desc &&
                    note.title       == _title &&
                    note.type        == _type)
                {
                    return note;
                }
            }
            return null;
        }

        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  Check if a note with an inApp capabilities is setted
        //-------------------------------------------------------------------------------------------------------------------------------
        private bool inAppNoteExists()
        {
            foreach (var note in notes)
            {
                if (note.inApp != null)
                    return true;
            }
            return false;
        }

        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  check if the specified location (X, Y) is already used by another note
        //-------------------------------------------------------------------------------------------------------------------------------
        private bool isLocationAlreadyUsed(NoteLocation location, Notifier note)
        {
            foreach (var p in notes)
                if (p.Left == location.X &&
                    p.Top  == location.Y)
                {
                    if (note.inApp != null && 
                        p.ID       == note.ID)
                        return false;
                    return true;
                }
            return false;
        }

        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  Close all the notes
        //-------------------------------------------------------------------------------------------------------------------------------
        public static void CloseAll()
        {
            for (int i = notes.Count - 1; i >= 0; i--)
            {
                notes[i].closeMe();
            }
        }

        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  Event used to draw a right side close icon
        //-------------------------------------------------------------------------------------------------------------------------------
        private void OnPaint(object sender, PaintEventArgs e)
        {
            var image = Properties.Resources.close;

            if (image != null)
            {
                var g = e.Graphics;
                g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
                g.DrawImage(image,
                    buttonClose.Width  - image.Width,
                    buttonClose.Height - image.Height - 2,
                    image.Width,
                    image.Height);
            }
        }
#endregion

#region NOTE CREATION AND MODIFY
        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  Show the note: it is the startup of the creation process of the note
        //-------------------------------------------------------------------------------------------------------------------------------
        public static short Show(string desc, 
                                 Type type      = Type.INFO, 
                                 string tit     = "Notifier", 
                                 bool isDialog  = false, 
                                 int timeout    = 0, 
                                 Form inApp     = null)
        {
            short updated_note_id        = 0,                                       // If there is already a note with the same content
                  updated_note_occurency = 0;                                       // update it and do not create a new one

            if (NotifierAlreadyPresent(desc, 
                                       type, 
                                       tit, 
                                       isDialog, 
                                       out updated_note_id, 
                                       out updated_note_occurency))
            {
                Update(updated_note_id, desc, type, "[" + ++updated_note_occurency + "] " + tit);
            }
            else
            {
                Notifier not = new Notifier(desc,                                   // Instantiate the Note
                                            type, 
                                            tit, 
                                            isDialog, 
                                            timeout, 
                                            inApp);           
                not.Show();                                                         // Show the note
           
                if (not.timeout_ms >= 500)                                          // Start autoclose timer (if any)
                {
                    not.timerResetEvent      = new AutoResetEvent(false);

                    BackgroundWorker timer   = new BackgroundWorker();
                    timer.DoWork             += timer_DoWork;
                    timer.RunWorkerCompleted += timer_RunWorkerCompleted;
                    timer.RunWorkerAsync(not);                                      // Timer (temporary notes)
                }

                notes.Add(not);                                                     // Add to our collection of Notifiers
                updated_note_id = not.ID;
            }

            return updated_note_id;                                                 // Return the current ID of the created/updated Note
        }

        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  Check if the note is already present
        //                                  Point out the ID and the occurency of the already present note
        //-------------------------------------------------------------------------------------------------------------------------------
        private static bool NotifierAlreadyPresent(string desc, 
                                                   Type type, 
                                                   string tit, 
                                                   bool isDiag, 
                                                   out short updated_note_id, 
                                                   out short updated_note_occurency)
        {
            updated_note_id         = 0;
            updated_note_occurency  = 0;

            foreach (var note in notes)
            {
                short occurency      = 0;
                string filteredTitle = note.title;
                int indx             = filteredTitle.IndexOf(']');

                if(indx > 0)
                {
                    string numberOccurency = filteredTitle.Substring(0, indx);              // Get occurrency from title
                    numberOccurency        = numberOccurency.Trim(' ', ']', '[');
                    Int16.TryParse(numberOccurency, out occurency);

                    if (occurency > 1)                                                      // This will fix the note counter due to the
                        --occurency;                                                        // displayed note number that starts from "[2]"
                
                    filteredTitle = filteredTitle.Substring(indx + 1).Trim();
                }

                if (note.Tag         != null &&                                             // Get the node
                    note.description == desc &&
                    note.isDialog    == isDiag &&
                    filteredTitle    == tit &&
                    note.type        == type)
                {
                    string hex_id          = note.Tag.ToString().Split('|')[1];             // Get Notifier ID
                    short id               = Convert.ToInt16(hex_id, 16);
                    updated_note_id        = id;
                    updated_note_occurency = ++occurency;
                    return true;
                }
            }
            return false;
        }

        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  Update the note with the new content. Reset the timeout if any
        //-------------------------------------------------------------------------------------------------------------------------------
        public static void Update(short ID, 
                                  string desc, 
                                  Type noteType, 
                                  string title)
        {
            foreach (var note in notes)
            {
                if (note.Tag != null &&                                     // Get the node
                    note.Tag.Equals("__Notifier|" + ID.ToString("X4")))
                {
                    if (note.timerResetEvent != null)                            // Reset the timeout timer (if any)
                        note.timerResetEvent.Set();

                    Notifier myNote = (Notifier)note;
                    myNote.setNotifier(desc, noteType, title, true);        // Set the new note content
                }
            }
        }
#endregion

#region TIMER
        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  Background Worker to handle the timeout of the note
        //-------------------------------------------------------------------------------------------------------------------------------
        private static void timer_DoWork(object sender, DoWorkEventArgs e)
        {
            Notifier not = (Notifier)e.Argument;
            bool timedOut = false;
            while (!timedOut)
            {
                if (!not.timerResetEvent.WaitOne(not.timeout_ms))
                    timedOut = true;                                        // Time is out
            }
            e.Result = e.Argument;
        }

        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  Background Worker to handle the timeout event
        //-------------------------------------------------------------------------------------------------------------------------------
        private static void timer_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            Notifier not = (Notifier) e.Result;
            not.closeMe();                                                  // Close the note
        }
#endregion

#region DIALOG NOTE CREATION
        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  Show a Dialog note: with faded background if specified
        //-------------------------------------------------------------------------------------------------------------------------------
        public static DialogResult ShowDialog(string content, 
                                              Type type                       = Type.INFO, 
                                              string title                    = "Notifier",
                                              BackDialogStyle backDialogStyle = BackDialogStyle.FadedScreen,
                                              Form application                = null)
        {
            Form back               = null;
            int backBorder          = 200;
            bool orgTopMostSettings = false;

            if (backDialogStyle == BackDialogStyle.FadedApplication && 
                application     == null)
                backDialogStyle     = BackDialogStyle.FadedScreen;

            if (backDialogStyle != BackDialogStyle.None)
            {
                back = new Form();                                              // Create the fade background
                back.FormBorderStyle = FormBorderStyle.None;
                back.BackColor       = Color.FromArgb(0, 0, 0);
                back.Opacity         = 0.6;
                back.ShowInTaskbar   = false;
            }

            Notifier note           = new Notifier(content, type, title, true);      // Instantiate the Notifier form
            note.backDialogStyle    = backDialogStyle;

            switch (note.backDialogStyle)
            {
                case BackDialogStyle.None:
                    if (application != null)                                    // Set the startup position
                    {
                        note.Owner         = application;
                        note.StartPosition = FormStartPosition.CenterParent;
                    }
                    else
                    {
                        note.StartPosition = FormStartPosition.CenterScreen;
                    }
                    break;
                case BackDialogStyle.FadedScreen:
                    back.Location          = new System.Drawing.Point(-backBorder, -backBorder);
                    back.Size              = new Size(Screen.PrimaryScreen.WorkingArea.Width + backBorder,
                                                      Screen.PrimaryScreen.WorkingArea.Height + backBorder);

                    if (application != null)
                        back.Show(application);
                    back.TopMost           = true;
                    note.StartPosition     = FormStartPosition.CenterScreen;    // Set the startup position
                    break;
                case BackDialogStyle.FadedApplication:
                    note.myCallerApp       = application;
                    orgTopMostSettings     = application.TopMost;
                    application.TopMost    = true;
                    back.StartPosition     = FormStartPosition.Manual;
                    back.Size              = application.Size;
                    back.Location          = application.Location;
                    if (application != null)
                        back.Show(application);
                    back.TopMost           = true;
                    note.StartPosition     = FormStartPosition.CenterParent;    // Set the startup position
                    break;
            }

            notes.Add(note);                                                    // Add to our collection of Notifiers    
            note.ShowInTaskbar = false;
            note.ShowDialog();

            if (back != null)                                                   // Close the back
                back.Close();

            if (application != null)                                            // restore app window top most property
                application.TopMost = orgTopMostSettings;

            return DialogResult.OK;
        }

        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  Show a Dialog note: fast creation
        //-------------------------------------------------------------------------------------------------------------------------------
        public static void ShowDialog(string content, string title = "Notifier", Type type = Type.INFO)
        {
            ShowDialog(content, type, title);
        }
#endregion

#region DRAG NOTE
        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  Handle the dragging event: change the position of the note
        //-------------------------------------------------------------------------------------------------------------------------------
        private void OnMouseMove(object sender, MouseEventArgs e)
        {
            if (noteLocation.mouseIsDown)
            {
                int xDiff = noteLocation.initialLocation.X - e.Location.X;      // Get the difference between the two points
                int yDiff = noteLocation.initialLocation.Y - e.Location.Y;

                int x = this.Location.X - xDiff;                                // Set the new point
                int y = this.Location.Y - yDiff;

                noteLocation.X = x;                                             // Update the location
                noteLocation.Y = y;
                Location = new Point(x, y);
            }
        }

        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  Handle the mouse down event
        //-------------------------------------------------------------------------------------------------------------------------------
        private void OnMouseDown(object sender, MouseEventArgs e)
        {
            noteLocation.initialLocation = e.Location;
            noteLocation.mouseIsDown = true;
        }
        
        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  Handle the mouse up event
        //-------------------------------------------------------------------------------------------------------------------------------
        private void OnMouseUp(object sender, MouseEventArgs e)
        {
            noteLocation.mouseIsDown = false;
        }
#endregion

    }   // Close Class
}       // Close NS
