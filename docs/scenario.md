# Scénario

## Narratif

Le jeu de données retenu, **Stolen Szechuan Sauce** (13Cubed), met en scène le vol d'une recette d'entreprise par un employé depuis son poste de travail Windows. L'entreprise fictive soupçonne une fuite de données via ce poste et fournit, pour investigation :

- une image disque du poste de travail concerné ;
- une capture mémoire (RAM) de ce même poste, réalisée au moment de l'incident.

Ce cas est volontairement utilisé tel quel, sans réécriture du contexte métier, pour rester honnête sur l'origine du jeu de données : il s'agit d'un cas d'entraînement public et documenté dans la communauté DFIR, pas d'un incident réel.

## Pourquoi ce jeu de données

- **Cohérence disque + mémoire** : les deux preuves proviennent du même poste au même moment, ce qui permet un véritable recoupement (et non deux analyses indépendantes forcées ensemble).
- **Accessibilité matérielle** : taille raisonnable pour une analyse statique sur un poste à 16 Go de RAM, sans besoin de rejouer l'infrastructure en machines virtuelles.
- **Usage légal et pédagogique** : diffusé publiquement par son auteur à des fins d'entraînement forensic, largement référencé dans des formations et conférences DFIR.
- **Reconnaissance dans le domaine** : cas suffisamment connu pour que la méthodologie appliquée ici soit vérifiable et comparable par un recruteur ou un pair technique.

## Hypothèses de travail à vérifier pendant l'investigation

Ces hypothèses encadrent la recherche d'artefacts ; elles ne préjugent pas des constats, qui seront documentés uniquement une fois établis :

1. Un document ou fichier sensible (la « recette »/« sauce ») a été consulté, copié ou exfiltré depuis le poste.
2. Un support amovible ou un service externe (stockage cloud, messagerie, partage réseau) a pu servir de vecteur d'exfiltration.
3. Des traces d'activité utilisateur (historique de navigateur, fichiers récents, exécutions) permettent de reconstituer la chronologie des actions sur le poste.
4. La capture mémoire peut révéler des processus, connexions réseau ou artefacts absents ou effacés du disque au moment de l'image.

## Alternative de repli (si le jeu de données principal n'est plus disponible)

Si **Stolen Szechuan Sauce** devient inaccessible, l'investigation peut être reproduite avec :

- **Disque** : une image publique du projet [NIST CFReDS](https://cfreds.nist.gov/) (Computer Forensic Reference Data Sets), par exemple l'image « Hacking Case », couramment utilisée dans les tutoriels Autopsy.
- **Mémoire** : un échantillon public du dépôt [`volatilityfoundation/volatility3`](https://github.com/volatilityfoundation/volatility3) (dossier d'échantillons de test officiels de l'outil).

Dans ce cas de figure, le disque et la mémoire proviennent de deux cas distincts et non corrélés : la chronologie finale le précisera explicitement, et le recoupement portera alors sur la méthode (comment croiser deux sources) plutôt que sur un lien factuel réel entre les deux preuves. Ce README et celui du dépôt seront mis à jour en conséquence si cette alternative est utilisée.
