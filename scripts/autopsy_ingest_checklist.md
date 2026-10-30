# Checklist d'ingestion et de revue Autopsy

## Création du cas

- [ ] Nouveau cas créé, nom explicite (ex. `dfir-windows-intrusion-lab`)
- [ ] Image disque ajoutée comme source de données
- [ ] Fuseau horaire du système source vérifié/renseigné

## Modules d'ingestion à activer

- [ ] Analyse du système de fichiers (Recent Activity)
- [ ] Hash Lookup (constitution/consultation d'une base de hash connus)
- [ ] Extraction de métadonnées (EXIF, etc.)
- [ ] Recherche de mots-clés (nom du document sensible, extensions pertinentes : `.docx`, `.pdf`, `.zip`, `.7z`, `.xlsx`)
- [ ] Email Parser (si boîte mail locale présente)
- [ ] Registry Analysis (clés de persistance, USB, utilisateurs)

## Revue ciblée après ingestion

### Activité utilisateur
- [ ] Fichiers récents (`Recent Documents`)
- [ ] Dossiers Bureau / Téléchargements / Documents
- [ ] Historique et téléchargements des navigateurs installés
- [ ] Historique des recherches locales (si disponible)

### Persistance
- [ ] Clés `Run` / `RunOnce` (HKCU et HKLM)
- [ ] Tâches planifiées (`Tasks`)
- [ ] Services installés récemment

### Journaux d'événements Windows
- [ ] Connexions/déconnexions (Security)
- [ ] Insertion de périphériques USB (System / Setup)
- [ ] Exécution de processus si journalisée (Security, si audit activé)

### Système de fichiers
- [ ] Horodatages MACB des fichiers d'intérêt identifiés
- [ ] Fichiers supprimés récupérables liés au document sensible
- [ ] Fichiers compressés ou chiffrés suspects (archives, conteneurs)

## Export

- [ ] Captures d'écran des écrans Autopsy pertinents enregistrées
- [ ] Liste des fichiers/artefacts retenus exportée vers `work/`
- [ ] Constats reportés dans `templates/rapport_incident_template.md` et `templates/chronologie_template.csv`
