# Journal de bord

Une entrée par séance de travail, 3 à 5 lignes : ce qui a été fait, ce qui a bloqué, ce qui a été décidé.
Ce journal sert de mémoire du projet et de support pour raconter le projet en entretien.

---

## 2026-10-12 — Étape 0 : préparation du poste

- Installation de Git, JDK 17, Maven, IntelliJ, Docker Desktop, Node.js, Postman, Chrome et Firefox.
- Vérification des versions en ligne de commande, résultats consignés dans `environnement.md`.
- Blocages : *(à compléter, ex. configuration de JAVA_HOME, activation de WSL 2)*.

## 2026-10-17 — Étape 1 : dépôt GitHub et projet Jira

- Création du dépôt `parabank-qa` et de la structure `docs/`.
- Création du ruleset `protection-main` : pull request obligatoire, suppression et force push interdits, squash uniquement.
- Vérification : un push direct sur `main` est bien refusé par GitHub.
- Création du projet Jira `PB` (Scrum), des Epics par étape et du workflow des défauts.
- Rédaction de `conventions.md` (branches, commits, identifiants, sévérités, cycle de vie des défauts).
- Décision : Xray sera activé à l'étape 6 pour ne pas consommer l'essai gratuit de 30 jours trop tôt.
