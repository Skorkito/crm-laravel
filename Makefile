# Makefile for CRM Laravel Docker Environment

.PHONY: help build up down restart logs shell mysql redis clean

# Default target
help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## Build all containers
	docker-compose build --no-cache

up: ## Start all services
	docker-compose up -d

down: ## Stop all services
	docker-compose down

restart: ## Restart all services
	docker-compose restart

logs: ## Show logs from all services
	docker-compose logs -f

logs-app: ## Show logs from app container
	docker-compose logs -f app

logs-mysql: ## Show logs from MySQL container
	docker-compose logs -f mysql

logs-redis: ## Show logs from Redis container
	docker-compose logs -f redis

shell: ## Access app container shell
	docker-compose exec app sh

mysql: ## Access MySQL shell
	docker-compose exec mysql mysql -u user_project_manager -p project_manager

redis: ## Access Redis CLI
	docker-compose exec redis redis-cli

status: ## Show container status
	docker-compose ps

clean: ## Clean up containers, networks, and volumes
	docker-compose down -v --remove-orphans
	docker system prune -f

fresh: ## Fresh install - rebuild everything
	make clean
	make build
	make up

install: ## Install dependencies in container
	docker-compose exec app composer install
	docker-compose exec app npm install

migrate: ## Run database migrations
	docker-compose exec app php artisan migrate

migrate-fresh: ## Fresh migration with seeding
	docker-compose exec app php artisan migrate:fresh --seed

cache-clear: ## Clear all caches
	docker-compose exec app php artisan cache:clear
	docker-compose exec app php artisan config:clear
	docker-compose exec app php artisan route:clear
	docker-compose exec app php artisan view:clear

optimize: ## Optimize application
	docker-compose exec app php artisan config:cache
	docker-compose exec app php artisan route:cache
	docker-compose exec app php artisan view:cache

test: ## Run tests
	docker-compose exec app php artisan test
