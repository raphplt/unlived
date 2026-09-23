# Unlived — Études de mouvement

Petit projet Godot **séparé du musée**, pour comparer trois gestes en 2D. Ne représente ni une direction artistique finale, ni un choix de mécanique de l’auteur.

**Statut après retour de l’auteur : les trois gestes ne conviennent pas.** Le laboratoire reste disponible comme historique ; la recherche continue maintenant par des [fiches projets complètes](../../docs/fiches-projets/README.md), pas par le développement de ces gestes.

Depuis la racine du dépôt :

```sh
./tools/movement.sh
```

Dans Godot 4.6, importer ce dossier via son `project.godot`, puis F6/F5. L’édition standard ou .NET convient : le code est en GDScript. Le jeu démarre maximisé, reste redimensionnable et conserve le cadre des parcours ; F11 bascule le plein écran.

## Jouer

- **F1 — Appui :** maintenir E au sol ou contre un mur, orienter avec les directions, puis relâcher. Espace annule la préparation. Une charge brève peut suffire ; elle est maximale après une demi-seconde.
- **F2 — Balancier :** sauter vers un anneau éclairé, maintenir E pour le saisir, se balancer avec gauche/droite, puis relâcher. Relâcher et appuyer de nouveau permet de saisir un autre anneau.
- **F3 — Portance :** sauter, maintenir E pour ouvrir la voile, relâcher pour descendre. Les traits ascendants indiquent les courants qui portent une voile ouverte.

**Flèches ou positions WASD/ZQSD** : directions ; **Espace** : saut ; **E ou Maj** : geste. Rejoindre l’ouverture éclairée termine le parcours. Une chute ramène au départ. Chaque geste dispose de trois parcours : **Entrée** continue après une réussite ; **Pg↑/Pg↓** les parcourent librement, même sans réussir.

**R** recommence, **Échap** met en pause, **H** masque l’aide, **T** affiche les temps et les chutes, **M** coupe le son. Les intitulés F1/F2/F3 sont aussi cliquables. La perte de focus met en pause ; reprendre explicitement avec Entrée ou Échap.

Manette : stick ou croix, **A** saut, **X** geste, **Start** pause, **Back/Select** recommencer, **RB** parcours suivant. Les bindings sont présents ; leur confort sur une manette physique reste à essayer.

Les [fiches de conception](../../docs/mouvement-2d.md) détaillent les règles, les situations avancées, les risques et le protocole de comparaison. Le chronomètre reste masqué par défaut. Les résultats sont enregistrés localement dans `user://movement-studies.json`, dans les données Godot du projet « Unlived — Études de mouvement ». Supprimer ce fichier remet les résultats à zéro. Rien n’est envoyé en ligne.

## Vérifications et organisation

```sh
./tools/test-movement.sh
./tools/test-movement.sh --display
./tools/movement.sh -- --capture
```

Le premier lance des contrôles de physique et une traversée des neuf parcours. L’option `--display` vérifie aussi les commandes d’essai et trois tailles de fenêtre. La commande `--capture` enregistre six images (trois départs et trois gestes) dans `artifacts/movement/`, puis ferme sa propre fenêtre. Les tests ne modifient pas les résultats personnels.

- `scripts/mover.gd` : marche, saut, trois gestes, dessin de la silhouette.
- `scripts/levels.gd` : géométrie, anneaux, courants et sorties des neuf parcours.
- `scripts/lab.gd` : parcours, commandes d’essai, affichage, reprise et résultats locaux.
- `scripts/sound.gd` : retours sonores synthétisés.
- `tests/smoke.gd` : tests dans le moteur, routes au moyen des commandes ordinaires.

Les formes sont dessinées par le moteur. Les polices Cormorant et Inter sont accompagnées de leurs licences. Aucun asset ne nécessite un téléchargement à l’exécution.
