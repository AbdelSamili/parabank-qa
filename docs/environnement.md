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
| Digest figé | *(à compléter à l'étape 2 avec `docker inspect`)* |
| URL locale | `http://localhost:8080/parabank/index.htm` |
| Page d'administration | `http://localhost:8080/parabank/admin.htm` |
| Base de données | HyperSQL intégrée |

## Historique des changements d'environnement

| Date | Changement | Raison |
| --- | --- | --- |
| | Création de l'environnement | Démarrage du projet |
