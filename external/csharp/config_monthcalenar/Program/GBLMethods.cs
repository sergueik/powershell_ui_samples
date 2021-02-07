using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using System.Drawing;
using System.Globalization;
using System.Data;

namespace CompleteDateTimePicker
{
    public enum IsDateValidResult
    {
        Valid = 0,
        Invalid = 1,
        LessThanMinDate = 2,
        GreaterThanMaxDate = 3,
    }
    internal enum MessageBeepTypes
    {
        Default,
        Hand,
        Question,
        Exclamation,
        Asterick,
    }
    internal class GBLMethods
    {
        internal const Int32
            SM_CXVSCROLL = 2,
            SM_CYHSCROLL = 3;

        [System.Runtime.InteropServices.DllImport("user32.dll")]
        internal static extern int GetSystemMetrics(int nIndex);

        [System.Runtime.InteropServices.DllImport("user32.dll")]
        private static extern Boolean MessageBeep(UInt32 messageBeep);

        #region String Conversion Methods

        internal static bool CBool(string szValue)
        {
            szValue = szValue.ToUpper();
            if (szValue == "TRUE")
                return true;
            if (szValue == "FALSE")
                return false;
            if (szValue.Trim().Length == 0)
                return false;
            int nVal = 0;
            int.TryParse(szValue, out nVal);
            return (nVal != 0);
        }
        internal static long CLong(string szValue)
        {
            szValue = szValue.Trim();
            long lReturn = 0;
            long.TryParse(szValue, out lReturn);
            return lReturn;
        }
        internal static uint CUInt(string szValue)
        {
            uint uiReturn = 0;
            szValue = szValue.Trim();
            uint.TryParse(szValue, out uiReturn);
            return uiReturn;
        }
        internal static int CInt(string szValue)
        {
            int nReturn = 0;
            szValue = szValue.Trim();
            int.TryParse(szValue, out nReturn);
            return nReturn;
        }
        internal static decimal CDecimal(string szValue)
        {
            szValue = szValue.Trim();
            decimal dReturn = 0;
            decimal.TryParse(szValue, out dReturn);
            return dReturn;
        }
        internal static double CDouble(string szValue)
        {
            szValue = szValue.Trim();
            double dReturn = 0;
            double.TryParse(szValue, out dReturn);
            return dReturn;
        }
        internal static byte CByte(string szValue)
        {
            szValue = szValue.Trim();
            byte bytReturn = 0;
            byte.TryParse(szValue, out bytReturn);
            return bytReturn;
        }
        internal static DateTime CDate(string szValue)
        {
            return CDate(szValue, "MM/dd/yyyy");
        }
        internal static DateTime CDate(string szValue, string szFormat)
        {
            szValue = szValue.Trim();
            DateTime dteReturn = DateTime.Today;
            //DateTime.TryParse(szValue, out dteReturn);
            try
            {
                dteReturn = DateTime.ParseExact(szValue, szFormat, null);
            }
            catch (Exception)
            {
                DateTime.TryParse(szValue, out dteReturn);
            }

            return dteReturn;
        }
        #endregion

        #region String Methods

        internal static string LeftStr(string param, int length)
        {
            //we start at 0 since we want to get the characters starting from the
            //left and with the specified lenght and assign it to a variable
            if (string.IsNullOrEmpty(param))
                return "";

            string result = param.Substring(0, length);
            //return the result of the operation
            return result;
        } 
        internal static string RightStr(string param, int length)
        {
            //start at the index based on the lenght of the sting minus
            //the specified lenght and assign it a variable
            if (string.IsNullOrEmpty(param))
                return "";

            int nStart = param.Length - length;
            string result = param.Substring(nStart, length);
            //return the result of the operation
            return result;
        }

        internal static string MidStr(string param,int startIndex, int length)
        {
            //start at the specified index in the string ang get N number of
            //characters depending on the lenght and assign it to a variable
            if (string.IsNullOrEmpty(param))
                return "";

            string result = param.Substring(startIndex, length);
            //return the result of the operation
            return result;
        }

        internal static string MidStr(string param,int startIndex)
        {
            //start at the specified index and return all characters after it
            //and assign it to a variable
            if (string.IsNullOrEmpty(param))
                return "";

            string result = param.Substring(startIndex);
            //return the result of the operation
            return result;
        }
        internal static string StrDup(string szDupString, int nCount)
        {
            StringBuilder objBuilder = new StringBuilder();
            for (int nCounter = 0; nCounter < nCount; nCounter++)
                objBuilder.Append(szDupString);

            return objBuilder.ToString();
        }
        internal static Size GetTextDims(Control ctlControl, string szText)
        {
            return ctlControl.CreateGraphics().MeasureString(szText, ctlControl.Font).ToSize();
        }
        internal static string StripText(string szText, string szStripString)
        {
            if (szText == "")
                return szText;

            string szReturn = szText;
            foreach (char cChar in szStripString)
                szReturn = szReturn.Replace(cChar.ToString(), "");

            return szReturn;
        }
        #endregion


        internal static void MessageBeep(MessageBeepTypes eMessageBeepType)
        {
            UInt32 uiBeepCode = 0xFFFFFFFF;

            switch (eMessageBeepType)
            {
                case MessageBeepTypes.Hand:
                    uiBeepCode = 0x00000010;
                    break;
                case MessageBeepTypes.Question:
                    uiBeepCode = 0x00000020;
                    break;
                case MessageBeepTypes.Exclamation:
                    uiBeepCode = 0x00000030;
                    break;
                case MessageBeepTypes.Asterick:
                    uiBeepCode = 0x00000040;
                    break;
            }
            MessageBeep(uiBeepCode);
        }
        internal static int GetLastDay(int nMonth, int nYear)
        {
            //int nToday = 
            int nLastDay = 0;
            switch (nMonth)
            {
                case 1:	//January
                case 3:	//March
                case 5:	//May
                case 7:	//July
                case 8:	//August
                case 10:	//October
                case 12:	//December
                    nLastDay = 31;
                    break;
                case 4: //April
                case 6: //June
                case 9: //September
                case 11: //November
                    nLastDay = 30;
                    break;
                case 2: //February (Who came up with this kind of a wacky month???)
                    if (nYear % 4 == 0 && nYear % 100 != 0 || nYear % 400 == 0)
                        //Leap Year
                        nLastDay = 29;
                    else
                        nLastDay = 28;
                    break;
            }
            return nLastDay;
        }
        internal static string FormatDate(DateTime dteDate, string szFormat)
        {
            string szReturn = "";
            if (szFormat.Length > 0)
            {
                string szStrFormat = "{0:" + szFormat + "}";
                szReturn = string.Format(szStrFormat, dteDate);
            }

            return szReturn;
        }
        internal static bool ValidateFormatString(string szFormat)
        {
            string szStrFormat = "{0:" + szFormat + "}";
            DateTime dteNow = DateTime.Now;
            string szDate = "";
            try
            {
                szDate = string.Format(szStrFormat, dteNow);
                dteNow = DateTime.ParseExact(szDate, szFormat, null);
            }
            catch (Exception)
            {
                return false;
            }

            //if (!DateTime.TryParse(szDate, out dteNow))
            //    return false;

            return true;
        }
    }
}
