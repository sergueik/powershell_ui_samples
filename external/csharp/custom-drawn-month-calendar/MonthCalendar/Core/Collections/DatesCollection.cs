using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.ComponentModel;
using System.Collections;

namespace MonthCalendar
{
    public class DatesCollection : CollectionBase
    {
        private Calendar m_Parent;

        public DatesCollection(Calendar Parent) : base()
            
        {
            m_Parent =Parent;
        }
        /// <summary>
        /// Add a DateItem to Collection
        /// </summary>
        /// <param name="Item">DateItem to add</param>
        public void Add(DateItem Item)
        {
            if (Item == null)
                throw new ArgumentNullException("Item");
            int iIndex = this.IndexOf(Item);
            Item.Calendar = m_Parent;
            if (iIndex > -1)
                this.List[iIndex] = Item;
            else
                this.List.Add(Item);
        }
        
        /// <summary>
        /// Add a DatesCollection to Collection
        /// </summary>
        /// <param name="Items">DatesCollection to add</param>
        public void Add(DatesCollection Items)
        {
            if (Items == null)
                throw new ArgumentNullException("Items");

            for (int iItemsCounter = 0; iItemsCounter < Items.Count; iItemsCounter++)
            {
                //add each DatesCollectionItem to this Collection
                this.Add(Items[iItemsCounter]);
            }
        }

        /// <summary>
        /// add an array of DateItems to Collection
        /// </summary>
        /// <param name="Items">DateItems to add</param>
        public void AddRange(DateItem[] Items)
        {
            if (Items == null)
                throw new ArgumentNullException("Items");

            for (int iItemsCount = 0; iItemsCount < Items.Length; iItemsCount++)
            {
                this.Add(Items[iItemsCount]);
            }
        }

        /// <summary>
        /// delete all items from collection
        /// </summary>
        public new void Clear()
        {
            //this.Clear();
        }

        /// <summary>
        /// returns the index of an existing DateItem
        /// </summary>
        /// <param name="Item">DateItem to return the index</param>
        /// <returns>Index from given DateItem; -1 if DateItem does not exist</returns>
        public int IndexOf(DateItem Item)
        {
            if (Item == null)
                throw new ArgumentNullException("Item");

            for (int IItemCounter = 0; IItemCounter < this.List.Count; IItemCounter++)
            {
                if (this.List[IItemCounter] == Item)
                {
                    return IItemCounter;
                }
            }
            return -1;
        }

        /// <summary>
        /// return the index of an existing DateItem 
        /// </summary>
        /// <param name="Date">Date to return the DateItemIndex</param>
        /// <returns>DateItem index</returns>
        public int IndexOf(DateTime Date)
        {
            for (int iItemCounter = 0; iItemCounter < this.List.Count; iItemCounter++)
            {
                if (this[iItemCounter].Date.Year == Date.Year &&
                    this[iItemCounter].Date.Month == Date.Month &&
                    this[iItemCounter].Date.Day == Date.Day)
                {
                    return iItemCounter;
                }
            }
            return -1;
        }

        /// <summary>
        /// check if a dateItem does exist in collection
        /// </summary>
        /// <param name="Item">DateItem to test</param>
        /// <returns>return true if item does exist otherwise false</returns>
        public bool Contains(DateItem Item)
        {
            if (Item == null)
                throw new ArgumentNullException("Item");

            return this.IndexOf(Item) != -1;
        }

        /// <summary>
        /// Remove a DateItem from List by using DateItemIndex
        /// </summary>
        /// <param name="Index">Itemindex to remove</param>
        public new void RemoveAt(int Index)
        {
            if (Index >= 0 && Index < this.Count)
            {
                this.List.RemoveAt(Index);
            }
        }

        /// <summary>
        /// Remove a DateItem from List
        /// </summary>
        /// <param name="Item">DateItem to remove</param>
        public void Remove(DateItem Item)
        {
            if (Item == null)
                throw new ArgumentNullException("Item");

            this.List.Remove(Item);
        }

        /// <summary>
        /// Add an DateItem to the arraylist
        /// </summary>
        /// <param name="New">the new DateItem to add</param>
        /// <param name="Old">old Array</param>
        /// <returns>the new array with added dateitem</returns>
        public DateItem[] AddInfo(DateItem New, DateItem[] Old)
        {
            //get old array dimension
            int iOldItemsSize = Old.Length;
            //create new dateitem array
            DateItem[] myDateItems = new DateItem[iOldItemsSize + 1];
            //copy old items to new array
            for (int iOldArrayCounter = 0; iOldArrayCounter < Old.Length; iOldArrayCounter++)
            {
                //copy each element from old array to the new
                myDateItems[iOldArrayCounter] = Old[iOldArrayCounter];
            }
            //at the end add the new value
            myDateItems[iOldItemsSize] = New;
            //return the new array
            return myDateItems;
        }

        /// <summary>
        /// returns an array with all dateitem assigned with given date
        /// </summary>
        /// <param name="Date">date to find assigned item with</param>
        /// <returns>with date assigned items</returns>
        public DateItem[] DateInfo(DateTime Date)
        {
            //first create a new dateitem array
            DateItem[] myItems = new DateItem[0];
            //secondly find all dates match with given date
            for (int iDateCounter = 0; iDateCounter < this.List.Count; iDateCounter++)
            {
                if (this[iDateCounter].Date <= Date && this[iDateCounter].Range >= Date)
                {
                    switch (this[iDateCounter].Reccurence)
                    {
                        case DateItemReccurence.None:
                            //item shows only on the date
                            if (this[iDateCounter].Date.ToShortDateString() == Date.ToShortDateString())
                                myItems = AddInfo(this[iDateCounter], myItems);
                            break;
                        case DateItemReccurence.Daily:
                            //item shows daily between date and range
                            myItems = AddInfo(this[iDateCounter], myItems);
                            break;
                        case DateItemReccurence.Weekly:
                            //item shows weekly between date and range
                            if (this[iDateCounter].Date.DayOfWeek == Date.DayOfWeek)
                                myItems = AddInfo(this[iDateCounter], myItems);
                            break;
                        case DateItemReccurence.Monthly:
                            //item shows monthly between date and range
                            if (this[iDateCounter].Date.Day == Date.Day)
                                myItems = AddInfo(this[iDateCounter], myItems);
                            break;
                        case DateItemReccurence.Yearly:
                            //item shows yearly between date and range
                            
                            break;
                    }
                }
            }
            return myItems;
        }

        public void Move(DateItem Item, int Index)
        {
            //do nothing at the moment
            if (Item == null)
                throw new ArgumentNullException("Item");

            //test if index is valid
            if (Index < 0)
                Index = 0;
            else if (Index > this.Count)
                Index = this.Count;
            //get old itemindex
            int iOldIndex = this.IndexOf(Item);
            //remove item from old position
            if (iOldIndex > -1)
                this.RemoveAt(iOldIndex);
            //insert item to new position
            if (this.List.Count < Index)
                this.Add(Item);
            else
                this.List.Insert(Index, Item);
        }

        public virtual DateItem this[int Index]
        {
            get
            {
                return this.List[Index] as DateItem;
            }
        }

    }

}
