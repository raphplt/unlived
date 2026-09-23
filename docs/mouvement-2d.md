# Trois études de mouvement en 2D

**20 septembre 2026 — recherche et petits essais implémentés, aucun geste retenu par l’auteur.**

**Retour ultérieur de l’auteur : aucun des trois gestes ne lui convient ; la recherche paraît trop centrée sur la réinvention des mouvements.** La recommandation d’essayer Appui en priorité est retirée de la démarche actuelle. Ce document et le laboratoire sont conservés comme historique. La suite demandée est la rédaction de [fiches projets complètes](fiches-projets/README.md) pour permettre de choisir une forme de jeu.

La demande est de trouver une action agréable à répéter et assez profonde pour porter Unlived. Le personnage aura une histoire propre ; les mêmes éléments pourront prendre plusieurs sens au fil des vies. Ces études examinent le plaisir de déplacement avant de choisir leur incarnation narrative. Elles ne supposent ni plusieurs versions manipulables d’une vie, ni plateforme en première personne.

## Livrable jouable

Lancer `./tools/movement.sh`, ou importer `experiments/movement/project.godot` dans Godot 4.6. Le laboratoire est un projet distinct du musée. F1/F2/F3 permettent de comparer les trois gestes ; chacun possède trois petits parcours. Pg↑/Pg↓ permettent de changer de parcours sans devoir réussir le précédent. L’aide H et le chronomètre T sont facultatifs.

Les neuf parcours utilisent une même présentation sobre, une silhouette temporaire, les mêmes collisions de base, la même marche et le même saut. La géométrie varie pour donner à chaque geste des situations adaptées. Ce n’est pas un test contrôlé de difficulté équivalente : leurs différences doivent être prises en compte dans les retours. La silhouette et les accessoires ne définissent pas le personnage final.

Les sons servent de retours discrets aux actions. Ils ne constituent pas une proposition de bande originale. Les consignes visibles sont celles d’un outil d’essai, sans explication du thème ou du scénario.

## Commandes communes

| Action | Clavier | Manette |
| --- | --- | --- |
| Marcher / orienter | Flèches ou positions physiques WASD (ZQSD en AZERTY) | Stick gauche ou croix |
| Sauter | Espace | A |
| Geste étudié | Maintenir puis relâcher E ou Maj | Maintenir puis relâcher X |
| Recommencer le parcours | R | Back / Select |
| Pause | Échap ; Entrée reprend aussi | Start |
| Parcours suivant | Entrée après réussite ; Pg↓ à tout moment | Gâchette supérieure droite |

Le saut ordinaire est volontairement court. Une pression prolongée donne davantage de hauteur qu’une pression brève. Une petite tolérance après le bord d’une plateforme et une anticipation du saut avant réception rendent les commandes plus accueillantes. Une chute ramène immédiatement au départ du petit parcours. Les essais ne retirent aucune possibilité narrative.

## A — Appui : préparer une trajectoire depuis une surface

### Proposition et minute de jeu

On court vers un bord, on prépare une poussée, puis on s’élance. En arrivant sur une petite plateforme, on freine ou on reprend immédiatement appui pour repartir. Une paroi verticale peut également servir d’appui : on peut s’y retenir, préparer puis éjecter le personnage vers l’extérieur.

La maîtrise recherchée porte sur le point de départ, la durée de préparation, la direction et la réception. Le geste n’est disponible qu’au contact d’une surface ; il ne fournit pas un rattrapage libre au milieu du vide.

### Règles de l’essai

- Maintenir E au sol ou contre un mur immobilise le personnage et prépare une impulsion. La préparation atteint son maximum en une demi-seconde ; la garder plus longtemps n’apporte rien.
- Les directions orientent le départ. Sans direction, le départ est diagonal, dans le sens du regard au sol, vers l’extérieur sur une paroi.
- La poussée quitte toujours la surface qui la supporte. Viser dans le sol ou dans le mur ne permet pas de les traverser.
- Relâcher E déclenche l’impulsion. Espace permet d’annuler la préparation ; aucune interprétation narrative n’est associée à ce geste.
- Tous les sols et murs solides partagent cette règle. Aucun marquage ne transforme une surface particulière en clé unique.
- En vol, on peut corriger ou freiner horizontalement. Une nouvelle impulsion demande un nouveau contact.

### Trois situations implémentées

1. **La portée :** deux intervalles plus longs qu’un saut ordinaire, avec de larges réceptions. Comprendre la préparation et la portée.
2. **Les hauteurs :** les appuis montent. Choisir où se placer avant le départ, afin de passer au-dessus de la face de la plateforme suivante.
3. **Les intervalles :** des réceptions plus étroites, une descente puis une remontée, et un plafond. La préparation maximale n’est pas toujours adaptée ; se replacer sur l’appui peut être utile.

L’appui mural est implémenté et vérifié physiquement, mais les parcours ne prouvent pas encore l’intérêt d’un long enchaînement de murs. Ce serait un essai supplémentaire si le geste plaît.

### Potentiel et limites

La même action peut produire de la vitesse ou des pauses d’observation. Des surfaces mobiles, obliques ou des routes alternatives pourraient approfondir le placement, mais ne sont pas implémentées ici. Ce système laisserait des endroits calmes où regarder un détail sans imposer une interruption narrative.

**Risque principal :** un jeu « arrêter, charger, repartir » qui fatigue rapidement. Une charge trop sensible pourrait devenir un exercice de dosage frustrant. Il faut vérifier si le plaisir vient de trajectoires que l’on choisit ou simplement du soulagement d’avoir réussi. Une règle familière de saut chargé n’établit pas à elle seule la singularité d’Unlived.

**Critère de poursuite :** après quelques passages, le joueur commence à varier volontairement ses points de départ et ses réceptions, et a envie de rejouer. **Critère de révision :** il attend systématiquement la charge maximale puis recommence jusqu’à tomber au bon endroit.

## B — Balancier : fabriquer une trajectoire puis choisir le lâcher

### Proposition et minute de jeu

On saute vers un anneau, on le saisit, on transforme la chute en arc, puis on lâche pour atteindre une plateforme ou un deuxième anneau. La vitesse acquise continue de porter le personnage après le lâcher.

La maîtrise recherchée porte sur le moment de saisie, qui détermine la longueur du fil, puis sur le balancement et l’angle du départ. Le joueur peut retrouver la même destination par des arcs différents.

### Règles de l’essai

- L’anneau accessible sélectionné est éclairé avant la saisie. La sélection tient compte de la distance, de la direction du personnage et des obstacles.
- Appuyer sur E saisit cet anneau ; maintenir conserve la prise. La longueur du fil est celle de la distance au moment de la saisie. Il n’y a pas de treuil automatique.
- Gauche/droite permettent de prendre de l’élan. Relâcher E ou appuyer sur saut lâche le fil, sans impulsion magique ajoutée.
- Il faut relâcher puis appuyer à nouveau pour saisir un autre anneau. Le fil ne se transfère pas automatiquement au suivant.
- Un obstacle masque une cible ou coupe le fil si celui-ci rencontre une paroi. Le fil ne s’enroule pas autour des angles. Les corrections de longueur respectent les collisions du personnage.

### Trois situations implémentées

1. **Le lâcher :** un anneau et un grand intervalle. Essayer plusieurs moments de lâcher.
2. **Le relais :** deux anneaux et un petit appui central, puis une arrivée plus haute. Choisir une reprise au sol ou un relais en vol.
3. **Le détour :** une paroi coupe certaines lignes de saisie. Passer en dessous, puis trouver un nouveau moment de prise.

### Potentiel et limites

Le mouvement peut devenir fluide et expressif. Une architecture faite de points de suspension pourrait donner des routes de maîtrise différentes des passages les plus sûrs. Des supports mobiles constitueraient une extension à vérifier, pas une promesse de contenu.

**Risques :** perdre la lisibilité de la cible automatique, se retrouver suspendu trop bas ou cogner une paroi en perdant tout son élan. Un parcours composé uniquement d’anneaux espacés régulièrement serait répétitif. Les anneaux ont une présence matérielle forte : leur intégration dans des vies très différentes reste à résoudre sans justification artificielle.

**Critère de poursuite :** le joueur décrit un meilleur arc ou un autre moment de lâcher qu’il veut essayer. **Critère de révision :** il se sent transporté par le système ou pense que les réussites dépendent du hasard de l’accroche.

## C — Portance : choisir quand planer et quand descendre

### Proposition et minute de jeu

On saute d’un promontoire, ouvre une voile pour prolonger le déplacement, la referme pour descendre sous un obstacle, puis l’ouvre dans un courant ascendant pour retrouver de la hauteur.

La maîtrise recherchée porte sur la gestion continue de la trajectoire. Ouvrir ne remplace pas systématiquement le saut : il faut d’abord une hauteur de départ ou un courant.

### Règles de l’essai

- E maintenu en l’air ouvre la voile. La vitesse horizontale disponible augmente, la gravité diminue et la chute est plafonnée.
- Hors d’un courant, la voile ne crée pas une ascension. Elle peut conserver un mouvement montant déjà acquis.
- Dans une zone de courant clairement dessinée, une voile ouverte reçoit une poussée ascendante.
- Relâcher retrouve la chute normale. On peut ouvrir et fermer plusieurs fois pendant un vol, sans stock ni recharge.
- Sols et obstacles restent solides. Il faut lire leurs passages et gérer la hauteur ; aucune transformation de monde n’intervient.

### Trois situations implémentées

1. **La traversée :** une grande distance depuis un point haut, sans courant. Ouvrir prolonge le trajet ; fermer permet de se poser.
2. **Les courants :** deux zones ascendantes et des arrivées plus élevées. Quitter le courant au bon endroit.
3. **Les passages :** une remontée, un obstacle suspendu, une zone basse puis une nouvelle remontée. Alterner délibérément ouverture et fermeture.

### Potentiel et limites

Cette famille de mouvement pourrait faire place à de grands paysages et à des trajectoires contemplatives, avec des détours plus exigeants. Des courants traversiers ou intermittents pourraient renouveler les routes, mais ne sont pas présents dans l’essai.

**Risque principal :** maintenir E et droite pendant l’essentiel du jeu. La voile seule fournit peu de décisions ; la qualité du placement des courants et obstacles sera déterminante. Multiplier les zones de vent pour donner de la profondeur pourrait finir par dicter trop visiblement tous les chemins.

**Critère de poursuite :** le joueur choisit sa hauteur et ouvre/ferme avec une intention qu’il peut expliquer. **Critère de révision :** il traverse sans choix, ou passe surtout du temps à attendre de monter ou de descendre.

## Comparaison de conception — à confronter au jeu

| Question | Appui | Balancier | Portance |
| --- | --- | --- | --- |
| Ce que l’on affine | Placement, direction, puissance | Saisie, arc, lâcher | Hauteur, ouverture, fermeture |
| Rythme pressenti | Impulsions séparées par des appuis | Trajectoires liées et variations de vitesse | Traversées plus longues, alternance montée/chute |
| Repos possible | Sol et prise murale | Sol ; suspension selon la situation | Sol, avec un vol parfois calme |
| Dépendance au décor | Géométrie des surfaces | Disposition et lisibilité des anneaux | Hauteurs, courants et passages |
| Dérive à éviter | Attendre une charge à chaque obstacle | Suivre une chaîne d’anneaux | Maintenir deux touches pendant un long trajet |

**Avis de travail : essayer Appui en premier**, parce que sa règle s’applique aux surfaces ordinaires et permet de varier placement, portée et réception sans multiplier les dispositifs. Balancier est un contrepoint important pour juger si le mouvement continu apporte davantage de plaisir. Portance sert à éprouver une cadence plus ample. Cet ordre est une hypothèse de conception ; les essais automatiques ne permettent pas de classer leur plaisir.

Je ne recommande pas de réunir immédiatement les trois gestes. Cela ajouterait des commandes et masquerait les faiblesses de chacun. Aucun de ces systèmes n’est encore considéré comme la mécanique distinctive d’Unlived.

## Ce qui a été vérifié et ce qui reste à observer

`./tools/test-movement.sh` exerce le moteur physique : marche et saut, préparation/annulation, appui mural, portée et obstruction des anneaux, conservation de l’élan au lâcher, voile et courant, pause, retour après chute et commandes physiques du clavier. Les neuf parcours disposent chacun d’une traversée automatique jusqu’à la sortie, sans téléportation pendant le parcours. Les routes Appui utilisent une diagonale de clavier, pas une direction réservée au stick analogique.

Ces contrôles vérifient la faisabilité et certaines règles. **Ils ne prouvent ni que les parcours sont accessibles à un débutant, ni qu’ils sont amusants, ni que la profondeur suffit pour un jeu entier.** Les exemples restent courts ; les paramètres sont exposés dans le code et la difficulté n’a pas été calibrée par des séances humaines.

Résultat technique de cette version : **37 contrôles de physique/progression, 0 échec**. `./tools/test-movement.sh --display` ajoute **23 contrôles graphiques et de commandes, 0 échec**, dont trois tailles de fenêtre (960 × 600, 1280 × 1024, 1920 × 1080), le plein écran et les changements de parcours. Des captures ont également été inspectées. Le confort d’une manette physique reste à essayer.

Pour une première séance, consacrer quelques minutes à chaque geste, changer de parcours librement et garder le chronomètre masqué au début. Puis revenir au premier geste : distinguer l’effet de nouveauté d’une envie durable de mieux jouer. Une autre séance peut changer l’ordre des trois essais.

Relever surtout :

- le moment précis où l’on a eu envie de recommencer ;
- une erreur comprise et une erreur qui semblait injuste ;
- une autre trajectoire que l’on a voulu tenter ;
- les attentes, répétitions ou commandes qui fatiguent ;
- l’envie réelle de passer encore dix minutes avec le même geste.

Le laboratoire conserve localement les derniers essais, chutes et meilleurs temps pour faciliter la comparaison. Ces valeurs n’évaluent pas le plaisir et ne sortent pas de la machine. Il n’y a ni classement en ligne ni perte narrative.

## Passage ultérieur au récit

Une fois un geste intéressant identifié, écrire une courte séquence avec un événement concret de l’histoire du personnage et une correspondance destinée à prendre un autre sens dans une autre vie. Il faudra alors vérifier les trois lectures validées : plaisir du parcours, reconnaissance entre vies, nouvelle compréhension du personnage. Les lieux de cette étape ne sont pas imposés par le laboratoire, et aucune biographie ou troisième couche de sens n’est fixée ici.
