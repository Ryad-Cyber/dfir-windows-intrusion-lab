# Prérequis

## Matériel et espace disque

- Poste utilisé : Intel i7-1255U, 16 Go de RAM.
- Prévoir au moins 20 à 30 Go d'espace disque libre : image disque source, copie de travail, base de cas Autopsy, exports Volatility.
- Travailler sur une copie des preuves, jamais sur l'original téléchargé (voir « Intégrité des preuves » ci-dessous).

## Logiciels

| Outil | Installation |
|---|---|
| Autopsy 4.21+ | [autopsy.com/download](https://www.autopsy.com/download/) (Windows) |
| Volatility 3 | `pip install volatility3` (Python 3.10+), ou clone du [dépôt GitHub](https://github.com/volatilityfoundation/volatility3) |
| TheHive 5 (Community) | conteneur Docker officiel (voir [documentation TheHive](https://docs.strangebee.com/)), ou instance locale existante |
| 7-Zip / outil d'extraction | pour décompresser l'image disque et la capture mémoire si elles sont archivées |
| Outil de hachage (`Get-FileHash` PowerShell ou `sha256sum`) | vérification d'intégrité des preuves |

## Obtention des preuves

1. Se procurer l'image disque et la capture mémoire du cas **Stolen Szechuan Sauce** auprès des canaux de diffusion officiels indiqués par 13Cubed (description de sa vidéo/chaîne dédiée au cas, ou dépôts communautaires DFIR qui le référencent). Les liens de téléchargement de ce type de jeu de données évoluent dans le temps ; vérifier la source avant téléchargement.
2. Si ce jeu de données n'est plus accessible, utiliser l'alternative décrite dans [`scenario.md`](scenario.md) (NIST CFReDS + échantillons Volatility Foundation).

## Intégrité des preuves

Avant toute analyse :

```powershell
# Calculer l'empreinte de l'image disque et de la capture mémoire
Get-FileHash .\evidence\disk.E01 -Algorithm SHA256
Get-FileHash .\evidence\memory.raw -Algorithm SHA256
```

Consigner ces empreintes dans le rapport d'incident ([`templates/rapport_incident_template.md`](../templates/rapport_incident_template.md)) avant d'entamer l'analyse, puis les recalculer en fin d'investigation pour confirmer qu'aucune preuve n'a été modifiée.

## Organisation du répertoire de travail

```
evidence/            # Preuves originales, en lecture seule, jamais modifiées (non versionné)
work/
  autopsy_case/       # Base de cas Autopsy
  volatility_out/      # Sorties des plugins Volatility (voir scripts/volatility_quickstart.ps1)
  thehive_export/       # Export ou notes du cas TheHive
```

Le dossier `evidence/` et les sorties volumineuses de `work/` sont exclus du dépôt Git (voir [`.gitignore`](../.gitignore)) : seules les analyses, notes et captures d'écran pertinentes sont versionnées.

## Installation rapide de TheHive (local, à usage personnel)

```powershell
# Exemple avec Docker Desktop (Windows)
docker run -d --name thehive -p 9000:9000 strangebee/thehive:5
```

Adapter selon la documentation officielle au moment de l'installation (version, variables d'environnement, stockage). Si l'installation locale s'avère disproportionnée par rapport au scénario, une alternative plus légère (ou une simple structuration manuelle du cas selon le modèle TheHive, documentée dans `examples/exemple_case_thehive.json`) sera utilisée et indiquée comme telle dans le rapport final.
