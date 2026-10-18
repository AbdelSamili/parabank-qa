# Session S-02 — Connexion et gestion de session

## 1. Charte

> **Explorer** **la connexion, la déconnexion et la protection des pages connectées**
> **avec** deux comptes clients, le bouton Retour du navigateur, deux onglets, l'accès direct aux URL et la modification des paramètres d'URL
> **pour découvrir** **les failles de gestion de session et d'autorisation**

| Élément | Valeur |
| --- | --- |
| Testeur | Abdelkhaleq Samili |
| Date | |
| Durée prévue | 45 minutes (time-box) |
| Durée réelle | |
| Environnement | ParaBank local, digest `…` (voir `environnement.md`), navigateur : … |
| Réglages admin | Init. Balance … / Min. Balance … / Loan Provider … / Loan Processor … / Threshold … |
| Pages concernées | `/index.htm`, `/logout.htm`, toutes les pages *Account Services*, `/admin.htm` |

## 2. Préparation

- Avoir deux clients : le compte de démonstration `john` et un compte créé en S-01.
- Noter les numéros de compte de chacun (Accounts Overview).

## 3. Idées de test (attaques)

> Base : estimation d'erreurs, ISTQB CTFL v4.0 §4.4.1 (entrées, sorties, logique, calculs, interfaces, données).
> Ce sont des pistes, pas un script : suivez ce que l'application vous montre.

| # | Idée | Catégorie d'erreur |
| --- | --- | --- |
| 1 | Connexion valide, puis déconnexion | Cas nominal |
| 2 | Username et mot de passe vides ; un seul des deux vide | Entrées |
| 3 | Mot de passe faux ; username en majuscules ; espaces autour | Logique |
| 4 | 5 tentatives échouées de suite : un blocage existe-t-il ? | Logique |
| 5 | Après déconnexion : bouton Retour, puis rechargement de la page | Logique |
| 6 | Après déconnexion : saisir directement `/overview.htm`, `/transfer.htm` | Interfaces |
| 7 | Connecté en tant que client A : ouvrir `/activity.htm?id=<compte du client B>` | Données (autorisation) |
| 8 | Find Transactions : saisir l'ID d'une transaction du client B | Données (autorisation) |
| 9 | Deux onglets : se déconnecter dans l'un, agir dans l'autre | Logique |
| 10 | Ouvrir `/admin.htm` sans être connecté ; en tant que client | Interfaces |
| 11 | Observer l'URL : contient-elle un identifiant de session (`jsessionid`) ? | Sorties |

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
| Q-01 | | |
| Q-02 | | |
| Q-03 | | |
| Q-04 | | |
| Q-19 | | |
| Q-36 | | |
| Q-45 | | |
| Q-49 | | |

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
