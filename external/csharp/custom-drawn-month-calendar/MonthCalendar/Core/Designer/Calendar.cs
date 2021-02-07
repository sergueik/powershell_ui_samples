using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms.Design;

namespace MonthCalendar
{
    class CalendarDesigner : System.Windows.Forms.Design.ControlDesigner
    {

        public CalendarDesigner()
        {

        }

        [System.Obsolete]
        public override void OnSetComponentDefaults()
        {
            base.OnSetComponentDefaults();

        }

        public override SelectionRules SelectionRules
        {
            get
            {
                // Remove all manual resizing of the control
                SelectionRules selectionRules = base.SelectionRules;
                selectionRules = SelectionRules.Visible | SelectionRules.AllSizeable | SelectionRules.Moveable;
                return selectionRules;
            }
        }

        protected override void PreFilterProperties(System.Collections.IDictionary properties)
        {
            //base.PreFilterProperties(properties);

            // Remove obsolete properties
            properties.Remove("AllowDrop");
            properties.Remove("Font");         
            properties.Remove("ForeColor");
            properties.Remove("Text");
            properties.Remove("RightToLeft");
            properties.Remove("ImeMode");
            properties.Remove("Padding");
            
        }
    }
}
