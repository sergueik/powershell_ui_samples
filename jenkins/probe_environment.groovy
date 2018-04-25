// http://blog.techstacks.com/2009/04/groovy-script-http-builder-get-example.html
import groovyx.net.http.HTTPBuilder
import static groovyx.net.http.Method.GET
import static groovyx.net.http.ContentType.*
def config = [
 dir: '',
 server: 'localhost',
 port: '8080',
 user: 'sergueik',
 password: 'i011155' ]

def http = new HTTPBuilder("http://${config.user}:${config.password}@${config.server}:${config.port}/${config.dir}")
try {
	http.request(GET)
} catch (all) {}


http.request(GET, HTML) {
	req -> headers.
	'User-Agent' = 'GroovyHTTPBuilderTest/1.0'
	headers.
	'Referer' = 'http://blog.techstacks.com/'
	// Switch to Java to set socket timeout

	req.getParams().setParameter("http.socket.timeout", new Integer(5000))

	// Back to Groovy

	response.success = {
		resp, html ->
		println "Server Response: ${resp.statusLine}"
		println "Server Type: ${resp.getFirstHeader('Server')}"
		println "Title: ${html.HEAD.TITLE.text()}"
	}
	response.failure = {
		resp ->
		println resp.statusLine
	}

}
