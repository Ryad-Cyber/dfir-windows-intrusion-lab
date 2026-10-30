# Rapport d'incident — [Titre du cas]

> Gabarit à remplir au fil de l'investigation. Les champs entre crochets sont à compléter ; supprimer cette ligne d'avertissement une fois le rapport finalisé.

## 1. Résumé exécutif

- **Date du rapport** : [date]
- **Analyste** : Ryad Boujenan
- **Cas** : [nom du jeu de données / scénario]
- **Sévérité estimée** : [faible / moyenne / élevée]
- **Résumé en 3 à 5 lignes** : [à rédiger une fois l'investigation terminée]

## 2. Preuves analysées

| Preuve | Type | SHA-256 (avant analyse) | SHA-256 (après analyse) |
|---|---|---|---|
| [image disque] | Image disque (E01/dd) | [hash] | [hash] |
| [capture mémoire] | Dump mémoire (raw) | [hash] | [hash] |

## 3. Méthodologie appliquée

[Renvoyer vers `docs/methodologie.md` et préciser les écarts éventuels par rapport au déroulé prévu.]

## 4. Constats — Analyse disque (Autopsy)

[Constats réels, avec référence aux captures d'écran correspondantes une fois disponibles.]

## 5. Constats — Analyse mémoire (Volatility 3)

[Constats réels, plugin par plugin ou regroupés par thème (processus, réseau, persistance).]

## 6. Chronologie consolidée

[Voir `templates/chronologie_template.csv` ; en résumer ici les étapes clés de l'intrusion.]

## 7. Indicateurs de compromission

[Voir `templates/ioc_template.csv` ; en lister ici les plus significatifs.]

## 8. Documentation TheHive

- Lien ou référence du cas : [lien/référence]
- Observables ajoutés : [nombre / liste]
- Tâches réalisées : [liste]

## 9. Recommandations

| Constat | Recommandation | Priorité |
|---|---|---|
| [constat lié] | [action concrète] | [faible/moyenne/haute] |

## 10. Limites de l'investigation

[Ce qui n'a pas pu être vérifié, les hypothèses non confirmées, le périmètre non couvert.]
