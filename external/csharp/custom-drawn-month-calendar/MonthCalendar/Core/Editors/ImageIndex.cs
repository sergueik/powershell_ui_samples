using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;
using System.ComponentModel.Design;
using System.ComponentModel.Design.Serialization;
using System.Collections;
using System.Drawing.Design;
using System.Drawing;
using System.Windows.Forms;
using System.Windows.Forms.Design;

namespace MonthCalendar
{
    internal class ExtImageIndexEditor : UITypeEditor
    {
        private ImageListControlPanel m_ImageListPanel = new ImageListControlPanel();
        private IWindowsFormsEditorService m_wfes;
        private int m_SelectedValue = -1;

        protected virtual ImageList GetImageList(object component)
        {
            DateItem Item = component as DateItem;
            if (Item != null)
            {
                return Item.GetImageList();
            }

            return null;
        }

        public override bool GetPaintValueSupported(ITypeDescriptorContext context)
        {
            return true;
        }

        public override object EditValue(System.ComponentModel.ITypeDescriptorContext context, IServiceProvider provider, object value)
        {
            m_wfes = (IWindowsFormsEditorService)provider.GetService(typeof(IWindowsFormsEditorService));
            if ((m_wfes == null) || (context == null))
                return null;

            ImageList myImageList = GetImageList(context.Instance);

            if (myImageList == null || myImageList.Images.Count == 0)
                return -1;

            m_ImageListPanel.ImageColumns = 6;
            m_ImageListPanel.ImageList = myImageList;
            m_ImageListPanel.ItemClick += new ImageListControlPanelEventHandler(ImageListItemClicked);
            m_ImageListPanel.SelectedImage = (int)value;

            m_wfes.DropDownControl(m_ImageListPanel);

            return m_SelectedValue;
        }

        public override System.Drawing.Design.UITypeEditorEditStyle GetEditStyle(System.ComponentModel.ITypeDescriptorContext context)
        {
            if (context != null && context.Instance != null)
            {
                return UITypeEditorEditStyle.DropDown;
            }
            return base.GetEditStyle(context);
        }

        public override void PaintValue(System.Drawing.Design.PaintValueEventArgs e)
        {
            int iImageIndex = -1;

            if (e.Value != null)
            {
                iImageIndex = Convert.ToInt32(e.Value);
            }
            else return;

            if (e.Context.Instance == null)
                return;

            ImageList myImageList = GetImageList(e.Context.Instance);

            if (myImageList != null && myImageList.Images.Count > 0 && iImageIndex >= 0 &&
                iImageIndex < myImageList.Images.Count)
            {
                e.Graphics.DrawImage(myImageList.Images[iImageIndex], e.Bounds);
            }
            else
            {
                e.Graphics.DrawLine(Pens.Black, e.Bounds.X + 1, e.Bounds.Y + 1,
                                        e.Bounds.Right - 1, e.Bounds.Bottom - 1);
                e.Graphics.DrawLine(Pens.Black, e.Bounds.Right - 1, e.Bounds.Y + 1,
                                    e.Bounds.X + 1, e.Bounds.Bottom - 1);
            }

        }

        private void ImageListItemClicked(object sender, ImageListControlPanelEventArgs e)
        {
            m_SelectedValue = ((ImageListControlPanelEventArgs)e).SelectedItem;
            m_wfes.CloseDropDown();
        }
    }
}
