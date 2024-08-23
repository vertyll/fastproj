# Variable definitions
DOCKER_COMPOSE = docker-compose
COMPOSE_FILE = docker-compose.yml
COMPOSE_FILE_OVERRIDE = docker-compose.override.yml
CONTAINER_NAME = fastproj

# Default targets
.PHONY: all build-dev build-prod up-dev up-prod down-dev down-prod start-dev start-prod stop-dev stop-prod restart-dev restart-prod logs-dev logs-prod ps-dev ps-prod exec-backend-dev exec-backend-prod exec-frontend-dev exec-frontend-prod exec-postgres-dev exec-postgres-prod prune shell

# Default target
all: build-dev up-dev

# Build containers for development
build-dev:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) -f $(COMPOSE_FILE_OVERRIDE) build

# Build containers for production
build-prod:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) build

# Start containers in detached mode for development
up-dev:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) -f $(COMPOSE_FILE_OVERRIDE) up -d

# Start containers in detached mode for production
up-prod:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) up -d

# Stop and remove all running containers for development
down-dev:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) -f $(COMPOSE_FILE_OVERRIDE) down

# Stop and remove all running containers for production
down-prod:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) down

# Start containers (if stopped) for development
start-dev:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) -f $(COMPOSE_FILE_OVERRIDE) start

# Start containers (if stopped) for production
start-prod:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) start

# Stop all running containers for development
stop-dev:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) -f $(COMPOSE_FILE_OVERRIDE) stop

# Stop all running containers for production
stop-prod:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) stop

# Restart containers for development
restart-dev: stop-dev start-dev

# Restart containers for production
restart-prod: stop-prod start-prod

# View logs for development
logs-dev:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) -f $(COMPOSE_FILE_OVERRIDE) logs -f

# View logs for production
logs-prod:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) logs -f

# List running containers for development
ps-dev:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) -f $(COMPOSE_FILE_OVERRIDE) ps

# List running containers for production
ps-prod:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) ps

# Prune Docker system
system-prune:
	docker system prune -f

# Prune Docker volumes
volume-prune:
	docker volume prune -f

# Prune Docker builder cache
builder-prune:
	docker builder prune -f

# Prune Docker images
image-prune:
	docker image prune -f

# Enter shell in the main container
shell:
	docker exec -it $(CONTAINER_NAME) /bin/sh

# Enter shell in the main container as root
shell-root:
	docker exec -it -u root $(CONTAINER_NAME) /bin/sh