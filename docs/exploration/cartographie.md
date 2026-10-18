# Cartographie de ParaBank

**Objet :** inventaire de toutes les pages de ParaBank, de leurs champs, de leurs actions et des règles visibles,
pour préparer l'exploration (étape 2) puis la rédaction de la base de test (étape 3).

**Sources :**

- pages publiques de `parabank.parasoft.com` (sans connexion) ;
- code source officiel `github.com/parasoft/parabank` (fichiers JSP et `messages.properties`) pour les pages qui
  demandent une connexion ;
- **à confirmer** pendant les sessions exploratoires sur l'instance locale (version figée, voir `environnement.md`).

> Règle : ce document décrit ce que l'application **affiche et annonce**. Ce qu'elle **fait vraiment** est vérifié
> pendant les sessions S-01 à S-05. Tout écart devient une anomalie `A-xx`.

**Légende de la colonne Statut :** ⏳ à explorer · ✅ exploré · ⚠️ anomalie trouvée

---

## 1. Vue d'ensemble

| Zone | Pages | Connexion requise |
| --- | --- | --- |
| Pages publiques | Accueil, About Us, Services, News, Site Map, Contact Us | Non |
| Accès client | Connexion, Register, Forgot login info? (Customer Lookup) | Non |
| Account Services | Open New Account, Accounts Overview, Account Activity, Transfer Funds, Bill Pay, Find Transactions, Update Contact Info, Request Loan, Log Out | **Oui** |
| Administration | Admin Page | Non (accessible sans connexion) |
| Services techniques | Services REST (WADL, OpenAPI), service SOAP (WSDL), LoanProcessor (WSDL) | — |

Les pages connectées appellent toutes l'API REST via `services_proxy/bank/...` : chaque action de l'interface
a donc un équivalent testable au niveau API (étape 9).

---

## 2. Pages publiques et accès client

| Page | URL | Champs / actions | Règles et messages annoncés | Questions à explorer | Statut |
| --- | --- | --- | --- | --- | --- |
| Accueil + panneau de connexion | `/index.htm` | `username` (texte), `password` (mot de passe), bouton **Log In** ; liens *Forgot login info?*, *Register* | Champs vides : « Please enter a username and password. » ; identifiants faux : « The username and password could not be verified. » | Q-01 Sensibilité à la casse du username ? Q-02 Espaces avant/après ? Q-03 Nombre d'essais limité ? Q-04 Que fait le bouton Retour après déconnexion ? | ⏳ |
| Liens du menu gauche | `/index.htm` | *ATM Services* (Withdraw, Transfer, Check Balances, Deposits) et *Online Services* (Bill Pay, Account History, Transfer) | Ces liens pointent vers les descriptions techniques des services (WSDL / WADL), pas vers des pages utilisateur | Q-05 Est-ce le comportement voulu pour un client ? (point à noter, voir S-01) | ⏳ |
| Register | `/register.htm` | `customer.firstName`, `customer.lastName`, `customer.address.street`, `customer.address.city`, `customer.address.state`, `customer.address.zipCode`, `customer.phoneNumber`, `customer.ssn`, `customer.username`, `customer.password`, `repeatedPassword` ; bouton **Register** | Messages « … is required » pour chaque champ obligatoire ; « Passwords did not match. » ; « This username already exists. » | Q-06 Le téléphone est-il obligatoire ? Q-07 Format et longueur du SSN, du Zip, du téléphone ? Q-08 Longueur max des champs ? Q-09 Règles de mot de passe (longueur, complexité) ? Q-10 Caractères spéciaux et HTML acceptés ? Q-11 Connexion automatique après inscription ? | ⏳ |
| Customer Lookup (Forgot login info?) | `/lookup.htm` | `firstName`, `lastName`, `address.street`, `address.city`, `address.state`, `address.zipCode`, `ssn` ; bouton **Find My Login Info** | Client inconnu : « The customer information provided could not be found. » | Q-12 Qu'affiche la page en cas de succès (le mot de passe en clair ?) Q-13 Le SSN seul suffit-il ? | ⏳ |
| Contact Us | `/contact.htm` | `name`, `email`, `phone`, `message` ; bouton **Send to Customer Care** | « Name / Email / Phone / Message is required. » | Q-14 Format de l'email vérifié ? | ⏳ |
| About Us, Services, News, Site Map | `/about.htm`, `/services.htm`, `/news.htm`, `/sitemap.htm` | Liens uniquement | — | Q-15 Liens cassés ? (vérification rapide) | ⏳ |

---

## 3. Account Services (connexion requise)

| Page | URL | Champs / actions | Règles et messages annoncés | Appel API utilisé | Questions à explorer | Statut |
| --- | --- | --- | --- | --- | --- | --- |
| Accounts Overview | `/overview.htm` | Tableau `accountTable` : numéro de compte (lien), solde, solde disponible, total | — | `GET customers/{customerId}/accounts` | Q-16 Le total est-il la somme exacte des soldes ? Q-17 Différence entre « Balance » et « Available Amount » ? Q-18 Affichage d'un solde négatif ? | ⏳ |
| Account Activity (détail d'un compte) | `/activity.htm?id={accountId}` | Détails : `accountId`, `accountType`, `balance`, `availableBalance` ; filtres `month` et `transactionType`, bouton **Go** ; tableau des transactions | « No transactions found. » | `GET accounts/{id}`, `GET accounts/{id}/transactions/month/{mois}/type/{type}` | Q-19 Peut-on afficher le compte d'un autre client en changeant `id` dans l'URL ? Q-20 Les filtres combinés fonctionnent-ils ? | ⏳ |
| Open New Account | `/openaccount.htm` | `type` (liste : CHECKING, SAVINGS), `fromAccountId` (liste), bouton **Open New Account** ; résultat `newAccountId` | « A minimum of $X must be deposited into this account at time of opening. » (montant paramétré dans l'admin) | `POST createAccount?customerId&newAccountType&fromAccountId` | Q-21 Le compte source est-il bien débité du dépôt minimum ? Q-22 Que se passe-t-il si le compte source a un solde inférieur au minimum ? Q-23 Le nouveau compte apparaît-il dans l'Overview ? | ⏳ |
| Transfer Funds | `/transfer.htm` | `amount`, `fromAccountId`, `toAccountId`, bouton **Transfer** ; résultat `amountResult`, `fromAccountIdResult`, `toAccountIdResult` | « The amount cannot be empty. » ; « Please enter a valid amount. » | `POST transfer?fromAccountId&toAccountId&amount` | Q-24 Montant > solde : refusé, accepté, découvert ? Q-25 Montant 0 ou négatif ? Q-26 Même compte en source et en cible ? Q-27 Nombre de décimales accepté (0,001) ? Q-28 Très grand montant ? Q-29 Les deux comptes sont-ils mis à jour ensemble ? | ⏳ |
| Bill Pay | `/billpay.htm` | `payee.name`, `payee.address.street`, `payee.address.city`, `payee.address.state`, `payee.address.zipCode`, `payee.phoneNumber`, `payee.accountNumber`, `verifyAccount`, `amount`, liste `fromAccountId`, bouton **Send Payment** | Champs obligatoires ; « The account numbers do not match. » ; « Please enter a valid number. » | `POST billpay?accountId&amount` | Q-30 Montant > solde ? Q-31 Le compte du bénéficiaire doit-il exister dans ParaBank ? Q-32 Le paiement apparaît-il dans l'historique ? Q-33 Le champ téléphone a un id aléatoire : impact sur l'automatisation (à noter pour l'étape 8) | ⏳ |
| Find Transactions | `/findtrans.htm` | `accountId` (liste) ; 4 recherches indépendantes : `transactionId` + bouton `findById`, `transactionDate` + `findByDate`, `fromDate` / `toDate` + `findByDateRange`, `amount` + `findByAmount` ; résultat `transactionTable` | Format de date `MM-DD-YYYY` ; « … is required. » ; « Please enter a valid date. » | `GET transactions/{id}`, `GET accounts/{id}/transactions/...` | Q-34 Autres formats de date acceptés ? Q-35 Date de début > date de fin ? Q-36 Recherche d'un ID de transaction d'un autre client ? Q-37 Montant décimal ou négatif ? | ⏳ |
| Update Contact Info | `/updateprofile.htm` | `customer.firstName`, `customer.lastName`, `customer.address.street`, `customer.address.city`, `customer.address.state`, `customer.address.zipCode`, `customer.phoneNumber`, bouton **Update Profile** | « First name / Last name / Address / City / State / Zip Code is required. » | `GET customers/{id}`, `POST customers/update/{id}` | Q-38 Le téléphone est-il obligatoire ici ? Q-39 La modification est-elle conservée après déconnexion ? Q-40 Peut-on vider le nom ? | ⏳ |
| Request Loan | `/requestloan.htm` | `amount`, `downPayment`, `fromAccountId`, bouton **Apply Now** ; résultat `loanProviderName`, `responseDate`, `loanStatus`, `newAccountId` | « The loan amount cannot be empty. » ; « The down payment cannot be empty. » ; 4 motifs de refus : fonds insuffisants, fonds insuffisants pour l'apport, apport insuffisant, fonds et apport insuffisants | `POST requestLoan?customerId&amount&downPayment&fromAccountId` | Q-41 Quelle règle d'acceptation exactement (seuil en %) ? Q-42 Apport > montant du prêt ? Q-43 Apport débité du compte source ? Q-44 Le compte de prêt (type LOAN) apparaît-il dans l'Overview ? | ⏳ |
| Log Out | `/logout.htm` | Lien | — | — | Q-45 Une page connectée reste-t-elle accessible après déconnexion (URL directe, bouton Retour) ? | ⏳ |

Types de comptes existants dans l'application : **CHECKING**, **SAVINGS** (ouvrables par le client) et **LOAN**
(créé automatiquement quand un prêt est accordé).

---

## 4. Administration

| Section | Éléments | Rôle pour le projet | Questions | Statut |
| --- | --- | --- | --- | --- |
| Database | Boutons **Initialize** et **Clean** | Remettre les données dans un état connu avant chaque campagne | Q-46 Que contient la base après Initialize (clients, comptes) ? | ⏳ |
| JMS Service | Statut (Running) | Fournisseur de prêt JMS | — | ⏳ |
| Data Access Mode | SOAP, REST (XML), REST (JSON), JDBC (défaut) | Change la façon dont l'interface lit les données | Q-47 Le comportement fonctionnel change-t-il selon le mode ? (hors périmètre sauf JDBC et REST JSON) | ⏳ |
| Web Service | Liens WSDL, WADL, OpenAPI ; champs SOAP Endpoint, REST Endpoint | **Le lien OpenAPI documente l'API REST** : source principale pour l'étape 9 | — | ⏳ |
| LoanProcessor Service | Lien WSDL, champ Endpoint | — | — | ⏳ |
| Application Settings | Init. Balance ($), Min. Balance ($), Loan Provider (JMS / Web Service / Local), Loan Processor (Available Funds / Down Payment / Combined), Threshold (%) | **Paramètres qui changent les règles métier** : solde initial des comptes, dépôt minimum, règle d'accord des prêts | Q-48 Valeurs par défaut ? (les noter dans `environnement.md`) Q-49 La page admin est accessible sans connexion : est-ce un risque ? | ⏳ |

> Les réglages de *Application Settings* font partie de la **configuration de test** : ils doivent être notés et
> remis à l'identique avant chaque campagne, sinon les résultats des tests ne sont pas comparables.

---

## 5. Synthèse pour la suite

| Élément | Nombre | Utilisation |
| --- | --- | --- |
| Pages fonctionnelles | 16 | Base de test (étape 3) |
| Formulaires | 10 | Partitions d'équivalence et valeurs limites (étape 6) |
| Appels API REST identifiés | 10 | Tests d'API (étape 9) |
| Questions ouvertes | 49 | Exploration (S-01 à S-05), puis exigences REQ-xx |

Correspondance questions → sessions :

| Session | Questions |
| --- | --- |
| S-01 Inscription et pages publiques | Q-05 à Q-15 |
| S-02 Connexion et session | Q-01 à Q-04, Q-19, Q-36, Q-45, Q-49 |
| S-03 Virements et ouverture de compte | Q-16 à Q-18, Q-21 à Q-29 |
| S-04 Paiement de factures, prêt, profil | Q-30 à Q-33, Q-38 à Q-44 |
| S-05 Historique et recherche | Q-20, Q-32, Q-34 à Q-37, Q-46 à Q-48 |
