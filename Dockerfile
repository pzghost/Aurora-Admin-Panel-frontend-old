# Stage 1: Build the Node.js application
FROM node:lts-slim AS builder

# Set working directory
WORKDIR /app

# Set the NODE_OPTIONS environment variable
ENV NODE_OPTIONS=--openssl-legacy-provider

# Copy package.json and yarn.lock files (if available)
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install

# Copy the rest of your application code
COPY . .

# Build the application
RUN yarn build

# Stage 2: Setup the Nginx server
FROM nginx:1.20-alpine

# Set working directory
WORKDIR /usr/share/nginx/html

# Remove default nginx static assets
RUN rm -rf ./*

# Copy static assets from builder stage
COPY --from=builder /app/build /usr/share/nginx/html

# Optional: Copy your nginx configuration file
ADD nginx-prod.conf /etc/nginx/conf.d/default.conf
