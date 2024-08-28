FROM cgr.dev/UPDATE-ME/jre-fips:openjdk-17.0.11-dev

USER root

ENV LANG C.UTF-8
ENV JAVA_HOME=/usr/lib/jvm/default-jvm

ARG JAR_FILE=build/libs/*.jar

COPY SpringHelloWorld/target/SpringHelloWorld-1.0-SNAPSHOT.jar /home/build/app.jar

RUN wget -SO /home/build/dd-java-agent.jar https://dtdg.co/latest-java-tracer && \
    chmod a+x /home/build/dd-java-agent.jar

ENTRYPOINT ["java", "-javaagent:/home/build/dd-java-agent.jar", "-Ddd.profiling.enabled=true", "-XX:FlightRecorderOptions=stackdepth=256", "-Ddd.logs.injection=true", "-Ddd.trace.header.tags=x-ras-events-billing-ssid:tr-ras-events-billing-ssid,x-ras-events-cid:tr-ras-events-cid,x-ras-events-userguid:tr-ras-events-userguid", "-jar", "/home/build/app.jar"]
