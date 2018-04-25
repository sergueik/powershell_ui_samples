// this is how to load the specific jar to the CLASSPATH at runtime 
// instantiating class that is no longer in the default Groovy JAR
// apache.commons.cli would be a good class 
// example how to load ... when the runtime is not the groovy script tool but the jenkins runtime
// unfinished
// this.getClass().classLoader.rootLoader.addURL(new File("D:/java/groovy-2.3.2/embeddable/groovy-all-2.3.2.jar").toURL())
// manager.hudson.class.classLoader.addURL(new URL("file:///" + filePath))
// println(Jenkins.instance.pluginManager.plugins)

import groovy.json.JsonSlurper;

// round way (and broken):
//def thr = Thread.currentThread()
//def build = thr?.executable
//def envWorkArea = build.parent.builds[0].properties.get("WORKAREA")
//println(envWorkArea)
// straight way 
Map<String, String> env = System.getenv();

// env.each {if (it.key =~ /(USE|BUILD)/ ) { println "${it.key} = ${it.value}"} } 
def slurper = new JsonSlurper()
json_file = env["TEMPORARY_LOG"]
File f = new File(json_file)
def result = null
result = slurper.parseText('[{"page_errors": 1, "page_performance": 670, "page_availability": "0.99", "page_address": "https://goccl1.uatcarnival.com", "page_status": "OK", "page_requests": 78}]')
if (!f.exists()){

  
  
  println("File: ${json_file} " + 'does not exist!' )

} else {
  String contents = f.getText( 'UTF-8' ) 
  contents = contents.replaceAll( "u\'", "'" )
  contents = contents.replaceAll( "\'", "\"" )
  println("trying to parge\n" + contents )
  result = slurper.parseText(contents)
  // because of the custom formatting of the json ? cannot use here
  // result = slurper.parse(new FileReader(f));
}


println result
boolean status = true
result.each { 
  if (it.page_errors != 0 ) { 
     status = false ;    
     println "${it.page_address } has ${it.page_errors} page errors"; 
  } 
}

// return status
// NOTE: System.exit is bad idea for system.groovy             environment 

new File("test.properties").withWriter { out ->
        out.writeLine("STEP_STATUS=ERROR")
}
System.exit(status ? 1 : 0)
