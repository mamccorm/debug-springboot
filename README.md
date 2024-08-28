# SpringHelloWorld

A sample SpringBoot application which is packaged into a JRE container image.
This is to test out / validate a reported config issue.


## Build the project

```bash
cd SpringHelloWorld
mvn package
```

This will output an executable jar under ./target. Validate it runs as
expected:

```bash
# ./SpringHelloWorld
java -jar target/SpringHelloWorld-1.0-SNAPSHOT.jar

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v3.2.5)

2024-08-28T00:41:55.552+01:00  INFO 2053 --- [           main] c.example.SpringHelloWorldApplication    : Starting SpringHelloWorldApplication using Java 17.0.11 with PID 2053 (/Users/mark/Desktop/SpringHelloWorld/SpringHelloWorld/target/SpringHelloWorld-1.0-SNAPSHOT.jar started by mark in /Users/mark/Desktop/SpringHelloWorld/SpringHelloWorld)
2024-08-28T00:41:55.557+01:00  INFO 2053 --- [           main] c.example.SpringHelloWorldApplication    : No active profile set, falling back to 1 default profile: "default"
2024-08-28T00:41:55.990+01:00  INFO 2053 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port 8080 (http)
2024-08-28T00:41:55.995+01:00  INFO 2053 --- [           main] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
2024-08-28T00:41:55.995+01:00  INFO 2053 --- [           main] o.apache.catalina.core.StandardEngine    : Starting Servlet engine: [Apache Tomcat/10.1.20]
2024-08-28T00:41:56.012+01:00  INFO 2053 --- [           main] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring embedded WebApplicationContext
2024-08-28T00:41:56.012+01:00  INFO 2053 --- [           main] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 420 ms
2024-08-28T00:41:56.060+01:00  WARN 2053 --- [           main] .s.s.UserDetailsServiceAutoConfiguration :
```

## Build container image

```bash
# root of project dir
docker build -t spring-helloworld:latest .
```

## Run the image

```bash
% docker run -it spring-helloworld:latest
NOTE: Picked up JDK_JAVA_OPTIONS: --add-exports=java.base/sun.security.internal.spec=ALL-UNNAMED --add-exports=java.base/sun.security.provider=ALL-UNNAMED -Djavax.net.ssl.trustStoreType=FIPS
OpenJDK 64-Bit Server VM warning: Sharing is only supported for boot loader classes because bootstrap classpath has been appended
[dd.trace 2024-08-27 23:43:43:290 +0000] [dd-telemetry] WARN datadog.telemetry.TelemetryRouter - Got FAILURE sending telemetry request to http://localhost:8126/telemetry/proxy/api/v2/apmtelemetry.

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v3.2.5)
```

And here's the error we're debugging:

```bash
org.springframework.beans.factory.BeanCreationException: Error creating bean with name 'conversionServicePostProcessor' defined in class path resource [org/springframework/security/config/annotation/web/configuration/WebSecurityConfiguration.class]: Failed to instantiate [org.springframework.beans.factory.config.BeanFactoryPostProcessor]: Factory method 'conversionServicePostProcessor' threw exception with message: java.security.NoSuchAlgorithmException: RSA KeyFactory not available
```

## Root cause? 

Spring Boot applications are typically packaged as "fat JARs," which bundle all
necessary classes and dependencies within a single archive. When running a
Spring Boot application using the java -cp approach, the JVM may not correctly
locate the application classes and dependencies due to the structure of the fat
JAR, where classes are nested under BOOT-INF/classes and libraries under
BOOT-INF/lib.

Using this example, I haven't been able to quite get the syntax right to use
'java -cp' instead. Tried:

```bash
ENTRYPOINT ["sh", "-c", "java -javaagent:/home/build/dd-java-agent.jar -Ddd.profiling.enabled=true -XX:FlightRecorderOptions=stackdepth=256 -Ddd.logs.injection=true -Ddd.trace.header.tags=x-ras-events-billing-ssid:tr-ras-events-billing-ssid,x-ras-events-cid:tr-ras-events-cid,x-ras-events-userguid:tr-ras-events-userguid -cp \"$JAVA_FIPS_CLASSPATH:/home/build/app.jar:/home/build/BOOT-INF/classes:/home/build/BOOT-INF/lib/*\" org.springframework.boot.loader.JarLauncher"]
```

But still results in:
> Error: Could not find or load main class org.springframework.boot.loader.JarLauncher
> Caused by: java.lang.ClassNotFoundException: org.springframework.boot.loader.JarLauncher
