FROM quay.io/fedora/fedora:latest

ARG user=fedora
EXPOSE 1080

RUN dnf -y update \
	&& dnf install -y java-11-openjdk-headless \
	&& dnf clean all

RUN useradd $user -g root
WORKDIR /home/$user
USER $user

ADD --chown=$user:root https://oss.sonatype.org/service/local/artifact/maven/redirect?r=releases&g=org.mock-server&a=mockserver-netty&c=jar-with-dependencies&e=jar&v=RELEASE mockserver.jar
ADD --chown=$user:root init-mockserver .
RUN chmod ug+rx . init-mockserver && chmod ug+r mockserver.jar

CMD ["java", "-Dfile.encoding=UTF-8", "-cp", "mockserver.jar:/libs/*", "-Dmockserver.propertyFile=/config/mockserver.properties", "-Dmockserver.enableCORSForAllResponses=true", "org.mockserver.cli.Main", "-serverPort", "1080"]
