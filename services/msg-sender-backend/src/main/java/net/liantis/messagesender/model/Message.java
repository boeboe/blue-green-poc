package net.liantis.messagesender.model;

public class Message {
  private int id;
  private String topic;
  private String message;

  public Message(int id, String topic, String message) {
    this.id = id;
    this.topic = topic;
    this.message = message;
  }

  // Getters and setters
  public int getId() {
    return id;
  }

  public void setId(int id) {
    this.id = id;
  }

  public String getTopic() {
    return topic;
  }

  public void setTopic(String topic) {
    this.topic = topic;
  }

  public String getMessage() {
    return message;
  }

  public void setMessage(String message) {
    this.message = message;
  }
}