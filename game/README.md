# Unlived — Les pièces manquantes · MVP

La scène représentative de la [fiche 02, version 3](../docs/fiches-projets/02-les-pieces-manquantes.md), en français, dans Godot 4.6+ / GDScript. Le lancement normal utilise désormais cette enquête. L’ancien essai A/D reste disponible séparément.

## Jouer

```sh
./tools/play.sh
```

Le lanceur importe les ressources, puis ouvre une fenêtre maximisée. `GODOT_BIN=/chemin/godot ./tools/play.sh` choisit le moteur. Dans l’éditeur, ouvrir `game/project.godot`, puis F5 ; la scène principale est `scenes/inquiry.tscn`.

Le rendu **Forward+ / Vulkan** est nécessaire pour la projection lumineuse des serres. Le rendu Compatibility ne permet pas cette expérience. Linux est la plateforme vérifiée ; aucun export autonome n’est livré.

| Commande | Geste |
| --- | --- |
| ZQSD / WASD physiques, flèches | Marcher |
| Souris | Regarder, y compris assis |
| E | Interagir à moins de 3 m ; se relever quand on est assis |
| C | Photographier le cadrage actuel, sans interface |
| Tab | Ouvrir / refermer le carnet |
| M | Consulter les accès connus |
| Échap | Refermer, annuler, ouvrir la pause |
| F11 | Plein écran, puis retour au mode précédent |

La pause règle le volume et la sensibilité. Les photographies du carnet se parcourent avec les boutons ou les flèches. « Comparer » garde une image à côté de la suivante ; les documents photographiques peuvent aussi être comparés à une vue personnelle. Les notes sont libres. Le carnet conserve les documents effectivement consultés.

## Ce que contient cette étape

- Hall avec deux alcôves, deux passages ouverts et collection modifiable.
- Cour unique en 3D, quatre points de vue reliés par deux rampes et les espaces qui les entourent. Le réservoir change de côté selon la rive ; sa base est occultée aux deux points bas et visible aux deux points hauts.
- Trois routes indépendantes vers le logement de Lou : expérience vitre/applique au sud bas, bande complète dans le laboratoire, enveloppe et reçu de location. Aucun drapeau de compréhension n’ouvre une porte. Une découverte directe est autorisée.
- Logement de Lou, traces du séjour, photographies historiques rendues dans la scène et passage de service traversable vers les serres.
- Jardin et chambre des serres : vitre et lumière, rideau, lampe orientable, cylindre, projection sur le mur, lit où s’asseoir. La lumière projetée rencontre réellement le mur et les objets de la chambre.
- Trois objets réservables par vie, toujours présents et manipulables. Une fiche illustrée les représente au hall. Une photographie personnelle par vie peut être retenue, remplacée et affichée dans son alcôve.

Cette étape couvre la **scène représentative du §15**, pas les quatre vies ni le dernier acte complet. Elle n’introduit aucune fermeture : on peut repartir enquêter après avoir rempli les deux alcôves. L’estuaire, les plaines, la composition finale, l’Exposition 0 et le départ définitif restent à fabriquer. Les décors et silhouettes sont une réalisation géométrique de prototype. Le plaisir de l’enquête et la durée ne sont pas validés par les tests techniques.

## Sauvegarde et photographies

La visite est enregistrée après les manipulations et déplacements entre lieux, périodiquement, et en quittant. « Continuer » restitue la position, le regard, les manipulations, documents, notes, réservations et photographies. « Nouvelle visite » demande confirmation avant de remplacer la progression.

Les données sont indépendantes de l’ancien prototype :

- `user://pieces-manquantes/save.json` : état versionné, écrit par remplacement atomique ;
- `user://pieces-manquantes/photo_*.png` : captures du joueur ;
- `user://inquiry-settings.cfg` : confort.

Sous Linux, `user://` se trouve habituellement dans `~/.local/share/godot/app_userdata/Unlived — Les pièces manquantes/`. Les anciennes photos sont conservées sur disque après une nouvelle visite. Il n’y a pas de synchronisation réseau. Une image manquante ne bloque aucun accès et la sélection des autres alcôves reste correcte.

## Fabrication

| Fichier | Rôle |
| --- | --- |
| `scripts/inquiry/world.gd` | Géométrie, collisions, prises, points de vue, miroirs et projection |
| `scripts/inquiry/game.gd` | Manipulations, documents, captures de preuves, circulation et collection |
| `scripts/inquiry/archive.gd` | Persistance indépendante et photographies PNG |
| `scripts/inquiry/interface.gd` | Commandes, carnet, comparaison, notes et pause |
| `scripts/player.gd` | Marche, regard et rayon d’interaction ; immobilisation assise |
| `shaders/reflection.gdshader` | Vitre composée avec une caméra réfléchie dans son plan |
| `tests/inquiry.gd` | Tests d’intégration du nouveau scénario |

Les preuves photographiques sont rendues au lancement depuis le monde 3D. Le tirage est un recadrage du même pixel source que la bande complète ; le négatif inverse ses valeurs. Les présences historiques sont retirées après leurs expositions photographiques. Les photographies du joueur capturent réellement son point de vue. Les petites fiches d’objets sont des pictogrammes d’inventaire, pas des preuves photographiques.

La projection utilise une texture de découpe procédurale dans un `SpotLight3D`, et l’image de l’album est photographiée ensuite dans la chambre. Les vitres rendent le monde depuis une caméra symétrique ; la lumière et le battant font varier sa présence. Aucun SVG ne tient lieu de preuve spatiale.

## Vérifier

```sh
./tools/test.sh
./tools/test.sh --display
```

Le premier lance l’import, l’intégration de l’enquête, puis les tests de l’ancien prototype. Le second ajoute les vrais rendus, photographies, fenêtres, contrôles de mise en page et plein écran. Les tests de la nouvelle scène utilisent un espace de sauvegarde distinct ; les données temporaires sont retirées après vérification.

Les vérifications de l’enquête couvrent notamment les vrais rayons d’occultation, la marche clavier sur les deux rampes jusque dans les pièces, l’assise et le retour par E, les boutons de manipulation/réservation, le remplacement des choix, les retours libres, la reprise de pose et les photos manquantes. Le test graphique compare les pixels des captures et de l’alcôve.

Captures reproductibles, depuis la racine, nécessitant une session graphique :

```sh
./tools/play.sh -- --inquiry-capture=hall
./tools/play.sh -- --inquiry-capture=city
./tools/play.sh -- --inquiry-capture=lou
./tools/play.sh -- --inquiry-capture=greenhouse
./tools/play.sh -- --inquiry-capture=projection
./tools/play.sh -- --inquiry-capture=film
```

Les images sont écrites dans `artifacts/inquiry-*.png`. Ces modes n’utilisent pas la sauvegarde normale. Les tests ne prouvent ni la qualité narrative, ni le confort sur toute machine, ni l’intérêt de chaque route : les essais de jeu restent nécessaires.

## Ancien prototype A/D

```sh
./tools/play.sh --legacy
./tools/play.sh --legacy -- --variant=leave
./tools/play.sh --legacy -- --capture=apartment
```

`scenes/main.tscn` conserve le hall et l’appartement du premier essai, le piano, le choix d’un objet avec effacement ou le départ sans emporter. Son état de visite n’est pas sauvegardé. Sa documentation de conception reste dans [docs/prototype.md](../docs/prototype.md), section historique. Ses scripts et ressources ont été conservés ; les polices Cormorant et Inter sont sous SIL OFL, licences dans `assets/fonts/`.
