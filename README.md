# SOC Detection & Digital Forensics Investigation — Windows Incident Response Lab

Laboratoire personnel combinant détection SOC, collecte d'artefacts Windows et investigation numérique. Une activité PowerShell **bénigne, simulée et contrôlée** a été générée dans une machine virtuelle, puis étudiée de la télémétrie Sysmon jusqu'à la corrélation des traces et à l'analyse mémoire. L'installation de TheHive prépare la gestion de l'incident ; le cas reste à créer après activation de la licence.

Il ne s'agit ni d'une compromission réelle, ni d'une infection par malware, ni d'une attaque réussie. Ce projet est distinct du [laboratoire SOC Elastic Security et Active Directory](https://github.com/Ryad-Cyber/elastic-security-soc-lab).

## Objectifs et architecture

- Transformer une création de processus Windows en alerte exploitable dans Elastic Security et la contextualiser avec MITRE ATT&CK.
- Collecter des artefacts et comparer les observations Sysmon et Prefetch, sans confondre corrélation temporelle et preuve de causalité.
- Examiner le registre, des données collectées et une image mémoire ; préparer la documentation d'incident dans TheHive.

```text
Windows 11 « RYAD » — VM VMware, 192.168.194.138
  Activité PowerShell contrôlée → Sysmon → Elastic Security / Kibana → alerte SOC
  Artefacts → KAPE / FTK Imager → PECmd, RECmd et Autopsy
  Mémoire → DumpIt → Volatility 3
                      ↓
       Comparaison manuelle des observations
                      ↓
Ubuntu 22.04 — VM VMware, 192.168.194.134
  TheHive 6 installé : organisation créée ; dossier d'incident à finaliser
```

Le schéma décrit des étapes de travail, **pas une intégration automatique avec TheHive**. L'hébergement exact de la pile Elastic de détection n'est pas déduit du schéma.

## Outils et rôles

| Outil | Rôle dans le laboratoire |
|---|---|
| PowerShell, Sysmon | Activité contrôlée et télémétrie Windows, notamment création de processus (Event ID 1). |
| Elastic Security, Elasticsearch, Kibana | Recherche dans la télémétrie et détection à l'aide d'une règle personnalisée. |
| MITRE ATT&CK | Contextualisation T1059.001 — PowerShell. |
| KAPE | Collecte ciblée d'artefacts Windows. |
| PECmd, RECmd | Lecture des artefacts Prefetch et du registre, notamment `NTUSER.DAT`. |
| FTK Imager, Autopsy | Acquisition logique ; création du dossier d'investigation et importation des données. |
| DumpIt, Volatility 3 | Acquisition de mémoire et analyse avec `windows.info` et `windows.pstree`. |
| TheHive 6.0.0, Java 17, Cassandra 4.1.x, Elasticsearch 8.x | Installation native et préparation de l'organisation de gestion d'incident sur Ubuntu. |

## Scénario et détection

Une commande PowerShell bénigne utilisant `-EncodedCommand` est exécutée dans le laboratoire. Un événement **Sysmon Event ID 1 — Process Create** pour `powershell.exe` porte l'horodatage `2026-11-11 11:28:46.231 UTC`. La télémétrie est recherchée dans Elastic : la règle personnalisée **Suspicious PowerShell Encoded Command** produit une alerte de sévérité **High**, avec un **risk score de 73**, contextualisée par **MITRE ATT&CK T1059.001 — PowerShell**. La règle et sa requête complète ne sont pas exportées dans ce dépôt.

La capture de recherche montre un événement et une alerte associée : l'heure de création de l'alerte ne doit pas être assimilée à la milliseconde de l'événement source.

## Collecte et investigation

1. **KAPE** : collecte ciblée de fichiers utiles à l'investigation, avec **789 fichiers copiés et 78 dédupliqués**. Ces quantités décrivent la collecte, pas une compromission.
2. **Prefetch / PECmd** : l'extrait associé à `POWERSHELL.EXE` indique **14 exécutions** et une dernière exécution à `2026-11-11 11:28:46 UTC`. Cette seconde concorde avec l'événement Sysmon de `11:28:46.231 UTC`. La capture est un extrait recadré ; le nom du fichier et son fuseau n'y sont pas visibles, et leur contexte est fourni par l'auteur. Cette concordance ne qualifie pas les 14 exécutions de malveillantes et n'identifie pas à elle seule chaque action.
3. **Registre / RECmd** : une **sous-clé** créée pour l'exercice, `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run\SOC-DFIR-Lab`, contient une valeur par défaut `C:\Windows\System32\notepad.exe`. Sa dernière modification relevée est `2026-11-11 11:35:12.1764899`, sans fuseau confirmé. La création de cet artefact ne démontre pas une persistance fonctionnelle.
4. **Fichier de simulation** : `C:\Users\Analyst\Desktop\suspicious_note.txt` est un artefact bénin du laboratoire.
5. **FTK Imager / Autopsy** : acquisition logique et importation des données dans un dossier d'investigation. Une recherche par mots-clés a rencontré un problème ; aucun résultat de cette recherche n'est revendiqué.
6. **Mémoire** : DumpIt a servi à l'acquisition ; Volatility 3 a été utilisé avec `windows.info` et `windows.pstree`. Un processus PowerShell **PID 10172**, créé à `2026-11-11 13:40:49 UTC`, a été observé. Il est postérieur à l'événement initial et n'est pas identifié comme son processus.

## Chronologie des observations

| Horodatage | Observation | Portée |
|---|---|---|
| 11 novembre 2026, 11:28:46.231 UTC | Création de processus PowerShell, Sysmon Event ID 1. | Activité simulée ensuite détectée par Elastic. |
| 11 novembre 2026, 11:28:46 UTC | Dernière exécution PowerShell relevée dans l'extrait Prefetch. | Concordance à la seconde avec Sysmon, sans identification causale définitive. |
| 11 novembre 2026, 11:35:12.1764899 | Dernière modification de la sous-clé `SOC-DFIR-Lab`. | Fuseau non confirmé ; artefact créé pour l'exercice. |
| 11 novembre 2026, 13:40:49 UTC | Création du PowerShell PID 10172 observé en mémoire. | Processus ultérieur, distinct de l'événement initial. |

## TheHive : état réel

Après une première tentative Docker, **TheHive 6.0.0** a été installé nativement sur Ubuntu 22.04 avec Java 17, Cassandra 4.1.x et Elasticsearch 8.x ; l'interface web a été ouverte. L'organisation **SOC-DFIR-Lab** est créée et active, avec la description « SOC investigation and digital forensics lab: Elastic Security, Sysmon, KAPE, Volatility and TheHive. » et les règles `manual` pour tâches et observables. Le compte **SOC Analyst** a été créé avec le profil `read-only`.

La demande de licence TheHive Community est **en attente de validation**. Aucun dossier d'incident n'a encore été créé. Le dossier envisagé, **SOC-DFIR-001 — Suspicious PowerShell Encoded Command**, reste à finaliser après activation ; son existence, des tâches ou des observables enregistrés ne sont pas revendiqués.

## Captures commentées

Les captures documentent l'environnement et les observations ; l'extrait Prefetch est volontairement conservé à sa résolution d'origine.

1. **Installation Sysmon** — service démarré et journal opérationnel disponible. ![Installation Sysmon et état du service](screenshots/01_Sysmon_Installation.png)
2. **Intégration Windows** — politique d'agent Elastic et intégration Windows. ![Politique et intégration Windows dans Elastic Fleet](screenshots/02_Windows_Sysmon_Integration.png)
3. **Télémétrie Sysmon** — recherche de créations de processus Event ID 1 dans Elastic. ![Recherche de créations de processus Sysmon dans Elastic](screenshots/03_Sysmon_Process_Detection.png)
4. **Détection** — alerte et événement PowerShell dans Elastic. ![Alerte PowerShell encodée et événement source](screenshots/04_Encoded_PowerShell_Alert.png)
5. **KAPE** — résultat de la collecte ciblée et déduplication. ![Collecte d'artefacts par KAPE](screenshots/05_KAPE_Forensic_Collection.png)
6. **Prefetch** — extrait PECmd : nombre et dernière heure d'exécution rapportés pour PowerShell ; le nom du fichier n'est pas visible dans cet extrait. ![Extrait du nombre et de la dernière heure d'exécution Prefetch](screenshots/06_PowerShell_Prefetch_Analysis.png)
7. **Registre** — sous-clé créée pour le lab et valeur par défaut. ![Sous-clé du registre examinée avec RECmd](screenshots/07_Registry_Persistence_Forensics.png)
8. **FTK Imager** — visualisation des données collectées et de `NTUSER.DAT`. ![Données logiques examinées dans FTK Imager](screenshots/08_FTK_Logical_Evidence.png)
9. **Mémoire** — extrait Volatility montrant le processus PowerShell ultérieur. ![Processus PowerShell observé avec Volatility](screenshots/09_Volatility_Memory_Analysis.png)
10. **TheHive** — création de l'organisation active. ![Organisation SOC-DFIR-Lab dans TheHive](screenshots/10_TheHive_SOC_DFIR_Organization.png)

## Limites et recommandations

- Les captures et constats concernent une simulation isolée. Aucune compromission, persistance effective ou activité malveillante réelle n'est déduite de ces observations.
- Les horodatages de l'extrait Prefetch reposent sur le contexte communiqué ; le fuseau du registre reste à confirmer. Le PID mémoire ultérieur ne prouve pas la présence du processus initial lors de la capture.
- Le dépôt ne contient ni dump mémoire, ni données collectées, ni export complet de règle, ni hash d'intégrité ou chaîne de conservation documentée. La recherche par mots-clés Autopsy n'a pas abouti.
- Pour poursuivre : valider le contexte et les fuseaux des artefacts, documenter les méthodes de vérification d'intégrité lors des prochaines acquisitions, affiner les critères de détection et traiter les faux positifs. Après validation de la licence TheHive, créer le cas prévu et documenter manuellement les tâches et observables effectivement retenus.

## Auteur

Ryad Boujenan — [Portfolio](https://ryad-cyber.github.io/#p-dfir-windows) · [GitHub](https://github.com/Ryad-Cyber)
