# for JNA see 
# // https://stackoverflow.com/questions/62289/read-write-to-windows-registry-using-java // readStringSubKeys
# // https://www.codota.com/code/java/methods/com.sun.jna.platform.win32.Advapi32Util/registryGetKeys
# // https://www.codota.com/code/java/methods/com.sun.jna.platform.win32.Advapi32Util/registryGetKeys
# // https://github.com/apache/npanday/tree/trunk/components/dotnet-registry/src/main/java/npanday/registry
add-Type -typeDefinition @"
// https://docs.microsoft.com/en-us/dotnet/api/microsoft.win32.registrykey.getsubkeynames?view=netframework-2.0
using Microsoft.Win32;
using System;
using System.Text;
using System.Collections;
using System.Collections.Generic;


namespace Tools {

  public class RegistryBrowser {
    public List<String> parse(RegistryKey key){
      List<String> subKeyNames = new List<String>();
      foreach(string subKeyName in key.GetSubKeyNames()){
        subKeyNames.Add(subKeyName);
      }
      return subKeyNames;
    }
    public List<String> parse(RegistryKey parentKey, String keyName){
      List<String> subKeyNames = new List<String>();
      RegistryKey key;
      using(key = parentKey.OpenSubKey(keyName)) {        
        foreach(string subKeyName in key.GetSubKeyNames()){
          subKeyNames.Add(subKeyName);
        }
      }
      return subKeyNames;
    }
  
    public void parse(){
      RegistryKey[] regKeyArray = new RegistryKey[] { Registry.CurrentUser };
      Dictionary<String,String> parentKeys = new Dictionary<String,String>();
      Dictionary<String,Boolean> hasSubKeys = new Dictionary<String,Boolean>();

      foreach (RegistryKey key in regKeyArray){
        List<String> subKeyNames = parse(key);
        if (subKeyNames.Count > 0) {
          hasSubKeys[key.Name] = true;
        } else {
          hasSubKeys[key.Name] = false;
        }
        foreach(string subKeyName in subKeyNames){
          parentKeys[subKeyName] = null ;
          List<String> sub2KeyNames = parse(key, subKeyName);
          if (sub2KeyNames.Count > 0) {
            hasSubKeys[subKeyName] = true;
          } else {
            hasSubKeys[subKeyName] = false;
          }
          foreach(string sub2KeyName in sub2KeyNames){
            hasSubKeys[sub2KeyName] = true; // guess - will be cleared
            parentKeys[sub2KeyName] = subKeyName;
          }
        }
      }
      foreach (String keyName in hasSubKeys.Keys){
        RegistryKey key = regKeyArray[0];
        Console.WriteLine("Examine: " + keyName);
        if (hasSubKeys[keyName]){
          Console.WriteLine("Has subkeys: " + keyName);
          // if (parentKeys.ContainsKey(keyName) && parentKeys[keyName] != null) {
          //  List<String> sub2KeyNames = parse(key, keyName);
          //  Console.WriteLine("Sub Key level 3 {0}", String.Join("/", sub2KeyNames));
         // }
        }
      }
      foreach (String keyName in hasSubKeys.Keys){
        // Console.WriteLine("Examine: " + keyName);
        if (!hasSubKeys[keyName]) {
          // Console.WriteLine("Has subkeys: " + keyName);
          String key = keyName;
          List<String> parentKeyNames = new List<String>();
          while (parentKeys.ContainsKey(key) && parentKeys[key] != null) {
            key = parentKeys[key];
            parentKeyNames.Add(key);
          }
          // Console.WriteLine("Sub Key level 2 {0}/{1}", String.Join("/", parentKeyNames), keyName);
        }
      }
      

    }
  }
}
"@ -ReferencedAssemblies 'System.dll', 'System.Data.dll', 'mscorlib.dll'

$o =  new-object 'Tools.RegistryBrowser'
$o.parse()