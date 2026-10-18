# ParaBank QA — Projet de test et d'assurance qualité

Projet personnel de test logiciel sur **ParaBank**, l'application bancaire de démonstration publiée par Parasoft.
L'objectif est d'appliquer une démarche de test complète et professionnelle, alignée sur l'**ISTQB CTFL v4.0** :
analyse, planification, conception, exécution, automatisation, intégration continue et clôture des tests.

## Système sous test

| Élément | Valeur |
| --- | --- |
| Application | ParaBank (Parasoft) — banque en ligne de démonstration |
| Version testée | Image Docker `parasoft/parabank` (digest figé, voir `docs/environnement.md`) |
| Accès local | `http://localhost:8080/parabank/index.htm` |
| Code source | https://github.com/parasoft/parabank |

## Périmètre

Parcours bancaires critiques : connexion, inscription, vue des comptes, ouverture de compte, virements,
historique et recherche de transactions, paiement de factures, demande de prêt.
Le périmètre détaillé et les éléments hors périmètre sont décrits dans le plan de test (`docs/test-plan/`).

## Stack prévue

| Niveau de test | Outils |
| --- | --- |
| Gestion des tests et des défauts | Jira + Xray |
| Tests unitaires | Java 17, JUnit 5, Mockito, JaCoCo |
| Tests d'API | Postman, Newman |
| Tests UI de bout en bout | Selenium WebDriver 4, JUnit 5, Page Object Model |
| Intégration continue | GitHub Actions (pull requests), Jenkins (campagne de non-régression) |
| Environnement | Docker, Docker Compose |

## Structure du dépôt

```text
parabank-qa/
├── CLAUDE.md                  Règles pour Claude Code (assistant de développement)
├── README.md
├── .gitignore
├── .gitattributes             Fins de ligne LF pour les scripts shell
├── docker-compose.yml         Lancement de ParaBank en local (image figée par digest)
├── scripts/                   wait-for-parabank et reset-db (bash + PowerShell)
├── .github/
│   └── pull_request_template.md
└── docs/
    ├── environnement.md     Versions des outils et de l'application testée
    ├── conventions.md       Règles du projet : branches, commits, identifiants, défauts
    ├── journal.md           Journal de bord
    ├── adr/                 Décisions d'architecture
    ├── exploration/         Cartographie et sessions exploratoires
    └── test-plan/           Plan de test
```

## Prérequis

Voir `docs/environnement.md`.

## Lancement

```bash
docker compose up -d                 # démarre ParaBank
./scripts/wait-for-parabank.sh       # attend un HTTP 200 (timeout 120 s)
./scripts/reset-db.sh                # remet la base dans l'état initial (Clean + Initialize)
docker compose down                  # arrête ParaBank
```

Sous Windows PowerShell : `.\scripts\wait-for-parabank.ps1` et `.\scripts\reset-db.ps1`.

Application : `http://localhost:8080/parabank/index.htm`
Administration (initialiser / nettoyer la base) : `http://localhost:8080/parabank/admin.htm`

Pourquoi une instance locale plutôt que l'instance publique : voir `docs/adr/ADR-0001-instance-locale-docker.md`.

## Statut

| Étape | Contenu | Statut |
| --- | --- | --- |
| 0 | Préparation du poste de travail | ✅ Terminé |
| 1 | Dépôt GitHub et projet Jira | ✅ Terminé |
| 2 | Lancement et exploration de ParaBank | 🔄 En cours |
| 3 | Base de test (exigences) | ⏳ À faire |
| 4 | Analyse des risques | ⏳ À faire |
| 5 | Plan de test | ⏳ À faire |
| 6 | Conception des cas de test | ⏳ À faire |
| 7 | Exécution manuelle et rapports de défauts | ⏳ À faire |
| 8 | Automatisation UI (Selenium) | ⏳ À faire |
| 9 | Tests d'API (Postman, Newman) | ⏳ À faire |
| 10 | Tests unitaires et couverture (JUnit 5, Mockito, JaCoCo) | ⏳ À faire |
| 11 | Intégration continue (GitHub Actions) | ⏳ À faire |
| 12 | Campagne de non-régression (Jenkins) | ⏳ À faire |
| 13 | Rapport de clôture des tests | ⏳ À faire |

## Conventions

Les règles de travail (branches, commits, identifiants, gestion des défauts) sont décrites dans `docs/conventions.md`.

## Auteur

Abdelkhaleq Samili — Ingénieur QA & Test Automation, ISTQB CTFL
