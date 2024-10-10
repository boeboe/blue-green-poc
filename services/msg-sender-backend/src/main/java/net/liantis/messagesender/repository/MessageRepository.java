package net.liantis.messagesender.repository;

import net.liantis.messagesender.model.Message;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicInteger;

@Repository
public class MessageRepository {
  private final List<Message> messages = new ArrayList<>();
  private final AtomicInteger counter = new AtomicInteger(1);

  public List<Message> findAll() {
    return messages;
  }

  public Optional<Message> findById(int id) {
    return messages.stream().filter(m -> m.getId() == id).findFirst();
  }

  public Message save(Message message) {
    message.setId(counter.getAndIncrement());
    message.setDateCreated(LocalDateTime.now()); // Set the creation date
    message.setDateUpdated(LocalDateTime.now()); // Set the initial update date
    messages.add(message);
    return message;
  }

  public void update(Message message) {
    messages.stream()
        .filter(m -> m.getId() == message.getId())
        .findFirst()
        .ifPresent(existingMessage -> {
          existingMessage.setTopic(message.getTopic());
          existingMessage.setMessage(message.getMessage());
          existingMessage.setDateUpdated(LocalDateTime.now()); // Update the update date
        });
  }

  public void delete(int id) {
    messages.removeIf(m -> m.getId() == id);
  }
}