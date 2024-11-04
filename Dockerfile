# Use a simple web server like Nginx
FROM nginx:alpine

# Copy the web build files to the Nginx directory
COPY build/web /usr/share/nginx/html

# Expose the port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
