# Stage 1: Build Angular app
FROM node:18-alpine AS build
WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Angular app for production
RUN npm run build -- --configuration production

# Stage 2: Serve with Nginx
FROM nginx:alpine

# Rename default configuration file
RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.disabled

# Copy the Nginx configuration template
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Copy the contents of the 'browser' folder to the Nginx static file directory
COPY --from=build /app/dist/message-frontend/browser /usr/share/nginx/html

# Set the backend URL as an environment variable (optional, handled by docker-compose)
ENV BACKEND_URL=http://localhost:8080

# Copy the entrypoint script to handle environment variable substitution
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

# Expose port 80 to the outside world
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]