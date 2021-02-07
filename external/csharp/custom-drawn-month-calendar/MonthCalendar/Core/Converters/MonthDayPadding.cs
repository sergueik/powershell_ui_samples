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
    internal class MonthDaysPaddingTypeConverter : ExpandableObjectConverter
    {
        private MonthDaysPadding m_DaysPadding = null;
        public override bool CanConvertTo(ITypeDescriptorContext context, Type destinationType)
        {
            if (destinationType == typeof(MonthDaysPadding))
                return true;

            return base.CanConvertTo(context, destinationType);
        }

        public override object ConvertTo(ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, Type destinationType)
        {
            if (destinationType == typeof(string) && (value is MonthDaysPadding))
            {
                MonthDaysPadding myDaysPadding = (MonthDaysPadding)value;
                m_DaysPadding = myDaysPadding;
                return myDaysPadding.Horizontal.ToString() + ";" + myDaysPadding.Vertical.ToString();
            }
            return base.ConvertTo(context, culture, value, destinationType);
        }

        public override bool CanConvertFrom(ITypeDescriptorContext context, Type sourceType)
        {
            if (sourceType == typeof(string))
                return true;

            return base.CanConvertFrom(context, sourceType);
        }

        public override object ConvertFrom(ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value)
        {
            if (value is string)
            {
                try
                {
                    string smyValue = (string)value;
                    int iSepPos = smyValue.IndexOf(";");
                    if (iSepPos > -1)
                    {
                        string sHorizontal = smyValue.Substring(0, iSepPos);
                        string sVertical = smyValue.Substring(iSepPos + 1, smyValue.Length - iSepPos - 1);
                        System.Diagnostics.Debug.WriteLine("Horizontal: " + sHorizontal);
                        System.Diagnostics.Debug.WriteLine("vertical: " + sVertical);

                        m_DaysPadding.Horizontal = Int32.Parse(sHorizontal);
                        m_DaysPadding.Vertical = Int32.Parse(sVertical);

                        return m_DaysPadding;
                    }
                }
                catch
                {
                    throw new ArgumentException("can't convert '" + (string)value + "' to type MonthDaysPadding");
                }
            }

            return base.ConvertFrom(context, culture, value);
        }
    }
}
