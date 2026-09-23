# Unlived

Aventure d’enquête à la première personne en développement. **Unlived est le nom de travail du dépôt ; le titre du jeu reste à choisir.**

Un musée, plusieurs vies possibles, des lieux à explorer et des traces à confronter.

**Direction choisie le 23 septembre 2026 : [Les pièces manquantes, version 3](docs/fiches-projets/02-les-pieces-manquantes.md).** L’auteur demande de reprendre le développement du MVP selon cette fiche. La biographie fine, la troisième lecture et le dernier acte restent des hypothèses à éprouver.

## MVP d’enquête jouable

La scène représentative de [Les pièces manquantes](docs/mvp-enquete.md) est implémentée dans Godot 4.6 : hall et deux alcôves, cour de la ville avec quatre points de vue et trois routes de recherche, laboratoire, logement de Lou, coulisses et fragment des serres.

```sh
./tools/play.sh
```

Explorer avec **ZQSD / WASD**, regarder à la souris, interagir avec **E**, photographier avec **C**, consulter le carnet avec **Tab** et le plan avec **M**. **Échap** ouvre la pause ; **F11** bascule en plein écran. Les photographies capturent réellement la vue sans interface. Le carnet permet de comparer ses images entre elles ou avec une image d’archive, consulter les documents et écrire des notes.

Les lieux restent accessibles ; réserver un objet ne le retire pas. Chaque alcôve associe l’un des trois objets du lieu et une photographie personnelle, tous deux remplaçables. La visite et les photographies sont sauvegardées automatiquement ; le menu permet de continuer ou de confirmer une nouvelle visite.

Voir [le guide du projet Godot](game/README.md) pour les commandes, les limites et les vérifications. Ouvrir [game/project.godot](game/project.godot) pour travailler dans l’éditeur. `./tools/test.sh` lance les contrôles techniques, `./tools/test.sh --display` ajoute les contrôles graphiques. La nouvelle enquête passe 41 contrôles sans fenêtre et 49 contrôles graphiques. Les quatre vies complètes et la fin restent à fabriquer ; aucune validation du plaisir de jeu n’est déduite des tests.

## Prototypes précédents

L’exposition **Créer** — appartement de musicien, piano, trois souvenirs et variantes conserver / partir — est conservée comme historique :

```sh
./tools/play.sh --legacy
```

Le [protocole A/D](docs/prototype.md) concerne cet ancien parcours. `./tools/movement.sh` lance le laboratoire de trois gestes ; ils ne conviennent pas à l’auteur et restent des essais techniques.

## Par où commencer ?

Lire le [suivi du MVP d’enquête](docs/mvp-enquete.md) pour le périmètre de réalisation, puis [Les pièces manquantes](docs/fiches-projets/02-les-pieces-manquantes.md) pour la direction du jeu complet. Les [trois fiches projets](docs/fiches-projets/README.md) restent disponibles comme historique de comparaison ; la fiche 02 est désormais choisie pour le développement.

| Document                                        | À quoi il sert                                                                 |
| ----------------------------------------------- | ------------------------------------------------------------------------------ |
| [Vision](docs/vision.md)                        | Comprendre la promesse, le thème et les piliers proposés.                      |
| [Moodboard évolutif](docs/moodboard.md) | Conserver les convictions et pistes de l’auteur sur l’expérience, le personnage et les couches de lecture. |
| [Fiches projets](docs/fiches-projets/README.md) | Retrouver la direction choisie et les deux alternatives de conception. |
| [Design du jeu](docs/design.md)                 | Décrire ce que fait le joueur et les règles à éprouver.                        |
| [Trame narrative](docs/narration.md)            | Conserver le parcours envisagé et repérer ses contradictions. Contient la fin. |
| [MVP d’enquête](docs/mvp-enquete.md) | Suivre le périmètre courant, ses vérifications et ses limites. |
| [Premier prototype](docs/prototype.md) | Retrouver le protocole historique A/D. |
| [Exposition : Créer](docs/expositions/creer.md) | Disposer d'un premier exemple concret, à réécrire librement.                   |
| [Questions et décisions](docs/decisions.md)     | Savoir ce qui reste ouvert et garder la raison des futurs choix.               |
| [Références créatives](docs/references.md)      | Transformer les inspirations en questions de conception.                       |
| [Notes initiales](docs/sources/README.md) | Retrouver les premières pistes. |
| [Alternatives de gameplay](docs/alternatives-gameplay.md) | Retrouver les alternatives de la recherche initiale. |
| [Mécaniques jouables](docs/mecaniques-jouables.md) | Conserver les trois systèmes de recherche antérieurs au choix de l’enquête. |
| [Études de mouvement 2D](docs/mouvement-2d.md) | Comparer Appui, Balancier et Portance, leurs essais jouables et leurs limites. |
| [Étude de fabrication](docs/fabrication.md) | Examiner modèles, moteurs, caméra et outils pour le prototype. |

Le [moodboard](docs/moodboard.md) reste la référence d’intention. Le personnage aura une histoire singulière, à découvrir progressivement à travers plusieurs lectures des mêmes éléments. Le [protocole A/D](docs/prototype.md) reste lié au premier MVP ; son implémentation ne vaut pas validation de la mécanique finale.

## Comment faire vivre ces documents

- **Proposition** : direction de travail, modifiable. C'est le statut par défaut de cette v0.2.
- **Préférence provisoire** : inclination actuelle, sans choix définitif.
- **À tester** : hypothèse dont on attend des observations en jeu.
- **À décider** : question qui exige un choix de l'auteur.
- **Décidé** : choix explicitement adopté, daté et motivé dans le registre.

Le [registre](docs/decisions.md) distingue les orientations adoptées des questions ouvertes. Une préférence ou une proposition de test ne devient pas automatiquement une contrainte pour le jeu.

Chaque sujet possède un document principal : la vision pour l'intention, le design pour les règles, la narration pour le récit, le prototype pour le test. Lorsqu'un choix évolue, modifier ce document et consigner la raison dans le registre.

`game/` contient le projet Godot et ses ressources, `tools/` les lanceurs et générateurs. `assets/` reste disponible pour les futures sources de fabrication hors du projet moteur.
