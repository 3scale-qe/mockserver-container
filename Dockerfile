FROM quay.io/fedora/fedora:41

ARG user=fedora
EXPOSE 1080

RUN dnf -y update \
	&& dnf install -y java-17-openjdk-headless openssl \
	&& dnf clean all

RUN useradd $user -g root
WORKDIR /home/$user
USER $user
ENV HOME=/home/${user}

ARG MOCKSERVER_VERSION=7.4.0
ARG GRAALVM_VERSION=23.1.4

RUN curl -L \
    https://repo1.maven.org/maven2/org/mock-server/mockserver-netty/${MOCKSERVER_VERSION}/mockserver-netty-${MOCKSERVER_VERSION}-jar-with-dependencies.jar \
    -o mockserver.jar

RUN MAVEN=https://repo1.maven.org/maven2 V=${GRAALVM_VERSION} && mkdir lib \
    && curl -L ${MAVEN}/org/graalvm/polyglot/polyglot/${V}/polyglot-${V}.jar -o lib/polyglot-${V}.jar \
    && curl -L ${MAVEN}/org/graalvm/js/js-language/${V}/js-language-${V}.jar -o lib/js-language-${V}.jar \
    && curl -L ${MAVEN}/org/graalvm/truffle/truffle-runtime/${V}/truffle-runtime-${V}.jar -o lib/truffle-runtime-${V}.jar \
    && curl -L ${MAVEN}/org/graalvm/truffle/truffle-api/${V}/truffle-api-${V}.jar -o lib/truffle-api-${V}.jar \
    && curl -L ${MAVEN}/org/graalvm/truffle/truffle-compiler/${V}/truffle-compiler-${V}.jar -o lib/truffle-compiler-${V}.jar \
    && curl -L ${MAVEN}/org/graalvm/regex/regex/${V}/regex-${V}.jar -o lib/regex-${V}.jar \
    && curl -L ${MAVEN}/org/graalvm/shadowed/icu4j/${V}/icu4j-${V}.jar -o lib/icu4j-${V}.jar \
    && curl -L ${MAVEN}/org/graalvm/sdk/collections/${V}/collections-${V}.jar -o lib/collections-${V}.jar \
    && curl -L ${MAVEN}/org/graalvm/sdk/nativeimage/${V}/nativeimage-${V}.jar -o lib/nativeimage-${V}.jar \
    && curl -L ${MAVEN}/org/graalvm/sdk/jniutils/${V}/jniutils-${V}.jar -o lib/jniutils-${V}.jar \
    && curl -L ${MAVEN}/org/graalvm/sdk/word/${V}/word-${V}.jar -o lib/word-${V}.jar
COPY --chown=$user:root . .
RUN chmod ug+rwx . && chmod ug+r mockserver.jar

CMD ["./entrypoint"]
