# Session S-03 — Virements et ouverture de compte

## 1. Charte

> **Explorer** **les virements, l'ouverture de compte et la vue des comptes**
> **avec** des montants limites (0 ; 0,01 ; solde exact ; solde + 0,01 ; négatif ; décimales ; très grand ; non numérique) et un relevé des soldes avant/après chaque opération
> **pour découvrir** **les règles métier sur les montants et la cohérence des soldes**

| Élément | Valeur |
| --- | --- |
| Testeur | Abdelkhaleq Samili |
| Date | |
| Durée prévue | 45 minutes (time-box) |
| Durée réelle | |
| Environnement | ParaBank local, digest `…` (voir `environnement.md`), navigateur : … |
| Réglages admin | Init. Balance … / Min. Balance … / Loan Provider … / Loan Processor … / Threshold … |
| Pages concernées | `/overview.htm`, `/openaccount.htm`, `/transfer.htm`, `/activity.htm` |

## 2. Préparation

- Réinitialiser la base, se connecter, noter **tous les soldes** dans un tableau avant de commencer.
- Ouvrir un compte SAVINGS pour disposer de deux comptes.
- Tenir un tableau « solde avant / opération / solde attendu / solde obtenu » : c'est l'oracle de test de cette session.

## 3. Idées de test (attaques)

> Base : estimation d'erreurs, ISTQB CTFL v4.0 §4.4.1 (entrées, sorties, logique, calculs, interfaces, données).
> Ce sont des pistes, pas un script : suivez ce que l'application vous montre.

| # | Idée | Catégorie d'erreur |
| --- | --- | --- |
| 1 | Ouvrir un compte SAVINGS puis CHECKING : le compte source est-il débité du dépôt minimum ? | Calculs |
| 2 | Ouvrir un compte depuis un compte dont le solde est inférieur au dépôt minimum | Logique |
| 3 | Virement nominal de 100 : vérifier les deux soldes et le total de l'Overview | Calculs |
| 4 | Virement de 0, de -50, de 0,01 | Valeurs limites |
| 5 | Virement du solde exact, puis du solde + 0,01, puis de 1 000 000 | Valeurs limites |
| 6 | Montant avec 3 décimales (`10.005`), avec une virgule (`10,50`), avec des lettres | Entrées |
| 7 | Même compte en source et en cible | Logique |
| 8 | Champ montant vide | Entrées |
| 9 | Double clic rapide sur **Transfer** : le virement est-il fait deux fois ? | Logique |
| 10 | Overview : le total est-il la somme exacte des soldes affichés ? | Calculs |

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
| Q-16 | | |
| Q-17 | | |
| Q-18 | | |
| Q-21 | | |
| Q-22 | | |
| Q-23 | | |
| Q-24 | | |
| Q-25 | | |
| Q-26 | | |
| Q-27 | | |
| Q-28 | | |
| Q-29 | | |

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
