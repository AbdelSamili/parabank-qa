# Conventions du projet ParaBank QA

Ce document fixe les règles de travail du projet. Il applique la **gestion de configuration** de l'ISTQB CTFL v4.0
(section 5.4) : chaque élément de testware est identifié, versionné et traçable, et chaque version validée
devient une base de référence (baseline). Il définit aussi le processus de **gestion des défauts** (section 5.5)
avant que le premier défaut ne soit trouvé.

---

## 1. Branches

La branche `main` est protégée par un ruleset GitHub (`protection-main`) :

- aucun push direct sur `main` ;
- toute modification passe par une pull request ;
- suppression et force push de `main` interdits ;
- fusion en mode *squash* uniquement (un commit propre par pull request).

Les branches de travail sont courtes (une tâche = une branche) et suivent ce nommage :

| Préfixe | Usage | Exemple |
| --- | --- | --- |
| `docs/` | Documentation de test (plan, exigences, rapports) | `docs/plan-de-test` |
| `test/` | Code de test (Selenium, Postman, JUnit) | `test/virement-ui` |
| `feat/` | Outillage ou framework de test | `feat/driver-factory` |
| `fix/` | Correction d'un test ou d'un script | `fix/attente-login` |
| `ci/` | Pipelines GitHub Actions ou Jenkins | `ci/newman-github-actions` |
| `chore/` | Maintenance (dépendances, configuration) | `chore/mise-a-jour-selenium` |

Une branche est supprimée après la fusion de sa pull request.

---

## 2. Commits

Les messages suivent **Conventional Commits** : `type: description courte à l'impératif`.

| Type | Usage | Exemple |
| --- | --- | --- |
| `docs` | Documentation | `docs: ajout de la base de test` |
| `test` | Ajout ou modification de tests | `test: ajout des cas limites du virement` |
| `feat` | Nouvel outillage de test | `feat: ajout de la DriverFactory` |
| `fix` | Correction | `fix: remplacement d'une attente fixe par une attente explicite` |
| `ci` | Intégration continue | `ci: exécution de Newman dans GitHub Actions` |
| `chore` | Maintenance | `chore: mise à jour de Selenium en 4.x` |

Règles :

- un changement logique par commit ;
- le message dit **quoi** et, si besoin, **pourquoi** dans le corps du commit ;
- la référence Jira est ajoutée quand elle existe : `test: cas limites du virement (PB-12)`.

---

## 3. Pull requests

- Chaque pull request utilise le modèle `.github/pull_request_template.md`.
- Elle est liée à un ticket Jira `PB-xx`.
- Avant la fusion, l'auteur relit l'onglet *Files changed* (auto-revue) et coche la checklist.
- À partir de l'étape 11, la fusion est bloquée tant que les contrôles de la CI ne sont pas verts.

---

## 4. Versions et bases de référence

Un tag Git est posé à chaque jalon validé. Chaque tag est une **baseline** : on peut toujours retrouver l'état exact
du testware à ce jalon.

| Tag | Jalon |
| --- | --- |
| `v0.1-exploration` | Exploration et cartographie terminées |
| `v0.2-base-de-test` | Exigences REQ-xx rédigées |
| `v0.3-risques` | Analyse des risques terminée |
| `v0.4-plan-de-test` | Plan de test validé |
| `v0.5-cas-de-test` | Cas de test conçus |
| `v0.6-campagne-manuelle` | Première campagne manuelle exécutée |
| `v0.7-ui-auto` | Tests UI automatisés |
| `v0.8-api-auto` | Tests d'API automatisés |
| `v0.9-unitaires` | Tests unitaires et couverture |
| `v1.0.0` | Projet complet, rapport de clôture livré |

La version de l'application testée est également figée (digest Docker), voir `docs/environnement.md`.

---

## 5. Identifiants

Chaque élément de testware a un identifiant unique, utilisé partout (documents, code, Jira) pour assurer la traçabilité.

| Élément | Format | Exemple |
| --- | --- | --- |
| Exigence (base de test) | `REQ-xx` | `REQ-07` |
| Risque produit | `RISK-xx` | `RISK-03` |
| Cas de test | `TC-<MODULE>-xx` | `TC-TRF-04` |
| Session exploratoire | `S-xx` | `S-03` |
| Anomalie (avant analyse) | `A-xx` | `A-05` |
| Question ouverte | `Q-xx` | `Q-02` |
| Ticket Jira (tâche, bug) | `PB-xx` | `PB-14` |
| Décision d'architecture | `ADR-xxxx` | `ADR-0001` |

Codes des modules :

| Code | Module |
| --- | --- |
| `LOG` | Connexion / déconnexion |
| `REG` | Inscription |
| `ACC` | Comptes (vue, ouverture) |
| `TRF` | Virements |
| `HIS` | Historique et recherche de transactions |
| `BIL` | Paiement de factures |
| `LOAN` | Demande de prêt |
| `PRF` | Mise à jour des coordonnées |

Dans le code de test, l'identifiant du cas apparaît dans le `@DisplayName` :
`@DisplayName("TC-TRF-01 Virement d'un montant inférieur au solde")`.

---

## 6. Gestion des défauts

### 6.1 Anomalie ou défaut ?

Une **anomalie** est un écart observé entre le résultat attendu et le résultat obtenu. Elle n'est pas forcément un
défaut : après analyse, elle peut être un faux positif, une demande d'évolution ou un doublon (ISTQB 5.5).

Règle du projet : une anomalie devient un **Bug Jira** seulement si elle a été **reproduite au moins deux fois**.
Sinon, elle reste notée comme anomalie `A-xx` ou question `Q-xx` dans la fiche de session.

### 6.2 Cycle de vie d'un défaut (workflow Jira)

```text
Ouvert → En analyse → En correction → À confirmer → Fermé
              │              │               │
              ├→ Rejeté      ├→ Différé      └→ Réouvert → En analyse
              └→ Dupliqué
```

| Statut | Signification |
| --- | --- |
| Ouvert | Défaut signalé, pas encore analysé |
| En analyse | Reproduction et qualification en cours |
| En correction | Défaut confirmé, correction attendue |
| À confirmer | Correction livrée, test de confirmation à exécuter |
| Fermé | Test de confirmation réussi |
| Rejeté | Pas un défaut (comportement attendu, erreur de test) |
| Dupliqué | Déjà signalé dans un autre ticket |
| Différé | Défaut accepté mais non corrigé dans cette version |
| Réouvert | Le test de confirmation a échoué |

ParaBank étant une application de démonstration que nous ne corrigeons pas, la plupart des défauts confirmés
resteront à l'état **Différé**. Ils sont tout de même documentés complètement et couverts par un test de non-régression.

### 6.3 Sévérité

La **sévérité** mesure l'impact du défaut sur le système et l'utilisateur.

| Sévérité | Définition | Exemple dans ParaBank |
| --- | --- | --- |
| Critique | Perte, création ou mauvais calcul d'argent ; accès aux données d'un autre client ; faille de sécurité | Un virement débite le compte source sans créditer le compte cible |
| Majeure | Fonctionnalité principale inutilisable, sans contournement | Impossible d'ouvrir un compte épargne |
| Mineure | Fonctionnalité dégradée, un contournement existe | La recherche par date échoue, mais la recherche par montant fonctionne |
| Triviale | Problème cosmétique, sans impact fonctionnel | Faute d'orthographe dans un libellé |

### 6.4 Priorité

La **priorité** indique l'urgence de traitement. Elle est distincte de la sévérité.

| Priorité | Signification |
| --- | --- |
| Haute | À traiter avant la prochaine campagne |
| Moyenne | À traiter dans le sprint |
| Basse | À traiter si le temps le permet |

### 6.5 Contenu obligatoire d'un rapport de défaut

Conformément à l'ISTQB (section 5.5) :

1. **Identifiant** : `PB-xx` (attribué par Jira)
2. **Titre** : résumé court du problème
3. **Date, auteur**
4. **Objet de test et environnement** : module, version de ParaBank (digest), navigateur et version
5. **Contexte** : cas de test ou session exploratoire qui a révélé le défaut
6. **Étapes de reproduction** : minimales et numérotées
7. **Résultat attendu / résultat obtenu**
8. **Sévérité et priorité**
9. **Preuves** : capture d'écran, journal, sortie Newman
10. **Statut**
11. **Références** : cas de test lié (`TC-xx`), exigence liée (`REQ-xx`)

Le ton est factuel et neutre : on décrit le comportement, jamais une personne.

---

## 7. Documentation

- Toute la documentation est en Markdown, dans le dossier `docs/`, versionnée avec le code.
- Chaque décision technique importante est consignée dans un ADR (`docs/adr/ADR-xxxx-titre.md`).
- Le journal de bord (`docs/journal.md`) est mis à jour à chaque séance de travail.
