package net.liantis.messagesender.controller;

import net.liantis.messagesender.model.Message;
import net.liantis.messagesender.service.MessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/v1/messages")
public class MessageController {

  @Autowired
  private MessageService messageService;

  @GetMapping
  public List<Message> getAllMessages() {
    return messageService.getAllMessages();
  }

  @GetMapping("/{id}")
  public ResponseEntity<Message> getMessageById(@PathVariable int id) {
    Optional<Message> message = messageService.getMessageById(id);
    return message.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
  }

  @PostMapping
  public ResponseEntity<Message> createMessage(@RequestBody Message message) {
    Message createdMessage = messageService.createMessage(message);
    return new ResponseEntity<>(createdMessage, HttpStatus.CREATED);
  }

  @PutMapping("/{id}")
  public ResponseEntity<Void> updateMessage(@PathVariable int id, @RequestBody Message message) {
    message.setId(id);
    messageService.updateMessage(message);
    return ResponseEntity.noContent().build();
  }

  @DeleteMapping("/{id}")
  public ResponseEntity<Void> deleteMessage(@PathVariable int id) {
    messageService.deleteMessage(id);
    return ResponseEntity.noContent().build();
  }
}