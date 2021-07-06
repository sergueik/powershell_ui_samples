using System;
using System.Collections.Generic;
using System.Text;
using System.IO;


// origin:  https://www.codeproject.com/Articles/20120/INI-Files
// see also: https://www.codeproject.com/Articles/318783/Simplified-INI-Handling
// NOTE: p/invoke methods covered in 
// https://www.codeproject.com/Articles/1966/An-INI-file-handling-class-using-C
// lack the ability to read sections
namespace Utils {
	public class IniFileReader : StreamReader {
		IniFileElement current = null;
		public IniFileReader(Stream str) : base(str) { }
		public IniFileReader(Stream str, Encoding enc) : base(str, enc) { }
		public IniFileReader(string path) : base(path) { }
		public IniFileReader(string path, Encoding enc) : base(path, enc) { }
		
		public static IniFileElement ParseLine(string line) {
			if (line == null)
				return null;
			if (line.Contains("\n"))
				throw new ArgumentException("String passed to the ParseLine method cannot contain more than one line.");
			string trim = line.Trim();
			IniFileElement elem = null;
			if (IniFileBlankLine.IsLineValid(trim))
				elem = new IniFileBlankLine(1);
			else if (IniFileCommentary.IsLineValid(line))
				elem = new IniFileCommentary(line);
			else if (IniFileSectionStart.IsLineValid(trim))
				elem = new IniFileSectionStart(line);
			else if (IniFileValue.IsLineValid(trim))
				elem = new IniFileValue(line);
			return elem ?? new IniFileElement(line);
		}

		public static List<IniFileElement> ParseText(string text) {
			if (text == null)
				return null;
			List<IniFileElement> ret = new List<IniFileElement>();
			IniFileElement currEl, lastEl = null;
			string[] lines = text.Split(new string[] { Environment.NewLine }, StringSplitOptions.None);
			for (int i = 0; i < lines.Length; i++) {
				currEl = ParseLine(lines[i]);
				if (IniFileSettings.GroupElements) {
					if (lastEl != null) {
						if (currEl is IniFileBlankLine && lastEl is IniFileBlankLine) {
							((IniFileBlankLine)lastEl).Amount++;
							continue;
						} else if (currEl is IniFileCommentary && lastEl is IniFileCommentary) {
							((IniFileCommentary)lastEl).Comment += Environment.NewLine + ((IniFileCommentary)currEl).Comment;
							continue;
						}
					} else
						lastEl = currEl;
				}
				lastEl = currEl;
				ret.Add(currEl);
			}
			return ret;
		}

		public IniFileElement ReadElement() {
			current = ParseLine(base.ReadLine());
			return current;
		}

		public List<IniFileElement> ReadElementsToEnd() {
			List<IniFileElement> ret = ParseText(base.ReadToEnd());
			return ret;
		}

		public IniFileSectionStart GotoSection(string sectionName) {
			IniFileSectionStart sect = null;
			string str;
			while (true) {
				str = ReadLine();
				if (str == null) {
					current = null;
					return null;
				}
				if (IniFileSectionStart.IsLineValid(str)) {
					sect = ParseLine(str) as IniFileSectionStart;
					if (sect != null && (sect.SectionName == sectionName || (!IniFileSettings.CaseSensitive && sect.SectionName.ToLowerInvariant() == sectionName))) {
						current = sect;
						return sect;
					}
				}
			}
		}

		public List<IniFileElement> ReadSection() {
			if (current == null || !(current is IniFileSectionStart))
				throw new InvalidOperationException("The current position of the reader must be at IniFileSectionStart. Use GotoSection method");
			var ret = new List<IniFileElement>();
			IniFileElement theCurrent = current;
			ret.Add(theCurrent);
			string text = "", temp;
			while ((temp = base.ReadLine()) != null) {
				if (IniFileSectionStart.IsLineValid(temp.Trim())) {
					current = new IniFileSectionStart(temp);
					break;
				}
				text += temp + Environment.NewLine;
			}
			if (text.EndsWith(Environment.NewLine) && text != Environment.NewLine)
				text = text.Substring(0, text.Length - Environment.NewLine.Length);
			ret.AddRange(ParseText(text));
			return ret;
		}

		public IniFileElement Current {
			get { return current; }
		}

		public List<IniFileValue> ReadSectionValues() {
			List<IniFileElement> elements = ReadSection();
			List<IniFileValue> ret = new List<IniFileValue>();
			for (int i = 0; i < elements.Count; i++)
				if (elements[i] is IniFileValue)
					ret.Add((IniFileValue)elements[i]);
			return ret;
		}

		public IniFileValue GotoValue(string key) {
			return GotoValue(key, false);
		}

		public IniFileValue GotoValue(string key, bool searchWholeFile) {
			IniFileValue val;
			string str;
			while (true) {
				str = ReadLine();
				if (str == null)
					return null;
				if (IniFileValue.IsLineValid(str.Trim())) {
					val = ParseLine(str) as IniFileValue;
					if (val != null && (val.Key == key || (!IniFileSettings.CaseSensitive && val.Key.ToLowerInvariant() == key.ToLowerInvariant())))
						return val;
				}
				if (!searchWholeFile && IniFileSectionStart.IsLineValid(str.Trim()))
					return null;
				
			}
		}
	}

	public class IniFileWriter : StreamWriter {
		public IniFileWriter(Stream str) : base(str) { }
		public IniFileWriter(string str) : base(str) { }
		public IniFileWriter(Stream str, Encoding enc): base(str, enc) { }
		public IniFileWriter(string str, bool append): base(str, append) { }
		public void WriteElement(IniFileElement element) {
			if (!IniFileSettings.PreserveFormatting)
				element.FormatDefault();
			// do not write if:
			if (!( // 1) element is a blank line AND blank lines are not allowed
			        (element is IniFileBlankLine && !IniFileSettings.AllowBlankLines)
				 // 2) element is an empty value AND empty values are not allowed
			        || (!IniFileSettings.AllowEmptyValues && element is IniFileValue && ((IniFileValue)element).Value == "")))
				base.WriteLine(element.Line);
		}


		public void WriteElements(IEnumerable<IniFileElement> elements) {
			lock (elements)
				foreach (IniFileElement el in elements)
					WriteElement(el);
		}
		public void WriteIniFile(IniFile file) {
			WriteElements(file.elements);
		}
		public void WriteSection(IniFileSection section) {
			WriteElement(section.sectionStart);
			for (int i = section.parent.elements.IndexOf(section.sectionStart) + 1; i < section.parent.elements.Count; i++) {
				if (section.parent.elements[i] is IniFileSectionStart)
					break;
				WriteElement(section.parent.elements[i]);
			}
		}
	}
	public class IniFile {
		internal List<IniFileSection> sections = new List<IniFileSection>();
		internal List<IniFileElement> elements = new List<IniFileElement>();

		public IniFile() { }

		public IniFileSection this[string sectionName] {
			get {
				IniFileSection sect = getSection(sectionName);
				if (sect != null)
					return sect;
				IniFileSectionStart start;
				if (sections.Count > 0) {
					IniFileSectionStart prev = sections[sections.Count - 1].sectionStart;
					start = prev.CreateNew(sectionName);
				} else
					start = IniFileSectionStart.FromName(sectionName);
				elements.Add(start);
				sect = new IniFileSection(this, start);
				sections.Add(sect);
				return sect;
			}
		}

		IniFileSection getSection(string name) {
			string lower = name.ToLowerInvariant();
			for (int i = 0; i < sections.Count; i++)
				if (sections[i].Name == name || (!IniFileSettings.CaseSensitive && sections[i].Name.ToLowerInvariant() == lower))
					return sections[i];
			return null;
		}
		
		public string[] GetSectionNames() {
			var ret = new string[sections.Count];
			for (int i = 0; i < sections.Count; i++)
				ret[i] = sections[i].Name;
			return ret;
		}

		public static IniFile FromFile(string path) {
			if (!System.IO.File.Exists(path)) {
				System.IO.File.Create(path).Close();
				return new IniFile();
			}
			var reader = new IniFileReader(path);
			IniFile ret = FromStream(reader);
			reader.Close();
			return ret;
		}

		public static IniFile FromElements(IEnumerable<IniFileElement> elemes) {
			IniFile ret = new IniFile();
			ret.elements.AddRange(elemes);
			if (ret.elements.Count > 0) {
				IniFileSection section = null;
				IniFileElement el;

				if (ret.elements[ret.elements.Count - 1] is IniFileBlankLine)
					ret.elements.RemoveAt(ret.elements.Count - 1);
				for (int i = 0; i < ret.elements.Count; i++) {
					el = ret.elements[i];
					if (el is IniFileSectionStart) {
						section = new IniFileSection(ret, (IniFileSectionStart)el);
						ret.sections.Add(section);
					} else if (section != null)
						section.elements.Add(el);
					else if (ret.sections.Exists(delegate(IniFileSection a) {
						return a.Name == "";
					}))
						ret.sections[0].elements.Add(el);
					else if (el is IniFileValue) {
						section = new IniFileSection(ret, IniFileSectionStart.FromName(""));
						section.elements.Add(el);
						ret.sections.Add(section);
					}
				}
			}
			return ret;
		}
		
		public static IniFile FromStream(IniFileReader reader) {
			return FromElements(reader.ReadElementsToEnd());
		}
		public void Save(string path) {
			var writer = new IniFileWriter(path);
			Save(writer);
			writer.Close();
		}

		public void Save(IniFileWriter writer) {
			writer.WriteIniFile(this);
		}

		public void DeleteSection(string name) {
			IniFileSection section = getSection(name);
			if (section == null)
				return;
			IniFileSectionStart sect = section.sectionStart;
			elements.Remove(sect);
			for (int i = elements.IndexOf(sect) + 1; i < elements.Count; i++) {
				if (elements[i] is IniFileSectionStart)
					break;
				elements.RemoveAt(i);
			}
		}

		public void Format(bool preserveIntendation) {
			string lastSectIntend = "";
			string lastValIntend = "";
			IniFileElement el;
			for (int i = 0; i < elements.Count; i++) {
				el = elements[i];
				if (preserveIntendation) {
					if (el is IniFileSectionStart)
						lastValIntend = lastSectIntend = el.Intendation;
					else if (el is IniFileValue)
						lastValIntend = el.Intendation;
				}
				el.FormatDefault();
				if (preserveIntendation) {
					if (el is IniFileSectionStart)
						el.Intendation = lastSectIntend;
					else if (el is IniFileCommentary && i != elements.Count - 1 && !(elements[i + 1] is IniFileBlankLine))
						el.Intendation = elements[i + 1].Intendation;
					else
						el.Intendation = lastValIntend;
				}
			}
		}

		public void UnifySections() {
			var dict = new Dictionary<string, int>();
			IniFileSection sect;
			IniFileElement el;
			IniFileValue val;
			int index;
			for (int i = 0; i < sections.Count; i++) {
				sect = sections[i];
				if (dict.ContainsKey(sect.Name)) {
					index = dict[sect.Name] + 1;
					elements.Remove(sect.sectionStart);
					sections.Remove(sect);
					for (int j = sect.elements.Count - 1; j >= 0; j--) {
						el = sect.elements[j];
						if (!(j == sect.elements.Count - 1 && el is IniFileCommentary))
							elements.Remove(el);
						if (!(el is IniFileBlankLine)) {
							elements.Insert(index, el);
							val = this[sect.Name].firstValue();
							if (val != null)
								el.Intendation = val.Intendation;
							else
								el.Intendation = this[sect.Name].sectionStart.Intendation;
						}
					}
				} else
					dict.Add(sect.Name, elements.IndexOf(sect.sectionStart));
			}
		}

		public string Header {
			get {
				if (elements.Count > 0)
				if (elements[0] is IniFileCommentary && !(!IniFileSettings.SeparateHeader
				     && elements.Count > 1 && !(elements[1] is IniFileBlankLine)))
					return ((IniFileCommentary)elements[0]).Comment;
				return "";
			}
			set {
				if (elements.Count > 0 && elements[0] is IniFileCommentary && !(!IniFileSettings.SeparateHeader
				    && elements.Count > 1 && !(elements[1] is IniFileBlankLine))) {
					if (value == "") {
						elements.RemoveAt(0);
						if (IniFileSettings.SeparateHeader && elements.Count > 0 && elements[0] is IniFileBlankLine)
							elements.RemoveAt(0);
					} else
						((IniFileCommentary)elements[0]).Comment = value;
				} else if (value != "") {					
					if ((elements.Count == 0 || !(elements[0] is IniFileBlankLine)) && IniFileSettings.SeparateHeader)
						elements.Insert(0, new IniFileBlankLine(1));
					elements.Insert(0, IniFileCommentary.FromComment(value));
				}
			}
		}

		public string Foot {
			get {
				if (elements.Count > 0) {
					if (elements[elements.Count - 1] is IniFileCommentary)
						return ((IniFileCommentary)elements[elements.Count - 1]).Comment;
				}
				return "";
			}
			set {
				if (value == "") {
					if (elements.Count > 0 && elements[elements.Count - 1] is IniFileCommentary) {
						elements.RemoveAt(elements.Count - 1);
						if (elements.Count > 0 && elements[elements.Count - 1] is IniFileBlankLine)
							elements.RemoveAt(elements.Count - 1);
					}
				} else {
					if (elements.Count > 0) {
						if (elements[elements.Count - 1] is IniFileCommentary)
							((IniFileCommentary)elements[elements.Count - 1]).Comment = value;
						else
							elements.Add(IniFileCommentary.FromComment(value));
						if (elements.Count > 2) {
							if (!(elements[elements.Count - 2] is IniFileBlankLine) && IniFileSettings.SeparateHeader)
								elements.Insert(elements.Count - 1, new IniFileBlankLine(1));
							else if (value == "")
								elements.RemoveAt(elements.Count - 2);
						}
					} else
						elements.Add(IniFileCommentary.FromComment(value));
				}
			}
		}
	}

	public class IniFileSection {
		internal List<IniFileElement> elements = new List<IniFileElement>();
		internal IniFileSectionStart sectionStart;
		internal IniFile parent;

		internal IniFileSection(IniFile _parent, IniFileSectionStart sect) {
			sectionStart = sect;
			parent = _parent;
		}

		public string Name {
			get { return sectionStart.SectionName; }
			set { sectionStart.SectionName = value; }
		}

		public string Comment {
			get {
				return Name == "" ? "" : getComment(sectionStart);
			}
			set {
				if (Name != "")
					setComment(sectionStart, value);
			}
		}

		void setComment(IniFileElement el, string comment)
		{
			int index = parent.elements.IndexOf(el);
			if (IniFileSettings.CommentChars.Length == 0)
				throw new NotSupportedException("Comments are currently disabled. Setup ConfigFileSettings.CommentChars property to enable them.");
			IniFileCommentary com;
			if (index > 0 && parent.elements[index - 1] is IniFileCommentary) {
				com = ((IniFileCommentary)parent.elements[index - 1]);
				if (comment == "")
					parent.elements.Remove(com);
				else {
					com.Comment = comment;
					com.Intendation = el.Intendation;
				}
			} else if (comment != "") {
				com = IniFileCommentary.FromComment(comment);
				com.Intendation = el.Intendation;
				parent.elements.Insert(index, com);
			}
		}
		string getComment(IniFileElement el)
		{
			int index = parent.elements.IndexOf(el);
			if (index != 0 && parent.elements[index - 1] is IniFileCommentary)
				return ((IniFileCommentary)parent.elements[index - 1]).Comment;
			else
				return "";
		}
		IniFileValue getValue(string key)
		{
			string lower = key.ToLowerInvariant();
			IniFileValue val;
			for (int i = 0; i < elements.Count; i++)
				if (elements[i] is IniFileValue) {
					val = (IniFileValue)elements[i];
					if (val.Key == key || (!IniFileSettings.CaseSensitive && val.Key.ToLowerInvariant() == lower))
						return val;
				}
			return null;
		}

		public void SetComment(string key, string comment) {
			IniFileValue val = getValue(key);
			if (val == null)
				return;
			setComment(val, comment);
		}

		public void SetInlineComment(string key, string comment) {
			IniFileValue val = getValue(key);
			if (val == null)
				return;
			val.InlineComment = comment;
		}

		public string GetInlineComment(string key) {
			IniFileValue val = getValue(key);
			return (val == null) ?
				null: val.InlineComment;
		}

		public string InlineComment {
			get { return sectionStart.InlineComment; }
			set { sectionStart.InlineComment = value; }
		}

		public string GetComment(string key) {
			IniFileValue val = getValue(key);
			return  (val == null) ?  null: getComment(val);
		}

		public void RenameKey(string key, string newName) {
			IniFileValue v = getValue(key);
			if (key == null)
				return;
			v.Key = newName;
		}

		public void DeleteKey(string key) {
			IniFileValue v = getValue(key);
			if (key == null)
				return;
			parent.elements.Remove(v);
			elements.Remove(v);
		}
		
		public string this[string key] {
			get {
				IniFileValue v = getValue(key);
				return (v == null )? null : v.Value;
			}
			set {
				IniFileValue v;
				v = getValue(key);
				//if (!IniFileSettings.AllowEmptyValues && value == "") {
				//    if (v != null) {
				//        elements.Remove(v);
				//        parent.elements.Remove(v);
				//        return;
				//    }
				//}
				if (v != null) {
					v.Value = value;
					return;
				}
				setValue(key, value);
			}
		}

		public string this[string key, string defaultValue] {
			get {
				string val = this[key];
				return (val == "" || val == null) ?  defaultValue: val;
			}
			set { this[key] = value; }
		}
		
		private void setValue(string key, string value) {
			IniFileValue ret = null;
			IniFileValue prev = lastValue();
			
			if (IniFileSettings.PreserveFormatting) {
				if (prev != null && prev.Intendation.Length >= sectionStart.Intendation.Length)
					ret = prev.CreateNew(key, value);
				else {
					IniFileElement el;
					bool valFound = false;
					for (int i = parent.elements.IndexOf(sectionStart) - 1; i >= 0; i--) {
						el = parent.elements[i];
						if (el is IniFileValue) {
							ret = ((IniFileValue)el).CreateNew(key, value);
							valFound = true;
							break;
						}
					}
					if (!valFound)
						ret = IniFileValue.FromData(key, value);
					if (ret.Intendation.Length < sectionStart.Intendation.Length)
						ret.Intendation = sectionStart.Intendation;
				}
			} else
				ret = IniFileValue.FromData(key, value);
			if (prev == null) {
				elements.Insert(elements.IndexOf(sectionStart) + 1, ret);
				parent.elements.Insert(parent.elements.IndexOf(sectionStart) + 1, ret);
			} else {
				elements.Insert(elements.IndexOf(prev) + 1, ret);
				parent.elements.Insert(parent.elements.IndexOf(prev) + 1, ret);
			}
		}
		internal IniFileValue lastValue() {
			for (int i = elements.Count - 1; i >= 0; i--) {
				if (elements[i] is IniFileValue)
					return (IniFileValue)elements[i];
			}
			return null;
		}
		
		internal IniFileValue firstValue() {
			for (int i = 0; i < elements.Count; i++) {
				if (elements[i] is IniFileValue)
					return (IniFileValue)elements[i];
			}
			return null;
		}

		public System.Collections.ObjectModel.ReadOnlyCollection<string> GetKeys() {
			List<string> list = new List<string>(elements.Count);
			for (int i = 0; i < elements.Count; i++) {
				if (elements[i] is IniFileValue) {
					list.Add(((IniFileValue)elements[i]).Key);
				}
			}
			return new System.Collections.ObjectModel.ReadOnlyCollection<string>(list);
			
		}

		public override string ToString() {
			return sectionStart.ToString() + " (" + elements.Count.ToString() + " elements)";
		}
		
		public void Format(bool preserveIntendation) {
			IniFileElement el;
			string lastIntend;
			for (int i = 0; i < elements.Count; i++) {
				el = elements[i];
				lastIntend = el.Intendation;
				el.FormatDefault();
				if (preserveIntendation)
					el.Intendation = lastIntend;
			}
		}
	}

	public static class IniFileSettings {
		private static iniFlags flags = (iniFlags)255;
		private static string[] commentChars = { ";", "#" };
		private static char? quoteChar = null;
		private static string defaultValueFormatting = "?=$   ;";
		private static string defaultSectionFormatting = "[$]   ;";
		private static string sectionCloseBracket = "]";
		private static string equalsString = "=";
		private static string tabReplacement = "    ";
		private static string sectionOpenBracket = "[";

		private enum iniFlags {
			PreserveFormatting = 1,
			AllowEmptyValues = 2,
			AllowTextOnTheRight = 4,
			GroupElements = 8,
			CaseSensitive = 16,
			SeparateHeader = 32,
			AllowBlankLines = 64,
			AllowInlineComments = 128
		}

		//private static string DefaultCommentaryFormatting = ";$";

		#region Public properties

		public static bool PreserveFormatting {
			get { return (flags & iniFlags.PreserveFormatting) == iniFlags.PreserveFormatting; }
			set {
				if (value)
					flags = flags | iniFlags.PreserveFormatting;
				else
					flags = flags & ~iniFlags.PreserveFormatting;
			}
		}

		public static bool AllowEmptyValues {
			get { return (flags & iniFlags.AllowEmptyValues) == iniFlags.AllowEmptyValues; }
			set {
				if (value)
					flags = flags | iniFlags.AllowEmptyValues;
				else
					flags = flags & ~iniFlags.AllowEmptyValues;
			}
		}

		public static bool AllowTextOnTheRight {
			get { return (flags & iniFlags.AllowTextOnTheRight) == iniFlags.AllowTextOnTheRight; }
			set {
				if (value)
					flags = flags | iniFlags.AllowTextOnTheRight;
				else
					flags = flags & ~iniFlags.AllowTextOnTheRight;
			}
		}

		public static bool GroupElements {
			get { return (flags & iniFlags.GroupElements) == iniFlags.GroupElements; }
			set {
				if (value)
					flags = flags | iniFlags.GroupElements;
				else
					flags = flags & ~iniFlags.GroupElements;
			}
		}
		public static bool CaseSensitive {
			get { return (flags & iniFlags.CaseSensitive) == iniFlags.CaseSensitive; }
			set {
				if (value)
					flags = flags | iniFlags.CaseSensitive;
				else
					flags = flags & ~iniFlags.CaseSensitive;
			}
		}
		public static bool SeparateHeader {
			get { return (flags & iniFlags.SeparateHeader) == iniFlags.SeparateHeader; }
			set {
				if (value)
					flags = flags | iniFlags.SeparateHeader;
				else
					flags = flags & ~iniFlags.SeparateHeader;
			}
		}
		public static bool AllowBlankLines {
			get { return (flags & iniFlags.AllowBlankLines) == iniFlags.AllowBlankLines; }
			set {
				if (value)
					flags = flags | iniFlags.AllowBlankLines;
				else
					flags = flags & ~iniFlags.AllowBlankLines;
			}
		}
		public static bool AllowInlineComments {
			get { return (flags & iniFlags.AllowInlineComments) != 0; }
			set {
				if (value)
					flags |= iniFlags.AllowInlineComments;
				else
					flags &= ~iniFlags.AllowInlineComments;
			}
		}
		public static string SectionCloseBracket {
			get { return IniFileSettings.sectionCloseBracket; }
			set {
				if (value == null)
					throw new ArgumentNullException("SectionCloseBracket");
				IniFileSettings.sectionCloseBracket = value;
			}
		}
		public static string[] CommentChars {
			get { return IniFileSettings.commentChars; }
			set {
				if (value == null)
					throw new ArgumentNullException("CommentChars", "Use empty array to disable comments instead of null");
				IniFileSettings.commentChars = value;
			}
		}
		public static char? QuoteChar {
			get { return IniFileSettings.quoteChar; }
			set { IniFileSettings.quoteChar = value; }
		}

		public static string DefaultSectionFormatting {
			get { return IniFileSettings.defaultSectionFormatting; }
			set {
				if (value == null)
					throw new ArgumentNullException("DefaultSectionFormatting");
				string test = value.Replace("$", "").Replace("[", "").Replace("]", "").Replace(";", "");
				if (test.TrimStart().Length > 0)
					throw new ArgumentException("DefaultValueFormatting property cannot contain other characters than [,$,] and white spaces.");
				if (!(value.IndexOf('[') < value.IndexOf('$') && value.IndexOf('$') < value.IndexOf(']')
				    && (value.IndexOf(';') == -1 || value.IndexOf(']') < value.IndexOf(';'))))
					throw new ArgumentException("Special charcters in the formatting strings are in the incorrect order. The valid is: [, $, ].");
				IniFileSettings.defaultSectionFormatting = value;
			}
		}
		public static string DefaultValueFormatting {
			get { return IniFileSettings.defaultValueFormatting; }
			set {
				if (value == null)
					throw new ArgumentNullException("DefaultValueFormatting");
				string test = value.Replace("?", "").Replace("$", "").Replace("=", "").Replace(";", "");
				if (test.TrimStart().Length > 0)
					throw new ArgumentException("DefaultValueFormatting property cannot contain other characters than ?,$,= and white spaces.");
				if (!(((value.IndexOf('?') < value.IndexOf('=') && value.IndexOf('=') < value.IndexOf('$'))
				    || (value.IndexOf('=') == -1 && test.IndexOf('?') < value.IndexOf('$')))
				    && (value.IndexOf(';') == -1 || value.IndexOf('$') < value.IndexOf(';'))))
					throw new ArgumentException("Special charcters in the formatting strings are in the incorrect order. The valid is: ?, =, $.");
				IniFileSettings.defaultValueFormatting = value;
			}
		}

		public static string SectionOpenBracket {
			get { return IniFileSettings.sectionOpenBracket; }
			set {
				if (value == null)
					throw new ArgumentNullException("SectionCloseBracket");
				IniFileSettings.sectionOpenBracket = value;
			}
		}

		public static string EqualsString {
			get { return IniFileSettings.equalsString; }
			set {
				if (value == null)
					throw new ArgumentNullException("EqualsString");
				IniFileSettings.equalsString = value;
			}
		}
		public static string TabReplacement {
			get { return IniFileSettings.tabReplacement; }
			set { IniFileSettings.tabReplacement = value; }
		}
		#endregion

		internal static string trimLeft(ref string str)
		{
			int i = 0;
			var ret = new StringBuilder();
			while (i < str.Length && char.IsWhiteSpace(str, i)) {
				ret.Append(str[i]);
				i++;
			}
			str = (str.Length > i) ? str.Substring(i) : "";
			return ret.ToString();
		}
		
		internal static string trimRight(ref string str) {
			int i = str.Length - 1;
			var build = new StringBuilder();
			while (i >= 0 && char.IsWhiteSpace(str, i)) {
				build.Append(str[i]);
				i--;
			}
			var reversed = new StringBuilder();
			for (int j = build.Length - 1; j >= 0; j--)
				reversed.Append(build[j]);
			str =   (str.Length - i > 0) ?
				str = str.Substring(0, i + 1): "";
			return reversed.ToString();
		}
		
		internal static string startsWith(string line, string[] array) {
			if (array == null)
				return null;
			for (int i = 0; i < array.Length; i++)
				if (line.StartsWith(array[i]))
					return array[i];
			return null;
		}

		internal struct indexOfAnyResult {
			public int index;
			public string any;
			public indexOfAnyResult(int i, string _any)
			{
				any = _any;
				index = i;
			}
		}

		internal static indexOfAnyResult indexOfAny(string text, string[] array) {
			for (int i = 0; i < array.Length; i++){
				if (text.Contains(array[i])){
					return new indexOfAnyResult(text.IndexOf(array[i]), array[i]);
				}
			}
			return new indexOfAnyResult(-1, null);
		}
		
		internal static string ofAny(int index, string text, string[] array) {
			for (int i = 0; i < array.Length; i++) {
				if (text.Length - index >= array[i].Length && text.Substring(index, array[i].Length) == array[i]) {
					return array[i];
				}
			}
			return null;
		}
	}

	public class IniFileElement {
		private string line;
		protected string formatting="";


		protected IniFileElement() {
			line = "";
		}
		public IniFileElement(string _content) {
			line = _content.TrimEnd();
		}
		public string Formatting {
			get { return formatting; }
			set { formatting = value; }
		}
		public string Intendation {
			get {
				var intend = new StringBuilder();
				for (int i = 0; i < formatting.Length; i++) {
					if (!char.IsWhiteSpace(formatting[i])) break;
					intend.Append(formatting[i]);
				}
				return intend.ToString();
			}
			set {
				if (value.TrimStart().Length > 0)
					throw new ArgumentException("Intendation property cannot contain any characters which are not condsidered as white ones.");
				if (IniFileSettings.TabReplacement != null)
					value = value.Replace("\t", IniFileSettings.TabReplacement);
				formatting = value + formatting.TrimStart();
				line = value + line.TrimStart();
			}
		}
		
		public string Content {
			get { return line.TrimStart(); }
			protected set { line = value; }
		}

		public string Line {
			get {
				string intendation = Intendation;
				if (line.Contains(Environment.NewLine)) {
					string[] lines = line.Split(new string[] { Environment.NewLine }, StringSplitOptions.None);
					var ret = new StringBuilder();
					ret.Append(lines[0]);
					for (int i = 1; i < lines.Length; i++)
						ret.Append(Environment.NewLine + intendation + lines[i]);
					return ret.ToString();
				}
				else
					return line;
			}
		}

		public override string ToString() {
			return "Line: \"" + line + "\"";
		}

		public virtual void FormatDefault() {
			Intendation = "";
		}
	}
	public class IniFileSectionStart : IniFileElement {
		private string sectionName;
		private string textOnTheRight; // e.g.  "[SectionName] some text"
		private string inlineComment, inlineCommentChar;

		private IniFileSectionStart() : base() { }
		public IniFileSectionStart(string content): base(content) {
			//content = Content;
			formatting = ExtractFormat(content);
			content = content.TrimStart();
			if (IniFileSettings.AllowInlineComments) {
				IniFileSettings.indexOfAnyResult result = IniFileSettings.indexOfAny(content, IniFileSettings.CommentChars);
				if (result.index > content.IndexOf(IniFileSettings.SectionCloseBracket)) {
					inlineComment = content.Substring(result.index + result.any.Length);
					inlineCommentChar = result.any;
					content = content.Substring(0, result.index);
				}
			}
			if (IniFileSettings.AllowTextOnTheRight) {
				int closeBracketPos = content.LastIndexOf(IniFileSettings.SectionCloseBracket);
				if (closeBracketPos != content.Length - 1) {
					textOnTheRight = content.Substring(closeBracketPos + 1);
					content = content.Substring(0, closeBracketPos);
				}
			}
			sectionName = content.Substring(IniFileSettings.SectionOpenBracket.Length, content.Length - IniFileSettings.SectionCloseBracket.Length - IniFileSettings.SectionOpenBracket.Length).Trim();
			Content = content;
			Format();
		}
		public string SectionName {
			get { return sectionName; }
			set {
				sectionName = value;
				Format();
			}
		}
		public string InlineComment {
			get { return inlineComment; }
			set {
				if (!IniFileSettings.AllowInlineComments || IniFileSettings.CommentChars.Length == 0)
					throw new NotSupportedException("Inline comments are disabled.");
				inlineComment = value; Format();
			}
		}
		
		public static bool IsLineValid(string testString) {
			return testString.StartsWith(IniFileSettings.SectionOpenBracket) && testString.EndsWith(IniFileSettings.SectionCloseBracket);
		}
		public override string ToString() {
			return "Section: \"" + sectionName + "\"";
		}
		public IniFileSectionStart CreateNew(string sectName) {
			var ret = new IniFileSectionStart();
			ret.sectionName = sectName;
			if (IniFileSettings.PreserveFormatting) {
				ret.formatting = formatting;
				ret.Format();
			}
			else
				ret.Format();
			return ret;
		}

		public static string ExtractFormat(string content) {
			bool beforeS = false;
			bool afterS = false;
			bool beforeEvery = true;
			char currC; string comChar; string insideWhiteChars = "";
			var form = new StringBuilder();
			for (int i = 0; i < content.Length; i++) {
				currC = content[i];
				if (char.IsLetterOrDigit(currC) && beforeS) {
					afterS = true;
					beforeS = false;
					form.Append('$');
				}
				else if (afterS && char.IsLetterOrDigit(currC)) {
					insideWhiteChars = "";
				}
				else if (content.Length - i >= IniFileSettings.SectionOpenBracket.Length && content.Substring(i, IniFileSettings.SectionOpenBracket.Length) == IniFileSettings.SectionOpenBracket && beforeEvery) {
					beforeS = true; beforeEvery = false; form.Append('[');
				}
				else if (content.Length - i >= IniFileSettings.SectionCloseBracket.Length && content.Substring(i, IniFileSettings.SectionOpenBracket.Length) == IniFileSettings.SectionCloseBracket && afterS) {
					form.Append(insideWhiteChars);
					afterS = false; form.Append(IniFileSettings.SectionCloseBracket);
				}
				else if ((comChar = IniFileSettings.ofAny(i, content, IniFileSettings.CommentChars)) != null) {
					form.Append(';');
				}
				else if (char.IsWhiteSpace(currC)) {
					if (afterS) insideWhiteChars += currC;
					else form.Append(currC);
				}
			}
			string ret = form.ToString();
			if (ret.IndexOf(';') == -1)
				ret += "   ;";
			return ret;
		}
		public override void FormatDefault() {
			Formatting = IniFileSettings.DefaultSectionFormatting;
			Format();
		}
		public void Format() {
			Format(formatting);
		}
		public void Format(string formatting) {
			char currC;
			var build = new StringBuilder();
			for (int i = 0; i < formatting.Length; i++) {
				currC = formatting[i];
				if (currC == '$')
					build.Append(sectionName);
				else if (currC == '[')
					build.Append(IniFileSettings.SectionOpenBracket);
				else if (currC == ']')
					build.Append(IniFileSettings.SectionCloseBracket);
				else if (currC == ';' && IniFileSettings.CommentChars.Length > 0 && inlineComment != null)
					build.Append(IniFileSettings.CommentChars[0]).Append(inlineComment);
				else if (char.IsWhiteSpace(formatting[i]))
					build.Append(formatting[i]);
			}
			Content = build.ToString().TrimEnd() + (IniFileSettings.AllowTextOnTheRight ? textOnTheRight : "");
		}

		public static IniFileSectionStart FromName(string sectionName)
		{
			var ret = new IniFileSectionStart();
			ret.SectionName = sectionName;
			ret.FormatDefault();
			return ret;
		}
	}

	public class IniFileBlankLine : IniFileElement {
		public IniFileBlankLine(int amount) : base("") {
			Amount = amount;
		}
		public int Amount {
			get { return Line.Length / Environment.NewLine.Length + 1; }
			set {
				if (value < 1)
					throw new ArgumentOutOfRangeException("Cannot set Amount to less than 1.");
				var build = new StringBuilder();
				for (int i = 1; i < value; i++)
					build.Append(Environment.NewLine);
				Content = build.ToString();
			}
		}
		public static bool IsLineValid(string testString) {
			return testString == "";
		}
		public override string ToString() {
			return Amount.ToString() + " blank line(s)";
		}
		public override void FormatDefault() {
			Amount = 1;
			base.FormatDefault();
		}
	}

	public class IniFileCommentary : IniFileElement {
		private string comment;
		private string commentChar;

		private IniFileCommentary() { }
		public IniFileCommentary(string content) : base(content) {
			if (IniFileSettings.CommentChars.Length == 0)
				throw new NotSupportedException("Comments are disabled. Set the IniFileSettings.CommentChars property to turn them on.");
			commentChar = IniFileSettings.startsWith(Content, IniFileSettings.CommentChars);
			if (Content.Length > commentChar.Length)
				comment = Content.Substring(commentChar.Length);
			else
				comment = "";
		}

		public string CommentChar {
			get { return commentChar; }
			set {
				if (commentChar != value) {
					commentChar = value;
					rewrite();
				}
			}
		}
		public string Comment {
			get { return comment; }
			set {
				if (comment != value) {
					comment = value;
					rewrite();
				}
			}
		}
		private void rewrite() {
			var newContent = new StringBuilder();
			string[] lines = comment.Split(new string[] { Environment.NewLine }, StringSplitOptions.None);
			newContent.Append(commentChar + lines[0]);
			for (int i = 1; i < lines.Length; i++)
				newContent.Append(Environment.NewLine + commentChar + lines[i]);
			Content = newContent.ToString();
		}
		public static bool IsLineValid(string testString) {
			return IniFileSettings.startsWith(testString.TrimStart(), IniFileSettings.CommentChars) != null;
		}
		public override string ToString() {
			return "Comment: \"" + comment + "\"";
		}

		public static IniFileCommentary FromComment(string comment) {
			if (IniFileSettings.CommentChars.Length == 0)
				throw new NotSupportedException("Comments are disabled. Set the IniFileSettings.CommentChars property to turn them on.");
			var ret = new IniFileCommentary();
			ret.comment = comment;
			ret.CommentChar = IniFileSettings.CommentChars[0];
			return ret;
		}

		public override void FormatDefault() {
			base.FormatDefault();
			CommentChar = IniFileSettings.CommentChars[0];
			rewrite();
		}
	}

	public class IniFileValue : IniFileElement {
		private string key;
		private string value;
		private string textOnTheRight; // only if qoutes are on, e.g. "Name = 'Jack' text-on-the-right"
		private string inlineComment, inlineCommentChar;

		private IniFileValue(): base() { }
		public IniFileValue(string content): base(content)  {
			string[] split = Content.Split(new string[] { IniFileSettings.EqualsString }, StringSplitOptions.None);
			formatting = ExtractFormat(content);
			string split0 = split[0].Trim();
			string split1 = split.Length >= 1 ?
				split[1].Trim()
				: "";
			
			if (split0.Length > 0) {
				if (IniFileSettings.AllowInlineComments) {
					IniFileSettings.indexOfAnyResult result = IniFileSettings.indexOfAny(split1, IniFileSettings.CommentChars);
					if (result.index != -1) {
						inlineComment = split1.Substring(result.index + result.any.Length);
						split1 = split1.Substring(0, result.index).TrimEnd();
						inlineCommentChar = result.any;
					}
				}
				if (IniFileSettings.QuoteChar != null && split1.Length >= 2) {
					char quoteChar = (char)IniFileSettings.QuoteChar;
					if (split1[0] == quoteChar) {
						int lastQuotePos;
						if (IniFileSettings.AllowTextOnTheRight) {
							lastQuotePos = split1.LastIndexOf(quoteChar);
							if (lastQuotePos != split1.Length - 1)
								textOnTheRight = split1.Substring(lastQuotePos + 1);
						}
						else
							lastQuotePos = split1.Length - 1;
						if (lastQuotePos > 0) {
							split1 =  (split1.Length == 2) ?
								split1 = "": split1.Substring(1, lastQuotePos - 1);
						}
					}
				}
				key = split0;
				value = split1;
			}
			Format();
		}
		public string Key {
			get { return key; }
			set { this.key = value;
				Format();
			}
		}
		public string Value {
			get { return value; }
			set { this.value = value;
				Format();
			}
		}
		public string InlineComment {
			get { return inlineComment; }
			set
			{
				if (!IniFileSettings.AllowInlineComments || IniFileSettings.CommentChars.Length == 0)
					throw new NotSupportedException("Inline comments are disabled.");
				if (inlineCommentChar == null)
					inlineCommentChar = IniFileSettings.CommentChars[0];
				inlineComment = value; Format();
			}
		}

		// state of format extractor (ExtractFormat method)
		enum feState {
			BeforeEvery,
			AfterKey,
			BeforeVal,
			AfterVal
		}

		public string ExtractFormat(string content) {
			feState pos = feState.BeforeEvery;
			char currC; string comChar; string insideWhiteChars = ""; string theWhiteChar; ;
			var form = new StringBuilder();
			for (int i = 0; i < content.Length; i++) {
				currC = content[i];
				if (char.IsLetterOrDigit(currC)) {
					if (pos == feState.BeforeEvery) {
						form.Append('?');
						pos = feState.AfterKey;
						//afterKey = true; beforeEvery = false; ;
					}
					else if (pos == feState.BeforeVal) {
						form.Append('$');
						pos = feState.AfterVal;
					}
				}

				else if (pos == feState.AfterKey && content.Length - i >= IniFileSettings.EqualsString.Length && content.Substring(i, IniFileSettings.EqualsString.Length) == IniFileSettings.EqualsString) {
					form.Append(insideWhiteChars);
					pos = feState.BeforeVal;
					//afterKey = false; beforeVal = true;
					form.Append('=');
				}
				else if ((comChar = IniFileSettings.ofAny(i, content, IniFileSettings.CommentChars)) != null) {
					form.Append(insideWhiteChars);
					form.Append(';');
				}
				else if (char.IsWhiteSpace(currC)) {
					if (currC == '\t' && IniFileSettings.TabReplacement != null)
						theWhiteChar = IniFileSettings.TabReplacement;
					else
						theWhiteChar = currC.ToString();
					if (pos == feState.AfterKey || pos == feState.AfterVal) {
						insideWhiteChars += theWhiteChar;
						continue;
					}
					else
						form.Append(theWhiteChar);
				}
				insideWhiteChars = "";
			}
			if (pos == feState.BeforeVal) {
				form.Append('$');
				pos = feState.AfterVal;
			}
			string ret = form.ToString();
			if (ret.IndexOf(';') == -1)
				ret += "   ;";
			return ret;
		}

		public void Format() {
			Format(formatting);
		}
		
		public void Format(string formatting) {
			char currC;
			var build = new StringBuilder();
			for (int i = 0; i < formatting.Length; i++) {
				currC = formatting[i];
				if (currC == '?')
					build.Append(key);
				else if (currC == '$') {
					if (IniFileSettings.QuoteChar != null) {
						char quoteChar = (char)IniFileSettings.QuoteChar;
						build.Append(quoteChar).Append(value).Append(quoteChar);
					}
					else
						build.Append(value);
				}
				else if (currC == '=')
					build.Append(IniFileSettings.EqualsString);
				else if (currC == ';')
					build.Append(inlineCommentChar + inlineComment);
				else if (char.IsWhiteSpace(formatting[i]))
					build.Append(currC);
			}
			Content = build.ToString().TrimEnd() + (IniFileSettings.AllowTextOnTheRight ? textOnTheRight : "");
		}

		public override void FormatDefault() {
			Formatting = IniFileSettings.DefaultValueFormatting;
			Format();
		}
		public IniFileValue CreateNew(string key, string value) {
			var ret = new IniFileValue();
			ret.key = key;
			ret.value = value;
			if (IniFileSettings.PreserveFormatting) {
				ret.formatting = formatting;
				if (IniFileSettings.AllowInlineComments)
					ret.inlineCommentChar = inlineCommentChar;
				ret.Format();
			} else {
				ret.FormatDefault();
			}
			return ret;
		}

		public static bool IsLineValid(string testString) {
			int index = testString.IndexOf(IniFileSettings.EqualsString);
			return index > 0;
		}
		public void Set(string key, string value) {
			this.key = key;
			this.value = value;
			Format();
		}

		public override string ToString() {
			return "Value: \"" + key + " = " + value + "\"";
		}

		public static IniFileValue FromData(string key, string value) {
			var ret = new IniFileValue();
			ret.key = key;
			ret.value = value;
			ret.FormatDefault();
			return ret;
		}
	}

}
