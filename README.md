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
```
