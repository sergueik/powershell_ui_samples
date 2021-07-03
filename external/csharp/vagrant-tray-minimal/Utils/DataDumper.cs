using System;
using System.Diagnostics;
using System.Collections;
using System.Reflection;

public class DataDumper {

	Hashtable DisplayFields = new Hashtable(1024);
	static String sDelimiter = ",";
	private bool _DEBUG = false;
	public bool DEBUG {
		get { return _DEBUG; }
		set { _DEBUG = value; }
	}

	public DataDumper()
	{
		DisplayFields.Add("all", 1);
	}

	public DataDumper(string sFields)
	{

		foreach (string s in sFields.Split(sDelimiter.ToCharArray())) {
			try {
				DisplayFields.Add(s, 1);
				if (_DEBUG)
					Console.WriteLine("Added to Display Fields: {0}", s);
			} catch (System.ArgumentException e) {
				Trace.Assert(e != null);
				// keep the compiler happy
			}
		}
	}

	public void Dump(object DataClass)
	{

		try {
			Type DataClassType = DataClass.GetType();
			foreach (PropertyInfo oProperty in DataClassType.GetProperties()) {
				string sProperty = oProperty.Name.ToString();
				if (DisplayFields.ContainsKey("all") || DisplayFields.ContainsKey(sProperty))
					Console.WriteLine("{0} = {1}", sProperty, DataClassType.GetProperty(sProperty).GetValue(DataClass, new Object[] { }));
			}
			;
		} catch (Exception e) {

			// Fallback to system formatting
			//
			Console.WriteLine("FileVersionInfo:\n{0}", DataClass.ToString());
			Trace.Assert(e != null);
			// keep the compiler happy
		}


	}

}
