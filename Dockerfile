# Stage 1: Install dependencies and build the application
ARG APP_TAG
FROM node:${APP_TAG} AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Temporarily set NODE_ENV to 'development' for installation of all dependencies
ARG NODE_ENV_TEMP=development
ENV NODE_ENV=$NODE_ENV_TEMP
RUN echo "Temporary NODE_ENV: $NODE_ENV"

# Install all dependencies (including devDependencies) using npm ci for consistency and speed
RUN npm ci

# Copy the rest of the application files to the working directory
COPY . .

# Set environment variables based on NODE_ENV
ARG NODE_ENV
ENV NODE_ENV=$NODE_ENV
RUN echo "NODE_ENV: $NODE_ENV"

# Set environment variables based on NODE_ENV
RUN case "$NODE_ENV" in \
  "development") \
  npm run setenv:dev ;; \
  "production") \
  npm run setenv:prod ;; \
  *) \
  echo "Unknown NODE_ENV: $NODE_ENV" && exit 1 ;; \
  esac

# Build the application if NODE_ENV is 'production'
RUN case "$NODE_ENV" in \
  "production") \
  npm run build ;; \
  "development") \
  echo "Skipping build for development environment" ;; \
  *) \
  echo "Unknown NODE_ENV: $NODE_ENV" && exit 1 ;; \
  esac

# Remove devDependencies after build if NODE_ENV is 'production'
RUN case "$NODE_ENV" in \
  "production") \
  npm prune --production ;; \
  "development") \
  echo "Skipping pruning for development environment" ;; \
  *) \
  echo "Unknown NODE_ENV: $NODE_ENV" && exit 1 ;; \
  esac

# Stage 2: Create the final image with only production dependencies
FROM node:${APP_TAG} AS final

# Set working directory
WORKDIR /app

# Copy only the necessary files from the build stage
COPY --from=build /app/package*.json ./
COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules

# Copy wait-for-it script
COPY docker/wait-for-it.sh /usr/local/bin/wait-for-it.sh
RUN chmod +x /usr/local/bin/wait-for-it.sh

# Copy the unified entrypoint script
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose the port the application will run on
EXPOSE 3000

# Argument to set the DB_PORT and DB_HOST
ARG DB_PORT
ARG DB_HOST
ENV DB_PORT=$DB_PORT
ENV DB_HOST=$DB_HOST

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 CMD curl --fail http://localhost:3000 || exit 1

# Start the application using the entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
