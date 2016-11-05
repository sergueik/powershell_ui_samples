package artifactory

import groovy.text.SimpleTemplateEngine
import groovyx.net.http.RESTClient
import net.sf.json.JSON
import groovy.json.JsonOutput
import groovy.transform.Field
import groovy.time.*


/**
* This groovy class is meant to be used to clean up your Atifactory server or get more information about it's
* contents. The api of artifactory is documented very well at the following location
* {@see http://wiki.jfrog.org/confluence/display/RTF/Artifactory%27s+REST+API}
*
* @author Jettro Coenradie
*/
private class Artifactory {

def printErr = System.err.&println
def engine = new SimpleTemplateEngine()
def config
def applications = []
def findfolder_result
def artifactory_entries = []
def Artifactory(config) {
	this.config = config
    config.rootpath = '/artifactory/api/repositories'
}

 /**
 * TODO: wrapper around Artifactory File Statistics REST API
 * {
 *   "uri": "http://localhost:8080/artifactory/api/storage/libs-release-local/org/acme/foo/1.0/foo-1.0.jar",
 *   "lastDownloaded": Timestamp (ms),
 *   "downloadCount": 1337,
 *   "lastDownloadedBy": "user1"
 * }
 */
 def fstat_entries() {
   // TODO
 }


// TODO refactor
def my_delete_entries()  {
  // read the Artifactory urls of the resources scheduled for deletion from csv file
  new File('a.csv').eachLine { line ->
    def (created, symbol, count, path, uri) = line.tokenize( '|' )
    if (symbol =~ /\*/){
       println( sprintf('Removing "%s"' , path ))
       removeItem2(path)
    }
  }
}
 /**
 * Print the data, before any sorting or filtering
 */
def print_entries() {
	def count = 0
	println(this.artifactory_entries.size)
	println(config.keep_builds)
	Integer last_count = this.artifactory_entries.size.toInteger()
	last_count -= config.keep_builds.toInteger()
    def data = []
	// NOTE: whitespace-sensitive
	artifactory_entries.sort {
		a, b -> a.created <=> b.created
	}.each {
		// only count the jars -  will delete full path
		def symbol = (count < last_count) ? '*' : ' '
		data <<= sprintf('%s|%s|%s|%s|%s', it.created, symbol, count, it.path, it.uri)
		count++
	}
  save_entries('a.csv', data)
}
def save_entries(data_filename, data) {
    // TODO: No such property: std_env for class: artifactory.Artifactory
	// def data_file_pathname = std_env['WORKSPACE'] + data_filename
    def data_file_pathname = data_filename
	def data_file = new File(data_file_pathname)
	data_file.createNewFile()

	data.each {
		data_file << ("${it}\r\n")
        println it
	}
}
/**
* Print information about all the available repositories in the configured Artifactory
*/
def printRepositories() {
  def server
  try {
	server = obtainServerConnection()
  } catch (all){
    printErr "FATAL: no server connection"
    throw new Exception()
  }

  def rootpath = config.rootpath

	def resp = server.get(path: rootpath)
	if (resp.status != 200) {
		printErr "FATAL: server.get: " + resp.status
		System.exit(-1)
	}
	JSON json = resp.data
	json.each {
      applications << it.key
      printErr(sprintf("key : %s\r\ntype :%s\r\ndescription :%s\r\nurl :%s\r\n", it.key, it.type , it.description, it.url ))
	}
}


  /**
* Return information about the provided path for the configured artifactory and server.
*
* @param path String representing the path to obtain information for
*
* @return JSON object containing information about the specified folder
*/
def JSON folderInfo(path) {
	def binding = [repository: config.repository, path: path]
  def template = engine.createTemplate( '''/artifactory/api/storage/$repository/$path''' ).make(binding)
	def query = template.toString()
	def server = obtainServerConnection()
	def resp = server.get(path: query)
	if (resp.status != 200) {
		printErr "ERROR: problem obtaining folder info: " + resp.status
		printErr query
		System.exit(-1)
	}
	return resp.data
}

/**
* http://www.jfrog.com/confluence/display/RTF/Artifactory+REST+API
*
* @param path String representing the path to obtain information for
*
* @return JSON object containing information about the specified folder
*/
def JSON fileInfo(path) {
	def binding = [repository: config.repository, path: path]
  def template = engine.createTemplate( '''/artifactory/api/storage/$repository/$path''' ).make(binding)
	def query = template.toString()
	def server = obtainServerConnection()
    /*
       Caught: org.codehaus.groovy.runtime.typehandling.GroovyCastException: Cannot cast object 'java.io.ByteArrayInputStream@19e09a4' with class 'java.io.ByteArrayInputStream' to class 'net.sf.json.JSON'
    */
	def resp = server.get(path: query)
	if (resp.status != 200) {
		printErr "ERROR: problem obtaining folder info: " + resp.status
		printErr query
		System.exit(-1)
	}

    // println(groovy.json.JsonOutput.prettyPrint(resp.data.toString()))
	return resp.data
}

  def exploredFolders(String path){
  	JSON json = folderInfo(path)
    printErr json
	json.children.each {
		child ->

		if ( child.folder.toBoolean() ) {
          applications << path + child.uri

        }
    }

  }

def findFolders(String target_folder_name, String path, Integer browse_level) {
	def result
	if (browse_level > config.browse_max_level ) {
        printErr (sprintf('Stop browsing at level %s/%s in %s' , browse_level, config.browse_max_level,  path ))
		return; // empty
	}
	// TODO: terminator
	if (path =~ /\b${target_folder_name}\b/  ) {
      result = path
      browse_level = config.browse_max_level + 1
      findfolder_result = result
      printErr ('set findfolder_result to ' + findfolder_result )
      return
    }

	JSON json = folderInfo(path)

	json.children.each {
		child ->

		if ( child.folder.toBoolean() ) {
          return findFolders(target_folder_name, path + child.uri, browse_level + 1)
        }
    }

}
/**
* Recursively removes all folders containing builds that start with the configured paths.
*
* @param path String containing the folder to check and use the childs to recursively check as well.
* @return Number with the amount of folders that were removed.
*/

def cleanArtifactsRecursive(path) {
    // TODO : browse_max_level too?
	def deleteCounter = 0
	JSON json = folderInfo(path)

	json.children.each {
		child ->
        def child_is_folder = child.folder.toBoolean()
		if ( child_is_folder   == true ) {
           assert child_is_folder
			if (isBuildFolder(child)) {
				// build folder logic
				config.versionsToRemove.each {
					toRemove ->
					if (child.uri.startsWith(toRemove)) {
						removeItem(path, child)
						deleteCounter++
					}
				}
			} else {
                // confinue recursing
				if (!child.uri.contains("ro-scripts")) {
					deleteCounter += cleanArtifactsRecursive(path + child.uri)
				}

			}
        } else {
          // file
          try {
            JSON fileinfo_json = fileInfo(path + child.uri)

            def artifact_entry = ['path' : fileinfo_json.path,'repo' : fileinfo_json.repo, 'uri' : fileinfo_json.uri, 'created' : fileinfo_json.created ]
            artifactory_entries.push ( artifact_entry )
          } catch(all){}
          removeItem(path,  child )
        }
	}
	return deleteCounter
}

private RESTClient obtainServerConnection() {
	def server = new RESTClient(config.server)
	server.auth.basic config.user, config.password
	server.parser.
	'application/vnd.org.jfrog.artifactory.storage.FolderInfo+json' = server.parser.
	'application/json'
	server.parser.
	'application/vnd.org.jfrog.artifactory.storage.FileInfo+json' = server.parser.
	'application/json'

	server.parser.
	'application/vnd.org.jfrog.artifactory.repositories.RepositoryDetailsList+json' = server.parser.
	'application/json'
	return server
}

// http://codebeautify.org/javaviewer
private def isBuildFolder(child) {
	child.uri.contains("-build-")
}



private def removeItem2(path) {
	if (config.powerless.toBoolean()) {
		println ( 'POWERLESS folder: ' + path + ' DELETE' )
	} else {
		def binding = [repository: config.repository, path: path]
		def template = engine.createTemplate('''/artifactory/$repository/$path''').make(binding)
		def query = template.toString()
		// TODO: store typed fields
		if (!config.powerless.toBoolean()) {
			def server2 = obtainServerConnection()
			try {
				server2.delete(path: query)
			} catch (groovyx.net.http.HttpResponseException e) {
				if (e.getMessage() =~ /Not Found/ ) {
					println(sprintf('The resource "%s" may already been deleted - ignoring', path ))
				} else {
					println(sprintf('Unexpected exception "%s" - rethrowing', e.getMessage()))
					throw (e)
				}
			}
			/*
			catch(Exception e) {
			     println( e.getClass())
			}
			*/
			finally {
				// TODO
			}
		}
	}
}

// TODO - refactor

private def removeItem(path, child) {
	if (config.powerles) {
		println "folder: " + path + child.uri + " DELETE"
	} else {
		def binding = [repository: config.repository, path: path + child.uri]
		def template = engine.createTemplate('''/artifactory/$repository/$path''').make(binding)
		def query = template.toString()
		// println(query)
		if (!config.powerless) {
			def server = new RESTClient(config.server)
            // NOT READY YET
			// server.delete(path: query)
		}
	}
}


}


@Field std_env = System.getenv()

if (std_env['JOB_DEBUG'].toBoolean()){
  println 'Run in debug mode: JOB_DEBUG = true'
}



assert[a: true, b: false] << [a: false] == [a: false, b: false]
// workaround the perceived difference scriptler and core handle parameters

def required_params = ['ARTIFACTORY_URL', 'ARTIFACTORY_USER', 'ARTIFACTORY_PASSWORD', 'APPLICATION_FOLDER', 'RECENT_BUILDS_KEEP', 'ARTIFACTORY_REPOSITORY', 'ARTIFACTORY_APPLICATIONS_ROOTFOLDER' , 'BROWSE_MAX_LEVEL', 'POWERLESS']
def default_env = [
	'ARTIFACTORY_URL' : 'http://localhost:8080',
	'ARTIFACTORY_USER' : 'sergueik',
	'ARTIFACTORY_PASSWORD' : 'i011155',
	'APPLICATION_FOLDER' : 'app',
	'RECENT_BUILDS_KEEP' : '3',
	'ARTIFACTORY_REPOSITORY' : 'libs-snapshot-local',
	'ARTIFACTORY_APPLICATIONS_ROOTFOLDER' : '/com',
	'BROWSE_MAX_LEVEL' : 2,
	'POWERLESS' : 'true'
]
def all_env = [:]
std_env = System.getenv()


all_env <<= std_env

// TODO: debug this...
// this appears to have has the oppsite effect: default_env overrides std_env
// all_env <<= default_env

// Lock to Windows OS, just for fun
assert all_env.containsKey('USERPROFILE')

// assert all required parameters are present
required_params.each {
	setting -> assert all_env.containsKey(setting)

}


if (std_env['JOB_DEBUG'].toBoolean()) {
	required_params.each {
		setting -> println(sprintf("'%s' : '%s'\r\n", setting, all_env.get(setting)))
	}
	return
}

 def timeStart = new Date()

 def config = [
	 rootfolder: all_env['ARTIFACTORY_APPLICATIONS_ROOTFOLDER'],
	 application_folder: all_env['APPLICATION_FOLDER'],
	 powerless: all_env['POWERLESS'],
	 browse_max_level: all_env['BROWSE_MAX_LEVEL'].toInteger(),
	 keep_builds:all_env['RECENT_BUILDS_KEEP'],
	 server: all_env['ARTIFACTORY_URL'],
	 user: all_env['ARTIFACTORY_USER'],
	 password: all_env['ARTIFACTORY_PASSWORD'],
	 repository: all_env['ARTIFACTORY_REPOSITORY'],
	 powerless: all_env['POWERLESS']
  ]

 // TODO:
 println 'Started.'
 def artifactory = new Artifactory(config)
/*
// this is wrong level
if ( std_env['LIST_APPLICATIONS_ROOTFOLDERS'].toBoolean() || std_env['ITERATE_ALL'].toBoolean()) {
   artifactory.applications = []
   artifactory.printRepositories()
  if ( std_env['LIST_APPLICATIONS_ROOTFOLDERS'].toBoolean()){
    // possibly some other code
    return
      } else {
    artifactory.applications.each {
      start_folder->
        println start_folder
    }

    return
  }
}

*/

 if (std_env['ITERATE_ALL'].toBoolean()) {

   artifactory.applications = []
   artifactory.exploredFolders(config.rootfolder)

    artifactory.applications.each {
      start_folder->
        println start_folder
    }

    return
  }

 // TODO - handle redundant and invalid inputs
 def find_folder = config.application_folder
 println(sprintf('Finding %s in %s' , config.application_folder, config.rootfolder ) )
 artifactory.findFolders(config.application_folder, config.rootfolder, 1)
if (!artifactory.findfolder_result  ) {
  throw new Exception(sprintf("'%s'was not found under '%s'", config.application_folder, config.rootfolder ))
}
 println('result=' + artifactory.findfolder_result)
 println ('Enumerating artifacts in ' + artifactory.findfolder_result )
 start_folder = artifactory.findfolder_result
 // artifactory.print_entries()
 def numberRemoved = artifactory.cleanArtifactsRecursive(start_folder)
 artifactory.print_entries()

artifactory.my_delete_entries()
 def timeStop = new Date()
 TimeDuration duration = TimeCategory.minus(timeStop, timeStart)
 println duration
