FROM quay.io/fedora/fedora:latest

ARG user=fedora
EXPOSE 1080

RUN dnf -y update \
	&& dnf install -y java-11-openjdk-headless openssl \
	&& dnf clean all

RUN useradd $user -g root
WORKDIR /home/$user
USER $user

ADD --chown=$user:root https://oss.sonatype.org/service/local/artifact/maven/redirect?r=releases&g=org.mock-server&a=mockserver-netty&c=jar-with-dependencies&e=jar&v=RELEASE mockserver.jar
COPY --chown=$user:root . .
RUN chmod ug+rwx . && chmod ug+r mockserver.jar

CMD ["./entrypoint"]
