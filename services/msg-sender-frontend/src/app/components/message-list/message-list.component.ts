import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MessageService } from '../../services/message.service';
import { Message } from '../../models/message';

@Component({
  selector: 'app-message-list',
  standalone: true,
  imports: [CommonModule],  // Import CommonModule here
  templateUrl: './message-list.component.html',
  styleUrls: ['./message-list.component.scss']
})
export class MessageListComponent implements OnInit {
  messages: Message[] = [];

  constructor(private messageService: MessageService) { }

  ngOnInit(): void {
    console.log('ngOnInit: Initializing MessageListComponent');
    this.getMessages();
  }

  getMessages(): void {
    console.log('getMessages: Fetching messages from the server...');
    this.messageService.getMessages().subscribe({
      next: (data) => {
        console.log('getMessages: Successfully fetched messages', data); // Log the response data
        this.messages = data;
      },
      error: (error) => {
        console.error('getMessages: Error fetching messages', error); // Log any errors
      },
      complete: () => {
        console.log('getMessages: Message fetching completed');
      }
    });
  }

  editMessage(id: number): void {
    console.log(`editMessage: Editing message with ID ${id}`);
    // Implement navigation or other logic to edit the message
  }

  deleteMessage(id: number): void {
    console.log(`deleteMessage: Deleting message with ID ${id}`);
    this.messageService.deleteMessage(id).subscribe({
      next: () => {
        console.log(`deleteMessage: Message with ID ${id} deleted successfully`);
        this.messages = this.messages.filter(m => m.id !== id);
      },
      error: (error) => {
        console.error(`deleteMessage: Error deleting message with ID ${id}`, error); // Log any errors
      },
      complete: () => {
        console.log(`deleteMessage: Deletion process completed`);
      }
    });
  }
}