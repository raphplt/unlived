# Chercher une manière de jouer

**Statut : propositions de conception, non implémentées et non retenues par l’auteur.** Recherche du 19 septembre 2026, après les premiers retours sur le MVP.

**Retour du 20 septembre 2026 : recherche à rouvrir au niveau du genre.** L’auteur relève que plusieurs versions d’une même vie risquent de diluer la métaphore du musée de vies différentes non vécues. La recommandation prioritaire d’« emprunter une possibilité » est retirée. Les deux autres pistes suscitent moins d’intérêt. Les propositions ci-dessous sont conservées comme historique de recherche, sans priorité d’implémentation. Le jeu d’énigmes, la plateforme et le RPG sont des directions possibles à examiner ; aucune n’est adoptée. Une représentation plus métaphorique est envisageable, sans obligation de conserver la caméra ou les espaces du MVP.

## Le problème à résoudre

L’auteur demande une activité principale assez riche pour porter un jeu entier, en prenant Outer Wilds et Celeste comme références d’une histoire forte portée par le gameplay. L’appartement actuel est parcouru très rapidement. L’effet de départ fonctionne à ses yeux, même avec les graphismes simples, mais l’intérêt de l’exploration et le risque de répétition restent préoccupants.

Les pistes A/D testent principalement la façon de terminer une visite ; B/C traitent du temps investi et de la sélection des souvenirs. Ce travail ne définit pas encore un ensemble de gestes qui se combine dans de nombreuses situations. Ajouter une activité musicale isolée ne suffit pas à résoudre ce problème pour tout le jeu.

La cible proposée est un plaisir d’action et de compréhension : observer une situation, formuler une hypothèse, agir, percevoir une réponse, ajuster et réussir quelque chose que l’on ne savait pas faire en entrant. Cette activité doit rester intéressante avec des volumes simples et sans texte narratif.

## Ce que les références apportent

Mobius décrit un travail de level design où les indices et les chemins permettent de se diriger avec une intention, plutôt que choisir au hasard : la curiosité doit orienter une décision concrète. [Entretien de l’équipe sur le level design d’Outer Wilds](https://www.mobiusdigitalgames.com/news/the-intentionality-of-wandering).

Maddy Thorson décrit des tolérances de timing et de placement dans Celeste qui favorisent la réussite du geste voulu : anticipation d’un saut, correction de coins, etc. Cette attention concerne directement la sensation de contrôle. [Celeste & Forgiveness](https://www.mattmakesgames.com/articles/celeste_and_forgiveness/index.html).

**Lecture de conception pour Unlived :** rechercher une action fiable et agréable, des règles que l’on peut approfondir, et des découvertes qui ouvrent de nouvelles possibilités d’action. Ces références ne prescrivent ni un jeu de plateforme difficile, ni une boucle temporelle, ni leur échelle de production.

## Trois directions distinctes

| Direction | Gestes dominants | Ce que le joueur apprend | Risque principal |
| --- | --- | --- | --- |
| Emprunter une possibilité | Basculer entre deux versions d’un lieu, retenir un élément, se déplacer, le relâcher | Composer un passage avec des éléments qui n’existent pas ensemble | Le joueur bascule au hasard ou cherche l’unique objet autorisé |
| Faire jouer son écho | Enregistrer une courte action, la faire rejouer, agir simultanément | Coordonner deux présences à partir d’un seul corps contrôlé | Répéter des enregistrements fastidieux ; multiplication des interrupteurs |
| Raccorder les lieux | Observer à travers un passage, déplacer sa destination, traverser | Comprendre une architecture et modifier ses connexions | Désorientation et coût technique des espaces reliés |

Ces directions sont concurrentes. Les combiner d’emblée empêcherait de comprendre laquelle porte réellement le plaisir de jeu.

## Ancienne recommandation, retirée le 20 septembre : emprunter une possibilité

### Proposition

Deux versions d’un lieu occupent le même espace. Le joueur peut passer de l’une à l’autre et maintenir un élément de la version qu’il quitte. Il construit temporairement un espace qui n’existe dans aucune version seule.

L’intérêt recherché est de comprendre comment circuler et agir avec deux dispositions incompatibles. Le rapport au thème vient des gestes répétés de retenir, déplacer son attention et lâcher ; aucun texte dans le jeu ne l’explique.

### Règles de départ

1. Deux versions seulement dans l’essai. Le joueur conserve sa position et son orientation lorsqu’il bascule.
2. Une commande de visée permet de retenir un élément. Il garde son état et sa position lors du basculement, avec ses propriétés utiles : surface solide, lumière, mouvement éventuel.
3. Un seul élément retenu à la fois. En retenir un autre libère le précédent. Un aperçu rend la substitution compréhensible avant validation.
4. L’élément retenu remplace son éventuel correspondant de l’autre version ; le pouvoir ne crée pas des copies infinies. Les éléments disponibles suivent une catégorie visuelle cohérente. On ne promet pas la sélection arbitraire de chaque morceau du décor.
5. Relâcher restaure cet élément dans l’état correspondant à la version actuelle. Les essais ne ferment pas une exposition et ne détruisent pas de souvenir.
6. Un basculement qui placerait le joueur dans un volume solide est refusé avec un retour perceptible. Une erreur de parcours ramène rapidement au dernier appui stable, sans recommencer la visite.

Commandes candidates : une touche pour basculer, une action au viseur pour retenir/remplacer, une action pour relâcher. Les affectations exactes restent à tester. Le petit essai peut fonctionner sans saut précis ; la qualité de la transition et du déplacement compte davantage qu’une exigence de réflexe.

### Une situation qui fonctionne avec la même règle

Le joueur voit une petite mezzanine et une ouverture qu’il souhaite atteindre.

- Dans la première version, une passerelle permet de gagner la mezzanine, mais une cloison ferme l’ouverture.
- Dans la seconde, l’ouverture est libre et la passerelle manque.
- Basculer seul ne suffit pas. Retenir la passerelle, puis basculer, donne une continuité praticable.

C’est une première application volontairement simple. Elle enseigne une propriété par l’espace. Elle ne suffit pas à prouver la profondeur du système.

La situation suivante ajoute un appui stable intermédiaire : le joueur doit s’y placer pour pouvoir abandonner le premier élément et en retenir un autre. Le problème porte désormais sur le trajet et l’ordre des opérations. Une variante utilise un élément mobile avec une trajectoire lisible et de longues plages d’accès. On cherche une maîtrise du placement et du passage entre états, sans faire du chronométrage serré une obligation.

Une application ultérieure peut concerner une propriété différente : retenir une lampe pendant le changement d’une cloison, par exemple, pour éclairer un angle auparavant inaccessible. Elle doit utiliser de la lumière effective, pas une association arbitraire du type « lumière dorée = serrure dorée ».

### D’où viendrait la profondeur

La difficulté ne doit pas dépendre principalement de nouvelles commandes. Les mêmes règles rencontrent des contraintes différentes : ligne de vue, accès à un point d’appui, trajet d’un objet mobile, remplacement d’un élément, observation d’un espace depuis un nouvel angle.

Les niveaux doivent ménager plusieurs éléments plausibles et accepter des solutions compatibles avec les règles, même si elles ne sont pas la séquence initialement prévue. Si un seul objet brille dans chaque salle, le joueur applique une indication au lieu de comprendre un système.

Le joueur expérimenté doit voir des possibilités qu’un débutant ne remarquait pas : un meilleur point où basculer, un raccourci, un moyen de se passer de l’élément qui semblait indispensable. Une connaissance acquise ailleurs doit parfois rendre un ancien espace nouvellement accessible sans nouvelle clé d’inventaire.

### Comment raconter avec ce système

Les deux états doivent être deux organisations plausibles du quotidien, avec des objets et des dispositions qui portent des activités différentes. Éviter de systématiquement opposer une version heureuse à une version sinistre, ou de présenter l’une comme fausse et l’autre comme vraie.

Un exemple possible : une pièce a été dégagée pour accueillir des musiciens dans un état ; dans l’autre, le même espace est occupé par une table préparée et des chaises. Le joueur apprend la disposition en résolvant un problème d’accès. Il peut ensuite en déduire des différences de vie. Le décor conserve des traces ordinaires qui ne sont pas toutes des outils d’énigme.

Les limites entre les versions peuvent également fournir des indices sur le musée. Cela ne fixe pas leur nature réelle, la biographie du visiteur ou la fin.

### Échecs possibles de cette direction

- Les basculements deviennent une inspection systématique et sans hypothèse de chaque mètre carré.
- Les objets retenus sont des clés déguisées, chacun ne servant qu’une seule fois dans son emplacement prévu.
- Les changements de caméra ou de géométrie désorientent davantage qu’ils ne donnent envie d’expérimenter.
- Les pièces sont déformées en parcours d’obstacles et ne donnent plus envie d’y habiter.
- Les relations entre états nécessitent tellement de contenu distinct que chaque problème coûte presque deux décors complets.

Pour limiter le dernier risque, l’essai utilise une enveloppe commune et quelques différences de géométrie. Les ombres ou la couleur seules ne constituent pas une seconde version jouable.

## Alternative : faire jouer son écho

### Proposition

Le joueur peut enregistrer une courte suite de déplacements et d’interactions, revenir au point de départ, puis agir pendant qu’un écho reproduit cette séquence. Il coopère avec une présence issue de ses propres gestes.

Règles candidates : un seul écho, enregistrement lancé et terminé volontairement, dernier geste maintenu lorsque c’est possible, réessai local rapide. Une limite courte sert à contenir le système, sans imposer de longs trajets à réenregistrer. L’essai réinitialise les quelques objets concernés avant chaque lecture pour éviter les incohérences.

### Situation

Une manivelle permet de déplacer une petite plateforme, mais on ne peut pas l’actionner tout en restant dessus. Le joueur enregistre l’action à la manivelle, puis monte pendant que l’écho la reproduit. Ensuite, il peut préparer une trajectoire plus élaborée et se rendre lui-même à un second endroit pendant l’exécution.

Le piano peut employer exactement le même système : enregistrer une partie, se déplacer, répondre depuis l’autre place. Une scène de relation naît de l’utilisation d’un outil déjà appris, sans ouvrir un mini-jeu sans rapport.

### Intérêt et réserve

Cette direction privilégie la préparation, la coordination et le plaisir de voir une action personnelle fonctionner. Elle est plus proche de l’activité musicale envisagée auparavant, mais la généralise à l’exploration.

Son danger est net : devenir un jeu de plaques de pression où l’on attend son double. Les scènes doivent offrir autre chose que « immobiliser l’écho sur un bouton ». Il faut également vérifier que regarder cette silhouette reste intrigant et ne livre pas trop tôt une interprétation sur l’identité du personnage.

## Alternative : raccorder les lieux

### Proposition

Certains encadrements montrent un autre espace et constituent de vrais passages. Le joueur peut conserver la destination d’un encadrement, puis la raccorder à un autre. Il modifie les voisinages du musée plutôt que déplacer son mobilier.

Règles candidates : une connexion mobile seulement ; des seuils compatibles reconnaissables ; une destination repérée avant d’être raccordée ; déplacement et orientation conservés de manière cohérente lors du franchissement. Aucun basculement illimité entre toutes les salles depuis un menu.

### Situation

Le joueur voit une coursive à travers une fenêtre haute, mais ne peut pas atteindre cette fenêtre depuis le sol. Il peut en viser l’encadrement pour retenir sa destination, puis la raccorder à un seuil situé à sa hauteur. Ce seuil donne désormais sur la coursive. C’est une introduction simple ; dans une autre configuration, le choix d’une ouverture et de son orientation change le côté par lequel on arrive dans la pièce. Il faut lire les orientations et les connexions, pas seulement trouver la prochaine porte à activer.

Une mélodie entendue à travers un passage peut permettre de reconnaître où il mène avant de le franchir. Le joueur découvre alors par l’action que deux expositions étaient voisines d’une manière qu’il n’imaginait pas.

### Intérêt et réserve

C’est la direction la plus forte pour faire de l’architecture impossible un outil du joueur. Elle peut aussi donner une raison de revisiter le hall et de comprendre la construction du musée.

C’est également la plus risquée techniquement et spatialement : rendu à travers les seuils, collisions, orientation, audio et lisibilité de la carte. Un essai devrait se limiter à deux pièces et deux encadrements, sans récursion visible. Ne pas prendre son pouvoir d’évocation pour une preuve de jouabilité.

## Tenir un jeu entier

Quelle que soit la direction retenue, les expositions doivent développer la même grammaire au lieu de proposer chacune un mini-jeu entièrement différent. Leur activité et leur tonalité peuvent varier ; les gestes fondamentaux doivent rester utiles.

La progression proposée comporte trois dimensions complémentaires :

- **Maîtrise :** réussir des combinaisons plus intéressantes avec les mêmes gestes.
- **Compréhension :** découvrir une propriété qui ouvre une nouvelle possibilité dans un lieu déjà vu.
- **Récit :** résoudre une question locale et modifier une hypothèse sur le musée, avec des indices cohérents plutôt qu’une série d’anomalies sans réponse écrite.

Le nombre d’expositions et les révélations finales restent ouverts. La progression ne peut pas compter seulement sur un effet d’effacement plus spectaculaire à chaque visite.

### Un conflit à résoudre avec le prototype actuel

L’expérimentation demande le droit de se tromper ; la clôture émotionnelle demande parfois une perte définitive. Les basculements, les essais d’écho ou les raccords doivent être réversibles. Un engagement de fin de visite appartient à une autre échelle.

De même, une progression fondée sur les connaissances profite des retours dans les lieux. Il faut envisager un retour ordinaire au hall distinct de la fermeture définitive d’une exposition. Si des lieux deviennent définitivement inaccessibles, aucune compréhension indispensable ne doit être perdue sans possibilité cohérente de la retrouver ailleurs. Ces changements de structure sont proposés, pas encore adoptés.

Le récit ne doit pas soudain déclarer mauvais le geste de combinaison que le jeu a appris au joueur à aimer. Le thème peut en interroger les limites ; une fin qui punit arbitrairement la maîtrise acquise demanderait une autre construction.

## Ce qui justifierait de poursuivre

L’essai recommandé contient deux états d’une pièce, un élément à retenir, puis trois problèmes courts qui réemploient la règle : la découvrir, combiner plusieurs opérations depuis un appui stable, trouver une application moins évidente. Pas de nouvelle exposition narrative, de score, de collection complète ou de décision irréversible nécessaire à cet essai.

Observer si le joueur comprend pourquoi une tentative échoue, anticipe une conséquence, invente un essai non montré et veut appliquer la règle à un autre endroit. Un joueur qui bascule partout au hasard ou suit seulement les objets mis en évidence ne démontre pas encore la profondeur recherchée.

Ne pas promettre que cette direction est déjà plaisante ou qu’elle portera plusieurs heures. Si elle n’offre pas de plaisir identifiable avec quelques volumes et un retour sensoriel soigné, la narration et les décors ne doivent pas servir à masquer ce résultat. L’écho est alors un autre essai crédible, avec une source de plaisir différente.
