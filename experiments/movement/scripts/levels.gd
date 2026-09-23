extends RefCounted
## Each study gets three small courses: introduction, variation, combination.
## Positions refer to a 1280 x 800 canvas; solids share exactly their drawn bounds.

const NAMES := ["Appui", "Balancier", "Portance"]
const COLORS := [Color("dfb978"), Color("91c8d7"), Color("b1c89b")]
const RULES := [
	"E maintenu au sol ou contre un mur · orienter avec les flèches · relâcher pour partir",
	"E maintenu : saisir l’anneau éclairé · ← → : se balancer · relâcher E pour lâcher",
	"E maintenu en l’air : ouvrir la voile · relâcher pour descendre · les courants portent",
]

static func course(mode: int, index: int) -> Dictionary:
	var courses: Array[Dictionary]
	match mode:
		0:
			courses = [
				{"name": "La portée", "spawn": Vector2(110, 564),
				 "solids": [Rect2(40, 580, 300, 170), Rect2(570, 580, 240, 170), Rect2(1020, 580, 260, 170)],
				 "goal": Rect2(1168, 516, 40, 64), "hint": "Un saut court pour se placer. Un appui préparé pour franchir."},
				{"name": "Les hauteurs", "spawn": Vector2(110, 614),
				 "solids": [Rect2(40, 630, 280, 120), Rect2(500, 490, 230, 260), Rect2(930, 350, 350, 400)],
				 "goal": Rect2(1168, 286, 40, 64), "hint": "↑ donne de la hauteur ; ↑ + → dessine une diagonale."},
				{"name": "Les intervalles", "spawn": Vector2(100, 594),
				 "solids": [Rect2(40, 610, 245, 140), Rect2(465, 500, 115, 250), Rect2(755, 570, 110, 180), Rect2(1040, 440, 240, 310), Rect2(635, 265, 275, 28)],
				 "goal": Rect2(1168, 376, 40, 64), "hint": "Un appui peut être bref. E contre une paroi permet aussi de se retenir."},
			]
		1:
			courses = [
				{"name": "Le lâcher", "spawn": Vector2(110, 564),
				 "solids": [Rect2(40, 580, 310, 170), Rect2(670, 580, 610, 170)],
				 "anchors": [Vector2(480, 270)], "goal": Rect2(1168, 516, 40, 64),
				 "hint": "L’anneau éclairé est à portée. Le mouvement continue après le lâcher."},
				{"name": "Le relais", "spawn": Vector2(110, 614),
				 "solids": [Rect2(40, 630, 280, 120), Rect2(650, 540, 125, 210), Rect2(1070, 450, 210, 300)],
				 "anchors": [Vector2(455, 275), Vector2(900, 205)], "goal": Rect2(1168, 386, 40, 64),
				 "hint": "Relâcher, puis saisir à nouveau. L’appui central permet de reprendre son souffle."},
				{"name": "Le détour", "spawn": Vector2(100, 554),
				 "solids": [Rect2(40, 570, 270, 180), Rect2(605, 635, 130, 115), Rect2(1060, 550, 220, 200), Rect2(710, 165, 35, 240)],
				 "anchors": [Vector2(425, 260), Vector2(800, 235)], "goal": Rect2(1168, 486, 40, 64),
				 "hint": "Une paroi coupe le fil. Choisir où lâcher et où saisir à nouveau."},
			]
		_:
			courses = [
				{"name": "La traversée", "spawn": Vector2(110, 424),
				 "solids": [Rect2(40, 440, 300, 310), Rect2(850, 585, 430, 165)],
				 "goal": Rect2(1168, 521, 40, 64), "hint": "Ouvrir la voile conserve de la hauteur. Elle ne fait pas monter toute seule."},
				{"name": "Les courants", "spawn": Vector2(110, 594),
				 "solids": [Rect2(40, 610, 300, 140), Rect2(620, 430, 165, 320), Rect2(1020, 270, 260, 480)],
				 "winds": [Rect2(335, 160, 255, 565), Rect2(795, 115, 215, 610)],
				 "goal": Rect2(1168, 206, 40, 64), "hint": "Voile ouverte dans un courant : monter. Sortir du courant : planer."},
				{"name": "Les passages", "spawn": Vector2(110, 484),
				 "solids": [Rect2(40, 500, 250, 250), Rect2(560, 625, 155, 125), Rect2(1030, 410, 250, 340), Rect2(540, 260, 230, 30)],
				 "winds": [Rect2(300, 150, 220, 575), Rect2(780, 115, 240, 610)],
				 "goal": Rect2(1168, 346, 40, 64), "hint": "Fermer pour passer sous l’obstacle. Rouvrir pour retrouver de la hauteur."},
			]
	var result: Dictionary = courses[index].duplicate(true)
	if not result.has("anchors"): result["anchors"] = []
	if not result.has("winds"): result["winds"] = []
	return result
