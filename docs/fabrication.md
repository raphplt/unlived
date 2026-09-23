# Étude de fabrication et d'outillage

**État : recherche du 19 septembre 2026 ; proposition, pas choix de production.** Caméra, rendu et temps disponible restent ouverts. L'objectif est d'établir une boucle courte : modifier une scène, la lancer, observer le résultat, corriger.

**Suite de l’étude :** un [MVP Godot 4.6](../game/README.md) met désormais en œuvre l’essai en première personne et les variantes A/D. Scènes, interactions et captures sont vérifiées dans le moteur. L’inventaire ci-dessous décrit le repérage préalable ; aucun export autonome ni essai comparatif avec des joueurs n’est encore livré.

## Modèles envisagés : ce qui est documenté

Le nom « ChatGPT 6 » est ici rapproché de **GPT‑6 Astra**, référence trouvée dans la documentation officielle. Le modèle exact et son accès dans l'application ou l'abonnement utilisé devront être confirmés ; une fiche API ne décrit pas toutes les possibilités d'une application.

| Modèle | Capacités documentées utiles | Application envisagée au projet |
| --- | --- | --- |
| GPT‑6 Astra | Texte en entrée/sortie, images en entrée, appels de fonctions et outils ; pas de sortie audio ou vidéo native indiquée. | Écriture et correction de scripts, analyse de captures et utilisation des commandes mises à disposition. |
| Claude Fable 5.1 | Travail de programmation prolongé avec outils ; texte et images en entrée, texte en sortie ; contexte de 1 million de tokens. | Second essai possible sur un problème de code ou examen d'une scène à partir de captures. |

Sources : [fiche GPT‑6 Astra](https://developers.openai.com/api/docs/models/gpt-6-astra), [fiche Claude Fable 5.1](https://platform.claude.com/docs/en/models/fable-5-1/overview). Les applications au projet sont des **déductions à vérifier**, pas des résultats de tests Godot, Unity ou Blender. Ces pages ne permettent pas de classer les deux modèles sur Unlived.

Le modèle fournit du code ou des instructions ; l'environnement de travail donne accès aux fichiers, au moteur et aux résultats. Codex CLI documente la lecture, la modification et l'exécution du code local. Cela ne prouve pas qu'un moteur est déjà pilotable graphiquement ni qu'une scène a été jouée. Voir [Codex CLI](https://learn.chatgpt.com/docs/codex/cli).

## Ce qu'on peut raisonnablement essayer

| Travail | Méthode proposée | Preuve attendue |
| --- | --- | --- |
| Déplacement, inspection, changement d'état | Scripts dans le moteur et petite scène de test. | Parcours jouable et interactions vérifiées. |
| Hall et appartement simples | Volumes et objets assemblés dans le moteur, puis retouchés. | Captures à hauteur de joueur et test des collisions. |
| Effacement, éclairage, interface | Effets simples, réglés à partir d'images avant/après. | Lisibilité pendant le jeu, pas seulement sur une capture. |
| Objets spécifiques | Modélisation dans Blender si les formes du moteur ne suffisent plus. | Un objet importé, à la bonne échelle, avec matériaux vérifiés. |
| Ambiance sonore | Quelques sons provisoires intégrés et réglés dans le moteur. | Écoute réelle du contraste avant/après ; l'analyse d'images ne suffit pas. |

Évaluer le rythme, le confort de caméra, la cohérence artistique et l'attachement exige une expérience jouée. La production de beaucoup de code ne renseigne pas à elle seule sur ces qualités.

## Godot, Unity et Blender

| Outil | Possibilité documentée | Proposition pour Unlived |
| --- | --- | --- |
| Godot | Lancement de projets et de scènes, scripts, fonctionnement sans fenêtre et export par commandes. | Premier candidat pour une scène très réduite, facile à relancer et observer. |
| Unity | Exécution de méthodes d'éditeur avec `-executeMethod` et mode `-batchmode`. | Alternative crédible, notamment si l'expérience personnelle de l'éditeur rend les itérations plus rapides. |
| Blender | Exécution de scripts en arrière-plan documentée ; Godot décrit l'import de scènes Blender et recommande glTF. | Complément pour quelques objets ou décors spécifiques, à ajouter lorsqu'un besoin apparaît. |

Sources : [commandes Godot](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html), [commandes Unity](https://docs.unity3d.com/6000.0/Documentation/Manual/EditorCommandLineArguments.html), [scripts Blender](https://docs.blender.org/api/5.0/info_tips_and_tricks.html), [formats 3D dans Godot](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/available_formats.html). La page Blender a été repérée dans l'index de recherche officiel, mais sa lecture intégrale a été bloquée ; ses détails devront être vérifiés avec la version installée avant automatisation.

L'exécution sans fenêtre vérifie certains comportements et erreurs, pas le rendu, le son ou le confort du joueur. Les commandes natives suffisent à envisager un premier essai ; un connecteur d'éditeur n'est pas un prérequis. En ajouter un seulement si une opération concrète reste difficile à effectuer ou observer.

## Repérage local

- **Godot :** exécutable repéré dans `/opt/godot-mono/`, version retournée : `4.6.1.stable.mono.official.14d19694e`. Son lancement pour lire la version fonctionne ; aucune scène n'a été testée.
- **Unity :** déclaré installé ; Unity Hub et une commande `unity` sont repérés. Un raccourci mentionne `6000.3.6f1`, mais son chemin d'éditeur reste à vérifier. La disponibilité d'un éditeur fonctionnel n'a pas été démontrée par ce repérage.
- **Blender :** aucune commande trouvée dans le PATH. Cela ne suffit pas à prouver son absence de la machine ; installation envisageable si nécessaire.

Aucune installation ou mise à niveau n'est nécessaire à cette étude. Utiliser d'abord la version du moteur réellement disponible, avec sa documentation correspondante ; ne pas reprendre les numéros de version des anciennes notes comme référence actuelle.

## Caméra et rendu à comparer

| Forme | Intérêt pour cette expérience | Travail et risque à mesurer |
| --- | --- | --- |
| 3D à la première personne | Inspecter les objets de près et découvrir spatialement l'envers du musée. | Confort du déplacement, composition moins contrôlée et repérage des interactions. |
| 3D en vues fixes | Composer chaque tableau et montrer précisément une transformation. | Transitions, zones cachées et distance ressentie avec les objets. |
| 2D ou 2,5D en tableaux | Organiser des scènes lisibles autour de gestes et de traces. | Production des images et expression des coulisses ; ce n'est pas automatiquement moins de travail. |

**Proposition de premier essai : Godot, petite pièce 3D en première personne, formes simples et éclairage sobre.** Ce choix sert à tester le rapport aux objets et à l'espace. Il ne fixe ni la direction artistique finale ni le moteur de production. Une vue fixe de la même pièce pourra ensuite fournir une comparaison sans refaire tout le contenu.

Blender devient utile quand la forme d'un objet compte pour l'expérience, pas pour prouver qu'une porte ou un choix fonctionne. Le photoréalisme, les personnages animés et une chaîne de production complète ne sont pas nécessaires à cet essai.

## Essai technique proposé, à réaliser ensuite

Créer une pièce, un objet inspectable, une lumière modifiable et une sortie. Vérifier le lancement, corriger une erreur, obtenir une capture et exporter un petit exécutable. Mesurer le temps passé et les interventions manuelles ; tester ensuite le confort en jouant.

Pour examiner l'apport éventuel de Fable 5.1, lui soumettre plus tard le même problème borné depuis une copie identique du projet et comparer le résultat vérifié, les régressions, les corrections manuelles et le coût réel. Aucun benchmark comparatif n'est réalisé ici.

Retenir l'environnement qui permet de **modifier, voir et jouer rapidement**. Si le premier essai fonctionne, construire les variantes [A/D](prototype.md) dedans ; sinon examiner Unity avant de multiplier les extensions. Disponibilités hebdomadaires, budget d'outils et aisance dans chaque éditeur restent inconnus : aucun délai de livraison n'en est déduit.
