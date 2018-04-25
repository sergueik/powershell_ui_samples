// no recursion

def files = [] 
    new File(".").eachFileRecurse { 
        if (it.isFile() && it.getName() =~ /\.jar$/ ) { 
            files << it 
        } 
    } 

files.each { 
  
  println(it.getAbsolutePath())
  println(it.getClass())
  println ''
  this.getClass().classLoader.rootLoader.addURL(new File(it.getAbsolutePath()).toURL())
           }

import groovy.text.SimpleTemplateEngine
import groovyx.net.http.RESTClient
import net.sf.json.JSON
import groovy.json.JsonOutput
import groovy.transform.Field
import groovy.time.*
