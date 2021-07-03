using System;
using System.Text.RegularExpressions;
using System.Collections.Specialized;
using System.Reflection;

public class ParseArgs
{

	private bool _DEBUG = false;
	public bool DEBUG {
		get { return _DEBUG; }
		set { _DEBUG = value; }
	}
	private StringDictionary _MACROS;

	private StringDictionary AllMacros {
		get { return _MACROS; }
	}

	private bool DefinedMacro(string sMacro)
	{
		return _MACROS.ContainsKey(sMacro);
	}


	public string GetMacro(string sMacro)
	{

		if (DefinedMacro(sMacro))
			return _MACROS[sMacro];
		else
			return String.Empty;
	}

	public string SetMacro(string sMacro, string sValue)
	{
		_MACROS[sMacro] = sValue;
		return _MACROS[sMacro];
	}

	public ParseArgs(string sLine)
	{

		_MACROS = new StringDictionary();

		string s = @"(\s|^)(?<token>(/|-{1,2})(\S+))";
		Regex r = new Regex(s, RegexOptions.ExplicitCapture | RegexOptions.IgnoreCase);
		MatchCollection m = null;
		try {
			m = r.Matches(sLine);
		} catch (Exception e) {
			Console.WriteLine(e.Message);
		}
		if (m != null) {

			for (int i = 0; i < m.Count; i++) {
				string sToken = m[i].Groups["token"].Value.ToString();
				// Console.WriteLine("{0}", sToken);
				ParseSwithExpression(sToken);
			}
		}
		return;
	}

	private void ParseSwithExpression(string sToken)
	{
		string s = @"(/|\-{1,2})(?<macro>[a-z0-9_\-\\\@\$\#]+)([\=\:](?<value>[\:a-z0-9_\.\,\\\-\@\$\#]+))*";

		Regex r = new Regex(s, RegexOptions.ExplicitCapture | RegexOptions.IgnoreCase);
		MatchCollection m = r.Matches(sToken);

		if (m != null) {
			for (int i = 0; i < m.Count; i++) {
				string sMacro = m[i].Groups["macro"].Value.ToString();

				string sValue = m[i].Groups["value"].Value;
				if (sValue == "")
					sValue = "true";
				SetMacro(sMacro, sValue);
				if (DEBUG)
					Console.WriteLine("{0} = \"{1}\"", sMacro, GetMacro(sMacro));
			}
		}
		return;
	}

}

