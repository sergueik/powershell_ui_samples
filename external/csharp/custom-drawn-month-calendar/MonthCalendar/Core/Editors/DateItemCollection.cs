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
    public class DateItemCollectionEditor : CollectionEditor
    {
        private Calendar m_calendar;
        private ITypeDescriptorContext m_context;

        public DateItemCollectionEditor(Type type)
            : base(type)
        {

        }

        protected override void DestroyInstance(object instance)
        {
            base.DestroyInstance(instance);

        }

        public override object EditValue(ITypeDescriptorContext context, IServiceProvider provider, object value)
        {
            m_context = context;

            object returnObject = base.EditValue(context, provider, value);

            DatesCollection collection = returnObject as DatesCollection;
            if (collection != null)
            {
                if (m_calendar != null) m_calendar.OnDatesChange();
            }

            return returnObject;
        }


        protected override object CreateInstance(Type itemType)
        {
            object dateItem = base.CreateInstance(itemType);

            Calendar originalControl = (Calendar)m_context.Instance;
            m_calendar = originalControl;

            ((DateItem)dateItem).Date = DateTime.Today;
            ((DateItem)dateItem).Calendar = m_calendar;
            return dateItem;
        }

    }
}
