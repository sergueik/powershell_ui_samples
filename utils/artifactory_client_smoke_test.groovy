package artifactory

import groovy.text.SimpleTemplateEngine
import groovyx.net.http.RESTClient
import net.sf.json.JSON
import groovy.json.JsonOutput
import groovy.transform.Field
import groovy.time.*

/**
 * Minimal version of Jettro Coenradie's  artifactory REST Client groovy class
 */
public class Artifactory {

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
	 * Print information about all the available repositories in the configured Artifactory
	 */
	def printRepositories() {
		def server
		try {
			server = obtainServerConnection()
		} catch (all) {
			println "FATAL: no server connection"
			throw new Exception()
		}

		def rootpath = config.rootpath

		def resp = server.get(path: rootpath)
		if (resp.status != 200) {
			println "FATAL: server.get: " + resp.status
			System.exit(-1)
		}
		JSON json = resp.data
		json.each {
			applications << it.key
			println sprintf("key : %s\r\ntype :%s\r\ndescription :%s\r\nurl :%s\r\n", it.key, it.type, it.description, it.url)
		}
	}

	private RESTClient obtainServerConnection() {
		def server = new RESTClient(config.server)
		server.auth.basic config.user, config.password
		server.parser.'application/vnd.org.jfrog.artifactory.storage.FolderInfo+json' = server.parser.'application/json'
		server.parser.'application/vnd.org.jfrog.artifactory.storage.FileInfo+json' = server.parser.'application/json'
		server.parser.'application/vnd.org.jfrog.artifactory.repositories.RepositoryDetailsList+json' = server.parser.'application/json'
		return server
	}
}

 def config = ['user':'sergueik','password':'i011155','server':'http://172.28.128.3:8080']
 def artifactory = new Artifactory(config)
 artifactory.printRepositories()
// start artifactory on 8080 and get some repositories output 
// start groovy on 8080 and get Your application is not available
