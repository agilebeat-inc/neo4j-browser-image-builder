# -------- Stage 1: Build --------
FROM debian:stable-slim AS builder

# Install git
RUN apt-get update && apt-get install -y git curl sudo

# https://deb.nodesource.com/setup_16.x is a bash script that prepares for installing NodeJS
RUN curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash - && sudo apt-get install -y nodejs

RUN npm install -g yarn

# Set working directory
WORKDIR /app

# Clone the GitHub repository
RUN git clone -b default-user --single-branch https://github.com/agilebeat-inc/neo4j-browser.git .

RUN yarn install && yarn build

# -------- Stage 2: Serve with Koa --------
FROM node:24-slim

# Set working directory
WORKDIR /app

# Install Yarn and Koa
RUN npm install -g koa

# Copy only the dist folder from the builder stage
COPY --from=builder /app/dist ./dist

# Copy Koa server code
COPY server.js .

# Install Koa dependencies
RUN yarn add koa koa-static

# Expose port
EXPOSE 3000

# Start the Koa server
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
ENTRYPOINT ["/app/entrypoint.sh"]
