# MVP — Les pièces manquantes

**Direction choisie par l’auteur le 23 septembre 2026. Scène représentative implémentée dans Godot 4.6 ; contrôles techniques et graphiques effectués.**

La référence de conception est la [fiche 02, version 3](fiches-projets/02-les-pieces-manquantes.md), en particulier son §15. Le MVP poursuit le projet Godot existant avec une scène représentative de l’enquête. Cette réalisation permet de soumettre la boucle et la relation à des essais ; leur intérêt reste à évaluer avant de fabriquer les quatre vies et le dernier acte.

## Périmètre de cette reprise

| Lieu ou système | Réalisation du MVP |
| --- | --- |
| Hall et deux alcôves | Relier la ville aux serres ; montrer et remplacer les choix d’objet et de photographie de chaque lieu. |
| Cour de la ville | Comparer quatre points de vue plausibles et éprouver une hypothèse sur la photographie de fête. |
| Laboratoire | Examiner le tirage, le plein cadre et le négatif issus d’une même capture de la scène ; écarter les caches pour retrouver les repères masqués. |
| Vitre et lumière | Expérimenter le reflet, puis distinguer les repères directs de ceux réfléchis. |
| Traces du séjour | Suivre une adresse, puis vérifier le logement par les relations spatiales. |
| Logement de Lou | Découvrir des traces de sa présence et rejoindre une coursive de service. |
| Fragment des serres | Manipuler rideau, lampe et cylindre, s’asseoir et expérimenter le reflet ; revenir ensuite dans la ville. |
| Photographie personnelle | Capturer le point de vue réel du joueur, revoir ses images et en choisir une pour chaque alcôve. |
| Réservation d’objet | Choisir parmi trois objets par lieu, soit six au total ; remplacer la réservation sans consommer l’objet ni supprimer son usage. |

La ville conserve trois routes valides : travailler le film, produire une expérience optique ou suivre les traces de la visite. Une arrivée directe au bon logement reste recevable. Le jeu ne doit pas imposer trois étapes successives déguisées en routes alternatives.

L’interface indique les commandes pratiques. Elle n’annonce ni les intentions du musée, ni le sens des objets, ni la lecture attendue de la relation. Les explications de protocole restent dans ce document et les outils de test.

## Limites du MVP

Cette scène représentative ne comprend pas les quatre vies complètes, les huit recherches, les douze objets de la collection complète, les quatre espaces de composition, l’Exposition 0 ou la fin. Elle n’évalue pas encore le rythme d’une partie de trois à quatre heures. La réalisation cible clavier et souris ; la manette et un export autonome ne sont pas livrés. Le rendu Forward+ / Vulkan est requis pour la projection des serres ; le rendu Compatibility ne reproduit pas cette expérience. Les décors et silhouettes restent une réalisation géométrique de prototype.

Sortir d’une vie ou remplir les deux alcôves ne ferme pas les lieux. Le dernier départ définitif décrit dans la fiche n’est pas une condition nécessaire pour éprouver ce MVP. Il sera traité séparément avec sa confirmation annulable, sans revenir à la fermeture après chaque objet du premier prototype.

Noa et Lou servent la scène choisie ; cela n’arrête pas toute la biographie. L’enfant Élie, la troisième lecture et le dernier acte restent des hypothèses de la fiche. Une vérification technique ne peut pas valider l’attachement aux personnages ou le plaisir d’enquêter.

## Lancement, commandes et sauvegarde

Lancer `./tools/play.sh` depuis la racine ou ouvrir `game/project.godot` dans Godot 4.6 et démarrer le projet. La scène par défaut est `game/scenes/inquiry.tscn` ; l’ancien prototype reste accessible avec `./tools/play.sh --legacy`.

| Commande | Action |
| --- | --- |
| ZQSD / WASD et souris | Marcher et regarder |
| E | Interagir avec la prise visée |
| C | Photographier la vue réelle sans interface |
| Tab | Ouvrir le carnet : photographies, comparaison entre clichés ou avec une image d’archive, documents et notes |
| M | Consulter le plan |
| Échap | Refermer une consultation ou ouvrir la pause |
| F11 | Basculer en plein écran |

La pause propose le volume et la sensibilité. La visite est sauvegardée automatiquement dans `user://pieces-manquantes/save.json` ; les photographies sont des fichiers PNG dans le même dossier. La sauvegarde conserve position, orientations, états des manipulations, documents consultés, notes, photographies et choix des alcôves. « Continuer » reprend cette visite.

« Nouvelle visite » demande confirmation avant de remplacer la progression. Les anciens fichiers PNG restent sur disque mais ne figurent plus dans le carnet de la nouvelle partie. La photographie retenue et la vue d’inventaire d’un objet sont deux éléments distincts ; réserver l’objet ne remplace pas l’image personnelle.

## Vérifications de réalisation

À consigner avec les résultats effectivement obtenus, en distinguant contrôles automatiques, inspection graphique et essai humain :

- Parcourir chaque route indépendamment et atteindre le logement sans obliger à lire les autres sources.
- Essayer une mauvaise position et obtenir une différence visible qui permet de réviser l’hypothèse.
- Vérifier les repères de la fiche depuis les quatre positions : côté du réservoir, hauteur et occultation par la passerelle.
- Vérifier que le tirage, le film élargi et les vues du joueur partagent une géométrie réelle cohérente.
- Changer la lumière du reflet, quitter le lieu et revenir ; constater un état de recherche cohérent.
- Entrer et sortir de Lou, des coulisses, des serres et du hall sans bloquer les retours.
- Réserver puis remplacer un objet ; vérifier que son usage dans la scène reste disponible.
- Prendre plusieurs photographies différentes ; revoir et remplacer l’image exposée dans chaque alcôve.
- Vérifier la lisibilité des commandes, des preuves et des images aux résolutions prises en charge.
- Documenter explicitement la persistance entre sessions et ce que réinitialise une nouvelle partie.

## Protocole d’essai humain

Présenter uniquement les commandes. Laisser le joueur choisir le lieu et sa manière de chercher, sans expliquer le reflet, désigner la bonne fenêtre ou annoncer ce que représente Lou.

Observer les hypothèses formulées, les essais entrepris, les changements de route et les retours spontanés. Distinguer une erreur de raisonnement compréhensible d’une information illisible ou d’un accès impraticable. Ne pas déduire la profondeur du jeu du seul nombre de documents consultés.

Après le parcours, demander ce qui a conduit au logement, quelle autre piste semblait possible, ce qui a motivé les retours et pourquoi cette photographie a été retenue. Relever les interventions nécessaires et les moments sans prochaine action imaginable.

## État de réalisation et résultats

La scène représentative, le carnet, les photographies réelles, les choix de collection et la reprise de visite sont implémentés.

**Contrôles sans fenêtre, Godot 4.6.1 : 41 vérifications, 0 échec**, sortie normale sans avertissement. La suite `game/tests/inquiry.gd` contrôle notamment les déplacements, les interactions par rayon et touche E, les boutons, les quatre points de vue et la reprise de sauvegarde, y compris le maintien des bonnes associations lorsqu’une image manque.

**Contrôles graphiques, Godot 4.6.1 / Vulkan : 49 vérifications, 0 échec**, sortie normale sans avertissement. Le passage en plein écran avec F11 est contrôlé. Les captures du carnet, du film, de la pause et de la collection ont été inspectées à **960 × 600 pixels réellement vérifiés**, sans débordement observé.

Les suites se lancent avec `./tools/test.sh` et, dans une session graphique, `./tools/test.sh --display`. Ces commandes exécutent aussi les suites de l’ancien prototype A/D ; les nombres ci-dessus concernent uniquement l’enquête.

**Pipeline complet `./tools/test.sh --display`, Godot 4.7.2 / AMD Vulkan : 361 vérifications, 0 échec**, sortie normale sans avertissement : enquête, 41 contrôles sans fenêtre et 49 graphiques ; ancien prototype A/D, 111 sans fenêtre et 160 d’affichage. Ce passage complète la vérification indépendante sous Godot 4.6.1 décrite ci-dessus.

Les résultats techniques ne valident ni le plaisir, ni la difficulté perçue, ni l’attachement aux personnages. Aucune séance joueur n’est consignée.

Le [guide du projet Godot](../game/README.md) est la référence pratique pour les commandes de la version livrée. Le [premier protocole A/D](prototype.md) et le [laboratoire de mouvement](mouvement-2d.md) restent l’historique des essais antérieurs.
