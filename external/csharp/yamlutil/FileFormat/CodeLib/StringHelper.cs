using System;
using System.Text;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace QiHe.CodeLib
{
    /// <summary>
    /// This class represents a String Helper.
    /// </summary>
    public class StringHelper
    {
        /// <summary>
        /// Split text with a separator char
        /// </summary>
        /// <param name="text">The text.</param>
        /// <param name="sep">The separator.</param>
        /// <returns></returns>
        public static string[] SplitWithSeparator(string text, char sep)
        {
            if (String.IsNullOrEmpty(text)) return null;

            string[] items = new string[2];

            int index = text.IndexOf(sep);
            if (index >= 0)
            {
                items[0] = text.Substring(0, index);
                items[1] = text.Substring(index + 1);
            }
            else
            {
                items[0] = text;
                items[1] = null;
            }

            return items;
        }

        /// <summary>
        /// Split text with a separator char
        /// </summary>
        /// <param name="text">The text.</param>
        /// <param name="sep">The separator.</param>
        /// <returns></returns>
        public static string[] SplitWithSeparatorFromRight(string text, char sep)
        {
            if (String.IsNullOrEmpty(text)) return null;

            string[] items = new string[2];

            int index = text.LastIndexOf(sep);
            if (index >= 0)
            {
                items[0] = text.Substring(0, index);
                items[1] = text.Substring(index + 1);
            }
            else
            {
                items[0] = text;
                items[1] = null;
            }

            return items;
        }

        /// <summary>
        /// Splits the text with spaces.
        /// </summary>
        /// <param name="text">The text.</param>
        /// <returns></returns>
        public static string[] SplitWithSpaces(string text)
        {
            string pattern = "[^ ]+";
            Regex rgx = new Regex(pattern);
            MatchCollection mc = rgx.Matches(text);
            string[] items = new string[mc.Count];
            for (int i = 0; i < items.Length; i++)
            {
                items[i] = mc[i].Value;
            }
            return items;
        }

        /// <summary>
        /// Splits the text into lines.
        /// </summary>
        /// <param name="text">The text.</param>
        /// <returns></returns>
        public static string[] SplitIntoLines(string text)
        {
            List<string> lines = new List<string>();
            StringBuilder line = new StringBuilder();
            foreach (char ch in text)
            {
                switch (ch)
                {
                    case '\r':
                        break;
                    case '\n':
                        lines.Add(line.ToString());
                        line.Length = 0;
                        break;
                    default:
                        line.Append(ch);
                        break;
                }
            }
            if (line.Length > 0)
            {
                lines.Add(line.ToString());
            }
            return lines.ToArray();
        }

        /// <summary>
        /// Concats two strings with a delimiter.
        /// </summary>
        /// <param name="s1">string 1</param>
        /// <param name="delim">delimiter</param>
        /// <param name="s2">string 2</param>
        /// <returns></returns>
        public static string AddWithDelim(string s1, string delim, string s2)
        {
            if (string.IsNullOrEmpty(s1)) return s2;
            else return s1 + delim + s2;
        }
        /// <summary>
        /// Contacts the with delim.
        /// </summary>
        /// <param name="str1">The STR1.</param>
        /// <param name="delim">The delim.</param>
        /// <param name="str2">The STR2.</param>
        /// <returns></returns>
        public static string ContactWithDelim(string str1, string delim, string str2)
        {
            if (string.IsNullOrEmpty(str1)) return str2;
            else if (string.IsNullOrEmpty(str2)) return str1;
            else return str1 + delim + str2;
        }

        /// <summary>
        /// Contact with delim, delim is used after the first not Empty item
        /// </summary>
        /// <param name="items"></param>
        /// <param name="delim"></param>
        /// <returns></returns>
        public static string ContactWithDelimSkipEmpty(IEnumerable<string> items, string delim)
        {
            return ContactWithDelimSkipSome(items, delim, string.Empty);
        }

        /// <summary>
        /// Contact with delim, delim is used after the first not null item
        /// </summary>
        /// <param name="items"></param>
        /// <param name="delim"></param>
        /// <returns></returns>
        public static string ContactWithDelimSkipNull(IEnumerable<string> items, string delim)
        {
            return ContactWithDelimSkipSome(items, delim, null);
        }

        /// <summary>
        /// Contacts the items with delim skip some.
        /// </summary>
        /// <param name="items">The items.</param>
        /// <param name="delim">The delim.</param>
        /// <param name="skip">The skip.</param>
        /// <returns></returns>
        public static string ContactWithDelimSkipSome(IEnumerable<string> items, string delim, string skip)
        {
            StringBuilder text = new StringBuilder();
            bool isFirst = true;
            foreach (string item in items)
            {
                if (item == skip) continue;
                if (isFirst)
                {
                    isFirst = false;
                }
                else
                {
                    text.Append(delim);
                }
                text.Append(item);
            }
            return text.ToString();
        }

        /// <summary>
        /// Contacts the items with delim.
        /// </summary>
        /// <param name="items">The items.</param>
        /// <param name="delim">The delim.</param>
        /// <returns></returns>
        public static string ContactWithDelim(IEnumerable<string> items, string delim)
        {
            return ContactWithDelim(items, delim, null, null);
        }
        /// <summary>
        /// Contacts the items with delim.
        /// </summary>
        /// <param name="items">The items.</param>
        /// <param name="delim">The delim.</param>
        /// <param name="initialValue">The initial value.</param>
        /// <returns></returns>
        public static string ContactWithDelim(IEnumerable<string> items, string delim, string initialValue)
        {
            return ContactWithDelim(items, delim, initialValue, null);
        }
        /// <summary>
        /// Contacts the items with delim.
        /// </summary>
        /// <param name="items">The items.</param>
        /// <param name="delim">The delim.</param>
        /// <param name="initialValue">The initial value.</param>
        /// <param name="endValue">The end value.</param>
        /// <returns></returns>
        public static string ContactWithDelim(IEnumerable<string> items, string delim, string initialValue, string endValue)
        {
            StringBuilder text = new StringBuilder(initialValue);
            bool isFirst = true;
            foreach (string item in items)
            {
                if (isFirst)
                {
                    isFirst = false;
                }
                else
                {
                    text.Append(delim);
                }
                text.Append(item);
            }
            text.Append(endValue);
            return text.ToString();
        }

        /// <summary>
        /// Contacts the items with delim.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="items">The items.</param>
        /// <param name="delim">The delim.</param>
        /// <returns></returns>
        public static string ContactWithDelim<T>(IEnumerable<T> items, string delim)
        {
            return ContactWithDelim<T>(items, delim, null, null);
        }

        /// <summary>
        /// Contacts the items with delim.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="items">The items.</param>
        /// <param name="delim">The delim.</param>
        /// <param name="initialValue">The initial value.</param>
        /// <param name="endValue">The end value.</param>
        /// <returns></returns>
        public static string ContactWithDelim<T>(IEnumerable<T> items, string delim, string initialValue, string endValue)
        {
            StringBuilder text = new StringBuilder();
            text.Append(initialValue);
            bool isFirst = true;
            foreach (T item in items)
            {
                if (isFirst)
                {
                    isFirst = false;
                }
                else
                {
                    text.Append(delim);
                }
                text.Append(item.ToString());
            }
            text.Append(endValue);
            return text.ToString();
        }

        /// <summary>
        /// Gets the header.
        /// </summary>
        /// <param name="text">The text.</param>
        /// <param name="length">The length.</param>
        /// <returns></returns>
        public static string GetHeader(string text, int length)
        {
            if (text.Length <= length)
            {
                return text;
            }
            else
            {
                return text.Substring(0, length);
            }
        }

        /// <summary>
        /// Get the sub string between 'ket' and 'bra'.
        /// </summary>
        /// <param name="text"></param>
        /// <param name="bra"></param>
        /// <param name="ket"></param>
        /// <returns></returns>
        public static string GetSubStringBetween(string text, char bra, char ket)
        {
            if (text == null) return null;
            int braIndex = text.IndexOf(bra);
            if (braIndex > -1)
            {
                int ketIndex = text.IndexOf(ket);
                if (ketIndex > braIndex)
                {
                    return text.Substring(braIndex + 1, ketIndex - braIndex - 1);
                }
            }
            return String.Empty;
        }

        /// <summary>
        /// Get the sub string between 'ket' and 'bra'.
        /// </summary>
        /// <param name="text"></param>
        /// <param name="bra"></param>
        /// <param name="ket"></param>
        /// <returns></returns>
        public static string GetLastSubStringBetween(string text, char bra, char ket)
        {
            if (text == null) return null;
            int braIndex = text.LastIndexOf(bra);
            if (braIndex > -1)
            {
                int ketIndex = text.LastIndexOf(ket);
                if (ketIndex > braIndex)
                {
                    return text.Substring(braIndex + 1, ketIndex - braIndex - 1);
                }
            }
            return String.Empty;
        }

        /// <summary>
        /// Starts with upper case.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <returns></returns>
        public static bool StartWithUpperCase(string name)
        {
            return name.Length >= 1 && char.IsUpper(name[0]);
        }

        /// <summary>
        /// Uppers the case of the first char.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <returns></returns>
        public static string UpperCaseFirstChar(string name)
        {
            if (name.Length >= 1 && char.IsLower(name[0]))
            {
                char[] chars = name.ToCharArray();
                chars[0] = Char.ToUpper(chars[0]);
                return new string(chars);
            }
            return name;
        }

        /// <summary>
        /// Lowers the case of the first char.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <returns></returns>
        public static string LowerCaseFirstChar(string name)
        {
            if (name.Length >= 1 && char.IsUpper(name[0]))
            {
                char[] chars = name.ToCharArray();
                chars[0] = Char.ToLower(chars[0]);
                return new string(chars);
            }
            return name;
        }

        /// <summary>
        /// split text into words by space and newline chars, multiple spaces are treated as a single space.
        /// </summary>
        /// <param name="text"></param>
        /// <returns></returns>
        public static string[] GetWords(string text)
        {
            List<string> tokens = new List<string>();

            List<char> token = new List<char>();

            foreach (char ch in text)
            {
                switch (ch)
                {
                    case ' ':
                    case '\r':
                    case '\n':
                        if (token.Count > 0)
                        {
                            tokens.Add(new string(token.ToArray()));
                            token.Clear();
                        }
                        break;
                    default:
                        token.Add(ch);
                        break;

                }
            }
            if (token.Count > 0)
            {
                tokens.Add(new string(token.ToArray()));
            }
            return tokens.ToArray();
        }

        public static Dictionary<string, int> CountWordFrequency(string article, string delimiters)
        {
            if (article == null)
            {
                throw new ArgumentNullException("article");
            }
            if (delimiters == null)
            {
                throw new ArgumentNullException("delimiters");
            }
            List<string> words = new List<string>();
            List<char> buffer = new List<char>();
            foreach (char c in article)
            {
                if (delimiters.IndexOf(c) == -1)
                {
                    buffer.Add(c);
                }
                else
                {
                    if (buffer.Count > 0)
                    {
                        words.Add(new string(buffer.ToArray()));
                        buffer.Clear();
                    }
                }
            }
            if (buffer.Count > 0)
            {
                words.Add(new string(buffer.ToArray()));
            }

            Dictionary<string, int> table = new Dictionary<string, int>();
            foreach (string word in words)
            {
                if (table.ContainsKey(word))
                {
                    table[word]++;
                }
                else
                {
                    table.Add(word, 1);
                }
            }
            return table;
        }
    }
}
