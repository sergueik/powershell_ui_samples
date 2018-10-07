#Copyright (c) 2018 Serguei Kouzmine
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the 'Software'), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.


# @( 'System.Drawing','System.Windows.Forms') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }

# origin: https://github.com/RdlP/IniParser/blob/master/IniParser.cs
Add-Type -TypeDefinition @'

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Collections;

namespace EditorTDTChannels {
  public class IniParser {
    private Dictionary<string, Dictionary<string, object>> data = new Dictionary<string, Dictionary<string, object>>();

    public void parseFile(string path) {
      string[] lines = System.IO.File.ReadAllLines(path);
      string lastSection = "";
      foreach (string line in lines) {
        int startSection = line.IndexOf('[');
        int endSection = line.IndexOf(']');
        if (startSection != -1 && endSection != -1 && endSection > startSection) {
          string section = lastSection = line.Substring(startSection + 1, endSection - startSection - 1);
          data.Add(section, new Dictionary<string, object>());
        } else if (line.Contains("=") && !line.Trim().StartsWith(";")) {
          string[] keyValue = line.Split('=');
          int hasComments = keyValue[1].Trim().IndexOf(';');
          if (hasComments == -1) {
            Dictionary<string, object> hash = (Dictionary<string, object>)(data[lastSection]);
            hash.Add(keyValue[0].Trim(), keyValue[1].Trim());
          } else {
            Dictionary<string, object> hash = (Dictionary<string, object>)(data[lastSection]);
            hash.Add(keyValue[0].Trim(), keyValue[1].Trim().Substring(0, hasComments));
          }
        } else {
          if (line.Trim().StartsWith(";")) {
            string[] comment = line.Split(';');
            Dictionary<string, object> hash = (Dictionary<string, object>)(data[lastSection]);
            hash.Add(";", comment[1]);
          }
        }
      }
    }


    public void writeFile(string path)
    {
      ArrayList lines = new ArrayList();
      foreach (KeyValuePair<string, Dictionary<string, object>> de in data) {
        lines.Add("[" + de.Key + "]");
        foreach (KeyValuePair<string, object> d in de.Value) {
          if (d.Key != ";") {
            lines.Add(d.Key + "=" + d.Value);
          } else {
            lines.Add(d.Key + d.Value);
          }
        }
      }

      System.IO.File.WriteAllLines(path, (string[])lines.ToArray(typeof(string)));
    }

    public int getSectionSize(){
      return data.Count;
    }

    public List<String> getSections() {
      List<String> keys = new List<string>(data.Keys);
      return keys;
    }

    public void addSection(string section) {
      if (!data.Keys.Contains(section)) {
        data[section] = new Dictionary<string, object>();
      }
    }


    public void addString(string section, string key, string value) {
      if (!data.Keys.Contains(section)) {
        throw new ArgumentException("Section " + section + " doesn't exist");
      }
      Dictionary<string, object> hash = data[section];
      hash[key] = value;
    }

    public void addInteger(string section, string key, int value)
    {
      if (!data.Keys.Contains(section)) {
        throw new ArgumentException("Section " + section + " doesn't exist");
      }
      Dictionary<string, object> hash = data[section];
      hash[key] = value;
    }

    public void addFloat(string section, string key, float value)
    {
      if (!data.Keys.Contains(section)) {
        throw new ArgumentException("Section " + section + " doesn't exist");
      }
      Dictionary<string, object> hash = data[section];
      hash[key] = value;
    }

    public void addDouble(string section, string key, double value)
    {
      if (!data.Keys.Contains(section)) {
        throw new ArgumentException("Section " + section + " doesn't exist");
      }
      Dictionary<string, object> hash = data[section];
      hash[key] = value;
    }

    public void addBoolean(string section, string key, bool value) {
      if (!data.Keys.Contains(section)) {
        throw new ArgumentException("Section " + section + " doesn't exist");
      }
      Dictionary<string, object> hash = data[section];
      hash[key] = value;
    }

    public string getString(string section, string key) {
      if (!data.Keys.Contains(section)) {
        throw new ArgumentException("Section " + section + " doesn't exist");
      }
      Dictionary<string, object> hash = data[section];
      if (!hash.Keys.Contains(key)) {
        throw new ArgumentException(String.Format("Key {0} doesn't exist", key));
      }
      string result = (string)hash[key];
      Regex regex = new Regex("^\"\"$", RegexOptions.Compiled);
      return regex.IsMatch(result) ? "" : result;
    }

    public int getInteger(string section, string key) {
      if (!data.Keys.Contains(section)) {
        throw new ArgumentException("Section " + section + " doesn't exist");
      }
      Dictionary<string, object> hash = data[section];
      if (!hash.Keys.Contains(key)) {
        throw new ArgumentException(String.Format("Key {0} doesn't exist", key));
      }
      int result;
      if (!int.TryParse((string)hash[key], out result)) {
        throw new FormatException(String.Format("Data format is invalid: {0}", (string)hash[key]));
      }
      return result;
    }

    public bool getBoolean(string section, string key) {
      if (!data.Keys.Contains(section)) {
        throw new ArgumentException("Section " + section + " doesn't exist");
      }
      Dictionary<string, object> hash = data[section];
      if (!hash.Keys.Contains(key)) {
        throw new ArgumentException(String.Format("Key {0} doesn't exist", key));
      }
      return ((string)hash[key]).ToLower().Equals("true") ? true : false;
    }

    public float getFloat(string section, string key) {
      if (!data.Keys.Contains(section)) {
        throw new ArgumentException("Section " + section + " doesn't exist");
      }
      Dictionary<string, object> hash = data[section];
      if (!hash.Keys.Contains(key)) {
        throw new ArgumentException(String.Format("Key {0} doesn't exist", key));
      }
      float result;
      if (!float.TryParse((string)hash[key], out result)) {
        throw new FormatException("Format is invalid");
      }
      return result;
    }

    public double getDouble(string section, string key) {
      if (!data.Keys.Contains(section)) {
        throw new ArgumentException("Section " + section + " doesn't exist");
      }
      Dictionary<string, object> hash = data[section];
      if (!hash.Keys.Contains(key)) {
        throw new ArgumentException(String.Format("Key {0} doesn't exist", key));
      }
      double result;
      if (!double.TryParse((string)hash[key], out result)) {
        throw new FormatException(String.Format("Data format is invalid: {0}", (string)hash[key]));
      }
      return result;
    }
  }
}
'@  -ReferencedAssemblies 'System.dll', 'System.Data.dll'

$o =  new-object 'EditorTDTChannels.IniParser'
$o.parseFile((resolve-path -path './data.ini'))
write-output ('message = {0}' -f $o.getString('Section1', 'message')) 
write-output ('flag = {0}' -f $o.getString('Section1', 'flag') )
write-output ('number = {0}' -f $o.getString('Section1', 'number') )
write-output ('empty = {0}' -f $o.getString('Section1', 'empty') )