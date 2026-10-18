# CLAUDE.md — Règles permanentes du projet ParaBank QA

Ce fichier est lu par Claude Code au début de chaque session. Il fixe les règles qui s'appliquent à **toutes** les étapes.
Le déroulé étape par étape est dans `docs/prompts/prompt-claude-code.md`.

## 1. Contexte

- Projet personnel de **test et d'assurance qualité** sur ParaBank (application bancaire de démonstration de Parasoft).
- Auteur : Abdelkhaleq Samili, ingénieur QA (ISTQB CTFL). Le projet sert de portfolio et sera présenté en entretien :
  chaque fichier doit pouvoir être expliqué par l'auteur. Privilégier le code **simple, lisible et commenté avec parcimonie**
  plutôt que l'astuce.
- Référentiel : **ISTQB CTFL v4.0** (syllabus français). Citer la section ISTQB concernée dans chaque document de test.
- Langue : **documentation en français**, code, noms de classes/méthodes et messages de commit en anglais technique
  (sauf `@DisplayName`, en français, avec l'identifiant du cas).

## 2. Règles absolues (ne jamais enfreindre)

1. **Ne jamais inventer de résultat.** Aucun résultat de test, défaut, chiffre de couverture, temps de réponse ou
   comportement de ParaBank n'est écrit sans avoir été **exécuté ou observé**. Si une information manque, écrire
   `À VÉRIFIER` et le signaler.
2. **Ne jamais inventer de défaut.** Un défaut n'est rapporté que s'il a été reproduit au moins deux fois
   (voir `docs/conventions.md` §6). Un test qui échoue n'est pas automatiquement un défaut : analyser d'abord
   (erreur de test, environnement, ou vrai défaut).
3. **Ne jamais affaiblir un test pour le faire passer** (assertion supprimée, `@Disabled`, retry silencieux,
   `Thread.sleep`). Si le comportement réel diffère du comportement attendu d'une banque, le test garde
   l'assertion attendue et un défaut est documenté.
4. **Aucun secret dans le dépôt** : mots de passe, tokens, clés API passent par variables d'environnement,
   secrets GitHub ou credentials Jenkins. `.env` est ignoré par Git ; fournir `.env.example`.
5. **Ne jamais pousser sur `main`** ni faire de force push. Une branche par tâche, une pull request par étape.
6. **Ne jamais automatiser contre l'instance publique** `parabank.parasoft.com`. Toujours l'instance locale Docker
   (`http://localhost:8080/parabank`), version figée par digest (ADR-0001).
7. **S'arrêter à la fin de chaque étape** et attendre la validation de l'auteur avant de passer à la suivante.
8. **Ne pas supprimer** de fichier de documentation existant ni réécrire l'historique Git.
9. **Ne jamais ajouter de mention de Claude** (Co-Authored-By, Claude-Session, Generated with Claude Code)
   dans les commits, les pull requests ou les fichiers du dépôt.

## 3. Environnement et stack

| Élément | Valeur |
| --- | --- |
| Java | 17 (Temurin) |
| Build | Maven 3.9+ |
| Tests UI | Selenium WebDriver 4 (Selenium Manager), JUnit 5 (Jupiter), AssertJ |
| Tests unitaires | JUnit 5, Mockito (+ `mockito-junit-jupiter`), JaCoCo |
| Tests API | Postman (collection v2.1 versionnée), Newman + `newman-reporter-htmlextra` |
| CI | GitHub Actions (PR et push) ; Jenkins LTS dans Docker (campagne nocturne) |
| Suivi | Jira projet `PB` (connecteur Atlassian si disponible), Xray à partir de l'étape 6 |
| Système sous test | `docker compose up -d` → `http://localhost:8080/parabank/index.htm` |
| Admin ParaBank | `http://localhost:8080/parabank/admin.htm` (Initialize / Clean de la base) |
| API REST ParaBank | `http://localhost:8080/parabank/services/bank/...` (`Accept: application/json`) |

Versions des dépendances : utiliser la **dernière version stable** publiée sur Maven Central / npm au moment de
l'étape, la **figer** dans le `pom.xml` ou le `package.json`, et la noter dans `docs/environnement.md`.
Ne jamais deviner un numéro de version.

## 4. Structure cible du dépôt

```text
parabank-qa/
├── CLAUDE.md
├── README.md
├── docker-compose.yml
├── .env.example
├── .github/
│   ├── pull_request_template.md
│   └── workflows/ci.yml
├── Jenkinsfile
├── jenkins/                      # Jenkins as code (Dockerfile, casc.yaml, plugins.txt)
├── ui-tests/                     # Projet Maven : framework Selenium + tests UI
│   ├── pom.xml
│   └── src/{main,test}/java/com/abdel/parabank/...
├── api-tests/                    # Postman : collection, environnements, données
│   ├── ParaBank.postman_collection.json
│   ├── environments/{local,ci}.postman_environment.json
│   ├── data/*.csv
│   └── package.json              # newman + reporter, scripts npm
├── unit-tests/
│   └── parabank/                 # sous-module Git : fork de parasoft/parabank + tests unitaires
├── test-data/                    # jeux de données partagés (CSV, JSON)
├── scripts/                      # wait-for-parabank.sh, reset-db.sh, ...
└── docs/
    ├── environnement.md  conventions.md  journal.md
    ├── adr/              exploration/    base-de-test/
    ├── risk-analysis.md  test-plan/      test-design/
    ├── campagnes/        reports/        prompts/
    └── test-summary-report.md
```

## 5. Conventions (résumé — la référence est `docs/conventions.md`)

- Branches : `docs/…`, `test/…`, `feat/…`, `fix/…`, `ci/…`, `chore/…`.
- Commits : Conventional Commits (`test: add transfer boundary tests (PB-xx)`), un changement logique par commit.
- Identifiants : `REQ-xx`, `RISK-xx`, `TC-<MODULE>-xx`, `S-xx`, `A-xx`, `Q-xx`, `PB-xx`, `ADR-xxxx`.
  Modules : `LOG REG ACC TRF HIS BIL LOAN PRF`.
- Tags de baseline : `v0.2-base-de-test` … `v1.0.0` (voir `conventions.md` §4).
- Chaque test automatisé porte l'ID de son cas : `@DisplayName("TC-TRF-01 …")`, nom Postman `TC-TRF-01 …`.
- Tags JUnit : `@Tag("smoke")` ou `@Tag("regression")` (un test smoke est aussi exécuté en régression).

## 6. Qualité du code de test

- **Page Object Model** strict : locators et attentes dans les pages, assertions uniquement dans les tests.
- **Attentes explicites** uniquement (`WebDriverWait`). Interdit : `Thread.sleep`, mélange attente implicite/explicite.
- Locators : `id` > `name` > CSS > XPath. Pour un id généré aléatoirement (champ téléphone de Bill Pay),
  utiliser l'attribut `name`.
- **Indépendance des tests** : chaque test crée ses propres données (de préférence via l'API REST), s'exécute
  dans n'importe quel ordre et en parallèle (`ThreadLocal<WebDriver>`).
- Principes **F.I.R.S.T.**, structure **Arrange / Act / Assert**, un comportement vérifié par test.
- Données de test hors du code (`@CsvFileSource`, `test-data/`), identifiants uniques par exécution.
- Configuration par `config.properties` surchargeable en `-D` ou variable d'environnement.
- Une capture d'écran + le code source de la page sont enregistrés automatiquement en cas d'échec.
- Mockito : ne simuler que les dépendances de l'unité testée, vérifier les interactions significatives
  (`verify`, `ArgumentCaptor`), pas de mock de types valeur.
- Formatage automatique (Spotless / google-java-format) ; aucun avertissement de compilation ignoré.

## 7. Méthode de travail de Claude Code

1. **Lire avant d'écrire** : `README.md`, `docs/conventions.md`, les livrables de l'étape précédente.
2. **Planifier** : avant de coder, présenter le plan de l'étape (fichiers créés, choix, risques) et attendre
   l'accord si un choix est discutable.
3. **Petits incréments** : écrire → exécuter → vérifier → commiter. Ne jamais livrer du code non exécuté.
4. **Vérifier** avant de déclarer une tâche finie : build vert, tests exécutés, rapport ouvert, documents relus.
5. **Tracer** : mettre à jour `docs/journal.md`, le README (tableau de statut) et les tickets Jira de l'étape.
6. **Rendre compte** en fin d'étape : ce qui a été fait, résultats réels (chiffres exécutés), défauts trouvés,
   points ouverts, commandes pour reproduire. Puis **s'arrêter**.

## 8. Commandes utiles

```bash
docker compose up -d && ./scripts/wait-for-parabank.sh     # démarrer ParaBank
./scripts/reset-db.sh                                     # Clean + Initialize de la base
mvn -f ui-tests -B test -Dgroups=smoke -Dheadless=true    # suite UI smoke
mvn -f ui-tests -B test -Dheadless=true                   # suite UI complète
npm --prefix api-tests run test:ci                        # Newman
mvn -f unit-tests/parabank -B verify                      # tests unitaires + JaCoCo
```
