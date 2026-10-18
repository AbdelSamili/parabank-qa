# Relecture des fiches de session S-01 à S-05

**Objet :** revue informelle (ISTQB CTFL v4.0 §3.2) des fiches de session exploratoire avant leur utilisation
comme base de test à l'étape 3. Points vérifiés : anomalies mal décrites, questions `Q-xx` sans réponse, défauts
candidats non reproduits deux fois (`conventions.md` §6).

| Élément | Valeur |
| --- | --- |
| Relecteur | Abdelkhaleq Samili |
| Date | 2026-10-18 |
| Fiches relues | `session-01` à `session-05` (état du commit `54d71c7`) |
| Ticket Jira | PB-33 |

---

## 1. Constat principal

Les 5 fiches sont encore des **gabarits vierges** : aucune date, aucune note de test, aucune anomalie, aucune
réponse aux questions. La relecture du **contenu** (anomalies, réponses, reproductions) est donc impossible à ce
stade et sera **refaite après les sessions** (PB-33 reste ouvert).

| Contrôle | S-01 | S-02 | S-03 | S-04 | S-05 |
| --- | --- | --- | --- | --- | --- |
| Date et durée réelle renseignées | Non | Non | Non | Non | Non |
| Notes de test | Vide | Vide | Vide | Vide | Vide |
| Anomalies `A-xx` décrites | Aucune | Aucune | Aucune | Aucune | Aucune |
| Questions avec réponse observée | 0 / 11 | 0 / 8 | 0 / 12 | 0 / 11 | 0 / 9 |
| Débriefing | Vide | Vide | Vide | Vide | Vide |

## 2. Remarques sur les gabarits (à corriger ou trancher avant les sessions)

| # | Fiche | Remarque | Proposition |
| --- | --- | --- | --- |
| R-01 | S-01 à S-05 | Le champ *Environnement* contient `digest …` | Reporter le digest figé `sha256:5343aebd…459b0f` (voir `environnement.md`) |
| R-02 | S-01, S-03 | La préparation dit « réinitialiser la base depuis la page admin (**Initialize**) » | Possible aussi avec `./scripts/reset-db.sh` (Clean puis Initialize) ; noter dans la fiche la méthode utilisée |
| R-03 | S-01 | La préparation renvoie à `test-data/inscription.md`, qui n'existe pas ; `CLAUDE.md` prévoit des CSV/JSON dans `test-data/` | Créer le jeu de données pendant la session, de préférence en `test-data/inscription.csv` |
| R-04 | S-02 et S-05 | **Q-36** (ID de transaction d'un autre client) est attribuée aux deux sessions | Choisir une session responsable (S-02, autorisation) ; l'autre y renvoie |
| R-05 | S-04 et S-05 | **Q-32** (paiement visible dans l'historique) est attribuée aux deux sessions | Observer en S-04, confirmer en S-05 ; indiquer la réponse de référence dans une seule fiche |
| R-06 | S-04 | **Q-33** (id aléatoire du champ téléphone de Bill Pay) n'est pas une question d'exploration mais une note d'automatisation | La garder pour l'étape 8 ; dans la fiche, simplement confirmer le constat |
| R-07 | Toutes | Colonne *Reproduite 2× ?* : rien n'indique **quand** la 2ᵉ reproduction a été faite | Ajouter l'heure des deux reproductions dans *Étapes* ou *Preuve* |
| R-08 | Toutes | Colonne *Preuve* : `docs/exploration/captures/` est vide | Nommer les captures `S-xx_A-xx_<n>.png` pour la traçabilité |

Couverture des questions : Q-01 à Q-49 sont toutes attribuées à au moins une session (vérifié contre
`cartographie.md` §5). Aucune question orpheline.

## 3. Faits observés pendant l'outillage (à confirmer ou qualifier par l'auteur)

Ces faits ont été **observés** en écrivant et en testant les scripts. Ils ne remplacent pas les sessions : l'auteur
décide s'ils deviennent une réponse, une anomalie `A-xx` ou une question.

| Fait observé | Combien de fois | Session concernée | Statut |
| --- | --- | --- | --- |
| Conteneur neuf : `index.htm` répond `302` vers `initializeDB.htm` tant que la redirection n'est pas suivie | 2 démarrages | S-05 (idée 8, Q-46) | Information, pas une anomalie a priori |
| Conteneur neuf, base non initialisée : `admin.htm` répond `500` | 2 essais | S-02 (idée 10, Q-49) / S-05 | **Défaut candidat à qualifier** par l'auteur (comportement attendu ou erreur non gérée ?) — pas de Bug Jira ouvert |
| Après `cleanDB` + `initializeDB`, le client `john` (id 12212) a 11 comptes | 3 réinitialisations, résultat identique | S-05 (Q-46) | À relever par l'auteur dans `environnement.md` (*Données de démonstration*) |
| Le conteneur précédent (démarré le 2026-10-17) montrait 2 comptes pour `john` avant réinitialisation | 1 fois | — | Origine non analysée : la base avait pu être modifiée depuis le démarrage |
