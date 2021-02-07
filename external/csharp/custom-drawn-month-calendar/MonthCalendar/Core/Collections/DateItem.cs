using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Drawing.Design;
using System.ComponentModel;
using System.Collections;
using System.Windows.Forms;

namespace MonthCalendar
{
    [TypeConverter(typeof(DateItemTypeConverter))]    
    [DesignTimeVisible(false)]
    [ToolboxItem(false)]
    public class DateItem : IComponent
    {
        public event EventHandler Disposed;

        private Calendar m_Parent = null;
        private BackgroundStyle m_BackgroundStyle = null;
        private BorderStyle m_BorderStyle = null;
        private ContentAlignment m_DayAlign = ContentAlignment.TopRight;
        private ContentAlignment m_ImageAlign = ContentAlignment.TopLeft;
        private ContentAlignment m_TextAlign = ContentAlignment.BottomLeft;
        private Padding m_Padding;
        private Font m_Font;
        private Color m_ForeColor = Color.Black;
        private Image m_Image = null;
        private Image m_BackgroundImage = null;
        private DateTime m_Date = DateTime.Now;
        private DateTime m_LastDate;
        private DateItemReccurence m_Reccurence = DateItemReccurence.None;
        private ISite m_Site;
        private string m_Text = "";
        private int m_ImageIndex = -1;
        private bool m_Enabled = true;
        private bool m_Disposed = false;

        public DateItem()
        {
            m_BackgroundStyle = new BackgroundStyle(null);
            m_BorderStyle = new BorderStyle(null);
            m_Font = new Font("Tahoma", 9);
            m_LastDate = m_Date;
            m_Padding = new Padding(2);
        }

        #region dispose
        protected virtual void Dispose(bool disposing)
        {
            if (!m_Disposed)
            {
                if (disposing)
                {

                    //There is nothing to clean.
                    if (Disposed != null)
                        Disposed(this, EventArgs.Empty);
                }
                // shared cleanup logic
                m_Disposed = true;
            }
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        #endregion

        #region properties

        [Category("Appearance")]
        public ContentAlignment DayAlign
        {
            get
            {
                return m_DayAlign;
            }
            set
            {
                m_DayAlign = value;
                if (m_Parent != null)
                    m_Parent.Invalidate();
            }
        }

        [Category("Appearance")]
        public ContentAlignment ImageAlign
        {
            get
            {
                return m_ImageAlign;
            }
            set
            {
                m_ImageAlign = value;
                if (m_Parent != null)
                    m_Parent.Invalidate();
            }
        }

        [Category("Appearance")]
        public ContentAlignment TextAlign
        {
            get
            {
                return m_TextAlign;
            }
            set
            {
                m_TextAlign = value;
                if (m_Parent != null)
                    m_Parent.Invalidate();
            }
        }

        [Browsable(false)]
        public Calendar Calendar
        {
            get
            {
                return m_Parent;
            }
            set
            {
                m_Parent = value;
                m_BackgroundStyle.Parent = value;
                m_BorderStyle.Parent = value;
            }
        }

        [Browsable(false)]
        public virtual ISite Site
        {
            get
            {
                return m_Site;
            }
            set
            {
                m_Site = value;
            }
        }

        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
        [Category("Appearance")]
        public BackgroundStyle Background
        {
            get
            {
                return m_BackgroundStyle;
            }
            set
            {
                m_BackgroundStyle = value;
            }
        }

        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
        [Category("Appearance")]
        public BorderStyle Border
        {
            get
            {
                return m_BorderStyle;
            }
            set
            {
                m_BorderStyle = value;
            }
        }

        [Description("Set with a formated day used font")]
        [Category("Appearance")]
        public Font Font
        {
            get
            {
                return m_Font;
            }
            set
            {
                m_Font = value;
                if (m_Parent != null)
                {
                    m_Parent.Invalidate();
                }
            }
        }

        [Description("Set used fontcolor")]
        [Category("Appearance")]
        public Color ForeColor
        {
            get
            {
                return m_ForeColor;
            }
            set
            {
                m_ForeColor = value;
                if (m_Parent != null)
                {
                    m_Parent.Invalidate();
                }
            }
        }

        [Description("set in a formated day viewed text")]
        [Category("Data")]
        public string Text
        {
            get
            {
                return m_Text;
            }
            set
            {
                m_Text = value;
                if (m_Parent != null)
                {
                    m_Parent.Invalidate();
                }
            }
        }

        [Description("set in formated day viewed image")]
        [Category("Appearance")]
        public Image Image
        {
            get
            {
                return m_Image;
            }
            set
            {
                m_Image = value;
                if (m_Parent != null)
                {
                    m_Parent.Invalidate();
                }
            }
        }

        [Description("set in formated day viewed image from imagelist")]
        [Category("Appearance")]
        [Editor(typeof(ExtImageIndexEditor), typeof(UITypeEditor))]
        public int ImageIndex
        {
            get
            {
                return m_ImageIndex;
            }
            set
            {
                m_ImageIndex = value;
                if (m_Parent != null)
                {
                    m_Parent.Invalidate();
                }
            }
        }

        [Description("set formated day date")]
        [Category("Data")]
        public DateTime Date
        {
            get
            {
                return m_Date;
            }
            set
            {
                m_Date = value;
                this.Range = value;
                if (m_Parent != null)
                {
                    m_Parent.Invalidate();
                }
            }
        }

        [Description("set formated day end date")]
        [Category("Data")]
        public DateTime Range
        {
            get
            {
                return m_LastDate;
            }
            set
            {
                m_LastDate = value;
                if (m_Parent != null)
                    m_Parent.Invalidate();
            }
        }

        [Category("Behavior")]
        public DateItemReccurence Reccurence
        {
            get
            {
                return m_Reccurence;
            }
            set
            {
                m_Reccurence = value;
                if (m_Parent != null)
                {
                    m_Parent.Invalidate();
                }
            }
        }

        [Description("set true if date is active and drawed")]
        [Category("Behavior")]
        public bool Enabled
        {
            get
            {
                return m_Enabled;
            }
            set
            {
                m_Enabled = value;
                if (m_Parent != null)
                {
                    m_Parent.Invalidate();
                }
            }
        }

        [Category("Appearance")]
        public Image BackgroundImage
        {
            get
            {
                return m_BackgroundImage;
            }
            set
            {
                m_BackgroundImage = value;
                if (m_Parent != null)
                {
                    m_Parent.Invalidate();
                }
            }
        }

        [Description("set space between text/image and border")]
        public Padding Padding
        {
            get
            {
                return m_Padding;
            }
            set
            {
                m_Padding = value;
                if (m_Parent != null)
                    m_Parent.Invalidate();
            }
        }

        #endregion

        #region internal methods
        internal ImageList GetImageList()
        {
            if (m_Parent != null)
                return m_Parent.ImageList;
            else return null;
        }
        #endregion
    }
}
