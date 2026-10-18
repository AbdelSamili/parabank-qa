# Environnement de test

Ce document décrit l'environnement utilisé pour le projet. Il sert à rendre les résultats reproductibles
(ISTQB CTFL v4.0, section 1.4.3 : les exigences d'environnement de test font partie du testware) et alimente
la section « Environnement de test » du plan de test.

## Poste de travail

| Élément | Valeur |
| --- | --- |
| Système d'exploitation | *(ex. Windows 11 Pro 23H2)* |
| Processeur / RAM | *(ex. Intel i5, 16 Go)* |

## Outils

Collez ici la sortie exacte des commandes de vérification.

| Outil | Commande | Version |
| --- | --- | --- |
| Git | `git --version` | |
| Java (JDK) | `java -version` | *(doit être 17)* |
| Maven | `mvn -version` | |
| Docker | `docker --version` | |
| Node.js | `node -v` | |
| npm | `npm -v` | |
| IntelliJ IDEA | Help → About | |
| Postman | Settings → About | |
| Chrome | `chrome://version` | |
| Firefox | Aide → À propos | |

## Application testée

| Élément | Valeur |
| --- | --- |
| Application | ParaBank (Parasoft) |
| Image Docker | `parasoft/parabank` |
| Digest figé | `sha256:5343aebd0bd2dbcc26fd41903a4271fb9b2ff19436c712dd9041a43782459b0f` (relevé le 2026-10-18, = `latest` à cette date, index multi-architecture linux/amd64 + linux/arm64) |
| URL locale | `http://localhost:8080/parabank/index.htm` |
| Page d'administration | `http://localhost:8080/parabank/admin.htm` |
| Base de données | HyperSQL intégrée |
| Lancement | `docker compose up -d` (fichier `docker-compose.yml` à la racine) |

Commande pour relever le digest :

```bash
docker inspect --format "{{index .RepoDigests 0}}" parasoft/parabank
# parasoft/parabank@sha256:5343aebd0bd2dbcc26fd41903a4271fb9b2ff19436c712dd9041a43782459b0f
```

L'image est référencée par ce digest dans `docker-compose.yml` (et non plus par `latest`).

## Démarrage et réinitialisation

| Action | Linux / Git Bash | Windows PowerShell |
| --- | --- | --- |
| Attendre que ParaBank soit prêt (HTTP 200, timeout 120 s) | `./scripts/wait-for-parabank.sh` | `.\scripts\wait-for-parabank.ps1` |
| Remettre la base dans l'état initial | `./scripts/reset-db.sh` | `.\scripts\reset-db.ps1` |

Les deux scripts acceptent une URL de base en paramètre (ou la variable `PARABANK_URL`).
`reset-db` appelle `POST services/bank/cleanDB` puis `POST services/bank/initializeDB` : services et méthodes
vérifiés dans le WADL de l'instance locale (`services/bank?_wadl`), réponse `204 No Content`.

Comportements observés le 2026-10-18 qui expliquent ces choix :

- Sur un conteneur neuf, `index.htm` répond `302` vers `initializeDB.htm` tant que personne n'a suivi cette
  redirection (observé sur 2 démarrages). `wait-for-parabank` suit donc les redirections, comme un navigateur.
- L'image ne contient ni `wget` ni `curl` : le healthcheck de `docker-compose.yml` fait sa requête HTTP en bash.
  Il considère l'application « healthy » dès qu'elle répond `200` ou `302` ; `wait-for-parabank` attend un vrai `200`.
- L'état de la base après un démarrage neuf est identique à l'état après `reset-db` (comptes du client `john`
  comparés via l'API, 3 réinitialisations successives donnent le même résultat).

## Configuration de l'application (page admin)

Ces réglages changent les règles métier. Ils sont relevés au premier lancement et remis à l'identique avant
chaque campagne de test.

| Réglage | Valeur par défaut relevée |
| --- | --- |
| Data Access Mode | |
| Init. Balance ($) | |
| Min. Balance ($) | |
| Loan Provider | |
| Loan Processor | |
| Threshold (%) | |

## Données de démonstration

| Élément | Valeur |
| --- | --- |
| Compte de démonstration | `john` (mot de passe dans la documentation ParaBank) |
| Clients et comptes après *Initialize* | *(à relever en S-05)* |

## Historique des changements d'environnement

| Date | Changement | Raison |
| --- | --- | --- |
| | Création de l'environnement | Démarrage du projet |
| 2026-10-18 | Image figée par digest `sha256:5343aebd…459b0f`, healthcheck corrigé, scripts `wait-for-parabank` et `reset-db` | Reproductibilité (ADR-0001) ; l'ancien healthcheck utilisait `wget`, absent de l'image |
