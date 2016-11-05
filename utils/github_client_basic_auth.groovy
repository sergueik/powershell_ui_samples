package gihubclient
// general documentation: https://my.usgs.gov/confluence/display/sciencebase/Making+POST,+PUT,+DELETE+Calls+from+Groovy

import groovy.grape.Grape
@Grab(group='org.codehaus.groovy.modules.http-builder', module='http-builder', version='0.7')

// if an error java.lang.RuntimeException: Error grabbing Grapes -- [download failed -
// review versions, possibly, recycle ~/.groovy/grapes and retry
// alternatively, one may let maven download the necesswary jars e.g.
// https://mvnrepository.com/artifact/org.codehaus.groovy.modules.http-builder/http-builder/0.5.0-RC2
// using a dummy project pom.xml and copy the jar file from .m2 into the groovy environment
// In the past, alternative to using grape was put into $GROOVY_HOME/lib the http-builder and dependency jars from
// http://snapshots.repository.codehaus.org/org/codehaus/groovy/modules/htxtp-builder/http-builder/0.5.2-SNAPSHOT/
// however since codehaus.org has been effectively shut down as an artifact repository,
// https://support.sonatype.com/hc/en-us/articles/217611787-codehaus-org-Repositories-Should-Be-Removed-From-Your-Nexus-Instance

import groovyx.net.http.*
import groovyx.net.http.ContentType.*
import groovyx.net.http.Method.*
import net.sf.json.*
import groovy.text.SimpleTemplateEngine
import groovy.json.JsonOutput
import groovy.transform.Field

// origin: https://gist.githubusercontent.com/kyleboon/5705380/raw/51b6a2ed1f0ff55b0ae7fc33e51ec061733cd6f1/GithubClient.groovy
public class GithubClient {

  def printErr = System.err.&println
	String user
	String password
	String owner
	String repository
	def config

	def GithubClient(config) {
		this.config = config
    this.user = config.user
    this.password = config.password
    this.owner = config.user
    this.repository = config.repository
	}

  String fetchFileContents(String filePath) {
		request("${repoUrl}contents/${filePath}").content.decodeBase64()
	}

	public Map request(String url) {
		githubApi.get(path : url).responseData
	}

	private String getRepoUrl() {
		"repos/${owner}/${repository}/"
	}

	private RESTClient getGithubApi() {
		return new RESTClient("https://api.github.com/").with {
			headers.'User-Agent' = 'Mozilla/5.0'
			if (user && password) {
				headers['Authorization'] = 'Basic '+"${user}:${password}".getBytes('iso-8859-1').encodeBase64()
			}
      handler.failure = { resp ->
        println "Unexpected failure: ${resp.statusLine}" }
			it
		}
	}
}

def config = ['user':'sergueik','password':'','server':'http://172.28.128.3:8080', 'repository': 'selenium_java']
def gihubclient = new GithubClient(config)
gihubclient.fetchFileContents('test')
