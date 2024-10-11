import { Component, OnInit } from '@angular/core';
import { CommonModule, formatDate } from '@angular/common';
import { FormsModule } from '@angular/forms';  // Import FormsModule for two-way binding
import { MessageService } from '../../services/message.service';
import { Message } from '../../models/message';

@Component({
  selector: 'app-message-list',
  standalone: true,
  imports: [CommonModule, FormsModule],  // Import FormsModule here
  templateUrl: './message-list.component.html',
  styleUrls: ['./message-list.component.scss']
})
export class MessageListComponent implements OnInit {
  messages: Message[] = [];
  expandedMessageId: number | null = null;
  isNewMessageFormVisible = false;
  isEditMode = false;  // To track if we're in edit mode
  editingMessageId: number | null = null;  // Store the ID of the message being edited
  newMessageTopic = '';
  newMessageContent = '';

  constructor(private messageService: MessageService) { }

  ngOnInit(): void {
    this.getMessages();
  }

  getMessages(): void {
    this.messageService.getMessages().subscribe({
      next: (data) => this.messages = data,
      error: (error) => console.error('Error fetching messages', error),
    });
  }

  toggleMessageDetails(id: number): void {
    this.expandedMessageId = this.expandedMessageId === id ? null : id;
  }

  deleteMessage(id: number): void {
    this.messageService.deleteMessage(id).subscribe(() => {
      this.messages = this.messages.filter(m => m.id !== id);
      if (this.expandedMessageId === id) {
        this.expandedMessageId = null;  // Reset expanded message if it's deleted
      }
    });
  }

  deleteAllMessages(): void {
    if (confirm('Are you sure you want to delete all messages?')) {
      this.messages.forEach(message => {
        this.deleteMessage(message.id);
      });
    }
  }

  // Show the form for creating a new message
  showNewMessageForm(): void {
    this.isEditMode = false;  // Set to false as we're creating a new message
    this.isNewMessageFormVisible = true;
    this.newMessageTopic = '';  // Clear the form
    this.newMessageContent = '';
  }

  // Show the form for editing a message
  editMessage(message: Message): void {
    this.isEditMode = true;  // Set to true as we're editing an existing message
    this.editingMessageId = message.id;  // Store the ID of the message being edited
    this.newMessageTopic = message.topic;  // Pre-fill the form with the current message data
    this.newMessageContent = message.message;
    this.isNewMessageFormVisible = true;
  }

  closeNewMessageForm(): void {
    this.isNewMessageFormVisible = false;
    this.newMessageTopic = '';
    this.newMessageContent = '';
  }

  saveNewMessage(): void {
    const currentDate = new Date().toISOString(); // Current date in ISO 8601 format
  
    if (this.isEditMode && this.editingMessageId !== null) {
      // Update the existing message
      const originalMessage = this.messages.find(m => m.id === this.editingMessageId);
      const updatedMessage: Message = {
        id: this.editingMessageId,
        topic: this.newMessageTopic,
        message: this.newMessageContent,
        // Retain the original creation date if available, otherwise set it to ISO 8601 format
        dateCreated: originalMessage ? new Date(originalMessage.dateCreated).toISOString() : currentDate,
        // Set the updated date to the current ISO 8601 format
        dateUpdated: currentDate,
      };
  
      this.messageService.updateMessage(this.editingMessageId, updatedMessage).subscribe({
        next: () => {
          // Update the message in the list
          const index = this.messages.findIndex(m => m.id === this.editingMessageId);
          if (index !== -1) {
            this.messages[index] = updatedMessage;
          }
          this.closeNewMessageForm(); // Close the form after saving
        },
        error: (error) => {
          console.error('Error updating the message', error);
        }
      });
    } else {
      // Create a new message
      const newMessage: Message = {
        id: 0,  // Temporary, backend will assign a real ID
        topic: this.newMessageTopic,
        message: this.newMessageContent,
        // Set both created and updated dates to the current ISO 8601 format
        dateCreated: currentDate,
        dateUpdated: currentDate,
      };
  
      this.messageService.createMessage(newMessage).subscribe({
        next: (savedMessage) => {
          this.messages.push(savedMessage);  // Add the saved message to the list
          this.closeNewMessageForm(); // Close the form after saving
        },
        error: (error) => {
          console.error('Error creating new message', error);
        }
      });
    }
  }
}