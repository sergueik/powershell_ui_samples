using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.ComponentModel;
using System.Collections;

namespace MonthCalendar
{
    public class SelectedItemsCollection : CollectionBase
    {
        private Calendar m_Parent = null;

        public SelectedItemsCollection(Calendar Parent)
        {
            m_Parent = Parent;
        }

        public void Add(DateTime Date)
        {
            //add to list
            if (IndexOf(Date) == -1) 
                this.List.Add(Date);

            if (m_Parent != null)
                m_Parent.Invalidate();
        }

        public int IndexOf(DateTime Date)
        {
            //find index of date
            for (int iCollectionCount = 0; iCollectionCount < this.List.Count; iCollectionCount++)
            {
                if (this[iCollectionCount].ToShortDateString() == Date.ToShortDateString())
                {
                    return iCollectionCount;                    
                }
            }
            return -1;
        }

        public new void RemoveAt(int Index)
        {
            //remove item
            this.List.RemoveAt(Index);

            if (m_Parent != null)
                m_Parent.Invalidate();
        }

        public virtual DateTime this[int Index]
        {
            get
            {
                return ((DateTime)this.List[Index]);
            }
        } 
        
    }
}
