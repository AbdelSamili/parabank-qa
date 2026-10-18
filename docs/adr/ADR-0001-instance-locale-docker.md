# ADR-0001 — Tester sur une instance locale Docker à version figée

| Élément | Valeur |
| --- | --- |
| Statut | Accepté |
| Date | 2026-10-18 |
| Décideur | Abdelkhaleq Samili |

## Contexte

ParaBank est disponible de deux façons :

1. une **instance publique** hébergée par Parasoft (`parabank.parasoft.com`), partagée par tous les utilisateurs ;
2. une **image Docker officielle** (`parasoft/parabank`) que l'on peut lancer en local.

Le projet a besoin de résultats de test **reproductibles** : la même campagne, lancée deux fois, doit donner le même
résultat si l'application n'a pas changé. C'est une condition pour que la non-régression, l'automatisation et la
CI aient un sens.

## Options étudiées

| Critère | Instance publique | Instance locale Docker |
| --- | --- | --- |
| Données | Partagées et modifiées par d'autres testeurs | Isolées, contrôlées |
| Réinitialisation | Imprévisible, hors de notre contrôle | À la demande (page admin, ou recréation du conteneur) |
| Version de l'application | Peut changer sans prévenir | Figée par le digest de l'image |
| Réglages admin (prêt, soldes) | Modifiables par n'importe qui | Sous notre contrôle |
| Disponibilité | Dépend d'Internet et de Parasoft | Toujours disponible en local |
| Utilisation en CI | Charge un service public, résultats instables | Conteneur lancé dans le pipeline |
| Effort de mise en place | Aucun | Docker à installer |

## Décision

Toutes les activités de test (exploration formelle, exécution des cas de test, automatisation, CI) se font sur une
**instance locale lancée par `docker-compose.yml`**, avec l'image **figée par son digest**.

L'instance publique sert uniquement à une première découverte de l'application, jamais à l'automatisation.

## Conséquences

- **Positives :** résultats reproductibles ; base réinitialisable avant chaque campagne ; version testée connue et
  tracée (baseline de l'objet de test, ISTQB 5.4) ; même environnement en local et en CI.
- **Négatives :** Docker est un prérequis ; la mise à jour de la version testée est une décision explicite
  (nouveau digest, nouvelle entrée dans `environnement.md`).
- **À faire :** relever le digest et les réglages admin par défaut dans `environnement.md`.
