# Session S-04 — Paiement de factures, demande de prêt et profil

## 1. Charte

> **Explorer** **le paiement de factures, la demande de prêt et la mise à jour du profil**
> **avec** des montants et apports limites, des numéros de compte qui correspondent ou non, et les réglages de prêt de la page admin
> **pour découvrir** **les règles d'acceptation et la cohérence des soldes après chaque opération**

| Élément | Valeur |
| --- | --- |
| Testeur | Abdelkhaleq Samili |
| Date | |
| Durée prévue | 45 minutes (time-box) |
| Durée réelle | |
| Environnement | ParaBank local, digest `…` (voir `environnement.md`), navigateur : … |
| Réglages admin | Init. Balance … / Min. Balance … / Loan Provider … / Loan Processor … / Threshold … |
| Pages concernées | `/billpay.htm`, `/requestloan.htm`, `/updateprofile.htm`, `/overview.htm` |

## 2. Préparation

- Noter les réglages admin : Loan Provider, Loan Processor, Threshold, Init. Balance, Min. Balance.
- Relever les soldes avant chaque opération (même tableau qu'en S-03).

## 3. Idées de test (attaques)

> Base : estimation d'erreurs, ISTQB CTFL v4.0 §4.4.1 (entrées, sorties, logique, calculs, interfaces, données).
> Ce sont des pistes, pas un script : suivez ce que l'application vous montre.

| # | Idée | Catégorie d'erreur |
| --- | --- | --- |
| 1 | Paiement de facture nominal : solde débité, transaction visible | Cas nominal |
| 2 | Numéro de compte et confirmation différents | Logique |
| 3 | Paiement supérieur au solde ; montant 0 ; montant négatif | Valeurs limites |
| 4 | Compte bénéficiaire inexistant dans ParaBank | Données |
| 5 | Prêt avec apport > fonds disponibles | Logique (table de décision) |
| 6 | Prêt avec apport très faible ; apport = 0 ; apport > montant du prêt | Valeurs limites |
| 7 | Prêt accordé : nouveau compte LOAN visible ? Apport débité ? | Calculs |
| 8 | Changer le *Loan Processor* dans l'admin et refaire la même demande : la décision change-t-elle ? | Logique |
| 9 | Profil : vider chaque champ obligatoire ; vider le téléphone | Entrées |
| 10 | Profil modifié : conservé après déconnexion / reconnexion ? | Données |

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
| Q-30 | | |
| Q-31 | | |
| Q-32 | | |
| Q-33 | | |
| Q-38 | | |
| Q-39 | | |
| Q-40 | | |
| Q-41 | | |
| Q-42 | | |
| Q-43 | | |
| Q-44 | | |

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
