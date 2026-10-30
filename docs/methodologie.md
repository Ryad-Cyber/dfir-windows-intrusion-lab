# Méthodologie

Déroulé prévu, étape par étape. Les commandes listées sont des points de départ ; la liste réelle des plugins/modules utilisés sera ajustée selon ce qu'ils révèlent et consignée dans le rapport final.

## 1. Préparation

- Calcul et consignation des empreintes SHA-256 de l'image disque et de la capture mémoire ([`prerequisites.md`](prerequisites.md)).
- Création du répertoire de travail (`work/autopsy_case`, `work/volatility_out`).
- Ouverture du rapport d'incident ([`templates/rapport_incident_template.md`](../templates/rapport_incident_template.md)) pour consigner chaque étape au fil de l'eau, horodatée.

## 2. Analyse disque — Autopsy

1. Création d'un nouveau cas, ajout de l'image disque comme source de données.
2. Modules d'ingestion activés : système de fichiers, artefacts récents, hachage, extraction de métadonnées EXIF, recherche de mots-clés (nom de la « recette »/du document sensible, extensions de fichiers pertinentes).
3. Revue ciblée (checklist complète dans [`scripts/autopsy_ingest_checklist.md`](../scripts/autopsy_ingest_checklist.md)) :
   - Fichiers récents, dossiers Téléchargements/Bureau/Documents.
   - Historique de navigation, téléchargements, recherches.
   - Journaux d'événements Windows (connexions, exécution de processus si journalisé, insertion de périphériques USB).
   - Clés de persistance : `Run`/`RunOnce`, tâches planifiées, services.
   - Horodatages MACB (Modified / Accessed / Created / entry modified) des fichiers d'intérêt.
   - Corbeille, fichiers supprimés récupérables.
4. Export des constats pertinents (captures d'écran, listes de fichiers, horodatages) vers le dossier de travail.

## 3. Analyse mémoire — Volatility 3

Plugins de référence, à exécuter via [`scripts/volatility_quickstart.ps1`](../scripts/volatility_quickstart.ps1) :

```powershell
# Identification du profil / informations système
vol -f memory.raw windows.info

# Processus
vol -f memory.raw windows.pslist
vol -f memory.raw windows.pstree

# Réseau
vol -f memory.raw windows.netscan

# Lignes de commande et variables d'environnement des processus
vol -f memory.raw windows.cmdline
vol -f memory.raw windows.envars

# Recherche d'injections de code / processus suspects
vol -f memory.raw windows.malfind

# DLL chargées par un processus suspect (PID à adapter selon les constats)
vol -f memory.raw windows.dlllist --pid <PID>

# Fichiers ouverts au moment de la capture
vol -f memory.raw windows.filescan

# Registre chargé en mémoire (clés de persistance)
vol -f memory.raw windows.registry.printkey --key "Software\Microsoft\Windows\CurrentVersion\Run"
```

Pour chaque plugin : noter les résultats bruts dans `work/volatility_out/`, puis ne retenir dans le rapport que les éléments effectivement exploitables (processus inconnu, connexion réseau inattendue, artefact absent du disque).

## 4. Recoupement et chronologie

- Reporter chaque élément daté (disque et mémoire) dans [`templates/chronologie_template.csv`](../templates/chronologie_template.csv) : horodatage, source (Autopsy/Volatility), artefact, description, hypothèse associée.
- Rechercher les correspondances temporelles entre les deux sources (ex. création d'un fichier sur disque au moment d'une connexion réseau observée en mémoire).
- Trier chronologiquement et ne conserver que les éléments qui contribuent réellement à expliquer l'incident.

## 5. Indicateurs de compromission

- Consolider dans [`templates/ioc_template.csv`](../templates/ioc_template.csv) : nom/chemin de processus, hash de fichier, clé de registre, adresse IP ou domaine, avec leur source et leur niveau de confiance.
- Ne documenter que des IOC réellement observés dans l'image ou la capture — pas d'indicateurs génériques non vérifiés sur ce cas.

## 6. Documentation dans TheHive

- Création d'un cas avec un résumé de l'incident, sévérité et TLP adaptés au contexte (cas d'entraînement).
- Ajout des observables (IOC) identifiés à l'étape précédente, avec leur type et leur description.
- Création de tâches correspondant aux étapes de l'investigation (analyse disque, analyse mémoire, recoupement, rapport), cochées au fur et à mesure.
- Le format attendu est illustré avec des données fictives dans [`examples/exemple_case_thehive.json`](../examples/exemple_case_thehive.json).

## 7. Conclusions et remédiation

- Rédaction des constats finaux à partir de la chronologie et des IOC consolidés.
- Recommandations de remédiation et de détection directement liées aux constats (par exemple : règle de détection pour le comportement observé, durcissement du point d'entrée identifié) plutôt que des recommandations génériques de sécurité.
- Mise à jour du README principal (section « État d'avancement » et ajout des constats réels) une fois chaque étape terminée.
