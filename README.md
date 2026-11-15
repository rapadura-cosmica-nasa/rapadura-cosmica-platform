<a id="top"></a>
<div align="center">

# 🚀 Rapadura Cósmica — Platform Orchestrator (`rapadura-cosmica-platform`)

**Central Multi-Service Orchestration, Git Submodules & Infrastructure Hub — Team Rapadura Cósmica**

[![Docker Compose](https://img.shields.io/badge/Docker_Compose-v2+-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://docs.docker.com/compose/)
[![Java](https://img.shields.io/badge/Java-17+_Spring_Boot-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)](https://spring.io/projects/spring-boot)
[![Python](https://img.shields.io/badge/Python-3.12+_Flask-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://flask.palletsprojects.com/)
[![Nginx](https://img.shields.io/badge/Frontend-HTML/JS_Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)](https://www.nginx.com/)

[🇺🇸 English](#english-docs) • [🇧🇷 Português](#portugues-docs)

</div>

---

<a id="english-docs"></a>
## 🇺🇸 English

### Overview

This repository is the **Central Platform Orchestrator** (`rapadura-cosmica-platform`) developed by **Team Rapadura Cósmica** for the NASA Space Apps Challenge.

It unifies, coordinates, and deploys the entire distributed aerospace biometric and real-time telemetry monitoring platform using **Git Submodules**, **Docker Compose** isolated networking, and **GNU Make** automation.

### Platform Architecture & Data Flow

All services run inside isolated containers connected via the internal `rapadura-net` bridge network, communicating through Docker's internal DNS:

```text
+--------------------------+       POST /api/telemetry        +-----------------------------+
|  telemetry-simulator     | -------------------------------> |    astronaut-health-api     |
|  (Interactive Python CLI)|                                  |  (Java / Spring Boot :8080) |
+--------------------------+                                  +--------------+--------------+
                                                                             |
                                                            POST /api/v1/analyze
                                                                             |
                                                                             v
+--------------------------+       GET /api/telemetry         +-----------------------------+
|    mission-control-ui    | <------------------------------- |     telemetry-analytics     |
|     (Nginx / Web :3000)  |         (via Java API)           |     (Python / Flask :5000)  |
+--------------------------+                                  +-----------------------------+
```

### Repository Structure & Submodules (`services/`)

```text
rapadura-cosmica-platform/
├── services/
│   ├── astronaut-health-api/   # Submodule: Core REST Gateway, JPA persistence & H2 Database
│   ├── telemetry-analytics/    # Submodule: Clinical risk engine, action protocols & CLI simulator
│   └── mission-control-ui/     # Submodule: Real-time Mission Control web dashboard
├── docker-compose.yml          # Multi-container orchestration, healthchecks & bridge network
├── Makefile                    # Streamlined commands (up, down, logs, sync, simulate)
├── .gitmodules                 # Git submodule repository mappings
└── README.md
```

| Submodule | Stack | Host Port | Responsibility |
| :--- | :--- | :--- | :--- |
| **`services/astronaut-health-api`** | Java 17+, Spring Boot, Spring Data JPA, H2 | `8080` | Central REST gateway, analytics orchestration, and relational database persistence. |
| **`services/telemetry-analytics`** | Python 3.12+, Flask, Marshmallow, Pytest | `5000` | Clinical vital-sign rules engine ($\text{HR}$, $\text{SpO}_2$, radiation, sleep), risk triage (`NOMINAL`, `WARNING`, `CRITICAL`), and interactive simulator. |
| **`services/mission-control-ui`** | HTML5, CSS3, JavaScript, Nginx Alpine | `3000` | Real-time Mission Control visual dashboard for live astronaut health monitoring. |

### Prerequisites

* **Git** (with submodule support)
* **Docker** and **Docker Compose** (v2+)
  * *Linux:* Docker Engine + `docker-compose-plugin`
  * *Windows / macOS:* Docker Desktop running (on Windows, ensure **WSL 2** and **Virtual Machine Platform** are enabled)
* **GNU Make** *(optional — every `make` target has a direct `docker compose` equivalent)*

### Getting Started

#### 1. Clone the repository with submodules
Because the microservices are linked as **Git Submodules**, clone using `--recurse-submodules`:

```bash
git clone --recurse-submodules https://github.com/rapadura-cosmica-nasa/rapadura-cosmica-platform.git
cd rapadura-cosmica-platform
```

> **Cloned without `--recurse-submodules`?** Run the following command at the project root to pull all service source code:
> ```bash
> git submodule update --init --recursive
> ```

#### 2. Build images and start the infrastructure

* **Using Make (Linux / macOS / Windows with Make):**
  ```bash
  make up
  ```
* **Using Docker Compose directly (Universal / PowerShell):**
  ```bash
  docker compose up --build -d
  ```

> ⏳ Wait approximately **20 seconds** after the containers start for the Java API (`rapadura-api`) to finish initializing Spring Boot and the H2 database.

#### 3. Start the Interactive Telemetry Simulator
The simulator runs on demand (`profile: simulator`) attached to your terminal so you can select live mission scenarios:

* **Using Make:**
  ```bash
  make simulate
  ```
* **Using Docker Compose directly:**
  ```bash
  docker compose run --rm telemetry-simulator
  ```

Select a scenario from the interactive terminal menu:
* **`[1]` Nominal Mission:** Stable vital signs and low solar radiation exposure.
* **`[2]` Critical Alert:** Acute cardiorespiratory stress, hypoxia, and high radiation dose.
* **`[3]` Random:** Continuous variation across nominal, warning, and critical states *(default)*.

Press `Ctrl + C` at any time to stop the simulator cleanly.

### Service Endpoints & Credentials

| Service | URL | Credentials / Notes |
| :--- | :--- | :--- |
| **Mission Control UI (Dashboard)** | `http://localhost:3000` | Main live telemetry monitoring interface |
| **Telemetry REST API (GET/POST)** | `http://localhost:8080/api/telemetry` | Java Spring Boot API endpoints |
| **H2 Database Console** | `http://localhost:8080/h2-console` | **JDBC URL:** `jdbc:h2:mem:astronautdb` \| **User:** `sa` \| **Password:** *(empty)* |
| **Analytics Healthcheck (Flask)** | `http://localhost:5000/api/v1/health` | Verifies Python clinical engine availability |

### Management Commands Reference

| Action | `make` Command | `docker compose` / `git` Equivalent |
| :--- | :--- | :--- |
| Build and start all services | `make up` | `docker compose up --build -d` |
| Launch interactive simulator | `make simulate` | `docker compose run --rm telemetry-simulator` |
| Stream live container logs | `make logs` | `docker compose logs -f` |
| Sync remote submodules | `make sync` | `git submodule update --remote --merge` |
| Stop and remove containers | `make down` | `docker compose down` |

---

<a id="portugues-docs"></a>
## 🇧🇷 Português

[⬆️ Back to top / Voltar ao topo](#top)

### Visão Geral

Este repositório é o **Orquestrador Central da Plataforma** (`rapadura-cosmica-platform`) desenvolvido pela equipe **Rapadura Cósmica** para o NASA Space Apps Challenge.

Ele unifica, coordena e implanta toda a plataforma distribuída de monitoramento biométrico e telemetria espacial em tempo real utilizando **Git Submodules**, rede isolada via **Docker Compose** e automação com **GNU Make**.

### Arquitetura da Plataforma e Fluxo de Dados

Todos os serviços executam em contêineres isolados dentro da rede interna `rapadura-net` (*bridge network*), comunicando-se via DNS interno do Docker:

```text
+--------------------------+       POST /api/telemetry        +-----------------------------+
|  telemetry-simulator     | -------------------------------> |    astronaut-health-api     |
|  (Python CLI Interativo) |                                  |  (Java / Spring Boot :8080) |
+--------------------------+                                  +--------------+--------------+
                                                                             |
                                                            POST /api/v1/analyze
                                                                             |
                                                                             v
+--------------------------+       GET /api/telemetry         +-----------------------------+
|    mission-control-ui    | <------------------------------- |     telemetry-analytics     |
|     (Nginx / Web :3000)  |         (via Java API)           |     (Python / Flask :5000)  |
+--------------------------+                                  +-----------------------------+
```

### Estrutura do Repositório e Submódulos (`services/`)

```text
rapadura-cosmica-platform/
├── services/
│   ├── astronaut-health-api/   # Submódulo: Gateway REST central, persistência JPA e banco H2
│   ├── telemetry-analytics/    # Submódulo: Motor de risco clínico, protocolos de ação e simulador CLI
│   └── mission-control-ui/     # Submódulo: Dashboard web em tempo real do Centro de Controle
├── docker-compose.yml          # Orquestração multi-contêiner, healthchecks e rede bridge
├── Makefile                    # Comandos automatizados (up, down, logs, sync, simulate)
├── .gitmodules                 # Mapeamento dos repositórios de submódulos Git
└── README.md
```

| Submódulo | Stack | Porta Host | Responsabilidade |
| :--- | :--- | :--- | :--- |
| **`services/astronaut-health-api`** | Java 17+, Spring Boot, Spring Data JPA, H2 | `8080` | Gateway REST central, orquestração das chamadas de análise e persistência em banco relacional. |
| **`services/telemetry-analytics`** | Python 3.12+, Flask, Marshmallow, Pytest | `5000` | Motor analítico de sinais vitais ($\text{FC}$, $\text{SpO}_2$, radiação, sono), classificação de risco (`NOMINAL`, `WARNING`, `CRITICAL`) e simulador interativo. |
| **`services/mission-control-ui`** | HTML5, CSS3, JavaScript, Nginx Alpine | `3000` | Painel visual do Centro de Controle da Missão (*Mission Control*) para acompanhamento ao vivo. |

### Pré-requisitos

* **Git** (com suporte a submódulos)
* **Docker** e **Docker Compose** (v2+)
  * *Linux:* Docker Engine + `docker-compose-plugin`
  * *Windows / macOS:* Docker Desktop em execução (no Windows, com **WSL 2** e **Plataforma de Máquina Virtual** habilitados)
* **GNU Make** *(opcional — todos os comandos possuem equivalente direto via `docker compose`)*

### Como Executar o Projeto

#### 1. Clonar o repositório com os submódulos
Como os microsserviços estão vinculados como **Git Submodules**, utilize a flag `--recurse-submodules`:

```bash
git clone --recurse-submodules https://github.com/rapadura-cosmica-nasa/rapadura-cosmica-platform.git
cd rapadura-cosmica-platform
```

> **Clonou sem `--recurse-submodules`?** Execute o comando abaixo na raiz do projeto para baixar o código-fonte de todos os serviços:
> ```bash
> git submodule update --init --recursive
> ```

#### 2. Construir as imagens e subir a infraestrutura

* **Usando Make (Linux / macOS / Windows com Make):**
  ```bash
  make up
  ```
* **Usando Docker Compose diretamente (Universal / PowerShell):**
  ```bash
  docker compose up --build -d
  ```

> ⏳ Aguarde cerca de **20 segundos** após o comando concluir para que a API Java (`rapadura-api`) finalize a inicialização do Spring Boot e do banco H2.

#### 3. Iniciar o Simulador Interativo de Telemetria
O simulador roda sob demanda (`profile: simulator`) conectado ao terminal para que você escolha o cenário da missão em tempo real:

* **Usando Make:**
  ```bash
  make simulate
  ```
* **Usando Docker Compose diretamente:**
  ```bash
  docker compose run --rm telemetry-simulator
  ```

No menu interativo exibido no terminal, selecione o cenário desejado:
* **`[1]` Missão Nominal:** Sinais vitais estáveis e baixa exposição à radiação.
* **`[2]` Alerta Crítico:** Estresse cardiorrespiratório agudo, hipóxia e radiação elevada.
* **`[3]` Aleatório:** Variação contínua entre estados normais, de alerta e críticos *(padrão)*.

Para encerrar o simulador a qualquer momento, pressione `Ctrl + C`.

### Acessos e Endpoints

| Serviço | URL | Credenciais / Observações |
| :--- | :--- | :--- |
| **Mission Control UI (Dashboard)** | `http://localhost:3000` | Interface principal de monitoramento ao vivo |
| **API de Telemetria (GET/POST)** | `http://localhost:8080/api/telemetry` | Endpoints REST da API Java |
| **Console do Banco H2** | `http://localhost:8080/h2-console` | **JDBC URL:** `jdbc:h2:mem:astronautdb` \| **User:** `sa` \| **Password:** *(vazio)* |
| **Healthcheck Analytics (Flask)** | `http://localhost:5000/api/v1/health` | Verifica disponibilidade do motor analítico Python |

### Comandos Úteis de Gerenciamento

| Ação | Comando `make` | Equivalente `docker compose` / `git` |
| :--- | :--- | :--- |
| Subir e construir contêineres | `make up` | `docker compose up --build -d` |
| Abrir simulador interativo | `make simulate` | `docker compose run --rm telemetry-simulator` |
| Acompanhar logs em tempo real | `make logs` | `docker compose logs -f` |
| Atualizar submódulos remotos | `make sync` | `git submodule update --remote --merge` |
| Parar e remover contêineres | `make down` | `docker compose down` |
