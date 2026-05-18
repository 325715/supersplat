# Stage 1: Build the application
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
# Using npm install as it is generally more robust in local docker builds,
# but npm ci is also fine if package-lock.json is perfectly in sync.
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the production files
RUN npm run build

# Stage 2: Serve the application with a lightweight web server
FROM nginx:alpine

# Copy the built files from the dist directory of the builder stage
# to Nginx's default html serving directory
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
