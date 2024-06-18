# Use the official Dart image as a parent image
FROM dart:stable AS build

# Set the working directory
WORKDIR /app

# Copy the pubspec files and get the dependencies
COPY pubspec.* ./
RUN dart pub get

# Copy the entire project directory to the Docker container
COPY . .

# Build the Flutter web application
RUN flutter build web

# Use a lightweight web server image to serve the Flutter web app
FROM nginx:alpine

# Copy the build output from the build stage to the web server's root directory
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Run the web server
CMD ["nginx", "-g", "daemon off;"]
