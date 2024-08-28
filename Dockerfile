FROM UPDATE-ME/jre-fips:openjdk-17-dev

USER 0
ENV LANG C.UTF-8
ENV JAVA_HOME=/usr/lib/jvm/default-jvm

COPY SpringHelloWorld/target/SpringHelloWorld-1.0-SNAPSHOT.jar /home/build/app.jar

ENTRYPOINT ["java", "-jar", "/home/build/app.jar"]
