# AI Agent Guidelines - Spring Boot Project

## CRITICAL: Read Official Documentation First

**BEFORE implementing any feature, check official docs for current syntax:**

- **Spring Boot**: https://docs.spring.io/spring-boot/docs/current/reference/html/
- **Spring Framework**: https://docs.spring.io/spring-framework/reference/
- **Java Docs**: https://docs.oracle.com/en/java/javase/21/

**Why**: Spring Boot versions have breaking changes. This project uses:
- Spring Boot 3.x (check pom.xml or build.gradle)
- Java 17+ or 21+ (check pom.xml `<java.version>`)

### Version-Specific Syntax Enforcement

| API Category | Docs URL | Common Version Conflicts |
|:-------------|:---------|:-------------------------|
| **Spring Data JPA** | https://docs.spring.io/spring-data/jpa/reference/ | Repository methods evolve |
| **Spring Security** | https://docs.spring.io/spring-security/reference/ | Config changes per version |
| **REST Controllers** | https://docs.spring.io/spring-framework/reference/web/webmvc/mvc-controller.html | Annotation patterns |
| **Bean Validation** | https://docs.spring.io/spring-framework/reference/core/validation/beanvalidation.html | Constraint annotations |

**Enforcement Rules**:
1. Check Java version: `java -version`
2. Verify Spring Boot version in pom.xml/build.gradle
3. Use constructor injection (not field injection)
4. Follow Java naming conventions (camelCase methods, PascalCase classes)

## Code Style Rules
1. **PascalCase**: Classes, interfaces, enums
2. **camelCase**: Methods, variables, parameters
3. **SCREAMING_SNAKE_CASE**: Constants
4. **Annotations**: Use Spring annotations (@Service, @Repository, @Component)
5. **Streams**: Use Java Streams API for collections

## Database (Spring Data JPA)
- **Entities**: JPA annotations (@Entity, @Table, @Column)
- **Repositories**: Extend JpaRepository<Entity, ID>
- **Migrations**: Use Flyway or Liquibase
- **Queries**: Use JPQL or native queries with @Query

## Testing
- **Framework**: JUnit 5 + Mockito
- **Run**: `mvn test` or `gradle test`
- **Integration**: Use @SpringBootTest

## Security
- **Authentication**: Spring Security + JWT
- **Authorization**: Method-level with @PreAuthorize
- **SQL Injection**: JPA prevents (use parameterized queries)
- ❌ No secrets in application.properties (use environment variables)

## Build Commands
- **Dev**: `mvn spring-boot:run` or `gradle bootRun`
- **Build**: `mvn clean package` or `gradle build`
- **Test**: `mvn test` or `gradle test`
