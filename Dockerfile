# Use the official Node.js image as the base
ARG APP_TAG
FROM node:20.16.0

# Install NestJS CLI globally
RUN npm install -g @nestjs/cli

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Argument to set the NODE_ENV
ARG NODE_ENV
ENV NODE_ENV=$NODE_ENV
RUN echo "NODE_ENV: $NODE_ENV"

# Install dependencies based on environment
RUN case "$NODE_ENV" in \
  "development") \
  npm install ;; \
  "production") \
  npm install ;; \
  *) \
  echo "Unknown NODE_ENV: $NODE_ENV" && exit 1 ;; \
  esac

# Copy the rest of the application files to the working directory
COPY . .

# Set the enviroment variable based on environment
RUN case "$NODE_ENV" in \
  "development") \
  npm run setenv:dev ;; \
  "production") \
  npm run setenv:prod ;; \
  *) \
  echo "Unknown NODE_ENV: $NODE_ENV" && exit 1 ;; \
  esac

# Build the application in production
RUN case "$NODE_ENV" in \
  "production") \
  npm run build ;; \
  "development") \
  echo "Skipping build for development environment" ;; \
  *) \
  echo "Unknown NODE_ENV: $NODE_ENV" && exit 1 ;; \
  esac

# Copy wait-for-it script
COPY docker/wait-for-it.sh /usr/local/bin/wait-for-it.sh
RUN chmod +x /usr/local/bin/wait-for-it.sh

# Copy the unified entrypoint script
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose the port the application will run on
EXPOSE 3000

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 CMD curl --fail http://localhost:3000 || exit 1

# Argumnet to set the DB_PORT and DB_HOST
ARG DB_PORT
ARG DB_HOST
ENV DB_PORT=$DB_PORT
ENV DB_HOST=$DB_HOST

# Start the application using the entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]