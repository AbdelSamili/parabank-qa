# Session S-01 — Inscription et pages publiques

## 1. Charte

> **Explorer** **l'inscription, la récupération des identifiants et les pages publiques**
> **avec** des données valides, vides, très longues et spéciales (accents, apostrophes, `< > " ;`, espaces)
> **pour découvrir** **les règles de validation des champs et la cohérence de la navigation publique**

| Élément | Valeur |
| --- | --- |
| Testeur | Abdelkhaleq Samili |
| Date | |
| Durée prévue | 45 minutes (time-box) |
| Durée réelle | |
| Environnement | ParaBank local, digest `…` (voir `environnement.md`), navigateur : … |
| Réglages admin | Init. Balance … / Min. Balance … / Loan Provider … / Loan Processor … / Threshold … |
| Pages concernées | `/index.htm`, `/register.htm`, `/lookup.htm`, `/contact.htm`, pages d'information |

## 2. Préparation

- Réinitialiser la base depuis la page admin (**Initialize**).
- Préparer un jeu de données dans `test-data/inscription.md` : 1 client valide complet, puis une variante par règle à tester.
- Utiliser un username unique par essai (ex. `s01_user01`, `s01_user02`…).

## 3. Idées de test (attaques)

> Base : estimation d'erreurs, ISTQB CTFL v4.0 §4.4.1 (entrées, sorties, logique, calculs, interfaces, données).
> Ce sont des pistes, pas un script : suivez ce que l'application vous montre.

| # | Idée | Catégorie d'erreur |
| --- | --- | --- |
| 1 | Inscription complète valide, puis connexion avec ce compte | Cas nominal |
| 2 | Soumettre le formulaire entièrement vide : quels messages, pour quels champs ? | Entrées |
| 3 | Laisser vide un seul champ à la fois (11 essais) : chaque champ est-il obligatoire ? | Entrées |
| 4 | Mot de passe et confirmation différents | Logique |
| 5 | Username déjà existant ; même username avec une casse différente | Données |
| 6 | Champs de 1 caractère puis de 255+ caractères | Valeurs limites |
| 7 | Lettres dans Zip, téléphone et SSN ; SSN de longueur inhabituelle | Entrées |
| 8 | Accents (`Élodie`), apostrophe (`O'Neil`), HTML (`<b>test</b>`) dans le nom : comment s'affiche-t-il ensuite ? | Sorties |
| 9 | Espaces avant/après le username | Entrées |
| 10 | Récupération des identifiants avec des informations exactes, puis avec un SSN faux | Logique |
| 11 | Formulaire Contact : email sans `@` | Entrées |
| 12 | Cliquer sur chaque lien du menu gauche et du pied de page : où mène-t-il ? | Interfaces |

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
| Q-05 | | |
| Q-06 | | |
| Q-07 | | |
| Q-08 | | |
| Q-09 | | |
| Q-10 | | |
| Q-11 | | |
| Q-12 | | |
| Q-13 | | |
| Q-14 | | |
| Q-15 | | |

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
