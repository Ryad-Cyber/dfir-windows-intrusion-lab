# DFIR Windows Intrusion Lab

Investigation forensic préparée sur un poste de travail **Windows** compromis, combinant l'analyse d'image disque (**Autopsy**), l'analyse de capture mémoire (**Volatility 3**) et le suivi d'incident (**TheHive**).

> **État d'avancement : préparation terminée, investigation à réaliser.**
> Ce dépôt contient le scénario, l'environnement, la méthodologie et les gabarits de documentation. Aucune analyse n'a encore été menée : les constats, la chronologie, les indicateurs de compromission et les recommandations réelles seront ajoutés à ce README au fur et à mesure de l'investigation.

## Sommaire

- [Contexte](#contexte)
- [Objectifs](#objectifs)
- [Jeu de données](#jeu-de-données)
- [Environnement et outils](#environnement-et-outils)
- [Méthodologie prévue](#méthodologie-prévue)
- [Structure du dépôt](#structure-du-dépôt)
- [Livrables attendus](#livrables-attendus)
- [État d'avancement](#état-davancement-1)
- [Limites et cadre d'utilisation](#limites-et-cadre-dutilisation)

## Contexte

Ce projet personnel a pour but de pratiquer une investigation numérique complète — de la collecte des indices à la documentation de l'incident — sur un cas d'intrusion visant un poste de travail Windows. Il s'inscrit dans une démarche de montée en compétences en forensic numérique et réponse à incident (DFIR), en complément de mes projets de détection SOC ([Lab SOC Elastic Security](https://github.com/Ryad-Cyber/elastic-security-soc-lab), [Lab Wazuh](https://github.com/Ryad-Cyber/wazuh-siem-detection-lab)) et de pentest.

## Objectifs

- Analyser une image disque Windows avec **Autopsy** : système de fichiers, artefacts utilisateur, journaux d'événements, persistance.
- Analyser une capture mémoire correspondante avec **Volatility 3** : processus, connexions réseau, injections de code, artefacts en mémoire absents du disque.
- Recouper les constats des deux analyses pour construire une **chronologie unique** de l'intrusion.
- Identifier des **indicateurs de compromission (IOC)** exploitables (processus, fichiers, clés de registre, connexions réseau).
- Centraliser et documenter l'incident dans **TheHive**, sous forme de cas structuré avec tâches et observables.
- Produire des **recommandations de remédiation et de détection** réalistes, directement liées aux constats.

## Jeu de données

L'investigation s'appuiera sur **Stolen Szechuan Sauce**, un cas d'entraînement DFIR public créé par 13Cubed, largement utilisé dans la communauté forensic et diffusé à des fins pédagogiques. Le scénario met en scène le vol d'une recette d'entreprise (« la sauce ») depuis le poste de travail d'un employé, et fournit :

- une image disque du poste de travail Windows concerné ;
- une capture mémoire (RAM) correspondante.

Ce jeu de données a été choisi car il réunit, pour un **même incident**, une image disque et une capture mémoire cohérentes entre elles — condition nécessaire pour recouper réellement les deux analyses et construire une chronologie unique, plutôt que de combiner artificiellement deux cas sans rapport.

**Alternative de repli** si ce jeu de données venait à ne plus être accessible : les images disque publiques du projet **NIST CFReDS** (Computer Forensic Reference Data Sets, domaine public) pour la partie Autopsy, associées à un échantillon mémoire public du dépôt **Volatility Foundation** (`samples`, utilisés pour les tests officiels de l'outil) pour la partie Volatility. Cette alternative est documentée dans [`docs/scenario.md`](docs/scenario.md) au cas où elle serait nécessaire ; dans ce cas, la chronologie recoupera deux sources distinctes et ce README le précisera explicitement.

Aucune image disque ni capture mémoire n'est incluse dans ce dépôt (taille, droits de diffusion) : voir [`docs/prerequisites.md`](docs/prerequisites.md) pour se les procurer.

## Environnement et outils

| Outil | Rôle | Version prévue |
|---|---|---|
| [Autopsy](https://www.autopsy.com/) | Analyse de l'image disque : système de fichiers, artefacts, timeline | 4.21+ |
| [Volatility 3](https://github.com/volatilityfoundation/volatility3) | Analyse de la capture mémoire : processus, réseau, injections | 2.x |
| [TheHive](https://thehive-project.org/) | Gestion de cas, centralisation des observables et des tâches | 5.x (Community) |

Matériel utilisé : poste personnel (Intel i7-1255U, 16 Go de RAM), suffisant pour l'analyse statique d'une image disque et d'une capture mémoire de cette taille sans virtualisation lourde. Aucune machine virtuelle compromise n'est exécutée : seules des copies statiques (image disque, dump mémoire) sont analysées, dans un répertoire de travail dédié et hors de tout réseau de production.

Détails d'installation et prérequis complets : [`docs/prerequisites.md`](docs/prerequisites.md).

## Méthodologie prévue

Déroulé prévu de l'investigation, détaillé dans [`docs/methodologie.md`](docs/methodologie.md) :

1. **Préparation** — vérification des empreintes (hash) de l'image disque et de la capture mémoire, mise en place d'un répertoire de travail en lecture seule sur les preuves.
2. **Analyse disque (Autopsy)** — ingestion de l'image, revue des artefacts utilisateur (historique, téléchargements, documents récents), des journaux d'événements Windows, des clés de persistance (Run/RunOnce, tâches planifiées, services) et des horodatages du système de fichiers (MACB).
3. **Analyse mémoire (Volatility 3)** — identification du profil système, liste des processus (`pslist`, `pstree`), connexions réseau (`netscan`), recherche d'injections de code (`malfind`), extraction des lignes de commande (`cmdline`), revue des DLL chargées et des fichiers ouverts au moment de la capture.
4. **Recoupement et chronologie** — mise en correspondance des constats disque et mémoire (un processus suspect en mémoire retrouvé sur disque, un fichier créé au moment d'une connexion réseau suspecte, etc.) dans une chronologie unique.
5. **Indicateurs de compromission** — consolidation des IOC identifiés (nom de processus, hash de fichier, chemin, clé de registre, IP/domaine) dans un tableau exploitable.
6. **Documentation dans TheHive** — création du cas, ajout des observables, suivi des tâches d'investigation, journal des actions menées.
7. **Conclusions et remédiation** — rédaction des constats, de la chronologie finale et de recommandations de remédiation et de détection directement liées aux constats observés (pas de recommandations génériques).

Chaque étape produira des notes et, le cas échéant, des captures d'écran réellement obtenues, qui remplaceront progressivement les sections encore vides de ce README.

## Structure du dépôt

```
dfir-windows-intrusion-lab/
├── README.md                          Ce fichier
├── LICENSE
├── .gitignore                         Exclut les preuves (images disque, dumps mémoire, exports TheHive)
├── docs/
│   ├── scenario.md                    Scénario détaillé et jeu de données
│   ├── prerequisites.md               Installation des outils, obtention des preuves, vérification des hash
│   └── methodologie.md                Méthodologie détaillée, étape par étape, avec commandes de référence
├── templates/
│   ├── rapport_incident_template.md   Gabarit de rapport d'incident à remplir
│   ├── chronologie_template.csv       Gabarit de chronologie (timeline)
│   └── ioc_template.csv               Gabarit de suivi des indicateurs de compromission
├── scripts/
│   ├── volatility_quickstart.ps1      Enchaîne les plugins Volatility 3 de base et range les sorties
│   └── autopsy_ingest_checklist.md    Checklist des modules d'ingestion et artefacts à vérifier dans Autopsy
└── examples/
    ├── exemple_ioc.csv                Exemple de tableau d'IOC avec données fictives
    └── exemple_case_thehive.json      Exemple de structure de cas TheHive avec données fictives
```

Les fichiers des dossiers `templates/` et `examples/` contiennent des **données fictives**, clairement indiquées comme telles, destinées à illustrer le format attendu avant que l'investigation ne produise des données réelles.

## Livrables attendus

À l'issue de l'investigation, ce dépôt contiendra :

- une chronologie consolidée de l'intrusion (disque + mémoire) ;
- un tableau d'indicateurs de compromission réels ;
- des captures d'écran commentées des analyses Autopsy et Volatility réellement réalisées ;
- un export ou une description du cas TheHive documenté ;
- un rapport d'incident complet avec recommandations de remédiation.

## État d'avancement

- [x] Choix du scénario et du jeu de données
- [x] Définition de la méthodologie et des outils
- [x] Préparation des gabarits de documentation (rapport, chronologie, IOC)
- [x] Script d'aide à l'exécution des plugins Volatility
- [ ] Obtention et vérification des preuves (image disque, capture mémoire)
- [ ] Analyse disque avec Autopsy
- [ ] Analyse mémoire avec Volatility 3
- [ ] Recoupement et chronologie
- [ ] Documentation du cas dans TheHive
- [ ] Rapport final et recommandations

## Limites et cadre d'utilisation

Ce projet est un exercice personnel de démonstration de compétences en DFIR, basé sur un jeu de données public conçu pour l'entraînement forensic. Il ne constitue ni une preuve légale ni un rapport d'expertise judiciaire. La méthodologie suit les grands principes d'une investigation réelle (préservation des preuves, documentation, recoupement des sources) mais est appliquée ici hors de toute chaîne de custody formelle.
