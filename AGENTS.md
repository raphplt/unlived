# Consignes de conception permanentes

Lire `docs/vision.md`, `docs/design.md` et `docs/decisions.md` avant de faire évoluer l’expérience de jeu. Les hypothèses du prototype ne sont pas des décisions sur le jeu final.

## Retours de l’auteur — 19 septembre 2026

- **Rester dans la suggestion.** Le jeu, ses menus et ses textes ne doivent pas expliquer aussi explicitement son thème, le sens des objets, les émotions attendues ou la signification d’un choix. Faire porter ces éléments par les lieux, les sons et les gestes. Cette exigence s’applique dès le prototype.
- **Préserver la découverte dès l’entrée.** La retenue concerne aussi le phrasé, la signalétique et l’ordre des révélations. Ne pas annoncer le principe du musée, les issues ou leurs conséquences visuelles avant que le joueur ait pu découvrir le lieu. Garder les variantes et explications de protocole dans les outils de test ; une validation peut annoncer sobrement l’absence de retour, sans raconter la scène à venir.
- **Une interface avec une identité de jeu.** Éviter la composition de page web, les grands boutons rectangulaires et les panneaux texte/actions systématiques. Privilégier une présentation discrète, liée à la matière et aux interactions du monde. Une police élégante et une palette cohérente ne suffisent pas à donner une âme à l’interface.
- Garder les commandes compréhensibles. Ne pas confondre subtilité du récit et manque de lisibilité d’une interaction. Un engagement doit pouvoir être interrompu avant sa validation ; chercher une mise en scène sobre de sa conséquence pratique.
- Le premier retour relève une boucle de jeu peu perceptible dans l’appartement. Approfondir ce que le joueur y fait et les réponses du lieu avant de multiplier les expositions. Ne pas traiter l’exploration de trois textes suivie d’un choix comme une boucle déjà validée.
- **Une mécanique principale qui porte le récit.** L’auteur cite Outer Wilds et Celeste pour demander une manière de jouer riche, engageante et approfondissable. Ne pas réduire cette demande à davantage de textes, de beaux décors ou de mini-jeux isolés. Les systèmes proposés dans `docs/mecaniques-jouables.md` restent des candidats à éprouver, pas des choix de l’auteur.

## Retours de l’auteur — 20 septembre 2026

- **Le genre reste ouvert.** L’exploration à la première personne et les énigmes sont des hypothèses de travail, pas une direction adoptée. Examiner aussi des formes comme la plateforme ou le RPG, y compris une représentation plus métaphorique. Partir du plaisir de jeu et des actions répétées, sans imposer la forme du MVP au jeu final.
- La bascule entre plusieurs versions d’une même vie pose un problème de cohérence et risque d’affaiblir la métaphore des différentes vies non vécues. La recommandation prioritaire de ce système est retirée ; ne pas inventer une justification de lore pour le conserver. Les pistes de l’écho et des lieux raccordés suscitent moins d’intérêt chez l’auteur et ne sont pas retenues.
- **Le personnage a une histoire propre : décision adoptée.** Il ne doit être ni générique ni impersonnel. La préférence précédente pour un personnage surtout ouvert à la projection est remplacée ; sa biographie précise reste à écrire.
- Conserver le [moodboard évolutif](docs/moodboard.md) comme référence : solitude, sentiment d’être hors du temps, vies fortement différentes, histoire reconstituée progressivement, plaisir de jeu accessible sans comprendre le récit, plusieurs couches de lecture sans explication démonstrative.
- **Orientation validée pour l’instant : trois lectures des mêmes éléments.** Découvrir un lieu agréable à parcourir, reconnaître une correspondance entre les vies, puis voir cette correspondance transformer la compréhension du personnage. Un détail déjà rencontré peut changer de portée sans être modifié ni expliqué. Le contenu de la troisième couche reste ouvert.
- **La plateforme à la première personne est écartée de la recherche actuelle.** Si plateforme il y a, l’auteur l’envisage en 2D dans les vies, avec éventuellement de la première personne ailleurs. L’hybride n’est pas adopté ; une forme sans plateforme reste possible. Niveaux et compétition sont facultatifs.
- Élargir les exemples et les propositions au-delà du piano, du compositeur et du théâtre. L’exposition Créer est un exemple du MVP, pas le modèle des vies à concevoir.
- La transidentité et la troisième couche de sens restent des sujets en exploration, pas des révélations à implémenter ou à expliciter.
- **Retour sur le laboratoire :** les trois gestes Appui, Balancier et Portance ne conviennent pas à l’auteur. Ne pas chercher l’intérêt du jeu principalement dans la réinvention d’un mouvement. Conserver les essais comme historique, sans les présenter comme une direction retenue ou comme le point de départ obligatoire.
- **Démarche actuelle : fiches projets complètes, une par une.** L’auteur a besoin de se projeter dans des jeux cohérents du début à la fin avant de décider du genre. Chaque fiche doit assumer une direction forte tout en restant globalement fidèle à la vision d’origine. Les hypothèses propres à une fiche, notamment une biographie ou une fin, ne deviennent pas des décisions générales. Ne pas substituer de nouveaux prototypes isolés à cette demande documentaire.

Les solutions concrètes à ces retours restent à concevoir et à éprouver ; ne pas présenter une intention ou une modification de documentation comme une correction déjà implémentée.


## Direction choisie — 23 septembre 2026

- **Reprendre le développement du MVP selon [Les pièces manquantes, version 3](docs/fiches-projets/02-les-pieces-manquantes.md).** Cette demande explicite remplace la phase de fiches documentaires et le maintien du genre ouvert pour le travail courant : aventure d’enquête à la première personne.
- Partir du périmètre représentatif du §15 : ville avec trois routes d’enquête, logement de Lou et coulisses, fragment des serres et deux alcôves de collection. Le [suivi du MVP](docs/mvp-enquete.md) distingue ce périmètre du jeu complet.
- Préserver les découvertes directes, les allers-retours libres et les résolutions alternatives. Réserver un objet ne le retire pas du lieu ; les photographies sont celles que le joueur prend réellement. Aucun départ de vie ou choix de collection ne clôt automatiquement l’enquête.
- Le choix de cette direction ne vaut ni validation du plaisir de jeu, ni adoption générale de chaque détail biographique, de la troisième lecture ou de la fin. Conserver ces éléments comme hypothèses de la fiche et consigner séparément les résultats observés.
