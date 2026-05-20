# Build stage
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Run stage
FROM tomcat:10.1-jre17
WORKDIR /usr/local/tomcat

# Remove default Tomcat apps
RUN rm -rf webapps/*

# Copy built WAR
COPY --from=build /app/target/NutritionTracker.war webapps/ROOT.war

# Copy PostgreSQL JDBC driver
COPY --from=build /app/src/main/webapp/WEB-INF/lib/postgresql-*.jar lib/

EXPOSE 8080
CMD ["catalina.sh", "run"]