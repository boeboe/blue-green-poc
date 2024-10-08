package net.liantis.messagesender;

import io.restassured.RestAssured;
import io.restassured.http.ContentType;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.http.HttpStatus;

import static io.restassured.RestAssured.given;
import static org.hamcrest.Matchers.*;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.DEFINED_PORT)  // Use DEFINED_PORT for fixed port (e.g., 8080)
class MessageControllerIntegrationTest {

    @BeforeEach
    void setUp() {
        // Determine the base URL and port from system properties
        String baseUrl = System.getProperty("api.base.url", "http://localhost");
        String portValue = System.getProperty("api.port", "8080"); // Default to 8080 if no system property is set

        // Add debug info
        System.out.println("Base URL: " + baseUrl);
        System.out.println("Port Value: " + portValue);

        // Use the port from system properties or default
        RestAssured.port = Integer.parseInt(portValue);

        RestAssured.baseURI = baseUrl;
    }

  @Test
  void testCreateMessage() {
    String requestBody = "{ \"topic\": \"Test Topic\", \"message\": \"Test Message\" }";

    given()
        .contentType(ContentType.JSON)
        .body(requestBody)
        .when()
        .post("/api/v1/messages")
        .then()
        .statusCode(HttpStatus.CREATED.value())
        .body("id", notNullValue())
        .body("topic", equalTo("Test Topic"))
        .body("message", equalTo("Test Message"));
  }

  @Test
  void testGetMessages() {
    given()
        .when()
        .get("/api/v1/messages")
        .then()
        .statusCode(HttpStatus.OK.value())
        .body("$", hasSize(greaterThanOrEqualTo(0))); // Check if the response has messages
  }

  @Test
  void testUpdateMessage() {
    String updatedRequestBody = "{ \"topic\": \"Updated Topic\", \"message\": \"Updated Message\" }";

    given()
        .contentType(ContentType.JSON)
        .body(updatedRequestBody)
        .when()
        .put("/api/v1/messages/1")
        .then()
        .statusCode(HttpStatus.NO_CONTENT.value());
  }

  @Test
  void testDeleteMessage() {
    given()
        .when()
        .delete("/api/v1/messages/1")
        .then()
        .statusCode(HttpStatus.NO_CONTENT.value());
  }

}