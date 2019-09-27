using System;
using System.Drawing;
using System.Windows.Forms;

// https://www.doogal.co.uk/transparent.php
// C# Transparent Label
namespace Utilities {
    public class TransparentLabel : Control {
        public TransparentLabel ( ) {
            TabStop = false;
        }

        protected override CreateParams CreateParams {
            
            get {
                CreateParams cp = base.CreateParams;
                cp.ExStyle |= 0x20;
                return ( cp );
                }
            }

        protected override void OnPaintBackground ( PaintEventArgs e ) {
        }

        protected override void OnPaint ( PaintEventArgs e ) {
            DrawText ( );
        }

        protected override void WndProc ( ref Message m ){    
            base.WndProc ( ref m );
            if ( m.Msg == 0x000F ) {
                DrawText ( );
            }    
        }

        private void DrawText ( ){
            using ( Graphics graphics = CreateGraphics ( ) )  {
                using ( SolidBrush brush = new SolidBrush ( ForeColor ) ) {
                    SizeF size = graphics.MeasureString ( Text, Font );
                                        // determine the top
                    float top = 0;
                    switch ( textAlign ) {
                        case ContentAlignment.MiddleLeft:
                        case ContentAlignment.MiddleCenter:
                        case ContentAlignment.MiddleRight:
                            top = ( Height - size.Height ) / 2;
                            break;
                            
                        case ContentAlignment.BottomLeft:
                        case ContentAlignment.BottomCenter:
                        case ContentAlignment.BottomRight:
                            top = Height - size.Height;
                            break;
                        }

                    float left = -1;
                    switch ( textAlign ) {
                        case ContentAlignment.TopLeft:
                        case ContentAlignment.MiddleLeft:
                        case ContentAlignment.BottomLeft:
                            if ( RightToLeft == RightToLeft.Yes )
                                left = Width - size.Width;
                            else
                                left = -1;
                            break;
                            
                        case ContentAlignment.TopCenter:
                        case ContentAlignment.MiddleCenter:
                        case ContentAlignment.BottomCenter:
                            left = ( Width - size.Width ) / 2;
                            break;
                            
                        case ContentAlignment.TopRight:
                        case ContentAlignment.MiddleRight:
                        case ContentAlignment.BottomRight:
                            if ( RightToLeft == RightToLeft.Yes )
                                left = -1;
                            else
                                left = Width - size.Width;
                            break;
                        }
                    graphics.DrawString ( Text, Font,brush, left, top );
                    }
                }
            }

        public override string Text {
            get {
                return base.Text;
            }
            
            set {
	            base.Text = value;
	            RecreateHandle ( );
            }
        }

        public override RightToLeft RightToLeft {
			get {
                return base.RightToLeft;
            }
            
            set  {
                base.RightToLeft = value;
                RecreateHandle ( );
            }
        }
        public override Font Font {
            get {
                return base.Font;
            }
                
            set {
                base.Font = value;
                RecreateHandle ( );
            }
        }

        private ContentAlignment textAlign = ContentAlignment.TopLeft;
        public ContentAlignment TextAlign {
            get {
                return textAlign;
            }
            
            set {
                textAlign = value;
                RecreateHandle ( );
            }
        }
    }
}