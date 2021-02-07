using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using System.Globalization;
using System.Drawing;
using System.Drawing.Design;
using System.Drawing.Drawing2D;
using System.ComponentModel;
using System.Threading;

namespace MonthCalendar
{
    #region ImageLIstControlPanel
    [ToolboxItem(false)]
    public class ImageListControlPanel : Control
    {
        private Size m_ImageDimension = new Size(12,12);
        private ImageList m_ImageList;
        private Color m_HoverColor = Color.Blue;
        private Color m_SelectedColor = Color.PaleTurquoise;
        private int m_iColumns = 6;
        private int m_iSelectedImage = -1;
        private int m_iRealColumns = 6;
        private int m_iRealRows = 1;
        private int m_iMouseOverColumn = -1;
        private int m_iMouseOverRow = -1;

        public event ImageListControlPanelEventHandler ItemClick;

        public ImageListControlPanel()
        {
            this.ResizeRedraw = true;
            this.SetStyle(System.Windows.Forms.ControlStyles.DoubleBuffer, true);
            this.SetStyle(System.Windows.Forms.ControlStyles.SupportsTransparentBackColor, true);
            this.SetStyle(ControlStyles.UserPaint, true);
            this.SetStyle(System.Windows.Forms.ControlStyles.AllPaintingInWmPaint, true);
            this.SetStyle(ControlStyles.SupportsTransparentBackColor, true);
            this.UpdateStyles();
        }

        public Size ImageOffset
        {
            get
            {
                return m_ImageDimension;
            }
            set
            {
                m_ImageDimension = value;
                Init();
                Invalidate();
            }
        }

        public ImageList ImageList
        {
            get
            {
                return m_ImageList;
            }
            set
            {
                m_ImageList = value;
                Init();
                Invalidate();
            }
        }

        public int ImageColumns
        {
            get
            {
                return m_iColumns;
            }
            set
            {
                m_iColumns = value;
                Init();
                Invalidate();
            }
        }

        public int SelectedImage
        {
            get
            {
                return m_iSelectedImage;
            }
            set
            {
                m_iSelectedImage = value;
                Invalidate();
            }
        }

        public Color HoverColor
        {
            get
            {
                return m_HoverColor;
            }
            set
            {
                m_HoverColor = value;
                Invalidate();
            }
        }

        public Color ActiveColor
        {
            get
            {
                return m_SelectedColor;
            }
            set
            {
                m_SelectedColor = value;
                Invalidate();
            }
        }

        private void Init()
        {
            int iReallImages = 0;
            if (m_ImageList != null)
                iReallImages = m_ImageList.Images.Count;

            if (iReallImages == 0)
            {
                m_iRealColumns = 1;
                m_iRealRows = 1;
            }
            else if (iReallImages < m_iColumns)
            {
                m_iRealColumns = iReallImages;
                m_iRealRows = 1;
            }
            else
            {
                m_iRealColumns = m_iColumns;
                m_iRealRows = (int)iReallImages / m_iColumns;
                if (m_iRealRows * m_iColumns < iReallImages)
                    m_iRealRows++;
            }

            //set new controldimension
            if (m_ImageList != null)
            {
                this.Width = m_iRealColumns * (m_ImageList.ImageSize.Width + m_ImageDimension.Width);
                this.Height = m_iRealRows * (m_ImageList.ImageSize.Height + m_ImageDimension.Height);
            }
        }

        protected override void OnPaint(PaintEventArgs e)
        {
            base.OnPaint(e);
            int iRowCounter = 0; 
            int iColCounter = 0;
            int iLeftPos = 0;
            int iTopPos = 0;
            if (m_ImageList != null)
            {
                for (int iImageCounter = 0; iImageCounter <= m_ImageList.Images.Count; iImageCounter++)
                {
                    //get draw rect
                    Rectangle myRect = new Rectangle(iColCounter * (m_ImageList.ImageSize.Width + m_ImageDimension.Width),
                                                         iRowCounter * (m_ImageList.ImageSize.Height + m_ImageDimension.Height),
                                                         m_ImageList.ImageSize.Width + m_ImageDimension.Width,
                                                         m_ImageList.ImageSize.Height + m_ImageDimension.Height);
                    //draw activerect if image was selected
                    if (iImageCounter == m_iSelectedImage+1)
                    {
                        e.Graphics.FillRectangle(new SolidBrush(Color.FromArgb(255, m_SelectedColor)), myRect);
                    }

                    iLeftPos = iColCounter * (m_ImageList.ImageSize.Width + m_ImageDimension.Width) +
                               ((int)m_ImageDimension.Width / 2);
                    iTopPos = iRowCounter * (m_ImageList.ImageSize.Height + m_ImageDimension.Height) + 
                              ((int)m_ImageDimension.Height / 2);

                    if (iImageCounter > 0)
                    {
                        e.Graphics.DrawImage(m_ImageList.Images[iImageCounter-1], iLeftPos, iTopPos);

                    }
                    else
                    {
                        //draw empty value
                        e.Graphics.DrawRectangle(new Pen(this.ForeColor), iLeftPos, iTopPos,
                                                 m_ImageList.ImageSize.Width,
                                                 m_ImageList.ImageSize.Height);
                        e.Graphics.DrawLine(new Pen(this.ForeColor), iLeftPos, iTopPos,
                                            iLeftPos + m_ImageList.ImageSize.Width,
                                            iTopPos + m_ImageList.ImageSize.Height);
                        e.Graphics.DrawLine(new Pen(this.ForeColor), iLeftPos + m_ImageList.ImageSize.Width, iTopPos,
                                            iLeftPos,
                                            iTopPos + m_ImageList.ImageSize.Height);
                    }

                    if (m_iMouseOverColumn == iColCounter && m_iMouseOverRow == iRowCounter)
                    {
                        myRect = new Rectangle(iColCounter * (m_ImageList.ImageSize.Width + m_ImageDimension.Width),
                                                         iRowCounter * (m_ImageList.ImageSize.Height + m_ImageDimension.Height),
                                                         m_ImageList.ImageSize.Width + m_ImageDimension.Width,
                                                         m_ImageList.ImageSize.Height + m_ImageDimension.Height);
                        e.Graphics.FillRectangle(new SolidBrush(Color.FromArgb(60, m_HoverColor)), myRect);
                    }
                    iColCounter++;
                    if (iColCounter == 6)
                    {
                        iRowCounter++;
                        iColCounter = 0;
                    }
                }
            }
        }

        protected override void OnMouseMove(MouseEventArgs e)
        {
            base.OnMouseMove(e);
            if (m_ImageList != null)
            {
                m_iMouseOverColumn = (int)e.X / (m_ImageList.ImageSize.Width + m_ImageDimension.Width);
                m_iMouseOverRow = (int)e.Y / (m_ImageList.ImageSize.Height + m_ImageDimension.Height);

                Invalidate();
            }
        }

        protected override void OnMouseLeave(EventArgs e)
        {
            base.OnMouseLeave(e);
            m_iMouseOverColumn = -2;
            m_iMouseOverRow = -2;
            Invalidate();
        }

        protected override void OnMouseUp(MouseEventArgs e)
        {
            base.OnMouseUp(e);
            if (m_ImageList != null)
            {
                m_iMouseOverColumn = (int)e.X / (m_ImageList.ImageSize.Width + m_ImageDimension.Width);
                m_iMouseOverRow = (int)e.Y / (m_ImageList.ImageSize.Height + m_ImageDimension.Height);

                int iSelectedItem = (m_iMouseOverRow * m_iColumns) + m_iMouseOverColumn-1;
                //fire event
                if (ItemClick != null) ItemClick(this, new ImageListControlPanelEventArgs(iSelectedItem));
            }
        }
    }
    #endregion

    #region delegates
    public delegate void ImageListControlPanelEventHandler(object sender, ImageListControlPanelEventArgs e);
    #endregion

    #region ImageListControlPanelEventArgs
    public class ImageListControlPanelEventArgs : EventArgs
    {
        internal int SelectedItem;

        public ImageListControlPanelEventArgs(int Item)
        {
            SelectedItem = Item;
        }
    }
    #endregion
}
