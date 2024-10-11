import { Routes } from '@angular/router';
import { MessageListComponent } from './components/message-list/message-list.component';

export const routes: Routes = [
  { path: '', redirectTo: '/messages', pathMatch: 'full' }, // Default route
  { path: 'messages', component: MessageListComponent }, // Messages list route
  // Add more routes as needed
];