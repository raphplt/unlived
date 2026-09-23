class_name InquiryWorld
extends Node3D
## All observation positions share one physical courtyard; no evidence switches.
const CITY := Vector3(48, 0, 0)
const GREEN := Vector3(-38, 0, 0)
const VIEWS := {"south_low": Vector3(0, 1.64, 10), "south_high": Vector3(0, 5.84, 11.4), "north_low": Vector3(0, 1.64, -10), "north_high": Vector3(0, 5.84, -14)}
var interaction_names: Dictionary = {}
var mirrors: Array[Dictionary] = []
var city_light: OmniLight3D
var green_light: OmniLight3D
var curtain: Node3D
var lamp_head: Node3D
var history: Node3D
var film_picture: MeshInstance3D
var reference_picture: MeshInstance3D
var alcoves: Dictionary = {}
var switches := {"city_light": true, "city_low_light": true, "green_light": true, "curtain": false, "lamp": false, "slide": false, "film": false, "window": false}
var mats: Dictionary = {}
var reference_full: Texture2D
var reference_crop: Texture2D
var projector: SpotLight3D
var city_low_light: OmniLight3D
var sign: Label3D
var tank: MeshInstance3D
var bridge: MeshInstance3D

func _ready() -> void:
	for entry in {"stone": "b7ac96", "cream": "e0d4b9", "dark": "242d36", "wood": "755644", "copper": "a97958", "blue": "728e9b", "rose": "be8d80", "green": "57735c", "leaf": "72967b", "paper": "ede2c9", "gold": "ddc39a"}:
		mats[entry] = Forms.material({"stone": "b7ac96", "cream": "e0d4b9", "dark": "242d36", "wood": "755644", "copper": "a97958", "blue": "728e9b", "rose": "be8d80", "green": "57735c", "leaf": "72967b", "paper": "ede2c9", "gold": "ddc39a"}[entry])
	var env := WorldEnvironment.new()
	var atmosphere := Environment.new()
	atmosphere.background_mode = Environment.BG_COLOR
	atmosphere.background_color = Color("343f55")
	atmosphere.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	atmosphere.ambient_light_color = Color("afbdd4")
	atmosphere.ambient_light_energy = 0.68
	atmosphere.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.environment = atmosphere
	add_child(env)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-38, -28, 0)
	sun.light_color = Color("f1c7a1")
	sun.light_energy = 0.75
	sun.shadow_enabled = true
	add_child(sun)
	build_hall()
	build_city()
	build_greenhouse()

func box(parent: Node3D, at: Vector3, size: Vector3, material: String, solid: bool = true) -> MeshInstance3D:
	return Forms.box(parent, at, size, mats[material], solid)

func label(parent: Node3D, at: Vector3, words: String, size: int = 42, yaw: float = 0) -> Label3D:
	var result := Forms.text(parent, at, words, size, "eee2c9", true)
	result.rotation.y = yaw
	return result

func target(parent: Node3D, at: Vector3, size: Vector3, id: String, caption: String) -> void:
	Forms.target(parent, at, size, id)
	interaction_names[id] = caption

func table(parent: Node3D, at: Vector3, size: Vector2 = Vector2(2.3, 1.3)) -> void:
	box(parent, at + Vector3(0, 0.78, 0), Vector3(size.x, 0.12, size.y), "wood")
	for x in [-1, 1]:
		for z in [-1, 1]: box(parent, at + Vector3(x * (size.x / 2 - 0.14), 0.37, z * (size.y / 2 - 0.14)), Vector3(0.09, 0.74, 0.09), "dark")

func chair(parent: Node3D, at: Vector3, yaw: float = 0) -> void:
	var root := Node3D.new()
	parent.add_child(root)
	root.position = at
	root.rotation.y = yaw
	box(root, Vector3(0, 0.46, 0), Vector3(0.65, 0.12, 0.66), "rose")
	box(root, Vector3(0, 0.87, 0.28), Vector3(0.65, 0.78, 0.09), "wood")
	for x in [-0.25, 0.25]:
		for z in [-0.25, 0.25]: box(root, Vector3(x, 0.23, z), Vector3(0.06, 0.46, 0.06), "dark")

func plant(parent: Node3D, at: Vector3, height: float = 1.5) -> void:
	Forms.cylinder(parent, at + Vector3(0, 0.22, 0), 0.29, 0.44, mats.copper, 0.37, true)
	Forms.cylinder(parent, at + Vector3(0, height / 2, 0), 0.035, height, mats.wood)
	for i in range(7):
		var angle := float(i) * 2.4
		var leaf := Forms.sphere(parent, at + Vector3(cos(angle) * 0.25, height * (0.42 + float(i) * 0.08), sin(angle) * 0.25), 0.35, mats.leaf)
		leaf.scale = Vector3(1, 0.34, 0.6)
		leaf.rotation = Vector3(0.2, angle, 0.4)

func paper(parent: Node3D, at: Vector3, id: String, caption: String, color: String = "paper") -> void:
	box(parent, at, Vector3(0.48, 0.015, 0.34), color, false)
	for i in range(4): box(parent, at + Vector3(0, 0.009, -0.09 + i * 0.045), Vector3(0.3 - i * 0.04, 0.002, 0.005), "wood", false)
	target(parent, at + Vector3(0, 0.1, 0), Vector3(0.65, 0.25, 0.5), id, caption)

func mug(parent: Node3D, at: Vector3) -> void:
	Forms.cylinder(parent, at + Vector3(0, 0.10, 0), 0.095, 0.2, mats.blue)
	Forms.cylinder(parent, at + Vector3(0, 0.202, 0), 0.077, 0.004, mats.dark)
	var handle := TorusMesh.new()
	handle.inner_radius = 0.045
	handle.outer_radius = 0.065
	var piece := Forms.shape(parent, at + Vector3(0.12, 0.10, 0), handle, mats.blue)
	piece.rotation.x = PI / 2

func door(parent: Node3D, at: Vector3, id: String, caption: String, yaw: float = 0) -> void:
	var root := Node3D.new()
	parent.add_child(root)
	root.position = at
	root.rotation.y = yaw
	box(root, Vector3(0, 1.4, 0), Vector3(1.55, 2.8, 0.12), "dark")
	Forms.arch(root, Vector3(0, 0, 0.08), 0.88, 2.25, mats.copper)
	label(root, Vector3(0, 2.45, 0.13), caption, 32)
	box(root, Vector3(0.56, 1.15, 0.14), Vector3(0.07, 0.3, 0.09), "gold", false)
	target(root, Vector3(0, 1.4, 0.2), Vector3(1.55, 2.8, 0.22), id, "Ouvrir")

func build_hall() -> void:
	box(self, Vector3(0, -0.17, 0), Vector3(16, 0.3, 17), "stone")
	box(self, Vector3(0, 3, -8), Vector3(16, 6, 0.3), "cream")
	box(self, Vector3(-8, 3, 0), Vector3(0.3, 6, 16), "cream")
	box(self, Vector3(8, 3, 0), Vector3(0.3, 6, 16), "cream")
	box(self, Vector3(0, 3, 8), Vector3(16, 6, 0.3), "cream")
	box(self, Vector3(0, 6.1, 0), Vector3(16, 0.2, 16), "dark")
	for x in [-6.7, 6.7]:
		for z in [-5, 0, 5]:
			Forms.cylinder(self, Vector3(x, 2.4, z), 0.27, 4.8, mats.stone)
	for x in [-3.6, 3.6]:
		Forms.arch(self, Vector3(x, 0, -7.65), 2.4, 3.3, mats.stone)
		Forms.lamp(self, Vector3(x, 4.5, -4), "f5d4a4", 3.3, 8)
	door(self, Vector3(7.77, 0, -3), "to_city", "", -PI / 2)
	door(self, Vector3(-7.77, 0, -3), "to_greenhouse", "", PI / 2)
	label(self, Vector3(0, 4.6, -7.78), "U N L I V E D", 100)
	for entry in [{"id": "city", "x": 3.6}, {"id": "greenhouse", "x": -3.6}]:
		box(self, Vector3(entry.x, 0.50, -5.4), Vector3(2, 1, 1.1), "stone")
		box(self, Vector3(entry.x, 2.45, -7.7), Vector3(3.5, 2.4, 0.07), "dark", false)
		var image_mesh := textured_quad(self, Vector3(entry.x, 2.45, -7.63), Vector2(3.32, 2.20))
		var tag := label(self, Vector3(entry.x, 1.06, -4.81), "—", 25)
		alcoves[entry.id] = {"image": image_mesh, "label": tag}
		target(self, Vector3(entry.x, 1.0, -5.2), Vector3(2.0, 1.6, 1.2), "alcove_" + entry.id, "Regarder la collection")
	box(self, Vector3(0, 0.32, 2), Vector3(3.6, 0.64, 1), "wood")
	plant(self, Vector3(-6, 0, 5), 2.5)
	plant(self, Vector3(6, 0, 5), 2.1)

func build_city() -> void:
	var city := Node3D.new()
	add_child(city)
	city.position = CITY
	box(city, Vector3(0, -0.18, 0), Vector3(38, 0.3, 40), "stone")
	# Backdrops have depth; their other face is visible from Lou's service door.
	for x in [-19, 19]: box(city, Vector3(x, 5, 0), Vector3(0.35, 10, 40), "rose")
	for z in [-20, 20]: box(city, Vector3(0, 5, z), Vector3(38, 10, 0.35), "blue")
	for z in [-14.0, 14.0]:
		box(city, Vector3(0, 4.03, z), Vector3(36, 0.3, 7), "cream")
		# Floors are continuous with the tops of the ramps at +/- 10.5.
		for x in range(-14, 16, 3):
			box(city, Vector3(x, 2, z - signf(z) * 3), Vector3(0.24, 4, 0.24), "copper")
		for x in [-9, 9]:
			box(city, Vector3(x, 6.2, z - 2.25), Vector3(0.22, 4.2, 1.5), "rose")
			box(city, Vector3(x, 6.2, z + 2.25), Vector3(0.22, 4.2, 1.5), "rose")
			box(city, Vector3(x, 7.8, z), Vector3(0.22, 1, 3), "rose")
		box(city, Vector3(0, 8.25, z), Vector3(30, 0.2, 7), "rose")
		for x in [-12, 12]:
			box(city, Vector3(x, 4.68, z - signf(z) * 3.45), Vector3(5.8, 1.0, 0.12), "dark")
		# Central opening and its waist-high railing leave the principal view clear.
		box(city, Vector3(0, 4.98, z - signf(z) * 3.45), Vector3(7, 0.045, 0.06), "copper")
	for entry in [{"x": 16.6, "direction": -1.0}, {"x": -16.6, "direction": 1.0}]:
		var ramp := box(city, Vector3(entry.x, 2.01, 0), Vector3(3.4, 0.26, sqrt(21.0 * 21.0 + 4.2 * 4.2)), "stone")
		ramp.rotation.x = float(entry.direction) * atan(4.2 / 21.0)
		for offset in [-1.55, 1.55]:
			var rail := box(city, Vector3(entry.x + offset, 2.65, 0), Vector3(0.09, 1.1, sqrt(21.0 * 21.0 + 4.2 * 4.2)), "copper")
			rail.rotation.x = ramp.rotation.x
	# A broad bridge is opaque enough to hide the foot of the reservoir from below.
	bridge = box(city, Vector3(0, 2.42, -0.8), Vector3(24, 0.95, 1.25), "blue")
	for x in [-10, 10]: box(city, Vector3(x, 1.2, -0.8), Vector3(0.3, 2.4, 0.3), "dark")
	for x in range(-11, 12): box(city, Vector3(x, 3.15, -0.8), Vector3(0.045, 0.5, 0.08), "dark", false)
	box(city, Vector3(0, 3.4, -0.8), Vector3(24, 0.055, 0.08), "dark", false)
	tank = Forms.cylinder(city, Vector3(-4.5, 4.4, -4), 1.5, 4.0, mats.copper, -1, true)
	Forms.cylinder(city, Vector3(-4.5, 6.47, -4), 1.62, 0.15, mats.dark)
	for x in [-5.45, -3.55]:
		box(city, Vector3(x, 1.2, -4), Vector3(0.14, 2.4, 0.14), "dark")
	# Distinct pale band: the foot being compared, not the top of a support leg.
	Forms.cylinder(city, Vector3(-4.5, 2.44, -4), 1.515, 0.10, mats.cream)
	box(city, Vector3(-3.0, 2.22, -8), Vector3(7.5, 0.7, 0.16), "blue")
	table(city, Vector3(-0.8, 0, 3), Vector2(3.6, 1.6))
	for x in [-2.0, -0.4, 1.0]:
		chair(city, Vector3(x, 0, 4.25))
		mug(city, Vector3(x, 0.86, 3.25))
	for x in [-11, 11]:
		plant(city, Vector3(x, 0, 4), 2.5)
		plant(city, Vector3(x, 4.2, -15), 1.6)
	# Four accessible observation stations, with addresses rather than solutions.
	label(city, Vector3(0, 2.7, 9.7), "COUR SUD · REZ-DE-COUR", 35, PI)
	label(city, Vector3(0, 7.5, 10.55), "8 · COUR SUD", 44, PI)
	label(city, Vector3(4, 2.8, -10.4), "COUR NORD", 45)
	door(city, Vector3(11, 0, 19.7), "city_hall", "Galerie", PI)
	# Lab: all film operations are reachable without a prior clue flag.
	table(city, Vector3(-10.8, 0, -15), Vector2(4.5, 1.6))
	paper(city, Vector3(-12.2, 0.86, -15), "film", "Sortir la bande · 17 / 06")
	box(city, Vector3(-10.2, 1.1, -15), Vector3(0.7, 0.48, 0.8), "dark")
	box(city, Vector3(-10.2, 1.7, -15.3), Vector3(0.09, 1.3, 0.09), "copper")
	Forms.cylinder(city, Vector3(-10.2, 2.2, -15.1), 0.3, 0.24, mats.dark)
	target(city, Vector3(-10.2, 1.6, -14.6), Vector3(1.0, 1.6, 1.1), "enlarger", "Regarder l’agrandisseur")
	label(city, Vector3(-10.5, 3.1, -19.7), "LABORATOIRE", 50)
	Forms.lamp(city, Vector3(-10, 2.9, -15), "ffc3a0", 2, 6)
	film_picture = textured_quad(city, Vector3(-10.5, 2.4, -19.65), Vector2(4.1, 2.7))
	# First print and independent address route, by the entrance under south platform.
	reference_picture = textured_quad(city, Vector3(6.8, 1.9, 10.32), Vector2(1.7, 1.1))
	reference_picture.rotation.y = PI
	box(city, Vector3(6.8, 1.9, 10.35), Vector3(1.8, 1.2, 0.04), "wood", false)
	target(city, Vector3(6.8, 1.8, 10.16), Vector3(1.9, 1.4, 0.3), "print", "Regarder le tirage · 17 / 06")
	table(city, Vector3(6.8, 0, 13.5))
	paper(city, Vector3(6.3, 0.86, 13.5), "address", "Lire l’enveloppe")
	paper(city, Vector3(7.2, 0.86, 13.5), "receipt", "Lire le reçu")
	# The lower south window is an optical workbench before reaching Lou.
	add_mirror(city, Vector3(0, 1.85, 13), Vector2(6, 3.1), "city_low")
	label(city, Vector3(-1, 2.5, 18.8), "CINÉ", 150, PI)
	city_low_light = Forms.lamp(city, Vector3(1.6, 2.3, 16), "ffdcb0", 3, 7)
	box(city, Vector3(-2.8, 1.3, 14.8), Vector3(0.15, 0.35, 0.1), "gold", false)
	target(city, Vector3(-2.8, 1.3, 14.8), Vector3(0.45, 0.7, 0.4), "city_low_light", "Actionner l’applique")
	# Lou's upper south flat. Reach it on foot using the east ramp.
	table(city, Vector3(-3.7, 4.2, 15.6), Vector2(3, 1.5))
	paper(city, Vector3(-4.5, 5.06, 15.5), "contacts", "Regarder la planche de contacts")
	paper(city, Vector3(-3.6, 5.07, 15.4), "ticket", "Lire le billet échangé")
	mug(city, Vector3(-2.7, 5.05, 15.6))
	paper(city, Vector3(-4.6, 5.09, 16.0), "object_print", "Le tirage publié")
	paper(city, Vector3(-3.5, 5.10, 16.0), "object_lou", "La photographie de Lou", "blue")
	paper(city, Vector3(-2.5, 5.09, 16.0), "object_notebook", "Le carnet de repérages", "rose")
	box(city, Vector3(5, 4.5, 15), Vector3(3.0, 0.6, 1.5), "wood")
	box(city, Vector3(5, 4.86, 15), Vector3(2.9, 0.18, 1.45), "cream")
	box(city, Vector3(5.9, 5.02, 15), Vector3(0.7, 0.18, 1), "blue", false)
	paper(city, Vector3(4.7, 5.0, 15), "visit", "Lire la carte pliée")
	label(city, Vector3(-7, 5.9, 17.9), "Lou\n17 — 24 juin", 42, PI)
	Forms.lamp(city, Vector3(0, 7.5, 15), "ffdcab", 2.0, 10)
	city_light = Forms.lamp(city, Vector3(1.6, 6.2, 15.8), "ffdcb0", 2.2, 7)
	box(city, Vector3(2.8, 5.5, 14.8), Vector3(0.15, 0.35, 0.1), "gold", false)
	target(city, Vector3(2.8, 5.5, 14.8), Vector3(0.45, 0.7, 0.4), "city_light", "Actionner l’applique")
	sign = label(city, Vector3(-1.0, 6.6, 18.8), "CINÉ", 170, PI)
	sign.modulate = Color("ffbd86")
	add_mirror(city, Vector3(0, 5.95, 11.2), Vector2(6, 3), "city")
	target(city, Vector3(-2.8, 5.4, 11.5), Vector3(0.4, 0.7, 0.4), "window", "Ouvrir / fermer le battant")
	for x in [-3.05, 3.05]: box(city, Vector3(x, 5.95, 11.2), Vector3(0.08, 3.1, 0.08), "dark", false)
	box(city, Vector3(0, 7.5, 11.2), Vector3(6.15, 0.08, 0.08), "dark", false)
	door(city, Vector3(7.0, 4.2, 19.72), "backstage", "Service", PI)
	# Historical presence is rendered once into the film, then removed from now.
	history = Node3D.new()
	city.add_child(history)
	person(history, Vector3(0.6, 0, 4.2), "blue")
	history.visible = false
	# A real service passage behind the city set, with a useful onward connection.
	box(city, Vector3(0, 4.03, 24), Vector3(20, 0.3, 8), "dark")
	box(city, Vector3(0, 7.2, 28), Vector3(20, 6, 0.15), "cream")
	for x in [-10, 10]: box(city, Vector3(x, 7.2, 24), Vector3(0.15, 6, 8), "cream")
	for x in [-8, -4, 0, 4, 8]:
		var brace := box(city, Vector3(x, 6.1, 22), Vector3(0.1, 4.4, 0.1), "wood")
		brace.rotation.x = -0.4
		box(city, Vector3(x, 8.2, 20.25), Vector3(3.9, 3, 0.08), "blue", false)
	Forms.lamp(city, Vector3(0, 8, 25), "e3edf3", 4, 15)
	label(city, Vector3(0, 6.4, 27.8), "03     /     VILLE", 40)
	door(city, Vector3(7, 4.2, 20.25), "backstage_city", "Cour")
	door(city, Vector3(-7, 4.2, 27.78), "backstage_green", "Serres", PI)

func person(parent: Node3D, at: Vector3, fabric: String) -> void:
	Forms.sphere(parent, at + Vector3(0, 1.45, 0), 0.19, mats.copper)
	box(parent, at + Vector3(0, 1.04, 0), Vector3(0.48, 0.55, 0.3), fabric, false)
	for x in [-0.18, 0.18]: box(parent, at + Vector3(x, 0.49, -0.17), Vector3(0.16, 0.70, 0.16), "dark", false)
	for x in [-0.28, 0.28]:
		var arm := box(parent, at + Vector3(x, 0.95, -0.15), Vector3(0.12, 0.14, 0.6), fabric, false)
		arm.rotation.x = -0.2

func build_greenhouse() -> void:
	var green := Node3D.new()
	add_child(green)
	green.position = GREEN
	box(green, Vector3(0, -0.18, 0), Vector3(20, 0.3, 23), "stone")
	for x in [-10, 10]: box(green, Vector3(x, 2.5, 0), Vector3(0.2, 5, 23), "green")
	for z in [-11.5, 11.5]: box(green, Vector3(0, 2.5, z), Vector3(20, 5, 0.2), "cream")
	box(green, Vector3(0, 5, 4), Vector3(20, 0.2, 14), "dark")
	for x in range(-9, 10, 3):
		box(green, Vector3(x, 3, -5), Vector3(0.06, 6, 12), "copper", false)
		var beam := box(green, Vector3(x, 5.9, -5), Vector3(0.08, 0.08, 14), "copper", false)
		beam.rotation.x = 0.13
	for x in [-7, -4, 4, 7]:
		for z in [-8, -4]: plant(green, Vector3(x, 0, z), 1.5 + (x + 7) * 0.08)
	box(green, Vector3(0, 0.1, -6), Vector3(3, 0.2, 6), "blue")
	Forms.lamp(green, Vector3(0, 4, -5), "c3e4cb", 2.0, 12)
	# Bedroom and glass overlook a garden that continues physically beyond it.
	add_mirror(green, Vector3(0, 1.85, 1.0), Vector2(5, 3.1), "greenhouse")
	for x in [-2.55, 2.55]: box(green, Vector3(x, 1.8, 1), Vector3(0.10, 3.6, 0.1), "wood", false)
	green_light = Forms.lamp(green, Vector3(1, 3, 5), "ffdeb0", 3.0, 9)
	label(green, Vector3(1, 2.7, 9.7), "É L I E", 78, PI)
	box(green, Vector3(-1.5, 0.28, 6), Vector3(2.5, 0.55, 1.5), "wood")
	box(green, Vector3(-1.5, 0.62, 6), Vector3(2.45, 0.18, 1.45), "blue")
	box(green, Vector3(-2.25, 0.76, 6), Vector3(0.75, 0.15, 1.2), "cream", false)
	target(green, Vector3(-1.5, 0.8, 6), Vector3(2.7, 1.0, 1.8), "sit", "S’asseoir / se lever")
	table(green, Vector3(4.6, 0, 5.6), Vector2(2.4, 1.2))
	lamp_head = Node3D.new()
	green.add_child(lamp_head)
	lamp_head.position = Vector3(4.6, 1.1, 5.6)
	Forms.cylinder(lamp_head, Vector3(0, -0.15, 0), 0.23, 0.08, mats.dark)
	box(lamp_head, Vector3(0, 0.12, 0), Vector3(0.06, 0.55, 0.06), "copper", false)
	var shade := Forms.cylinder(lamp_head, Vector3(-0.08, 0.38, 0), 0.25, 0.4, mats.gold, 0.12)
	shade.rotation.z = PI / 2
	box(lamp_head, Vector3(-0.31, 0.38, 0), Vector3(0.04, 0.33, 0.33), "dark", false)
	target(green, Vector3(4.6, 1.2, 5.6), Vector3(0.65, 0.8, 0.65), "lamp", "Orienter la lampe")
	box(green, Vector3(3.9, 1.02, 5.6), Vector3(0.45, 0.35, 0.42), "wood", false)
	for i in range(5): Forms.sphere(green, Vector3(3.67, 1 + i * 0.03, 5.47 + i * 0.05), 0.025, mats.gold)
	target(green, Vector3(3.9, 1.15, 5.6), Vector3(0.55, 0.8, 0.6), "object_box", "La boîte ajourée")
	paper(green, Vector3(5.3, 0.86, 5.6), "object_drawing", "Le dessin à plusieurs mains", "blue")
	mug(green, Vector3(5.4, 0.86, 5.95))
	target(green, Vector3(5.4, 1.0, 5.95), Vector3(0.3, 0.4, 0.3), "object_cup", "La coupe réparée")
	paper(green, Vector3(4.6, 0.86, 6), "album", "Ouvrir l’album")
	target(green, Vector3(2.8, 1.3, 1.2), Vector3(0.4, 0.8, 0.4), "green_light", "Allumer / éteindre la pièce")
	box(green, Vector3(2.8, 1.3, 1.2), Vector3(0.12, 0.22, 0.08), "gold", false)
	curtain = Node3D.new()
	green.add_child(curtain)
	for i in range(16): box(curtain, Vector3(-2.35 + float(i) * 0.31, 1.85, 1.14 + float(i % 2) * 0.05), Vector3(0.34, 3.3, 0.05), "blue", false)
	target(green, Vector3(-2.85, 1.3, 1.3), Vector3(0.4, 1, 0.4), "curtain", "Tirer le rideau")
	box(green, Vector3(-2.85, 1.6, 1.3), Vector3(0.025, 1.8, 0.025), "gold", false)
	target(green, Vector3(3.5, 1.1, 5.6), Vector3(0.3, 0.5, 0.5), "slide", "Faire glisser le cylindre")
	door(green, Vector3(7.2, 0, 11.32), "green_hall", "Galerie", PI)
	door(green, Vector3(-7.2, 0, 11.32), "green_backstage", "Service", PI)
	# This slide is actually projected by a spot light onto the bedroom wall.
	# It is a light gobo, never a photographic clue drawn outside the scene.
	var gobo := Image.create(256, 256, false, Image.FORMAT_RGB8)
	gobo.fill(Color.BLACK)
	for y in range(256):
		for x in range(256):
			var pixel := Vector2(x, y)
			if y > 150 + 6 * sin(x * 0.04): gobo.set_pixel(x, y, Color("4daccb"))
			if pixel.distance_to(Vector2(183, 64)) < 19: gobo.set_pixel(x, y, Color("ebefd0"))
	for i in range(22):
		var point := Vector2i(16 + (i * 73) % 224, 20 + (i * 37) % 110)
		for y in range(-2, 3):
			for x in range(-2, 3): gobo.set_pixelv(point + Vector2i(x, y), Color("c6e4dc"))
	projector = SpotLight3D.new()
	green.add_child(projector)
	projector.position = Vector3(3.55, 1.45, 5.6)
	projector.light_projector = ImageTexture.create_from_image(gobo)
	projector.light_energy = 55
	projector.spot_range = 18
	projector.spot_angle = 17
	projector.spot_attenuation = 0.4
	projector.shadow_enabled = true
	apply_states()

func textured_quad(parent: Node3D, at: Vector3, size: Vector2) -> MeshInstance3D:
	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = Color("4d555b")
	var quad := QuadMesh.new()
	quad.size = size
	return Forms.shape(parent, at, quad, mat)

func set_image(mesh: MeshInstance3D, texture: Texture2D) -> void:
	var mat := mesh.material_override as StandardMaterial3D
	mat.albedo_texture = texture
	mat.albedo_color = Color.WHITE if texture else Color("4d555b")

func add_mirror(parent: Node3D, at: Vector3, size: Vector2, id: String) -> void:
	var view := SubViewport.new()
	view.size = Vector2i(960, 600)
	view.world_3d = get_world_3d()
	view.render_target_update_mode = SubViewport.UPDATE_DISABLED
	add_child(view)
	var cam := Camera3D.new()
	cam.cull_mask = 1
	view.add_child(cam)
	var mat := ShaderMaterial.new()
	mat.shader = preload("res://shaders/reflection.gdshader")
	mat.set_shader_parameter("reflected_view", view.get_texture())
	var quad := QuadMesh.new()
	quad.size = size
	var mesh := Forms.shape(parent, at, quad, mat)
	mesh.layers = 2
	mirrors.append({"id": id, "viewport": view, "camera": cam, "mesh": mesh, "material": mat})

func update_mirrors(camera: Camera3D, zone: String) -> void:
	for mirror in mirrors:
		var active: bool = (mirror.id == zone or (mirror.id == "city_low" and zone == "city")) and camera.global_position.z > mirror.mesh.global_position.z
		mirror.viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS if active else SubViewport.UPDATE_DISABLED
		mirror.mesh.visible = active and not (mirror.id == "city" and switches.window) and not (zone == "greenhouse" and switches.curtain)
		if not active: continue
		var size := camera.get_viewport().get_visible_rect().size
		mirror.viewport.size = Vector2i(size * 0.65)
		var point := camera.global_position
		point.z = 2 * mirror.mesh.global_position.z - point.z
		var forward := -camera.global_basis.z
		var up := camera.global_basis.y
		forward.z *= -1
		up.z *= -1
		mirror.camera.global_position = point
		mirror.camera.look_at(point + forward, up)
		mirror.camera.fov = camera.fov
		mirror.camera.near = camera.near
		var lit: bool = switches.city_low_light if mirror.id == "city_low" else (switches.city_light if zone == "city" else switches.green_light)
		mirror.material.set_shader_parameter("strength", 0.20 if lit else 0.008)

func apply_states() -> void:
	city_light.visible = switches.city_light
	city_low_light.visible = switches.city_low_light
	green_light.visible = switches.green_light and not switches.curtain
	curtain.visible = switches.curtain
	lamp_head.rotation.y = 0 if switches.lamp else -PI / 2
	if projector:
		projector.visible = switches.lamp
		projector.look_at(projector.global_position + (Vector3(-14, 1, 1.3 if switches.slide else 0) if switches.lamp else Vector3(0, 0, -8)))
	for mirror in mirrors:
		if mirror.id == "greenhouse": mirror.mesh.visible = not switches.curtain

func toggle(id: String) -> void:
	if switches.has(id):
		switches[id] = not switches[id]
		apply_states()
