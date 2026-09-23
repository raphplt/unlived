# Questions ouvertes et journal de décisions

**Mise à jour : 23 septembre 2026.** Distinguer les préférences actuelles, les hypothèses de test et les décisions adoptées. Q01 est choisi pour le MVP : enquête selon la fiche 02 version 3. Q02 est partiellement tranchée : le personnage possède une histoire propre. Sa biographie fine et le dernier acte restent des hypothèses à éprouver.

## Trois sujets prioritaires

| ID | Sujet | État actuel | Suite proposée |
| --- | --- | --- | --- |
| Q01 | Genre et geste central | Choisi le 23 septembre pour le développement du MVP : enquête à la première personne selon la fiche 02, version 3. Les gestes du laboratoire et la plateforme à la première personne restent écartés. | Fabriquer puis évaluer la scène représentative : ville, trois routes, Lou, fragment des serres et collection personnelle. |
| Q02 | Qui visite ? | Décidé : un personnage singulier avec une histoire propre, ni générique ni impersonnel. Biographie encore ouverte. | Écrire des événements et des attaches concrets, puis travailler leur découverte progressive. Voir le [moodboard](moodboard.md). |
| Q03 | Forme et moyens du prototype | Reprise du projet Godot 4.6 existant en 3D à la première personne. Plateforme de diffusion, rendu final et durée de production encore à préciser. | Vérifier la réalisation décrite dans le [MVP d’enquête](mvp-enquete.md), puis recueillir des essais joueurs. |

La comparaison A/D et l'essai Godot sont des propositions de travail, pas des décisions de l'auteur sur le jeu final.

## Questions à traiter ensuite

| ID | Question | État / moment utile |
| --- | --- | --- |
| Q04 | Quand voit-on les coulisses ? | MVP choisi : accès depuis le logement de Lou. Le réseau complet et son rythme restent à fabriquer et à évaluer. |
| Q05 | Les objets donnent-ils des capacités ? | Direction choisie : objets réservés sur place, sans bonus ni pouvoir de collection. Les connaissances et les manipulations ouvrent les pistes. |
| Q06 | Certaines expositions restent-elles invisibles pendant une partie ? | Ouvert ; avant de concevoir plusieurs parcours. |
| Q07 | Que permettent sauvegarde, retour en arrière et nouvelle partie ? | Allers-retours et remplacement de la collection libres pendant l’enquête. Sauvegarde automatique de la visite et des photographies implémentée ; nouvelle visite avec confirmation. Le dernier départ reste hors du MVP. |
| Q08 | Que signifie disparaître ? | Ouvert : représentation, possibilité ou vie réelle. La disparition elle-même dépend de Q01. |
| Q09 | Quelle liberté à la fin ? | Ouvert ; ni l'abandon obligatoire ni le devenir d'un refus ne sont écrits. |
| Q10 | Quel public, quelles plateformes et quelle accessibilité ? | Ouvert ; avant de stabiliser contrôles et présentation. |
| Q11 | Combien d'expositions et quelle durée ? | Ouvert ; après mesure d'une exposition représentative. |
| Q12 | Comment reconnaître l'Exposition 0 ? | Ouvert ; à travailler avec Q02 sans imposer une solution par indices familiers. |
| Q13 | Quel rapport entre vider la collection et laisser le dernier socle vide ? | Ouvert ; conserver, fusionner ou remplacer ces gestes selon leur fonction et Q01. |

Les six questions narratives sont Q02, Q04, Q08, Q12, Q09 et Q13. La [trame narrative](narration.md) conserve leur formulation initiale ; la [fiche 02](fiches-projets/02-les-pieces-manquantes.md) propose désormais un parcours complet, sans valider automatiquement ses hypothèses de fin.

## Journal

| Date | Statut | Entrée | Motif et conséquence |
| --- | --- | --- | --- |
| 2026-09-18 | Organisation réalisée | Notes initiales regroupées dans `docs/sources/` ; documentation v0.1 créée. | Distinguer les pistes anciennes des documents de travail. |
| 2026-09-19 | Orientation adoptée | Évaluer des alternatives au choix d'un objet suivi de l'effacement. | La v0.2 sépare la promesse du jeu d'une mécanique particulière. Q01 reste ouvert. |
| 2026-09-19 | Préférence provisoire | Aller plutôt vers la projection, avec quelques attaches, sans décision définitive. | Q02 et Q12 restent ouverts ; aucun personnage n'est fixé. |
| 2026-09-19 | Étude demandée | Examiner les moyens de fabrication et les capacités des outils envisagés. | Étude documentée ; pas de moteur final ni de calendrier décidé. |
| 2026-09-19 | Questions maintenues ouvertes | Les six questions narratives n'ont pas de réponse définitive. | Les pistes ne deviennent pas des contraintes de scénario. |
| 2026-09-19 | Choix d’implémentation du MVP | Première exposition en Godot 4.6 / GDScript, 3D à la première personne, variantes A et D dans une scène commune. | Mise en œuvre de la demande d’un MVP soigné et de l’essai proposé. Décor stylisé, sons et illustrations originaux, aucune dépendance externe à l’exécution. Ne fixe pas Q01, Q02 ou le moteur final. Voir [guide du MVP](../game/README.md). |
| 2026-09-19 | Consigne permanente de l’auteur | Le jeu et son UI doivent rester suggestifs ; ne pas expliciter aussi directement les intentions, les émotions ou le sens des choix. | S’applique dès le prototype. Faire comprendre par les lieux, les sons et les gestes, avec des commandes lisibles. Consigne reprise dans `AGENTS.md` et le design. Correction du MVP encore à réaliser. |
| 2026-09-19 | Direction d’interface adoptée | Reprendre l’interface jugée trop « web » et manquant d’âme. | Chercher une identité liée au monde et aux interactions ; ne pas se limiter aux couleurs et aux polices. La forme précise reste à concevoir. |
| 2026-09-19 | Premier retour auteur / Q01 | La boucle de jeu dans l’appartement n’est pas clairement perceptible. | Le MVP valide un parcours technique mais propose peu d’actions avant le départ. Approfondir l’activité vécue dans la pièce avant d’ajouter des expositions ; aucune nouvelle mécanique n’est encore retenue. |
| 2026-09-19 | Consigne précisée et première passe implémentée | Préserver le mystère dès l’ouverture, dans le phrasé comme dans l’ordre des révélations. | Retrait de l’explication du thème au menu et dans le hall, des issues annoncées d’avance et des commentaires interprétatifs. Variantes d’essai déplacées dans les arguments de lancement. Confirmations limitées à l’absence de retour ; commandes textuelles plus sobres. Cela ne valide pas encore le rythme de découverte. |
| 2026-09-19 | Correction d’affichage | Démarrage maximisé, fenêtre redimensionnable, UI mise à l’échelle et restauration du mode précédent après F11. | Retour de l’auteur : fenêtre trop petite au lancement dans Godot Mono. Vérification graphique sur plusieurs formats ajoutée à `tools/test.sh --display`. |
| 2026-09-19 | Recherche demandée / Q01 | Trouver une mécanique principale riche qui porte une histoire forte, avec Outer Wilds et Celeste comme références. | Trois systèmes proposés dans [Mécaniques jouables](mecaniques-jouables.md). Recommandation d’essai : basculer entre deux versions d’un lieu en retenant un élément. Aucun système retenu par l’auteur ou implémenté ; retour ordinaire au hall et clôture définitive à réexaminer si cette direction est poursuivie. |

Un parcours de vérification technique automatisé est disponible dans `game/tests/smoke.gd`. Un premier retour de l’auteur est consigné ci-dessus. Aucune séance comparative suivant le protocole n’a encore été consignée ; les vérifications techniques ne valident pas les hypothèses affectives.

### 20 septembre 2026 — genre rouvert / Q01

**Retour de l’auteur :** les propositions précédentes ont privilégié les énigmes sans choix préalable de ce genre. Examiner la manière de jouer au niveau du jeu entier, avec une ouverture explicite à la plateforme, au RPG et à une représentation plus métaphorique. Ni ces exemples, ni la caméra du MVP ne constituent un choix du jeu final.

**Recommandation retirée :** la bascule entre plusieurs versions d’une même vie risque d’affaiblir la métaphore de vies différentes non vécues. Les systèmes d’écho et de raccordement des lieux suscitent moins d’intérêt. Conserver leur description comme historique, sans priorité d’implémentation. L’entrée du 19 septembre recommandant un premier essai est remplacée sur ce point.

### Retour du 20 septembre — personnage et moodboard

**Décidé / Q02 :** le personnage a une histoire propre. La préférence pour la projection du 19 septembre est remplacée. Aucune biographie précise n’est encore adoptée.

**Intentions exprimées :** solitude, sentiment d’être hors du temps, diversité forte des vies, reconstitution progressive de l’existence, jeu agréable sans compréhension de l’histoire, plusieurs couches de lecture sans réponse explicite, direction artistique singulière et musique soignée. L’ambition d’une fin bouleversante n’est pas un effet garanti.

**Pistes ouvertes :** plateforme et première personne ; niveaux et compétition facultatifs ; identité de genre comme sujet intime possible, sans conclusion ni thème arrêté. Le RPG centré sur un groupe attire moins l’auteur à cause de la solitude recherchée. La troisième couche de sens reste indéterminée. Voir le [moodboard évolutif](moodboard.md) pour le détail. Aucun de ces systèmes n’est implémenté à cette occasion.

### Précision du 20 septembre — lectures communes et forme de jeu

**Validé pour l’instant :** trois lectures des mêmes éléments. Le joueur découvre un lieu agréable à parcourir, reconnaît une correspondance entre les vies, puis comprend autrement le personnage. Un détail ancien peut changer de portée sans être modifié ni expliqué. La troisième couche de sens n’est pas pour autant définie.

**Recherche réorientée / Q01 :** l’auteur ne souhaite pas poursuivre la plateforme à la première personne, notamment pour des questions de proportions. S’il y a plateforme, l’envisager en 2D dans les vies ; de la première personne ailleurs est une possibilité, pas une décision. Une forme sans plateforme reste ouverte. Cette précision remplace la recommandation de l’agent d’essayer d’abord une plateforme à la première personne.

**Consigne de recherche :** sortir des exemples récurrents de piano, de compositeur et de théâtre ; imaginer des vies et des lieux plus variés. Aucun nouveau système n’est implémenté.

### 20 septembre — trois études de mouvement jouables / Q01

**Travail autorisé et réalisé :** conception de trois gestes 2D distincts (Appui, Balancier, Portance), puis mise en œuvre dans un laboratoire séparé du musée. Chaque geste dispose de trois petits parcours, avec reprises immédiates, sélection libre des essais et chronomètre facultatif. Lancer `./tools/movement.sh` ou importer `experiments/movement/project.godot`.

**Avis de conception, non décision de l’auteur :** commencer le test humain par Appui pour explorer placement, portée et réception sur les surfaces ordinaires ; comparer ensuite avec la continuité de Balancier et les trajectoires de Portance. Ne pas fusionner les trois gestes à ce stade. Aucun de ces systèmes n’est encore reconnu comme le cœur du jeu.

**Vérifications observées :** 37 contrôles de physique/progression et 23 contrôles graphiques/de commandes passent. Les neuf parcours sont terminés par des commandes simulées dans le moteur, sans téléportation pendant les traversées ; les routes Appui sont réalisables avec les directions du clavier. Affichage inspecté, dont la fenêtre minimale de 960 × 600. Le confort sur manette physique, l’accessibilité de la difficulté et le plaisir ne sont pas validés par ces contrôles.

**Suite :** recueillir des observations sur l’envie de recommencer, les erreurs comprises, les trajectoires alternatives et la fatigue du geste, puis choisir une piste à approfondir. Les trois lectures narratives validées restent la cible de l’étape suivante ; aucune biographie, DA finale ou troisième couche intime n’est fixée dans le laboratoire. Voir les [fiches des trois études](mouvement-2d.md).

### 20 septembre — rejet des gestes et première fiche projet / Q01

**Retour de l’auteur :** Appui, Balancier et Portance ne conviennent pas ; la recherche lui paraît trop centrée sur la réinvention des mouvements. Le genre reste ouvert. La recommandation précédente d’approfondir Appui est retirée de la démarche actuelle. Les essais restent un historique technique.

**Nouvelle demande :** rédiger plusieurs cahiers des charges ou fiches projets, une par une, avec une direction forte et une expérience cohérente du début à la fin. Préserver globalement la vision d’origine. Commencer par une première fiche pour permettre à l’auteur de se projeter, plutôt que poursuivre les gestes isolés.

**Document rédigé :** [Fiche 01 — Les lieux que l’on quitte](fiches-projets/01-les-lieux-que-lon-quitte.md), proposition d’aventure de plateforme entièrement en 2D avec mouvements familiers. Elle comprend une biographie de travail pour Noa, quatre vies, les coulisses, la composition, l’Exposition 0, les choix et la fin, ainsi qu’une direction artistique et sonore et un périmètre de production envisagé.

**Statut :** proposition complète, non adoptée et non implémentée. La biographie de Noa, la lecture intime proposée et les modifications du dernier acte sont propres à cette fiche ; elles ne tranchent pas les questions générales du projet. Les écarts avec les premières notes sont détaillés dans le document pour être discutés.

### 20 septembre — deuxième fiche projet / Q01

**Demande de l’auteur :** poursuivre la série avec la fiche suivante.

**Document rédigé :** [Fiche 02 — Les pièces manquantes, version 1](fiches-projets/archives/02-les-pieces-manquantes-v1.md), proposition d’aventure d’enquête à la première personne. Elle décrit des lieux ouverts en parallèle, des énigmes spatiales et matérielles, la conservation des observations après fermeture d’une vie, la progression jusqu’à la fin et une comparaison avec la plateforme 2D.

**Statut :** proposition écrite, non adoptée et non implémentée. La biographie de Noa et les quatre vies de la fiche 01 sont reprises comme hypothèses pour faciliter la comparaison des genres ; elles ne deviennent pas des décisions communes. Les vérifications de progression et les essais joueurs décrits sont à réaliser si cette direction est retenue pour un prototype.

### 20 septembre — troisième et dernière fiche projet / Q01

**Demande de l’auteur :** rédiger la dernière proposition de la série.

**Document rédigé :** [Fiche 03 — Ce que les mains retiennent](fiches-projets/03-ce-que-les-mains-retiennent.md), proposition de RPG tactique solitaire en vue de trois quarts. Elle détaille l’équipement, les actions au tour par tour, les rencontres, les quatre vies, le rythme entre conflits et espaces intimes, les choix et la fin. Elle conclut par une comparaison des trois directions.

**Statut :** proposition écrite, non adoptée et non implémentée. L’ajout d’affrontements contre des appareils du musée est une hypothèse propre à cette fiche, dont le risque pour l’atmosphère est explicite. La biographie partagée reste une hypothèse de comparaison. La série compte désormais trois propositions ; leur rédaction ne valide ni leur plaisir, ni leur équilibre, ni leur faisabilité dans une durée de production donnée.

### 23 septembre — approfondissement de la direction d’enquête / Q01

**Échange :** l’auteur demande laquelle des trois propositions semble la plus prometteuse. L’agent recommande l’enquête pour le lien possible entre comprendre les vies et progresser, tout en jugeant ses premières énigmes trop conventionnelles et sa biographie trop centrée sur la réparation. Cet avis est une préférence de conception, pas une observation de jeu.

**Demande de l’auteur :** reprendre cette fiche et lui donner une identité suffisamment forte pour convaincre à la lecture.

**Travail réalisé :** réécriture de [Les pièces manquantes, version 2](fiches-projets/archives/02-les-pieces-manquantes-v2.md). La proposition fait retrouver les points de vue, usages et trajets autour des images de vies sélectionnées par le musée. Elle détaille notamment un tirage recadré, un paysage fabriqué dans une chambre et un itinéraire modifié, puis reprend cette logique dans la composition finale. Les quatre vies divergent davantage ; Noa n’est plus principalement défini par les réparations. La version 1 est archivée et les deux autres fiches conservent leurs hypothèses antérieures.

**Statut :** approfondissement documentaire autorisé et réalisé. Le genre final, la biographie remaniée, la présence d’un enfant dans une vie et la lecture intime restent proposés. Aucun jeu nouveau n’est implémenté ; les vérifications documentaires ne valident pas les énigmes, la durée, l’émotion ou le plaisir.

### 23 septembre — reprise de la boucle et version 3 / Q01

**Demande de l’auteur :** livrer directement une proposition que l’agent puisse défendre avec assez de conviction, après avoir reconnu que la version 2 renforçait davantage les scènes et la narration que le jeu complet.

**Document réécrit :** [fiche 02, version 3](fiches-projets/02-les-pieces-manquantes.md). Le musée devient un terrain d’enquête ouvert avec huit recherches reliées, plusieurs sources et des routes alternatives. Une enquête détaillée possède trois voies de résolution et une table de contraintes factuelles. Le joueur produit ses observations et retient ses propres photographies dans la collection finale.

**Changements de cette proposition :** les quatre vies sont accessibles dès le début ; leurs fermetures sont reportées au dernier départ. Les objets sélectionnés restent sur place pendant l’enquête pour préserver les interactions. La composition finale peut être visitée et modifiée avant la confirmation extérieure qui clôt le musée. Les versions précédentes restent archivées.

**Statut :** direction désormais recommandée par l’agent pour un prochain prototype complet. Cette recommandation n’est ni une adoption de l’auteur, ni une validation du plaisir, de la géométrie des scènes ou de leur durée. Travail documentaire uniquement ; aucun gameplay nouveau implémenté.

### 23 septembre — direction choisie et reprise du développement / Q01, Q03

**Demande explicite de l’auteur :** « Reprend le développement du MVP du jeu », en désignant [Les pièces manquantes, version 3](fiches-projets/02-les-pieces-manquantes.md) comme le plan choisi.

**Décidé pour le MVP :** aventure d’enquête à la première personne. Cette décision remplace le statut de recommandation de l’agent et la phase de comparaison documentaire des genres. Le développement repart dans le projet Godot existant, selon la scène représentative du §15 : ville à trois routes d’enquête, logement de Lou et coulisses, fragment des serres et deux alcôves associant objets réservés et photographies personnelles.

**Règles à préserver :** retours libres pendant les recherches, objets sélectionnés toujours disponibles sur place, découvertes directes valides, absence de route obligatoire et de fermeture déclenchée par une sélection. La fermeture finale de la fiche reste hors de ce MVP.

**Portée :** l’auteur choisit une direction à réaliser. Ce choix ne constitue pas une validation du plaisir de jeu, de la lisibilité des preuves ou de la durée, et n’adopte pas chaque détail biographique ou la fin comme décision générale. Les alternatives et les précédents essais sont conservés comme historique.

**Éléments observés :** la demande de reprise motive la décision. Le [suivi du MVP](mvp-enquete.md) consigne séparément la réalisation et les vérifications ; une intention ne constitue pas une correction implémentée.

**Réalisation de cette reprise :** nouvelle scène d’enquête par défaut, hall à deux alcôves, ville et laboratoire, logement de Lou, coulisses et fragment des serres. Le carnet conserve les documents, les photographies prises depuis la scène et les notes ; les réservations restent remplaçables. La progression et les PNG sont sauvegardés séparément de l’ancien essai A/D. Les résultats de l’enquête sont consignés dans le [suivi du MVP](mvp-enquete.md) : 41 contrôles sans fenêtre et 49 contrôles graphiques passent sous Godot 4.6.1, sans échec ni avertissement. Les captures du carnet, du film, de la pause et de la collection sont inspectées à 960 × 600 réels. Le jeu complet et les essais joueurs restent à réaliser.

## Format des prochaines décisions

- **Date et sujet / ID :**
- **Statut :** proposé, préférence provisoire, décidé, à tester, remplacé.
- **Choix et périmètre :** essai seulement ou jeu envisagé.
- **Raison et options écartées :**
- **Éléments observés :** test ou contrainte qui motive le choix.
- **Ce qui ferait réexaminer la décision :**
- **Documents à mettre à jour :**

Conserver les décisions remplacées avec un lien vers leur nouvelle entrée. Un résultat de test décrit ce qui s'est passé ; une décision décrit ce qu'on en fait.
