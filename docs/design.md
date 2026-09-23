# Design du jeu — v0.2

**Statut : enquête choisie pour le développement du MVP, selon la fiche 02 version 3. Mise à jour : 23 septembre 2026.**

## Consignes adoptées pour l’écriture et l’interface

Retour de l’auteur sur le premier MVP, le 19 septembre 2026 : le jeu explique trop explicitement ses intentions et l’interface évoque trop une page web. Ces exigences valent dès les prototypes, pendant toute la suite du projet.

- Laisser les lieux, les sons, les objets et les gestes suggérer le sens. Ne pas commenter ce que le joueur devrait ressentir, ni expliquer la portée symbolique de ce qu’il vient de faire. Par exemple, annoncer « un peu de cette vie est resté ici » interprète à sa place ce que la transformation du hall devrait lui permettre de percevoir.
- Construire une interface discrète, dotée d’une identité liée au monde du jeu. Les grands boutons, les colonnes de texte et les écrans d’inspection présentés comme des fiches produit sont à reprendre. La lisibilité typographique ne remplace pas la mise en scène d’une interaction.
- Préserver la compréhension des commandes et une possibilité d’annuler l’engagement. La conséquence pratique doit devenir lisible avec sobriété, sans exposé du thème ni du déroulement futur.
- Préserver aussi l’ordre de découverte : ni les premières phrases, ni la signalétique, ni les choix du menu ne doivent livrer immédiatement le principe du musée ou la scène à venir. Cette retenue concerne toute la manière d’amener les choses, au-delà du retrait de quelques phrases.

Une première passe est implémentée : menu réduit à entrer/réglages/quitter, variantes d’essai sélectionnées au lancement, signalétique du hall neutralisée, retrait des commentaires interprétatifs et des descriptions symboliques, confirmations limitées à l’absence de retour. Les commandes utilisent des gestes concrets (« Emporter », « Reposer »). Le travail sur l’identité de l’interface et sur la découverte par les actions reste à poursuivre.

## Limite constatée dans le premier MVP

Le parcours implémenté permet d’explorer trois souvenirs, de jouer librement sept notes, de réécouter un motif et de choisir comment quitter l’appartement. Le piano n’est ni obligatoire ni une énigme. L’engagement change la scène et le hall, mais les actions précédentes produisent peu de transformations et ne construisent pas encore une activité à approfondir.

Le premier retour de l’auteur ne permet pas d’identifier clairement la boucle dans la pièce. Il faut donc travailler le cycle action → réponse perceptible → envie d’agir à nouveau à l’intérieur de cette vie, puis évaluer ce que le départ fait perdre. Ajouter des instructions explicatives ne résout pas ce manque.

**Piste à discuter, non implémentée :** écouter un fragment sur la cassette, reprendre quelques notes au piano, enregistrer sa propre version et la réécouter. Cette proposition chercherait à donner un contenu personnel au moment passé dans la pièce, sans score ni séquence musicale obligatoire. Elle ne tranche pas le geste central du jeu.

## Cœur retenu pour le MVP

**Choix de l’auteur du 23 septembre :** reprendre le développement selon [Les pièces manquantes, version 3](fiches-projets/02-les-pieces-manquantes.md). La comparaison documentaire des genres est terminée pour cette étape. La boucle est : **choisir une question → chercher des faits → produire une observation → éprouver une hypothèse → ouvrir un accès ou une piste → choisir la suite**.

Les observations doivent provenir des lieux : géométrie, occultation, reflet, cadrage et traces de séjour. Les trois routes de la ville convergent vers le logement de Lou sans imposer un ordre de lecture. Une découverte directe reste valide ; le jeu ne vérifie pas une liste d’indices avant d’autoriser un accès correct.

Les vies restent ouvertes pendant l’enquête. La collection associe un objet réservé, qui reste utilisable sur place, à une photographie réellement prise par le joueur. Ces choix peuvent être remplacés. Aucune image particulière ne constitue une clé ou une meilleure réponse. Le jeu complet prévoit un départ définitif séparé de la composition, après confirmation annulable ; ce dernier acte est hors du MVP actuel.

Le [périmètre de réalisation](mvp-enquete.md) retient la cour de la ville, le logement de Lou et les coulisses, un fragment des serres et deux alcôves. Les quatre vies et la fin de la fiche décrivent la cible du jeu complet. L’implémentation et ses vérifications doivent être consignées séparément des intentions.

**Principe narratif maintenu :** un même élément participe d’abord au plaisir de parcourir un lieu, puis à une correspondance entre les vies, enfin à une nouvelle compréhension du personnage. Concevoir ces lectures conjointement, sans expliquer ou modifier le détail pour produire la relecture. Le personnage possède une histoire propre ; sa biographie fine et le sens intime restent des hypothèses à travailler.

## Historique de recherche

Le [moodboard du 20 septembre](moodboard.md) avait rouvert le genre. Les trois [fiches projets](fiches-projets/README.md) permettaient de comparer plateforme 2D, enquête et RPG tactique solitaire. L’auteur choisit désormais la deuxième pour le MVP. La plateforme à la première personne reste écartée.

Le [laboratoire de mouvement 2D](mouvement-2d.md), dans `experiments/movement/`, conserve les essais Appui, Balancier et Portance. Ces gestes ne conviennent pas à l’auteur et ne sont pas la base du développement courant.

Les règles qui suivent documentent **l’ancienne piste A — conserver et effacer** et le premier essai A/D. Elles ne s’appliquent pas au MVP d’enquête : la fermeture après chaque sélection est remplacée par des allers-retours libres pendant les recherches. Les [alternatives](alternatives-gameplay.md) et le [protocole initial](prototype.md) sont conservés pour comprendre les décisions passées.

## Boucle de la piste A

**Entrer → explorer → interpréter → choisir un objet → voir disparaître le reste → rapporter l'objet au hall → constater une conséquence.**

L'attachement est un résultat recherché de l'exploration ; il ne constitue pas une étape que le système peut imposer.

## Règles de la piste A

| Moment | Action du joueur | Réponse du jeu |
| --- | --- | --- |
| Exploration | Se déplacer, observer, manipuler, écouter | Révéler des traces d'une vie sans imposer un ordre de lecture unique. |
| Inspection | Examiner plusieurs objets | Autoriser la comparaison sans déclencher de perte. |
| Engagement | Désigner un objet pour la collection | Rendre la conséquence pratique perceptible avec sobriété et permettre de se raviser avant de confirmer, sans expliquer sa signification symbolique. |
| Disparition | Assister au retrait du lieu et regagner la sortie | Retirer sons, lumière et éléments du décor en laissant le chemin de retour lisible. |
| Retour | Placer la pièce conservée dans le hall | Montrer une conséquence identifiable et liée à l'objet. |

Une exposition ne fournit qu'un objet conservé. La fermeture après le choix est la règle envisagée ; le comportement des sauvegardes reste ouvert. Aucun score de bonheur ou classement moral n'est prévu.

## Conséquences si une collection est retenue

Deux niveaux sont à distinguer : une trace perceptible dans le hall, nécessaire au premier test, et des effets sur l'exploration, à examiner ensuite.

| Objet envisagé | Trace possible dans le musée | Extension éventuelle, hors premier prototype |
| --- | --- | --- |
| Cassette | Un motif sonore devient audible | Écouter les traces d'autres pièces. |
| Photographie | Une image ou une silhouette apparaît | Révéler un état antérieur d'un lieu. |
| Clé | Un élément architectural se transforme | Ouvrir une zone secondaire. |
| Plante | De la végétation gagne un espace | Aucun pouvoir défini. |

Ces exemples ne constituent pas un inventaire à produire. La [fiche Créer](expositions/creer.md) définit les trois objets de la piste A et le départ de la piste D.

**Tension à résoudre :** si la clé donne accès à davantage de contenu que la photo, le choix risque de devenir une optimisation. Tester d'abord la valeur affective des objets, puis évaluer séparément l'intérêt des capacités.

Si ces capacités sont retenues, tous les choix doivent permettre de terminer le parcours principal. La perte éventuelle de capacités en fin de jeu ne doit pas bloquer la sortie.

## Progression à explorer selon la mécanique retenue

Une collection pourrait transformer le hall et ouvrir certaines possibilités tout en en fermant d'autres. Le nombre de visites, leur ordre et les règles de fermeture des ailes ne sont pas définis.

Si une fermeture définitive est retenue, la découverte des coulisses pose une question : faut-il les découvrir avant le choix, ou y accéder plus tard depuis un passage indépendant ? Voir la [trame narrative](narration.md).

## Hors du premier test

Les pouvoirs, la fermeture d'ailes non visitées, les énigmes propres à chaque exposition, la sauvegarde continue et l'abandon final de la collection restent en attente de la comparaison des gestes élémentaires. Le [prototype](prototype.md) propose de commencer par A et D.
