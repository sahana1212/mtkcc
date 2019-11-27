FROM tomcat
	COPY MCC.war /usr/local/tomcat/webapps/
	EXPOSE 8080

