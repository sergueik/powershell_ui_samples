using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.ComponentModel;
using System.Collections;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace MonthCalendar
{
    [TypeConverter(typeof(BackgroundStyleTypeConverter))]
    public class MonthImageData
    {
        private Calendar m_Parent;
        private bool m_UseImages = false;
        private int m_MonthImagesHeight = 68;
        private MonthImagePosition m_Position;
        private Image m_JanuaryImage;
        private Image m_FebrauryImage;
        private Image m_MarchImage;
        private Image m_AprilImage;
        private Image m_MayImage;
        private Image m_JuneImage;
        private Image m_JulyImage;
        private Image m_AusgustImage;
        private Image m_SeptemberImage;
        private Image m_OctoberImage;
        private Image m_NovemberImage;
        private Image m_DecemberImage;

        public MonthImageData(Calendar Parent)
        {
            m_Parent = Parent;            
        }

        [Description("set image position")]
        public MonthImagePosition ImagePosition
        {
            get
            {
                return m_Position;
            }
            set
            {
                m_Position = value;
                if (m_Parent != null)
                {
                    m_Parent.OnMonthImagesChange();
                    m_Parent.Invalidate();
                }
            }
        }

        [Description("true to use a Image for each Month")]
        public bool UseImages
        {
            get
            {
                return m_UseImages;
            }
            set
            {
                m_UseImages = value;
                if (m_Parent != null)
                {
                    m_Parent.OnMonthImagesChange();
                    m_Parent.Invalidate();
                }
            }
        }

        [Description("set the Images height")]
        public int ImagesHeight
        {
            get
            {
                return m_MonthImagesHeight;
            }
            set
            {
                m_MonthImagesHeight = value;
                if (m_Parent != null)
                {
                    m_Parent.OnMonthImagesChange();
                    m_Parent.Invalidate();
                }
            }
        }

        [Description("set the Image for month January")]
        public Image JanuaryImage
        {
            get
            {
                return m_JanuaryImage;
            }
            set
            {
                m_JanuaryImage = value;
                if (m_Parent != null)
                {
                    m_Parent.OnMonthImagesChange();
                    m_Parent.Invalidate();
                }
            }
        }

        [Description("set the Image for month February")]
        public Image FebruaryImage
        {
            get
            {
                return m_FebrauryImage;
            }
            set
            {
                m_FebrauryImage = value;
                if (m_Parent != null)
                {
                    m_Parent.OnMonthImagesChange();
                    m_Parent.Invalidate();
                }
            }
        }

        [Description("set the Image for month March")]
        public Image MarchImage
        {
            get
            {
                return m_MarchImage;
            }
            set
            {
                m_MarchImage = value;
                if (m_Parent != null)
                {
                    m_Parent.OnMonthImagesChange();
                    m_Parent.Invalidate();
                }
            }
        }

        [Description("set the Image for month April")]
        public Image AprilImage
        {
            get
            {
                return m_AprilImage;
            }
            set
            {
                m_AprilImage = value;
                if (m_Parent != null)
                {
                    m_Parent.OnMonthImagesChange();
                    m_Parent.Invalidate();
                }
            }
        }

        [Description("set the Image for month May")]
        public Image MayImage
        {
            get
            {
                return m_MayImage;
            }
            set
            {
                m_MayImage = value;
                if (m_Parent != null)
                {
                    m_Parent.OnMonthImagesChange();
                    m_Parent.Invalidate();
                }
            }
        }

        [Description("set the Image for month June")]
        public Image JuneImage
        {
            get
            {
                return m_JuneImage;
            }
            set
            {
                m_JuneImage = value;
                if (m_Parent != null)
                {
                    m_Parent.OnMonthImagesChange();
                    m_Parent.Invalidate();
                }
            }
        }

        [Description("set the Image for month July")]
        public Image JulyImage
        {
            get
            {
                return m_JulyImage;
            }
            set
            {
                m_JulyImage = value;
                if (m_Parent != null)
                {
                    m_Parent.OnMonthImagesChange();
                    m_Parent.Invalidate();
                }
            }
        }

        [Description("set the Image for month August")]
        public Image AugustImage
        {
            get
            {
                return m_AusgustImage;
            }
            set
            {
                m_AusgustImage = value;
                if (m_Parent != null)
                {
                    m_Parent.OnMonthImagesChange();
                    m_Parent.Invalidate();
                }
            }
        }

        [Description("set the Image for month September")]
        public Image SeptemberImage
        {
            get
            {
                return m_SeptemberImage;
            }
            set
            {
                m_SeptemberImage = value;
                if (m_Parent != null)
                {
                    m_Parent.OnMonthImagesChange();
                    m_Parent.Invalidate();
                }
            }
        }

        [Description("set the Image for month October")]
        public Image OctoberImage
        {
            get
            {
                return m_OctoberImage;
            }
            set
            {
                m_OctoberImage = value;
                if (m_Parent != null)
                {
                    m_Parent.OnMonthImagesChange();
                    m_Parent.Invalidate();
                }
            }
        }

        [Description("set the Image for month November")]
        public Image NovemberImage
        {
            get
            {
                return m_NovemberImage;
            }
            set
            {
                m_NovemberImage = value;
                if (m_Parent != null)
                {
                    m_Parent.OnMonthImagesChange();
                    m_Parent.Invalidate();
                }
            }
        }

        [Description("set the Image for month December")]
        public Image DecemberImage
        {
            get
            {
                return m_DecemberImage;
            }
            set
            {
                m_DecemberImage = value;
                if (m_Parent != null)
                {
                    m_Parent.OnMonthImagesChange();
                    m_Parent.Invalidate();
                }
            }
        }

    }
}
