# Design du jeu — v0.2

**Statut : hypothèses à comparer. Mise à jour : 19 septembre 2026.**

## Cœur encore ouvert

La boucle commune envisagée est : **entrer → explorer et agir → s’investir → s’engager ou partir → constater ce qui change**. Le geste précis reste à choisir parmi les [alternatives](alternatives-gameplay.md).

Les règles ci-dessous décrivent **la piste A — conserver et effacer uniquement**. Les objets, leur collection et l’effacement ne sont pas des exigences communes à toutes les pistes.

## Boucle de la piste A

**Entrer → explorer → interpréter → choisir un objet → voir disparaître le reste → rapporter l'objet au hall → constater une conséquence.**

L'attachement est un résultat recherché de l'exploration ; il ne constitue pas une étape que le système peut imposer.

## Règles de la piste A

| Moment | Action du joueur | Réponse du jeu |
| --- | --- | --- |
| Exploration | Se déplacer, observer, manipuler, écouter | Révéler des traces d'une vie sans imposer un ordre de lecture unique. |
| Inspection | Examiner plusieurs objets | Autoriser la comparaison sans déclencher de perte. |
| Engagement | Désigner un objet pour la collection | Signaler clairement que le choix entraîne la disparition du reste, puis permettre de le confirmer. |
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
