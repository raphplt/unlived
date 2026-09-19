# Unlived

Projet de jeu vidéo en exploration. **Unlived est le nom de travail du dépôt ; le titre du jeu reste à choisir.**

> Explorez un musée consacré aux vies que vous auriez pu vivre. Découvrez ce que signifie s’engager dans une vie et renoncer à d’autres possibilités.

Cette documentation rassemble la vision, les pistes de conception et les essais à mener. **Version de travail v0.2 — 19 septembre 2026.** La mécanique centrale, le personnage et les moyens de fabrication restent en exploration.

## Par où commencer ?

| Document                                        | À quoi il sert                                                                 |
| ----------------------------------------------- | ------------------------------------------------------------------------------ |
| [Vision](docs/vision.md)                        | Comprendre la promesse, le thème et les piliers proposés.                      |
| [Design du jeu](docs/design.md)                 | Décrire ce que fait le joueur et les règles à éprouver.                        |
| [Trame narrative](docs/narration.md)            | Conserver le parcours envisagé et repérer ses contradictions. Contient la fin. |
| [Premier prototype](docs/prototype.md)          | Définir une petite expérience jouable et son protocole de test.                |
| [Exposition : Créer](docs/expositions/creer.md) | Disposer d'un premier exemple concret, à réécrire librement.                   |
| [Questions et décisions](docs/decisions.md)     | Savoir ce qui reste ouvert et garder la raison des futurs choix.               |
| [Références créatives](docs/references.md)      | Transformer les inspirations en questions de conception.                       |
| [Notes initiales](docs/sources/README.md) | Retrouver les premières pistes. |
| [Alternatives de gameplay](docs/alternatives-gameplay.md) | Comparer quatre gestes possibles avant de retenir le cœur du jeu. |
| [Étude de fabrication](docs/fabrication.md) | Examiner modèles, moteurs, caméra et outils pour le prototype. |

**Prochaine étape proposée :** examiner les [alternatives de gameplay](docs/alternatives-gameplay.md) et l’[étude de fabrication](docs/fabrication.md), puis préparer un petit essai comparatif. Le personnage est envisagé plutôt ouvert à la projection, sans choix définitif ; les six questions narratives restent ouvertes.

## Comment faire vivre ces documents

- **Proposition** : direction de travail, modifiable. C'est le statut par défaut de cette v0.2.
- **Préférence provisoire** : inclination actuelle, sans choix définitif.
- **À tester** : hypothèse dont on attend des observations en jeu.
- **À décider** : question qui exige un choix de l'auteur.
- **Décidé** : choix explicitement adopté, daté et motivé dans le registre.

Le [registre](docs/decisions.md) distingue les orientations adoptées des questions ouvertes. Une préférence ou une proposition de test ne devient pas automatiquement une contrainte pour le jeu.

Chaque sujet possède un document principal : la vision pour l'intention, le design pour les règles, la narration pour le récit, le prototype pour le test. Lorsqu'un choix évolue, modifier ce document et consigner la raison dans le registre.

`game/`, `assets/` et `tools/` sont les emplacements prévus pour le jeu, ses ressources et ses outils. Cette étape porte uniquement sur la documentation.
