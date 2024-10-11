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
  expandedIndex: number | null = null; // Track the currently expanded row

  constructor(private messageService: MessageService) { }

  ngOnInit(): void {
    this.getMessages();
  }

  getMessages(): void {
    this.messageService.getMessages().subscribe({
      next: (data) => {
        this.messages = data;
      },
      error: (error) => {
        console.error('Error fetching messages', error);
      }
    });
  }

  toggleExpand(index: number): void {
    if (this.expandedIndex === index) {
      // Collapse if the same row is clicked again
      this.expandedIndex = null;
    } else {
      // Expand the clicked row and collapse others
      this.expandedIndex = index;
    }
  }

  editMessage(id: number): void {
    console.log(`Editing message with ID ${id}`);
    // Implement navigation or other logic to edit the message
  }

  deleteMessage(id: number): void {
    this.messageService.deleteMessage(id).subscribe({
      next: () => {
        this.messages = this.messages.filter(m => m.id !== id);
      },
      error: (error) => {
        console.error('Error deleting message', error);
      }
    });
  }
}