add-type -typedefinition @'

using System;
using System.Collections.Generic;
// TODO: introduce namespace, wrap it up
public class Results {
  private List<Result> data = new List<Result>();
  public List<Result> Data {
    get {
      return data;
    }
  }
  public Results() {
    this.data = new List<Result>();
  }

  public void addResult(String className, int handle) {
    this.data.Add(new Result(className, handle));
  }
  public void addResult(String className, int handle, bool active) {
    this.data.Add(new Result(className, handle, active));
  }
  public void addResult(String className, String title, int handle, bool active) {
    this.data.Add(new Result(className, title, handle, active));
  }
  public void addResult(String className, String title, int handle, bool active, bool topmost) {
    this.data.Add(new Result(className, title, handle, active,topmost));
  }
}
public class Result {
  private String className;
  public string ClassName {
    get { return className; }
    set {
      className = value;
    }
  }
  private String title;
  public string Title {
    get { return title; }
    set {
      title = value;
    }
  }
  private bool active;
  public bool Active {
    get { return active; }
    set {
      active = value;
    }
  }
  private bool topmost;
  public bool Topmost {
    get { return topmost; }
    set {
      topmost = value;
    }
  }
  private int handle;
  public int Handle {
    get { return handle; }
    set {
      handle = value;
    }
  }
  private int processid;
  public int Processid {
    get { return processid; }
    set {
      processid = value;
    }
  }
  public Result() { }
  public Result(String className, int handle) {
    this.className = className;
    this.handle = handle;
    this.active = false;
    this.topmost = false;
  }
  public Result(String className, int handle, bool active) {
    this.className = className;
    this.title = null;
    this.handle = handle;
    this.active = active;
    this.topmost = false;
  }
  public Result(String className, String title, int handle, bool active) {
    this.className = className;
    this.title = title;
    this.handle = handle;
    this.active = active;
    this.topmost = false;
  }
  public Result(String className, String title, int handle, bool active, bool topmost) {
    this.className = className;
    this.title = title;
    this.handle = handle;
    this.active = active;
    this.topmost = topmost;
  }
}
'@
$e = new-object -typeName 'Result'
$e.ClassName = 'test'
write-output ('e.ClassName= "{0}"' -f $e.ClassName)
$e|format-list
$e = new-object Result('another test', 42)
write-output 'Members of Result: '
$e | get-member

# TODO: chop down code compiled on the fly piece-meal

# for a no-arg constructor one to drop parenthesis
$o = new-object Results
$o.addResult('result 1',1)
$o.addResult('result 2',2)
$o.addResult('result 3',3,$true)
$o.addResult('result 4',4,$true)
$o.addResult('result 4','title',4,$true,$true)
$o.addResult('result 5',5,$true)
write-output 'Printing in table'
format-table -inputObject  $o.Data

write-output 'Iterating over and printing in list'
$o.Data | foreach-object { format-list -inputObject $_ }

