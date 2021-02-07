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
    public class DateItemTypeConverter : TypeConverter
    {
        public override object ConvertTo(ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, Type destinationType)
        {
            DateItem d;
            d = (DateItem)value;
            return d.Date.ToShortDateString();

        }

        public override bool CanConvertTo(ITypeDescriptorContext context, Type destinationType)
        {

            if (destinationType == typeof(string))
                return true;
            return base.CanConvertTo(context, destinationType);

        }

    }
}
