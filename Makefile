PHONY: up down build sync logs simulate

up:
	docker compose up --build -d

down:
	docker compose down

logs:
	docker compose logs -f

sync:
	git submodule update --remote --merge

simulate:
	docker compose run --rm telemetry-simulator