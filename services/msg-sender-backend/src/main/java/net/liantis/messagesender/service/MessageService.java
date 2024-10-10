package net.liantis.messagesender.service;

import net.liantis.messagesender.model.Message;
import net.liantis.messagesender.repository.MessageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class MessageService {

  @Autowired
  private MessageRepository messageRepository;

  public List<Message> getAllMessages() {
    return messageRepository.findAll();
  }

  public Optional<Message> getMessageById(int id) {
    return messageRepository.findById(id);
  }

  public Message createMessage(Message message) {
    return messageRepository.save(message);
  }

  public void updateMessage(Message message) {
    messageRepository.update(message);
  }

  public void deleteMessage(int id) {
    messageRepository.delete(id);
  }
}