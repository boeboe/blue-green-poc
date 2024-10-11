import { provideHttpClient } from '@angular/common/http';
import { ApplicationConfig, importProvidersFrom, provideZoneChangeDetection } from '@angular/core';
import { provideRouter } from '@angular/router';
import { CommonModule } from '@angular/common'; // Import CommonModule
import { routes } from './app.routes';

export const appConfig: ApplicationConfig = {
  providers: [
    provideHttpClient(), // Provides HTTP client
    provideRouter(routes), // Sets up routing
    provideZoneChangeDetection({ eventCoalescing: true }),
    importProvidersFrom(CommonModule) // Correct way to provide CommonModule
  ],
};