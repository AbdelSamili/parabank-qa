# Prompt maître — Compléter le projet ParaBank QA avec Claude Code

> **Mode d'emploi**
> 1. Placer ce fichier dans `docs/prompts/` et `CLAUDE.md` à la racine du dépôt.
> 2. Ouvrir Claude Code à la racine de `parabank-qa`.
> 3. Copier la section **« Prompt de démarrage »** ci-dessous dans Claude Code.
> 4. Ensuite, lancer chaque étape avec : `Exécute l'étape N du fichier docs/prompts/prompt-claude-code.md`.
> 5. À la fin de chaque étape, Claude Code s'arrête : relire, tester, merger la pull request, puis lancer l'étape suivante.

---

## Prompt de démarrage (à copier tel quel)

```text
Tu es un ingénieur QA senior et mentor. Tu m'aides à terminer le projet ParaBank QA, un projet de portfolio
de test logiciel aligné sur l'ISTQB CTFL v4.0.

Avant toute action :
1. Lis CLAUDE.md, README.md, docs/conventions.md, docs/environnement.md, docs/journal.md,
   docs/exploration/ (cartographie et fiches de session) et docs/prompts/prompt-claude-code.md.
2. Vérifie l'environnement : java -version (17), mvn -version, docker --version, node -v,
   puis docker compose up -d et un appel HTTP à http://localhost:8080/parabank/index.htm.
3. Fais-moi un état des lieux court : étapes terminées d'après le README et le journal, fichiers présents,
   écarts avec la structure cible de CLAUDE.md, problèmes d'environnement.
4. Si le connecteur Atlassian est disponible, lis les Epics PB-5 à PB-18 et les tâches ouvertes du projet PB.

Ne modifie rien pendant ce démarrage. Termine en me proposant l'étape à exécuter ensuite et attends ma réponse.

Règles pour toute la suite : respecte strictement CLAUDE.md ; une étape à la fois ; une branche et une
pull request par étape ; n'invente jamais un résultat, un défaut ou un comportement de ParaBank ;
exécute tout ce que tu écris ; arrête-toi à la fin de chaque étape avec un compte rendu.
```

---

## Gabarit commun à chaque étape

Pour **chaque** étape, Claude Code suit ce cycle :

1. **Lire** les livrables de l'étape précédente et la section de l'étape ci-dessous.
2. **Présenter le plan** : fichiers à créer ou modifier, choix techniques, points à valider. Attendre l'accord
   si un choix n'est pas évident.
3. **Créer la branche** indiquée, **créer les tickets Jira** de l'étape sous l'Epic correspondante
   (si le connecteur est disponible), passer l'Epic en « En cours ».
4. **Réaliser** en petits incréments vérifiés (écrire → exécuter → corriger → commiter).
5. **Vérifier** la *Definition of Done* de l'étape, case par case, avec preuves (sortie de commande, rapport).
6. **Documenter** : journal, README (statut), ADR si une décision technique a été prise.
7. **Ouvrir la pull request** avec le modèle du dépôt, lier les tickets Jira.
8. **Compte rendu** et **arrêt**.

Format du compte rendu de fin d'étape :

```text
## Étape N — <titre> : compte rendu
- Réalisé : ...
- Résultats exécutés : (chiffres réels, commandes utilisées)
- Défauts / anomalies : ...
- Décisions prises (ADR) : ...
- Points ouverts / à vérifier par l'auteur : ...
- Pour reproduire : (commandes)
- Prochaine étape proposée : ...
```

---

## Étape 2 (support) — Outillage pour l'exploration

> L'exploration elle-même (sessions S-01 à S-05) est faite **par l'auteur**, manuellement. Claude Code ne remplit
> **pas** les fiches de session à sa place. Il fournit seulement l'outillage et relit les fiches.

- **Branche :** `chore/outillage-environnement` · **Epic :** PB-7
- **Tâches :**
  1. `scripts/wait-for-parabank.sh` : attend un HTTP 200 sur `index.htm` (timeout 120 s, message clair).
  2. `scripts/reset-db.sh` : appelle les services REST `cleanDB` puis `initializeDB` (vérifier leur existence et
     leur méthode HTTP sur l'instance locale avant d'écrire le script), affiche le résultat.
  3. Version Windows des deux scripts en PowerShell si l'auteur est sous Windows.
  4. Figer l'image dans `docker-compose.yml` avec le digest relevé (`docker inspect`), le noter dans
     `docs/environnement.md`.
  5. Relire les fiches de session remplies par l'auteur : signaler les anomalies mal décrites, les questions sans
     réponse, les défauts candidats qui n'ont pas été reproduits deux fois.
- **Definition of Done :** les scripts fonctionnent ; le digest est figé ; les remarques de relecture sont listées.

---

## Étape 3 — Base de test (exigences REQ-xx)

- **ISTQB :** 1.4.1 (analyse de test), 1.4.4 (traçabilité), 3.1–3.2 (test statique, revues).
- **Branche :** `docs/base-de-test` · **Epic :** PB-8 · **Tag :** `v0.2-base-de-test`
- **Entrées :** `docs/exploration/cartographie.md`, fiches S-01 à S-05, code source ParaBank (JSP,
  `messages.properties`) pour confirmer les messages exacts.
- **Tâches :**
  1. Créer `docs/base-de-test/requirements.md` : une exigence par règle **observée ou annoncée**, au format :

     | ID | Module | Exigence (formulation testable) | Source | Priorité | Statut |
     |---|---|---|---|---|---|
     | REQ-01 | LOG | Le système refuse la connexion si le nom d'utilisateur ou le mot de passe est vide et affiche « Please enter a username and password. » | Cartographie §2, S-02 | Haute | Confirmée |

     - *Source* : cartographie, session `S-xx`, code source, ou « attendu métier » (règle bancaire raisonnable
       non garantie par l'application).
     - *Statut* : `Confirmée` (observée), `Attendue` (règle métier non vérifiée), `Question` (`Q-xx` ouverte).
     - Exigences non fonctionnelles en section séparée : sécurité (sessions, autorisation), utilisabilité
       (messages), performance indicative.
  2. Rédiger chaque exigence de façon **testable** : un seul comportement, mesurable, sans « etc. »,
     sans « doit fonctionner correctement ».
  3. Faire une **revue informelle** (ISTQB 3.2) en s'appuyant sur une checklist : ambiguïté, testabilité,
     contradictions, manques. Consigner les remarques et les corrections dans `docs/base-de-test/revue.md`.
  4. Mettre à jour `cartographie.md` : chaque question `Q-xx` renvoie vers une `REQ-xx` ou reste ouverte.
- **Definition of Done :** chaque page de la cartographie est couverte par au moins une exigence ; aucune
  exigence non testable ; la revue est documentée ; tag posé.

---

## Étape 4 — Analyse des risques

- **ISTQB :** 5.2 (risques produit et projet, analyse, maîtrise, test basé sur les risques).
- **Branche :** `docs/analyse-risques` · **Epic :** PB-9 · **Tag :** `v0.3-risques`
- **Tâches :**
  1. `docs/risk-analysis.md` avec une matrice :

     | ID | Risque produit | Module | REQ liées | Probabilité (1–3) | Impact (1–3) | Niveau (P×I) | Réponse (maîtrise) |
     |---|---|---|---|---|---|---|---|

     - Probabilité et impact **justifiés** en une ligne (complexité, observations d'exploration, enjeu argent).
     - Niveau → effort de test : 7–9 = couverture approfondie à tous les niveaux (UI, API, unitaire) ;
       4–6 = API + UI nominal ; 1–3 = smoke uniquement.
  2. Section **risques projet** (outils, temps, environnement instable, essai Xray limité) avec mitigation.
  3. Ajouter la colonne `Risque` dans `requirements.md` (lien REQ → RISK).
- **Definition of Done :** chaque module a au moins un risque évalué ; la priorisation est explicite et
  réutilisée dans le plan de test.

---

## Étape 5 — Plan de test

- **ISTQB :** 5.1.1 (contenu du plan), 5.1.3 (critères d'entrée et de sortie), 5.1.4 (estimation),
  5.1.5 (priorisation), 5.1.6 (pyramide), 5.1.7 (quadrants).
- **Branche :** `docs/plan-de-test` · **Epic :** PB-10 · **Tag :** `v0.4-plan-de-test`
- **Livrable :** `docs/test-plan/test-plan.md`, structure inspirée de l'ISO/IEC/IEEE 29119-3 :
  1. Identification (version du document, auteur, historique)
  2. Contexte et objectifs du test
  3. Objet de test (version figée, digest) et base de test (lien vers `requirements.md`)
  4. Périmètre : dans le périmètre / hors périmètre (avec la raison)
  5. Risques (lien vers `risk-analysis.md`) et stratégie basée sur les risques
  6. Approche : niveaux (composant, intégration, système), types (fonctionnel, non-régression, confirmation),
     techniques par module (PE, BVA, table de décision, transitions d'état, exploratoire)
  7. Pyramide des tests du projet et répartition dans les quadrants de test
  8. Environnement et données de test (Docker, réinitialisation, réglages admin, navigateurs)
  9. Outils (Jira/Xray, Selenium, Postman/Newman, JUnit/Mockito/JaCoCo, GitHub Actions, Jenkins)
  10. Critères d'entrée et critères de sortie **mesurables** (ex. 100 % des cas critiques exécutés,
      0 défaut critique ouvert non documenté, couverture ≥ seuil sur les packages ciblés)
  11. Critères de suspension et de reprise
  12. Livrables de test
  13. Estimation (technique à trois points ou par analogie, justifiée) et planning
  14. Métriques suivies (taux d'exécution, de réussite, défauts par sévérité, couverture des exigences)
  15. Rôles, risques projet, hypothèses
- **Definition of Done :** chaque section est remplie avec des informations propres au projet ;
  les critères de sortie sont vérifiables ; tag posé.

---

## Étape 6 — Conception des cas de test

- **ISTQB :** 4.2.1 (partitions d'équivalence), 4.2.2 (valeurs limites, 2 valeurs), 4.2.3 (tables de décision),
  4.2.4 (transitions d'état), 1.4.4 (traçabilité).
- **Branche :** `docs/conception-cas-de-test` · **Epic :** PB-11 · **Tag :** `v0.5-cas-de-test`
- **Tâches :**
  1. `docs/test-design/` : un fichier par module montrant **le raisonnement** de conception :
     - partitions valides et invalides avec leurs représentants ;
     - valeurs limites (montant du virement : 0, 0,01, solde − 0,01, solde, solde + 0,01) ;
     - table de décision du prêt (fonds disponibles, apport, montant ; selon le *Loan Processor* configuré) ;
     - diagramme de transitions d'état de la session (déconnecté, connecté, expiré, déconnexion).
  2. `docs/test-design/test-cases.csv` au format d'import Xray (vérifier le format CSV attendu par Xray avant
     d'écrire) : ID, titre, préconditions, étapes, données, résultat attendu, priorité, technique, REQ liée,
     niveau visé (UI / API / unitaire / manuel), tag (`smoke` / `regression`).
  3. Volume cible : 60 à 80 cas, priorisés selon les risques de l'étape 4.
  4. `docs/test-design/traceability-matrix.md` : REQ → TC (et RISK), avec la **couverture des exigences**
     (nombre de REQ couvertes / total).
  5. Si Xray est activé : importer les cas dans Jira (l'auteur active l'essai Xray à ce moment-là).
- **Definition of Done :** chaque REQ est couverte par au moins un TC ou justifiée ; chaque TC indique sa
  technique ; la matrice est à jour ; tag posé.

---

## Étape 7 — Exécution manuelle et rapports de défauts

- **ISTQB :** 1.4.1 (exécution), 5.5 (gestion des défauts), 2.2.3 (tests de confirmation).
- **Branche :** `docs/campagne-manuelle-1` · **Epic :** PB-12 · **Tag :** `v0.6-campagne-manuelle`
- **Rôle de Claude Code :** préparer et outiller ; **l'exécution manuelle et l'observation sont faites par
  l'auteur**. Claude Code ne coche aucun résultat qu'il n'a pas observé.
- **Tâches :**
  1. `docs/campagnes/campagne-01.md` : périmètre, version testée (digest), réglages admin, date, testeur,
     tableau d'exécution (TC, résultat Réussi / Échoué / Bloqué / Non exécuté, défaut lié, commentaire).
  2. Pour chaque défaut confirmé par l'auteur : créer un ticket **Bug** dans Jira (type Bug, champ Sévérité)
     avec le modèle de rapport (commentaire de PB-23 / `conventions.md` §6.5).
  3. Métriques de la campagne : taux d'exécution, taux de réussite, défauts par sévérité et par module.
  4. Lister les cas candidats à l'automatisation (critères : priorité, répétabilité, stabilité, coût).
- **Definition of Done :** campagne documentée avec les résultats réels de l'auteur ; défauts complets dans
  Jira ; liste d'automatisation validée ; tag posé.

---

## Étape 8 — Automatisation UI (Selenium WebDriver + JUnit 5)

- **ISTQB :** 6.2 (bénéfices et risques de l'automatisation), 5.1.6 (pyramide).
- **Branche :** `feat/framework-selenium` puis `test/ui-<module>` · **Epic :** PB-13 · **Tag :** `v0.7-ui-auto`
- **Architecture (`ui-tests/`) :**

  ```text
  src/main/java/com/abdel/parabank/
    config/   TestConfig (baseUrl, browser, headless, timeouts : -D > env > config.properties)
    driver/   DriverFactory (Chrome, Firefox, headless), DriverManager (ThreadLocal)
    pages/    BasePage (attentes explicites, type, click, select, isVisible)
              LoginPanel, RegisterPage, AccountsOverviewPage, OpenAccountPage,
              TransferFundsPage, BillPayPage, FindTransactionsPage,
              UpdateProfilePage, RequestLoanPage, AccountActivityPage
    api/      ParaBankApiClient (java.net.http) : créer un client, lire les comptes et soldes,
              réinitialiser la base — utilisé pour préparer les données et vérifier les soldes
    data/     Customer (record), TestDataFactory (identifiants uniques)
  src/test/java/com/abdel/parabank/
    support/  BaseTest, ScreenshotOnFailureExtension, DatabaseResetExtension
    ui/       LoginTest, RegisterTest, TransferFundsTest, OpenAccountTest, BillPayTest,
              FindTransactionsTest, RequestLoanTest, SessionTest
  src/test/resources/ config.properties, junit-platform.properties, test-data/*.csv
  ```

- **Exigences :**
  - Locators relevés sur l'instance locale (`id` d'abord ; `name` pour le téléphone de Bill Pay, dont l'id est
    aléatoire).
  - Préparation des données **par l'API**, action par l'UI, **vérification des soldes par l'API**.
  - Tests paramétrés pour les valeurs limites (`@ParameterizedTest` + `@CsvFileSource`).
  - Exécution parallèle configurée et stable ; captures sur échec dans `target/screenshots/`.
  - Rapport : Surefire + rapport HTML (Allure ou `maven-surefire-report-plugin`, choix noté dans un ADR).
  - 15 à 25 tests, chacun lié à un `TC-xx` ; suite `smoke` < 3 minutes.
  - Stabilité : la suite complète passe **3 fois de suite** sans échec intermittent avant le merge.
  - Les tests qui échouent à cause d'un défaut réel restent en échec et référencent le Bug (`PB-xx`) dans
    leur `@DisplayName` ou un commentaire ; ils ne sont pas désactivés.
  - ADR : `ADR-0002-page-object-model.md` (choix du framework, alternatives écartées).
- **Definition of Done :** `mvn -f ui-tests -B test -Dheadless=true` passe en local 3 fois ; rapport généré ;
  README mis à jour (lancer les tests, lire le rapport) ; tag posé.

---

## Étape 9 — Tests d'API (Postman + Newman)

- **ISTQB :** 5.1.7 (quadrant Q2), 2.2.1 (test d'intégration de composants / système).
- **Branche :** `test/api-postman` · **Epic :** PB-14 · **Tag :** `v0.8-api-auto`
- **Tâches :**
  1. Lire la description de l'API sur l'instance locale (lien OpenAPI ou WADL de la page admin) et lister les
     endpoints réellement disponibles dans `docs/test-design/api-endpoints.md`. **Ne pas supposer** un endpoint.
  2. Collection `api-tests/ParaBank.postman_collection.json`, dossiers ordonnés :
     Setup (reset, login) → Comptes → Virements → Historique → Prêt → Factures → Cas négatifs.
  3. Chaque requête vérifie : code HTTP, temps de réponse (seuil indicatif documenté), schéma JSON
     (`pm.response.to.have.jsonSchema`), donnée métier (ex. solde après = solde avant − montant).
  4. Variables : environnement `local` et `ci` (uniquement `baseUrl`, `username`, `password`) ; ID posés à
     l'exécution ; fonctions d'assertion réutilisables au niveau de la collection.
  5. Itérations pilotées par données (`api-tests/data/transfer-amounts.csv`).
  6. `api-tests/package.json` : `newman` et `newman-reporter-htmlextra` en devDependencies, scripts
     `test` et `test:ci` (reporters cli, htmlextra, junit vers `api-tests/reports/`).
  7. 40 à 60 requêtes avec assertions ; cas négatifs (compte inexistant, montant invalide, client inconnu).
- **Definition of Done :** `npm --prefix api-tests run test:ci` passe en local ; rapport HTML généré ;
  collection exportée et versionnée ; tag posé.

---

## Étape 10 — Tests unitaires et couverture (JUnit 5 + Mockito + JaCoCo)

- **ISTQB :** 4.3.1–4.3.2 (couverture des instructions et des branches), 2.2.1 (test de composants).
- **Branche :** `test/unitaires-parabank` · **Epic :** PB-15 · **Tag :** `v0.9-unitaires`
- **Tâches :**
  1. L'auteur forke `parasoft/parabank` sur son GitHub ; Claude Code l'ajoute en **sous-module Git** dans
     `unit-tests/parabank` et vérifie que le projet compile (`mvn -B -DskipTests package`), en arrêtant le
     conteneur ParaBank si des ports entrent en conflit. Lire le `pom.xml` du fork pour connaître sa version de
     Java et ses tests existants avant d'ajouter quoi que ce soit.
  2. Cibler la logique métier : `BankManagerImpl` (virement, dépôt, retrait, ouverture de compte, demande de
     prêt) et les processeurs de prêt (`AvailableFundsLoanProcessor`, `DownPaymentLoanProcessor`,
     `CombinedLoanProcessor`).
  3. Tests dans un package dédié (`src/test/java/com/abdel/unit/...`) pour isoler le travail de l'auteur :
     `@ExtendWith(MockitoExtension.class)`, `@Mock` des DAO, `@InjectMocks`, `verify` + `ArgumentCaptor`
     sur les transactions créées, `@Nested` par scénario, nommage `methode_condition_resultatAttendu`.
  4. Couvrir les **branches** des règles de prêt (table de décision de l'étape 6) et les valeurs limites.
  5. Ajouter `jacoco-maven-plugin` (`prepare-agent`, `report`, `check` limité aux packages ciblés,
     seuil 70 % lignes) ; rapporter **honnêtement** la couverture globale réelle.
  6. Optionnel : PIT (tests de mutation) sur les classes ciblées, score réel noté.
- **Definition of Done :** 30 à 50 tests unitaires verts ; `mvn verify` échoue si le seuil n'est pas atteint ;
  rapport JaCoCo lu et chiffres réels reportés dans le journal ; tag posé.

---

## Étape 11 — Intégration continue (GitHub Actions)

- **ISTQB :** 2.1.4 (DevOps et test), 2.1.5 (shift left).
- **Branche :** `ci/github-actions` · **Epic :** PB-16
- **Livrable :** `.github/workflows/ci.yml`

  | Job | Déclencheur | Contenu |
  |---|---|---|
  | `unit` | push, PR | checkout avec sous-modules, Java 17 + cache Maven, `mvn verify` du fork, rapport JaCoCo |
  | `api` | push, PR | ParaBank en *service container*, attente du HTTP 200, `reset-db`, Newman, rapports |
  | `ui-smoke` | push, PR (après `api`) | ParaBank en service, Chrome headless, `-Dgroups=smoke`, captures sur échec |

- **Exigences :** versions d'actions figées ; cache Maven et npm ; `concurrency` pour annuler les exécutions
  obsolètes ; `timeout-minutes` par job ; rapports publiés avec `actions/upload-artifact` ; résultats de tests
  affichés sur la PR ; aucun secret en clair.
- **Ruleset :** l'auteur ajoute ensuite la règle *Require status checks to pass* (jobs `unit`, `api`, `ui-smoke`)
  au ruleset `protection-main`. Claude Code lui indique les noms exacts des contrôles à sélectionner.
- **Definition of Done :** pipeline vert sur la PR ; un échec volontaire (test cassé sur une branche de test)
  bloque bien le merge, puis est annulé ; README avec badge CI.

---

## Étape 12 — Campagne de non-régression (Jenkins)

- **ISTQB :** 2.2.3 (tests de confirmation et de régression), 6.1 (outils).
- **Branche :** `ci/jenkins` · **Epic :** PB-17
- **Répartition :** GitHub Actions = retour rapide (unitaire + smoke) ; Jenkins = régression complète,
  chaque nuit et à la demande. Les deux ne font jamais le même travail.
- **Livrables :**
  - `jenkins/Dockerfile` (image `jenkins/jenkins:lts` + Maven/Node/navigateur ou agent Docker),
    `jenkins/plugins.txt`, `jenkins/casc.yaml` (Configuration as Code) ; service `jenkins` dans
    `docker-compose.yml` sous un profil `jenkins`.
  - `Jenkinsfile` déclaratif : paramètres `SUITE` (regression/smoke) et `BROWSER` (chrome/firefox),
    `cron('H 2 * * *')`, `timeout`, `timestamps`, `buildDiscarder`, `disableConcurrentBuilds` ;
    étapes : démarrer ParaBank → reset → unitaires → API (Newman) → UI ; `post { always { junit, jacoco,
    publishHTML, archiveArtifacts, docker compose down -v } }`.
  - Envoi des résultats JUnit vers une *Test Execution* Xray (API Xray, identifiants dans les credentials
    Jenkins via `withCredentials`) — si Xray est encore actif ; sinon documenter la procédure.
  - Optionnel : Selenium Grid (hub + nœuds Chrome/Firefox) pour paralléliser les navigateurs.
- **Definition of Done :** un build Jenkins paramétré passe en local ; tendances JUnit/JaCoCo visibles après
  deux builds ; README et ADR (`ADR-0003-github-actions-et-jenkins.md`) mis à jour.

---

## Étape 13 — Rapport de clôture et finalisation

- **ISTQB :** 5.3 (pilotage, contrôle, clôture), 5.3.2 (rapports de test).
- **Branche :** `docs/cloture` · **Epic :** PB-18 · **Tag :** `v1.0.0`
- **Livrables :**
  1. `docs/test-summary-report.md` : résumé ; objet et version testés ; écarts par rapport au plan ;
     activités réalisées par niveau ; métriques **réelles** (cas conçus/exécutés/réussis, couverture des
     exigences, couverture de code, défauts par sévérité et statut) ; défauts ouverts et risques résiduels ;
     évaluation des critères de sortie ; leçons apprises ; recommandation.
  2. README final : objectif, architecture du dépôt (schéma), comment tout lancer, comment lire les rapports,
     résultats clés, limites connues, compétences démontrées.
  3. Nettoyage : fichiers inutiles, TODO résolus ou transformés en tickets, liens vérifiés.
  4. Clôture Jira : Epics terminées, défauts au bon statut (*Différé* pour ceux que l'on ne corrige pas).
  5. Préparation d'entretien : `docs/presentation.md` avec 5 points forts du projet et la réponse courte à
     « montrez-moi où vous avez utilisé X » pour chaque outil du CV.
- **Definition of Done :** rapport relu ; tous les chiffres viennent d'exécutions réelles ; tag `v1.0.0` posé.

---

## Annexe — Ce que Claude Code ne doit pas faire à la place de l'auteur

| Activité | Pourquoi l'auteur doit la faire |
| --- | --- |
| Sessions exploratoires et exécution manuelle | C'est de l'observation humaine ; la déléguer rendrait le projet non défendable en entretien |
| Activer Xray, configurer Jira, ajouter les règles GitHub | Actions sur ses comptes et paramètres |
| Créer le fork de ParaBank | Action sur son compte GitHub |
| Valider chaque étape et merger les PR | Contrôle qualité et compréhension de chaque livrable |
| Expliquer chaque fichier | Objectif du portfolio : pouvoir tout justifier |
