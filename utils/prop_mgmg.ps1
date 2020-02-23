add-type -typedefinition @'
using System;
   
public class Entry {
  private String name;
  public string Name { 
    get { return name; }
    set { 
      this.name = value; 
    }
  }
  private int count;
  public int Count { 
    get { return count; }
    set { 
      this.count = value; 
    }
  }
  public Entry() { }
  public Entry(String name, int count) {
    this.name = name;
    this.count = count;
  }

}
'@
$e = new-object -typeName 'Entry'
$e.Name = 'test';
write-output ('e.Name= "{0}"' -f $e.Name)

$e = [Entry]::new('another test', 42)
write-output 'Members of Entry: ' 
$e | get-member

# TODO: chop down code compiled on the fly piece-meal

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

  public void addResult(String name, int count) {
    this.data.Add(new Result(name, count));
  }
}
public class Result {
  private String name;
  public string Name {
    get { return name; }
    set {
      this.name = value;
    }
  }
  private int count;
  public int Count {
    get { return count; }
    set {
      this.count = value;
    }
  }
  public Result() { }
  public Result(String name, int count) {
    this.name = name;
    this.count = count;
  }
}
'@
$o = [Results]::new()
$o.addResult('result 1',1);
$o.addResult('result 2',2);
$o.addResult('result 3',3);
$o.addResult('result 4',4);
$o.addResult('result 5',5);
write-output 'Printing in table'
format-table -inputObject  $o.Data

write-output 'Iterating over and printing in list'
$o.Data | foreach-object { format-list -inputObject $_ }
