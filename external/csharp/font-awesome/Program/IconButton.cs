using System;
using System.Diagnostics;
using System.Drawing;
using System.Drawing.Text;
using System.Windows.Forms;
using System.ComponentModel;

namespace FontAwesomeIcons {
    public class IconButton : PictureBox {

        private IconType _iconType = IconType.Star;
        private string _tooltip = null;
        private Color _activeColor = Color.Black;
        private Color _inActiveColor = Color.Black;
        private ToolTip _tT = new ToolTip();
        private string IconChar { get; set; }
        private Font IconFont { get; set; }
        private Brush IconBrush { get; set; } // brush currently in use
        private Brush ActiveBrush { get; set; } // brush to use when hovered over
        private Brush InActiveBrush { get; set; } // brush to use when not hovered over

        public IconButton() : this(IconType.Star, 16, Color.DimGray, Color.Black, false, null) {

        }

        public IconButton(IconType type, int size, Color normalColor, Color hoverColor, bool selectable, string toolTip) {
            IconFont = null;
            BackColor = Color.Transparent;

            // need more than this to make picturebox selectable
            if (selectable) {
                SetStyle(ControlStyles.Selectable, true);
                TabStop = true;
            }

            Width = size;
            Height = size;

            IconType = type;

            InActiveColor = normalColor;
            ActiveColor = hoverColor;

            ToolTipText = toolTip;

            MouseEnter += Icon_MouseEnter;
            MouseLeave += Icon_MouseLeave;
        }

        public IconType IconType {
            get { return _iconType; }
            set {
                _iconType = value;
                // see http://fortawesome.github.io/Font-Awesome/cheatsheet/ for a list of hex values
                IconChar = char.ConvertFromUtf32((int)value);
                Invalidate();
            }
        }

        [Localizable(true)]
        public string ToolTipText {
            get { return _tooltip; }
            set {
                _tooltip = value;
                if (value != null) {
                    _tT.IsBalloon = true;
                    _tT.ShowAlways = true;
                    _tT.SetToolTip(this, value);
                }
            }
        }

        public Color ActiveColor {
            get { return _activeColor; }
            set {
                _activeColor = value;
                ActiveBrush = new SolidBrush(value);
                Invalidate();
            }
        }

        public Color InActiveColor {
            get { return _inActiveColor; }
            set {
                _inActiveColor = value;
                InActiveBrush = new SolidBrush(value);
                IconBrush = InActiveBrush;
                Invalidate();
            }
        }

        public new int Width {
            set {
                // force the font size to be recalculated & redrawn
                base.Width = value;
                IconFont = null;
                Invalidate();
            }
            get { return base.Width; }
        }

        public new int Height {
            set {
                // force the font size to be recalculated & redrawn
                base.Height = value;
                IconFont = null;
                Invalidate();
            }
            get { return base.Height; }
        }

        public void SetIconChar(char value) {
            IconChar = value.ToString();
            Invalidate();
        }

        public void SetIconChar(String value) {
            IconChar = value;
            Invalidate();
        }
        protected void Icon_MouseLeave(object sender, EventArgs e) {
            // change the brush and force a redraw
            IconBrush = InActiveBrush;
            Invalidate();
        }
        protected void Icon_MouseEnter(object sender, EventArgs e) {
            // change the brush and force a redraw
            IconBrush = ActiveBrush;
            Invalidate();
        }
        protected override void OnPaint(PaintEventArgs e) {
            var graphics = e.Graphics;

            // Set best quality
            graphics.TextRenderingHint = System.Drawing.Text.TextRenderingHint.AntiAliasGridFit;
            graphics.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBilinear;
            graphics.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.HighQuality;
            graphics.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;

            if (IconFont == null) {
                SetFontSize(graphics);
            }

            // center the icon
            SizeF stringSize = graphics.MeasureString(IconChar, IconFont, Width);
            float w = stringSize.Width;
            float h = stringSize.Height;

            float left = (Width - w) / 2;
            float top = (Height - h) / 2;

            graphics.DrawString(IconChar, IconFont, IconBrush, new PointF(left, top));

            base.OnPaint(e);

            if (Focused) {
                var rc = this.ClientRectangle;
                rc.Inflate(-2, -2);
                ControlPaint.DrawFocusRectangle(e.Graphics, rc);
            }
        }

        private void SetFontSize(Graphics g) {
            IconFont = GetAdjustedFont(g, IconChar, Width, Height, 4, true);
        }

        private Font GetIconFont(float size) {
            return new Font(Fonts.Families[0], size, GraphicsUnit.Point);
        }

		private Font GetAdjustedFont(Graphics g, string graphicString, int containerWidth, int maxFontSize, int minFontSize, bool smallestOnFail) {
			for (double adjustedSize = maxFontSize; adjustedSize >= minFontSize; adjustedSize = adjustedSize - 0.5) {
				Font testFont = GetIconFont((float)adjustedSize);
				SizeF adjustedSizeNew = g.MeasureString(graphicString, testFont);
				if (containerWidth > Convert.ToInt32(adjustedSizeNew.Width)) {
					return testFont;
				}
			}
			return GetIconFont(smallestOnFail ? minFontSize : maxFontSize);
		}

        static IconButton() {
            InitialiseFont();
        }

        [System.Runtime.InteropServices.DllImport("gdi32.dll")]
        private static extern IntPtr AddFontMemResourceEx(IntPtr pbFont, uint cbFont,
           IntPtr pdv, [System.Runtime.InteropServices.In] ref uint pcFonts);

        private static readonly PrivateFontCollection Fonts = new PrivateFontCollection();

        private static void InitialiseFont() {
            try {
                unsafe {
                    fixed (byte* pFontData = Properties.Resources.fontawesome_webfont) {
                        uint dummy = 0;
                        Fonts.AddMemoryFont((IntPtr)pFontData, Properties.Resources.fontawesome_webfont.Length);
                        AddFontMemResourceEx((IntPtr)pFontData, (uint)Properties.Resources.fontawesome_webfont.Length, IntPtr.Zero, ref dummy);
                    }
                }
            } catch (Exception e) {
				Trace.Assert(e != null);
            }
        }
    }
}
