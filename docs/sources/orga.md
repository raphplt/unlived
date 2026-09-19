> **vision → preuve de concept → direction → structure complète → vertical slice → production**

Parce que tu veux valider très tôt que **le musée fonctionne réellement comme jeu**, pas uniquement comme idée.

## Les prochaines étapes, dans l’ordre

1. **Formaliser le cœur du jeu**
   Fais un document très court, 1 à 2 pages maximum. Il doit contenir : le pitch, le thème, ce que le joueur fait, ce qu’il ressent, ce que le jeu veut explorer, la boucle principale, la durée visée, et surtout les choses que le jeu **ne sera pas**.

   Pour l’instant, quelque chose comme :

   > Jeu narratif d’exploration où le joueur visite les vies qu’il aurait pu vivre. Chaque exposition lui demande d’en comprendre les traces puis d’en conserver une seule chose, provoquant la disparition du reste. À mesure que le musée se referme, le joueur découvre que chercher “la bonne vie” est peut-être précisément le piège.

   Ce document devient ta **constitution**.

2. **Définir les piliers de design**
   Trois à cinq max. Par exemple :
   - **Découvrir plutôt qu’être expliqué**
   - **Chaque choix implique une perte**
   - **Le gameplay porte le thème**
   - **Beauté et mélancolie, jamais misérabilisme**
   - **Aucun choix objectivement meilleur**

   Ensuite, chaque idée doit pouvoir être refusée si elle contredit ces piliers.

3. **Faire un prototype moche immédiatement**
   Avant le scénario complet. Avant le moodboard parfait.

   Une salle grise. Une porte. Une mini-“vie”. Trois objets. Tu en prends un. Les autres disparaissent. La porte derrière toi se ferme. L’objet apparaît ensuite dans le musée.

   **Pas de beaux graphismes. Pas de vraie histoire.**

   La question à vérifier est :

   > “Est-ce que choisir quelque chose puis perdre le reste produit déjà une sensation intéressante ?”

   Si non, le concept doit évoluer avant que tu investisses 200 heures dedans.

4. **Construire ta bible créative**
   Une fois ce prototype convaincant, là oui : formalisation sérieuse.

   Je créerais environ **7 documents**, pas un GDD de 150 pages :
   - **Vision / Game Pillars**
   - **Game Design Document**
   - **Narrative Design Document**
   - **World / Museum Bible**
   - **Art Direction Bible**
   - **Audio Direction**
   - **Production / Roadmap**

   Ils peuvent commencer très petits et grossir avec le jeu.

5. **Écrire l’architecture narrative complète**
   Oui, je pense que **ce jeu doit être largement écrit à l’avance**.

   Mais il faut distinguer deux choses.

   **Écrire la structure entière : oui.**  
   Tu dois connaître :
   - le début ;
   - les différentes expositions ;
   - ce que le joueur croit à chaque étape ;
   - les indices ;
   - la découverte des coulisses ;
   - l’exposition 0 ;
   - le twist ;
   - le dernier acte ;
   - la fin.

   **Écrire immédiatement chaque dialogue et chaque description : non.**

   Tu risques sinon d’écrire énormément de contenu qui disparaîtra lorsque le gameplay changera.

   Je ferais d’abord un énorme diagramme du type :

   `Entrée → exposition A/B/C → conséquences → anomalie → coulisses → nouvelles expositions → recontextualisation → exposition idéale → exposition 0 → abandon → sortie`

6. **Écrire chaque exposition comme une micro-histoire**
   Pour chacune, crée une fiche d’une page :
   - quel fantasme représente-t-elle ?
   - pourquoi est-elle séduisante ?
   - quel est son prix ?
   - quelle activité fait le joueur ?
   - quelle information comprend-il sans dialogue ?
   - quels objets peut-il conserver ?
   - comment chacun modifie le musée ?
   - qu’est-ce que les coulisses révèlent ?
   - quelle émotion doit rester après l’avoir quittée ?

   C'est probablement là que tu vas passer une énorme partie du travail créatif.

7. **Construire le système de conséquences**
   Très tôt.

   Fais une matrice :

   | Choix    | Effet immédiat              | Musée               | Gameplay                          | Narration                   | Contenu perdu            |
   | -------- | --------------------------- | ------------------- | --------------------------------- | --------------------------- | ------------------------ |
   | Cassette | conserve un souvenir sonore | musique dans le hub | permet d’écouter certaines traces | débloque certains fragments | autre objet inaccessible |

   L'objectif n'est pas d'avoir 500 embranchements.

   Au contraire : **quelques conséquences visibles et élégantes** valent mieux qu'un arbre narratif monstrueux.

8. **Direction artistique + moodboard**
   Là, oui.

   Mais pas seulement un Pinterest de belles images.

   Sépare ton moodboard en catégories :
   - architecture du musée ;
   - matériaux ;
   - lumière ;
   - palettes ;
   - interfaces ;
   - typographie ;
   - expositions ;
   - coulisses ;
   - personnages/silhouettes ;
   - effets de disparition ;
   - références cinéma/photo/peinture ;
   - musique et sound design.

   Et ajoute à chaque image :

   > **Pourquoi est-ce que je la garde ?**

   Sinon tu obtiens juste une collection d’images jolies sans direction artistique.

9. **Choisir la technologie après le prototype conceptuel**
   Pour ton cas, je commencerais très probablement par **Godot**.

   En septembre 2026, Godot 4.7.2 est la branche stable actuelle et 4.8 est encore en développement. Godot reste libre/open source, prend en charge la 2D et la 3D et propose GDScript ou C#.

   Pour ton projet, ses avantages sont très convaincants :
   - léger ;
   - itération rapide ;
   - excellent pour un solo dev ;
   - pas de lourdeur commerciale ;
   - suffisamment puissant pour une DA stylisée ;
   - scripting très accessible pour toi.

   **Unity** resterait un candidat valable si tu identifies un plugin, pipeline ou asset précis qui change réellement l’équation.

   **Unreal**, actuellement en 5.8, est extrêmement puissant et Epic l’oriente notamment vers des workflows de worldbuilding et de rendu haute fidélité ; pour un premier projet solo narratif de quelques heures, je le considérerais plutôt comme une complexité supplémentaire sauf si tu veux absolument une esthétique 3D très ambitieuse.

   Donc je ferais un **tech spike Godot** avant toute décision définitive.

10. **Créer une vertical slice**
    C'est une étape différente du prototype.

    Prototype :

    > “La mécanique fonctionne-t-elle ?”

    Vertical slice :

    > “Est-ce que ce jeu, dans sa forme finale, peut être bon ?”

    Tu prends **une exposition entière** et tu la réalises presque au niveau final :
    - DA ;
    - musique ;
    - interactions ;
    - narration environnementale ;
    - choix ;
    - disparition ;
    - retour au musée ;
    - conséquences.

    Si cette tranche de 15–20 minutes fonctionne vraiment, tu as quelque chose.

11. **Playtests externes**
    Très important pour un jeu métaphorique.

    Tu ne demandes pas :

    > “Tu as compris mon message ?”

    Tu demandes plutôt :

    > “Qu’est-ce que tu penses qu’il se passe ?”
    >
    > “Qu’est-ce que cette salle t’a fait ressentir ?”
    >
    > “Pourquoi as-tu choisi cet objet ?”
    >
    > “À quel moment tu t’es ennuyé ?”
    >
    > “Qu’est-ce que tu crois que le musée veut de toi ?”

    **Ne leur explique surtout pas le jeu avant.**

    S’ils comprennent exactement tout : tu es peut-être trop explicite.

    S’ils ne comprennent absolument rien : trop opaque.

    Le bon endroit se situe entre les deux.

12. **Seulement ensuite : vraie production**
    Là tu peux établir une roadmap sérieuse :
    - préproduction ;
    - vertical slice ;
    - production des expositions ;
    - hub et conséquences ;
    - narration finale ;
    - audio ;
    - polish ;
    - QA ;
    - localisation ;
    - Steam/store ;
    - trailer ;
    - démo ;
    - release.

---

# Ce que je ferais concrètement dans les 30 prochains jours

### Semaine 1 — Trouver le jeu

Écrire :

- Vision v0.1
- piliers
- pitch
- fantasy joueur
- boucle principale
- structure narrative macroscopique
- liste de 15–20 idées d’expositions

Puis réduire ces 20 idées à **5–7 excellentes**.

En parallèle : apprendre les fondamentaux de Godot et créer une salle simple.

### Semaine 2 — Prouver la mécanique

Prototype gris :

`hub → exposition → exploration → sélection objet → disparition → retour hub`

Avec zéro ambition graphique.

Teste-le toi-même et auprès de quelques personnes.

### Semaine 3 — Trouver l’identité

Ensuite seulement :

- moodboard ;
- architecture ;
- couleurs ;
- rendu 3D/2.5D ;
- caméra ;
- typographie ;
- UI ;
- références musicales ;
- premières recherches sonores.

Et surtout : construire un **art test**.

Une seule image ou scène qui répond à :

> “À quoi ressemble mon jeu ?”

### Semaine 4 — Préparer la vertical slice

Choisir **une seule exposition**.

Écrire entièrement celle-ci.

Storyboard.

Level design papier.

Assets nécessaires.

Interactions.

Audio.

Scripts.

Conséquences.

Puis commencer sa production.

---

# Un truc que j’ajouterais à ta liste : un “journal de décisions”

Très utile en solo.

Un fichier simple :

> **18 septembre — le joueur ne pourra pas visiter toutes les expositions.**
>
> Pourquoi : renforce le thème du renoncement.
>
> Risque : frustration / FOMO.
>
> À tester : faire comprendre assez tôt que c'est volontaire.

Six mois plus tard, tu te remercieras.

Parce que sinon tu vas régulièrement penser :

> “Mais pourquoi j'avais décidé ça déjà ?”

---

# Et un autre : le scope budget

Avant de produire, définis clairement :

**Must have / Should have / Could have / Won't have.**

Par exemple :

### Must

5 expositions excellentes  
hub évolutif  
système de choix  
coulisses  
twist  
fin  
sound design fort

### Should

variations du hub selon choix  
plusieurs chemins  
petites interactions physiques

### Could

voix  
plusieurs fins  
secrets massifs  
New Game+

### Won't

combat  
multiplayer  
open world  
NPC complexes  
20 heures de jeu

Ce document peut sauver ton projet.

---

# Et je ferais attention à un piège précis

Tu es développeur, donc tu risques naturellement de tomber amoureux de :

**l’architecture technique.**

Système générique d’expositions.

Event bus.

Framework narratif maison.

Éditeur custom.

ECS.

Pipeline procédural.

Sauvegarde ultra abstraite.

Ne fais quasiment rien de ça au départ.

Ton risque sur ce projet n'est probablement pas :

> “Je ne sais pas construire suffisamment proprement le système.”

C'est :

> **“Je vais passer six mois à fabriquer une excellente infrastructure pour un jeu dont je n'ai pas encore prouvé qu'une salle est émotionnellement intéressante.”**

Ta métrique principale des premiers mois devrait donc être :

**combien de minutes jouables vraiment bonnes ai-je ?**

Pas le nombre de systèmes terminés.

---

## L'arborescence de projet que je te conseillerais

```text
THE MUSEUM
│
├── 00_VISION
│   ├── Game Vision
│   ├── Pillars
│   └── Scope
│
├── 01_GAME_DESIGN
│   ├── Core Loop
│   ├── Mechanics
│   ├── Progression
│   └── Consequences
│
├── 02_NARRATIVE
│   ├── Story Structure
│   ├── Timeline
│   ├── Exhibitions
│   ├── Characters
│   └── Ending
│
├── 03_WORLD
│   ├── Museum Bible
│   ├── Rules
│   └── Environmental Storytelling
│
├── 04_ART
│   ├── Moodboards
│   ├── Art Bible
│   ├── Color
│   ├── Architecture
│   └── UI
│
├── 05_AUDIO
│   ├── Music Direction
│   └── Sound Design
│
├── 06_TECH
│   ├── Engine Research
│   ├── Architecture
│   └── Technical Spikes
│
├── 07_PRODUCTION
│   ├── Roadmap
│   ├── Backlog
│   ├── Milestones
│   └── Decision Log
│
└── 08_PLAYTESTS
    ├── Protocol
    ├── Feedback
    └── Changes
```
