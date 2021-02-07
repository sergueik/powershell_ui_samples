using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms.Design;

namespace MonthCalendar
{
 

    public class DateItemDesigner : System.Windows.Forms.Design.ControlDesigner
    {
        public DateItemDesigner()
        {

        }

        [System.Obsolete]
        public override void OnSetComponentDefaults()
        {
            base.OnSetComponentDefaults();

        }

        /*// Use pull model to populate smart tag menu.
        public override DesignerActionListCollection ActionLists
        {
            get
            {
                if (null == actionLists)
                {
                    actionLists = new DesignerActionListCollection();
                    actionLists.Add(
                        new CalendarActionList(this.Component));
                }
                return actionLists;
            }
        }
        */

        public override SelectionRules SelectionRules
        {
            get
            {
                // Remove all manual resizing of the control
                SelectionRules selectionRules = base.SelectionRules;
                //selectionRules = SelectionRules.Visible | SelectionRules.AllSizeable | SelectionRules.Moveable;
                return selectionRules;
            }
        }

        protected override void PreFilterProperties(System.Collections.IDictionary properties)
        {
            base.PreFilterProperties(properties);
            /*
            // Remove obsolete properties
            properties.Remove("(ApplicationSettings)");
            //properties.Remove("(Name)");
            properties.Remove("GenerateMember");
            properties.Remove("Modifiers");*/
        }

    }
}
