# Variables
COMPOSE_FILE := docker-compose.yml
DOCKER_COMPOSE := docker-compose -f $(COMPOSE_FILE)

# Couleurs pour les messages
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

# Cibles par défaut
.DEFAULT_GOAL := help

# Aide
help:
	@echo "Usage:"
	@echo "  make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  build [SERVICE]       - Construit tous les conteneurs ou un service spécifique"
	@echo "  up [SERVICE]          - Démarre tous les conteneurs ou un service spécifique"
	@echo "  up-fg [SERVICE]       - Démarre tous les conteneurs ou un service spécifique en avant-plan (avec logs)"
	@echo "  down                  - Arrête et supprime tous les conteneurs"
	@echo "  restart [SERVICE]     - Redémarre tous les conteneurs ou un service spécifique"
	@echo "  logs [SERVICE]        - Affiche les logs de tous les conteneurs ou d'un service spécifique"
	@echo "  ps                    - Liste tous les conteneurs"
	@echo "  clean                 - Nettoie tous les conteneurs, images et volumes non utilisés"
	@echo "  nginx-reload          - Recharge la configuration de Nginx"
	@echo "  rebuild [SERVICE]     - Reconstruit et redémarre tous les conteneurs ou un service spécifique"
	@echo "  rebuild-fg [SERVICE]  - Reconstruit et redémarre tous les conteneurs ou un service spécifique en avant-plan"

# Construire les conteneurs
build:
ifdef SERVICE
	@echo "$(GREEN)Construction du service $(SERVICE)...$(NC)"
	$(DOCKER_COMPOSE) build $(SERVICE)
else
	@echo "$(GREEN)Construction de tous les services...$(NC)"
	$(DOCKER_COMPOSE) build
endif

# Démarrer les conteneurs
up:
ifdef SERVICE
	@echo "$(GREEN)Démarrage du service $(SERVICE)...$(NC)"
	$(DOCKER_COMPOSE) up -d $(SERVICE)
else
	@echo "$(GREEN)Démarrage de tous les services...$(NC)"
	$(DOCKER_COMPOSE) up -d
endif

# Démarrer les conteneurs en avant-plan (avec logs)
up-fg:
ifdef SERVICE
	@echo "$(GREEN)Démarrage du service $(SERVICE) en avant-plan...$(NC)"
	$(DOCKER_COMPOSE) up $(SERVICE)
else
	@echo "$(GREEN)Démarrage de tous les services en avant-plan...$(NC)"
	$(DOCKER_COMPOSE) up
endif

# Arrêter et supprimer tous les conteneurs
down:
	@echo "$(RED)Arrêt et suppression des conteneurs...$(NC)"
	$(DOCKER_COMPOSE) down

# Redémarrer les conteneurs
restart:
ifdef SERVICE
	@echo "$(GREEN)Redémarrage du service $(SERVICE)...$(NC)"
	$(DOCKER_COMPOSE) restart $(SERVICE)
else
	@echo "$(GREEN)Redémarrage de tous les services...$(NC)"
	$(DOCKER_COMPOSE) restart
endif

# Afficher les logs
logs:
ifdef SERVICE
	@echo "$(GREEN)Affichage des logs du service $(SERVICE)...$(NC)"
	$(DOCKER_COMPOSE) logs -f $(SERVICE)
else
	@echo "$(GREEN)Affichage des logs de tous les services...$(NC)"
	$(DOCKER_COMPOSE) logs -f
endif

# Lister les conteneurs
ps:
	@echo "$(GREEN)Liste des conteneurs:$(NC)"
	$(DOCKER_COMPOSE) ps

# Nettoyer les ressources Docker non utilisées
clean:
	@echo "$(RED)Nettoyage des ressources Docker non utilisées...$(NC)"
	docker system prune -af --volumes

# Recharger la configuration de Nginx
nginx-reload:
	@echo "$(GREEN)Rechargement de la configuration Nginx...$(NC)"
	$(DOCKER_COMPOSE) exec nginx nginx -s reload

# Reconstruire et redémarrer les conteneurs
rebuild:
ifdef SERVICE
	@echo "$(YELLOW)Reconstruction et redémarrage du service $(SERVICE)...$(NC)"
	$(DOCKER_COMPOSE) up -d --build $(SERVICE)
else
	@echo "$(YELLOW)Reconstruction et redémarrage de tous les services...$(NC)"
	$(DOCKER_COMPOSE) up -d --build
endif

# Reconstruire et redémarrer les conteneurs en avant-plan
rebuild-fg:
ifdef SERVICE
	@echo "$(YELLOW)Reconstruction et redémarrage du service $(SERVICE) en avant-plan...$(NC)"
	$(DOCKER_COMPOSE) up --build $(SERVICE)
else
	@echo "$(YELLOW)Reconstruction et redémarrage de tous les services en avant-plan...$(NC)"
	$(DOCKER_COMPOSE) up --build
endif

.PHONY: help build up up-fg down restart logs ps clean nginx-reload rebuild rebuild-fg