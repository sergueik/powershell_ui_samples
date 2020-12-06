param (
  [String]$target = "v3.5",
  [switch]$debug
)
add-Type -typeDefinition @'
using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.Linq;

using System.Reflection;
using Microsoft.CSharp;

// see also: https://docs.microsoft.com/en-us/dotnet/api/microsoft.csharp.csharpcodeprovider.createcompiler?view=netframework-2.0
// https://docs.microsoft.com/en-us/dotnet/api/microsoft.csharp.csharpcodeprovider?view=netframework-2.0
// https://docs.microsoft.com/en-us/dotnet/api/system.codedom.compiler.compilerparameters?view=netframework-2.0
// https://habr.com/ru/company/pvs-studio/blog/301204/
namespace ConsoleCompile {
  public class Program {
    public static void Main(string[] args) {
      string source =
        @"
using System.Collections.Generic;
using System.Linq;

namespace Dynamic {
  public class Example {
    public static void Main() {
      System.Console.WriteLine(""Hello World"");
      System.Console.WriteLine( string.Join("","", Enumerable.Range(0,10).Select(n=>n.ToString()).ToArray() ) );
    }
  }
} ";

      string target = args.Length >0 ? args[0]: "v.3.5";
      Console.WriteLine("Console Compile: target version {0}", target);
      Dictionary<string, string> providerOptions = new Dictionary<string, string> { { "CompilerVersion", target } };
      var provider = new CSharpCodeProvider(providerOptions);

      string assembly = args.Length > 1 ? args[1]: "c:\\temp\\foo.exe";
      var compilerParams = new CompilerParameters { OutputAssembly = assembly, GenerateExecutable = true};
      compilerParams.ReferencedAssemblies.Add("System.dll");
      compilerParams.ReferencedAssemblies.Add("System.Core.dll");            
      compilerParams.ReferencedAssemblies.Add("System.Data.dll");            
      CompilerResults results = provider.CompileAssemblyFromSource(compilerParams, source);
  
      Console.WriteLine("Console Compile: {0} Errors", results.Errors.Count);
      foreach (CompilerError err in results.Errors) {
        Console.WriteLine("Error {0}", err.ErrorText);
      }

      // Console.ReadKey();
    }
  }
}
'@  -ReferencedAssemblies 'System.dll', 'System.Data.dll', 'System.Core.dll'

$o = new-object -typeName 'ConsoleCompile.Program'
[ConsoleCompile.Program]::Main(@($target))
# TODO: support passing nulls
# [ConsoleCompile.Program]::Main(@())
& c:\temp\foo.exe
