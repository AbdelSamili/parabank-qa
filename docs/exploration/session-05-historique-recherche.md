# Session S-05 — Historique et recherche de transactions

## 1. Charte

> **Explorer** **l'historique des comptes et la recherche de transactions**
> **avec** les opérations réalisées en S-03 et S-04 (dont on connaît dates et montants), des dates dans plusieurs formats et des plages incohérentes
> **pour découvrir** **si chaque mouvement d'argent est tracé correctement et retrouvable**

| Élément | Valeur |
| --- | --- |
| Testeur | Abdelkhaleq Samili |
| Date | |
| Durée prévue | 45 minutes (time-box) |
| Durée réelle | |
| Environnement | ParaBank local, digest `…` (voir `environnement.md`), navigateur : … |
| Réglages admin | Init. Balance … / Min. Balance … / Loan Provider … / Loan Processor … / Threshold … |
| Pages concernées | `/activity.htm`, `/findtrans.htm`, `/admin.htm` |

## 2. Préparation

- Reprendre le tableau des opérations de S-03 et S-04 : c'est la liste des transactions attendues.
- Ne pas réinitialiser la base avant cette session.

## 3. Idées de test (attaques)

> Base : estimation d'erreurs, ISTQB CTFL v4.0 §4.4.1 (entrées, sorties, logique, calculs, interfaces, données).
> Ce sont des pistes, pas un script : suivez ce que l'application vous montre.

| # | Idée | Catégorie d'erreur |
| --- | --- | --- |
| 1 | Chaque opération de S-03/S-04 apparaît-elle, avec le bon montant, le bon sens (débit/crédit) et la bonne date ? | Données |
| 2 | Un virement apparaît-il sur les deux comptes ? | Données |
| 3 | Filtres de l'historique : chaque mois, chaque type, puis combinés | Logique |
| 4 | Recherche par ID existant, inexistant, non numérique | Entrées |
| 5 | Recherche par date au format `MM-DD-YYYY`, puis `DD-MM-YYYY`, `2026-10-18`, date invalide `02-30-2026` | Entrées |
| 6 | Plage de dates inversée (début > fin) ; plage d'un seul jour | Valeurs limites |
| 7 | Recherche par montant exact, décimal, négatif | Entrées |
| 8 | Page admin : Initialize puis Clean, que reste-t-il ? | Données |
| 9 | Data Access Mode REST (JSON) au lieu de JDBC : l'historique est-il identique ? | Interfaces |

## 4. Notes de test (au fil de la session)

> Notez tout ce que vous essayez et ce que vous observez, même quand tout fonctionne.
> Format conseillé : `hh:mm — action — observation`.

| Heure | Action / donnée utilisée | Observation |
| --- | --- | --- |
| | | |

## 5. Anomalies

> Une anomalie n'est pas encore un défaut. Reproduisez-la deux fois avant d'ouvrir un Bug Jira (voir `conventions.md` §6).

| ID | Titre | Étapes | Attendu | Obtenu | Reproduite 2× ? | Preuve | Jira |
| --- | --- | --- | --- | --- | --- | --- | --- |
| A-xx | | 1. … 2. … | | | Oui / Non | `captures/…png` | PB-xx |

## 6. Réponses aux questions de la cartographie

| Question | Réponse observée | Devient |
| --- | --- | --- |
| Q-20 | | |
| Q-32 | | |
| Q-34 | | |
| Q-35 | | |
| Q-36 | | |
| Q-37 | | |
| Q-46 | | |
| Q-47 | | |
| Q-48 | | |

*Colonne « Devient » : `REQ` (règle à écrire à l'étape 3), `A-xx` (anomalie), `Q` (reste ouverte).*

## 7. Nouvelles questions

| ID | Question |
| --- | --- |
| Q-xx | |

## 8. Répartition du temps

| Activité | % |
| --- | --- |
| Conception et exécution des tests | |
| Investigation et rédaction des anomalies | |
| Préparation (données, environnement) | |

## 9. Débriefing

- **Ce que j'ai appris sur l'application :**
- **Ce qui reste à explorer (idée de prochaine charte) :**
- **Risques repérés (à reporter à l'étape 4) :**
- **Couverture estimée de la charte :** faible / moyenne / bonne
