# -------- Stage 1: Build --------
FROM debian:stable-slim AS builder

# Install git
RUN apt-get update && apt-get install -y git curl sudo

# https://deb.nodesource.com/setup_16.x is a bash script that prepares for installing NodeJS

# Set environment variables
ENV NODE_VERSION=16.20.2

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    xz-utils \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Download and install Node.js
RUN ARCH="$(dpkg --print-architecture)" && \
    case "${ARCH}" in \
      amd64) NODE_ARCH="x64";; \
      arm64) NODE_ARCH="arm64";; \
      armhf|armv7l) NODE_ARCH="armv7l";; \
      ppc64el) NODE_ARCH="ppc64le";; \
      *) echo "Unsupported architecture: ${ARCH}"; exit 1;; \
    esac && \
    curl -fsSL "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${NODE_ARCH}.tar.xz" -o node.tar.xz && \
    tar -xf node.tar.xz -C /usr/local --strip-components=1 && \
    rm node.tar.xz && \
    ln -s /usr/local/bin/node /usr/local/bin/nodejs


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
