class_name Museum
extends Node3D
## Authored architecture and props, built from a shared geometry vocabulary.

var hall: Node3D
var apartment: Node3D
var furnishings: Node3D
var memory_materials: Array[ShaderMaterial] = []
var memory_lights: Array[OmniLight3D] = []
var shutter: MeshInstance3D
var keepsake: Node3D
var trace_light: OmniLight3D
var rain_lines: MultiMeshInstance3D
var window_glass: MeshInstance3D
var env: Environment
var piano_keys: Array[MeshInstance3D] = []
var loss := 0.0
var stone := Forms.material("c4baa3")
var pale := Forms.material("e2d8bf")
var dark := Forms.material("263c38")
var brass := Forms.material("b89962", 0.32, 0.65)
var black := Forms.material("242a25", 0.4)
var glow := Forms.material("ffdda0", 0.5, 0.0, 1.5)
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.seed = 418
	lighting()
	hall = Node3D.new()
	hall.name = "Hall"
	add_child(hall)
	build_hall()
	apartment = Node3D.new()
	apartment.name = "Creer"
	apartment.position.x = 30.0
	add_child(apartment)
	build_apartment()

func lighting() -> void:
	var world := WorldEnvironment.new()
	env = Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color("718382")
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color("adb8ad")
	env.ambient_light_energy = 0.36
	env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.tonemap_exposure = 1.12
	env.ssao_enabled = true
	env.ssao_radius = 1.0
	env.ssao_intensity = 1.6
	env.glow_enabled = true
	env.glow_intensity = 0.35
	env.fog_enabled = true
	env.fog_light_color = Color("afb0a0")
	env.fog_density = 0.004
	world.environment = env
	add_child(world)

func memory_mat(color: String, roughness: float = 0.8) -> ShaderMaterial:
	var mat := Forms.material(color, roughness)
	memory_materials.append(mat)
	return mat

func build_hall() -> void:
	# Travertine slabs, recessed inlays, tall mineral walls.
	Forms.box(hall, Vector3(0, -0.15, 0), Vector3(12, 0.3, 15), stone, true)
	var grout := Forms.material("a69d89")
	for x in range(-6, 7, 2):
		Forms.box(hall, Vector3(x, 0.005, 0), Vector3(0.012, 0.008, 15), grout)
	for z in range(-7, 8, 2):
		Forms.box(hall, Vector3(0, 0.005, z), Vector3(12, 0.008, 0.012), grout)
	for x in [-5.65, 5.65]:
		Forms.box(hall, Vector3(x, 0.012, 0), Vector3(0.025, 0.012, 14.5), brass)
	Forms.box(hall, Vector3(0, 2.7, -5.5), Vector3(12, 5.4, 0.35), pale, true)
	Forms.box(hall, Vector3(0, 2.7, 7.5), Vector3(12, 5.4, 0.3), pale, true)
	for x in [-6.0, 6.0]:
		Forms.box(hall, Vector3(x, 2.7, 1), Vector3(0.3, 5.4, 13), pale, true)
		Forms.box(hall, Vector3(x * 0.974, 0.48, 1), Vector3(0.04, 0.96, 13), dark)
		Forms.box(hall, Vector3(x * 0.97, 0.98, 1), Vector3(0.045, 0.025, 13), brass)
		for z in [-4.2, 0.4, 5.0]:
			Forms.box(hall, Vector3(x * 0.91, 2.5, z), Vector3(0.6, 5, 0.62), stone, true)
			Forms.box(hall, Vector3(x * 0.91, 0.17, z), Vector3(0.75, 0.34, 0.77), pale)
			Forms.box(hall, Vector3(x * 0.91, 4.9, z), Vector3(0.83, 0.18, 0.85), pale)
			Forms.box(hall, Vector3(x * 0.855, 2.2, z + 0.02), Vector3(0.04, 0.7, 0.07), glow)
			Forms.lamp(hall, Vector3(x * 0.82, 2.6, z), "ffddad", 1.1, 4.0)
	# Coffered ceiling around a large, soft skylight.
	Forms.box(hall, Vector3(0, 5.45, 1), Vector3(12.1, 0.2, 13.2), stone)
	for x in [-3.0, 3.0]:
		Forms.box(hall, Vector3(x, 5.25, 1), Vector3(0.2, 0.4, 13), pale)
	for z in [-4, -1, 2, 5]:
		Forms.box(hall, Vector3(0, 5.26, z), Vector3(12, 0.35, 0.15), pale)
	Forms.box(hall, Vector3(0, 5.32, 0), Vector3(5.8, 0.02, 7.8), Forms.material("dfe5d6", 1, 0, 1.0))
	Forms.lamp(hall, Vector3(0, 4.7, 0), "e5e8d6", 2.0, 10, true)
	Forms.lamp(hall, Vector3(0, 3.7, 5), "d7dfd1", 1.1, 8)
	# Portal 01, with nested brass arches and a deep green field.
	Forms.box(hall, Vector3(0, 1.115, -5.27), Vector3(2.36, 2.23, 0.16), dark)
	var arch_cap := Forms.cylinder(hall, Vector3(0, 2.23, -5.27), 1.18, 0.16, dark)
	arch_cap.rotation.x = PI / 2
	Forms.arch(hall, Vector3(0, 0, -5.08), 1.34, 2.25, stone)
	Forms.arch(hall, Vector3(0, 0, -4.95), 1.18, 2.23, brass)
	Forms.box(hall, Vector3(0, 1.3, -5.14), Vector3(0.018, 2.6, 0.02), brass)
	Forms.box(hall, Vector3(0.14, 1.12, -4.99), Vector3(0.045, 0.32, 0.06), brass)
	Forms.text(hall, Vector3(0, 2.58, -4.92), "01", 88, "d7b783", true)
	Forms.text(hall, Vector3(0, 1.9, -4.92), "Créer", 84, "e7dcc3", true)
	Forms.target(hall, Vector3(0, 1.5, -4.82), Vector3(2.3, 3, 0.2), "enter")
	Forms.lamp(hall, Vector3(0, 3.4, -3.9), "ffd39a", 0.8, 4)
	# Museum wall typography.
	Forms.text(hall, Vector3(-3.45, 3.2, -5.28), "Galerie", 100, "3b5048", true)
	Forms.text(hall, Vector3(-3.45, 2.6, -5.28), "01", 70, "667264", true)
	Forms.box(hall, Vector3(-3.45, 2.04, -5.24), Vector3(0.42, 0.012, 0.012), brass)
	Forms.text(hall, Vector3(3.3, 2.75, -5.28), "Collection\npermanente", 61, "536456", true)
	Forms.text(hall, Vector3(3.3, 1.95, -5.28), "01   CRÉER\n\n02   AILLEURS\n\n03   PRENDRE RACINE", 16, "687063")
	Forms.text(hall, Vector3(3.3, 0.94, -5.28), "SEULE LA PREMIÈRE AILE EST OUVERTE", 10, "727a6c")
	# Plinth left of the circulation route: destination of the chosen memory.
	Forms.cylinder(hall, Vector3(-2.45, 0.08, 0.1), 0.93, 0.16, dark, -1, true)
	Forms.box(hall, Vector3(-2.45, 0.66, 0.1), Vector3(0.82, 1.12, 0.82), pale, true)
	Forms.box(hall, Vector3(-2.45, 1.24, 0.1), Vector3(0.88, 0.055, 0.88), brass)
	Forms.text(hall, Vector3(-2.45, 0.76, 0.521), "01", 18, "6f735e")
	Forms.target(hall, Vector3(-2.45, 1.1, 0.1), Vector3(1.05, 1.7, 1.05), "plinth")
	keepsake = Node3D.new()
	hall.add_child(keepsake)
	keepsake.position = Vector3(-2.45, 1.29, 0.1)
	trace_light = Forms.lamp(hall, Vector3(-2.45, 2.15, 0.2), "ffd5a0", 0.0, 4.5)
	# Long upholstered bench, sparse plants and a sculptural empty ring.
	Forms.box(hall, Vector3(3.15, 0.51, 1.5), Vector3(1.2, 0.2, 3.3), dark, true)
	for z in [0.3, 2.7]:
		Forms.box(hall, Vector3(3.15, 0.25, z), Vector3(0.95, 0.5, 0.13), brass)
	plant(hall, Vector3(4.7, 0, -3.6), 1.3, false)
	plant(hall, Vector3(-4.85, 0, 4.7), 1.6, false)
	var ring := TorusMesh.new()
	ring.inner_radius = 0.68
	ring.outer_radius = 0.74
	var sculpture := Forms.shape(hall, Vector3(0, 2.8, 5.7), ring, brass)
	sculpture.rotation_degrees.x = 90
	Forms.cylinder(hall, Vector3(0, 0.52, 5.7), 0.64, 1.04, dark, -1, true)
	Forms.box(hall, Vector3(0, 1.55, 5.7), Vector3(0.025, 1.1, 0.025), brass)

func build_apartment() -> void:
	var plaster := memory_mat("b8b59a")
	var green := memory_mat("4c6256")
	var wood := memory_mat("76563a")
	var oak := memory_mat("aa8657")
	var cream := memory_mat("d9cfaf")
	var piano_black := memory_mat("29322c", 0.32)
	var rust := memory_mat("a56446")
	# A permanent floor and doorway keep the erased room traversable.
	Forms.box(apartment, Vector3(0, -0.14, 0), Vector3(10, 0.28, 10), Forms.material("71644c"), true)
	for i in range(25):
		for j in range(4):
			var tint := Color("a17b50").darkened(rng.randf_range(0, 0.2))
			var board := memory_mat(tint.to_html(false))
			Forms.box(apartment, Vector3(-4.8 + i * 0.4, 0.012, -3.75 + j * 2.5 + (0.05 if i % 2 else 0.0)), Vector3(0.39, 0.02, 2.47), board)
	Forms.box(apartment, Vector3(0, 2.0, 5), Vector3(10, 4, 0.3), plaster, true)
	for x in [-5, 5]:
		Forms.box(apartment, Vector3(x, 2, 0), Vector3(0.25, 4, 10), plaster, true)
		Forms.box(apartment, Vector3(x * 0.976, 0.53, 0), Vector3(0.03, 1.06, 10), green)
		Forms.box(apartment, Vector3(x * 0.97, 1.08, 0), Vector3(0.055, 0.04, 10), oak)
		Forms.box(apartment, Vector3(x * 0.97, 0.1, 0), Vector3(0.06, 0.19, 10), wood)
	Forms.box(apartment, Vector3(0, 4, 0), Vector3(10, 0.15, 10), plaster)
	# Back wall wraps the window; no collision is hidden in its opening.
	Forms.box(apartment, Vector3(-3, 2, -5), Vector3(4, 4, 0.25), plaster, true)
	Forms.box(apartment, Vector3(4.2, 2, -5), Vector3(1.6, 4, 0.25), plaster, true)
	Forms.box(apartment, Vector3(1.2, 0.45, -5), Vector3(4.4, 0.9, 0.25), green, true)
	Forms.box(apartment, Vector3(1.2, 3.8, -5), Vector3(4.4, 0.4, 0.25), plaster, true)
	for x in [-1.0, 1.2, 3.4]:
		Forms.box(apartment, Vector3(x, 2.2, -4.92), Vector3(0.085, 2.8, 0.2), cream)
	for y in [0.86, 2.25, 3.6]:
		Forms.box(apartment, Vector3(1.2, y, -4.92), Vector3(4.6, 0.07, 0.2), cream)
	Forms.box(apartment, Vector3(1.2, 0.85, -4.76), Vector3(4.7, 0.13, 0.45), oak, true)
	var glass := StandardMaterial3D.new()
	glass.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	glass.albedo_color = Color(0.6, 0.75, 0.73, 0.13)
	window_glass = Forms.box(apartment, Vector3(1.2, 2.2, -5.05), Vector3(4.4, 2.8, 0.025), glass, true)
	city()
	# Heavy linen curtains, with visible folds.
	for side in [-1.0, 3.45]:
		for i in range(6):
			Forms.cylinder(apartment, Vector3(side + i * 0.1 - 0.25, 2.05, -4.65), 0.085, 3.12, cream)
	Forms.box(apartment, Vector3(1.2, 3.67, -4.63), Vector3(5.1, 0.045, 0.05), memory_mat("b89962"))
	# A warm doorway stays intact as the apartment fades.
	Forms.box(apartment, Vector3(0, 1.4, 4.8), Vector3(1.85, 2.8, 0.15), dark)
	for x in [-0.98, 0.98]:
		Forms.box(apartment, Vector3(x, 1.46, 4.62), Vector3(0.12, 2.92, 0.18), pale)
	Forms.box(apartment, Vector3(0, 2.9, 4.62), Vector3(2.1, 0.13, 0.18), pale)
	var exit_label := Forms.text(apartment, Vector3(0, 2.25, 4.69), "LE MUSÉE", 24, "e2c99c")
	exit_label.rotation.y = PI
	Forms.target(apartment, Vector3(0, 1.4, 4.54), Vector3(1.9, 2.8, 0.25), "exit")
	Forms.lamp(apartment, Vector3(0, 2.4, 3.5), "f7d49a", 0.8, 4)
	for x in [-0.78, 0.78]:
		Forms.box(apartment, Vector3(x, 0.021, 3.5), Vector3(0.025, 0.014, 2.7), glow)
	shutter = Forms.box(apartment, Vector3(0, 1.5, 3.1), Vector3(9.7, 3.0, 0.06), glass)
	for x in [-4.8, -1.15, 1.15, 4.8]:
		Forms.box(shutter, Vector3(x, 0, 0), Vector3(0.045, 3.0, 0.08), brass)
	for y in [-1.48, 1.48]:
		Forms.box(shutter, Vector3(0, y, 0), Vector3(9.7, 0.05, 0.08), brass)
	shutter.visible = false
	furnishings = Node3D.new()
	furnishings.name = "EverydayLife"
	apartment.add_child(furnishings)
	# Upright piano, ivory keys, unfinished score, and a worn bench.
	var p := Vector3(-2.8, 0, -3.45)
	Forms.box(furnishings, p + Vector3(0, 0.68, 0), Vector3(2.2, 1.36, 0.62), piano_black, true)
	Forms.box(furnishings, p + Vector3(0, 1.4, 0), Vector3(2.28, 0.1, 0.72), wood)
	Forms.box(furnishings, p + Vector3(0, 0.8, 0.47), Vector3(2.18, 0.13, 0.44), piano_black, true)
	Forms.box(furnishings, p + Vector3(0, 1.12, 0.34), Vector3(1.9, 0.015, 0.02), brass)
	Forms.text(furnishings, p + Vector3(0, 1.2, 0.323), "É R A R D", 15, "ae986b")
	for i in range(28):
		var key := Forms.box(furnishings, p + Vector3(-0.96 + i * 0.071, 0.886, 0.49), Vector3(0.065, 0.035, 0.34), cream)
		piano_keys.append(key)
		if i % 7 in [0, 1, 3, 4, 5]:
			Forms.box(furnishings, p + Vector3(-0.927 + i * 0.071, 0.919, 0.4), Vector3(0.04, 0.045, 0.19), piano_black)
	for x in [-0.9, 0.9]:
		Forms.box(furnishings, p + Vector3(x, 0.43, 0.56), Vector3(0.1, 0.86, 0.1), wood)
	for x in [-0.12, 0.12]:
		Forms.box(furnishings, p + Vector3(x, 0.12, 0.5), Vector3(0.08, 0.045, 0.25), brass)
	Forms.target(apartment, p + Vector3(0, 0.95, 0.65), Vector3(2.0, 0.32, 0.4), "piano")
	Forms.box(furnishings, p + Vector3(0, 0.48, 1.18), Vector3(1.15, 0.15, 0.47), rust, true)
	for x in [-0.45, 0.45]:
		Forms.box(furnishings, p + Vector3(x, 0.22, 1.18), Vector3(0.07, 0.44, 0.34), wood)
	var score := Forms.picture(furnishings, p + Vector3(0, 1.23, 0.37), Vector2(0.56, 0.39), preload("res://assets/art/score.png"), oak)
	score.rotation.x = -0.13
	item(furnishings, "cassette", p + Vector3(0.65, 1.49, 0.0))
	Forms.target(apartment, p + Vector3(0.65, 1.54, 0.0), Vector3(0.6, 0.35, 0.65), "cassette")
	# A woven rug anchors the quieter living corner.
	Forms.box(furnishings, Vector3(1.75, 0.041, 0.15), Vector3(4.1, 0.025, 4.9), rust)
	for inset in [0.1, 0.18, 0.27]:
		for x in [-0.3 + inset, 3.8 - inset]:
			Forms.box(furnishings, Vector3(x, 0.058, 0.15), Vector3(0.025, 0.006, 4.9 - inset * 2), cream)
		for z in [-2.3 + inset, 2.6 - inset]:
			Forms.box(furnishings, Vector3(1.75, 0.058, z), Vector3(4.1 - inset * 2, 0.006, 0.025), cream)
	var fabric := memory_mat("8e9a7c")
	Forms.box(furnishings, Vector3(3.6, 0.38, 0.4), Vector3(1.15, 0.5, 2.75), fabric, true)
	Forms.box(furnishings, Vector3(4.1, 0.9, 0.4), Vector3(0.28, 1.0, 2.8), fabric, true)
	for z in [-0.94, 1.74]:
		Forms.box(furnishings, Vector3(3.55, 0.73, z), Vector3(1.2, 0.58, 0.21), fabric)
	for z in [-0.3, 0.8]:
		Forms.box(furnishings, Vector3(3.45, 0.67, z), Vector3(0.83, 0.17, 1.05), cream)
	var cushion := Forms.box(furnishings, Vector3(3.8, 0.96, 1.14), Vector3(0.25, 0.59, 0.57), rust)
	cushion.rotation.z = -0.2
	# Photo and two mugs, interrupted in the middle of an ordinary day.
	Forms.cylinder(furnishings, Vector3(1.35, 0.55, -0.4), 0.84, 0.085, oak, -1, true)
	Forms.cylinder(furnishings, Vector3(1.35, 0.27, -0.4), 0.15, 0.55, wood, -1, true)
	Forms.cylinder(furnishings, Vector3(1.35, 0.045, -0.4), 0.48, 0.06, wood)
	item(furnishings, "photo", Vector3(1.45, 0.61, -0.53))
	Forms.target(apartment, Vector3(1.45, 0.83, -0.53), Vector3(0.65, 0.5, 0.4), "photo")
	mug(Vector3(0.99, 0.63, -0.19), cream)
	mug(Vector3(1.7, 0.63, -0.02), green)
	Forms.box(furnishings, Vector3(1.0, 0.607, -0.76), Vector3(0.3, 0.025, 0.23), dark)
	# Writing desk near the doorway. The train ticket is still here.
	Forms.box(furnishings, Vector3(-3.7, 0.79, 2.3), Vector3(1.8, 0.1, 0.85), oak, true)
	for x in [-4.42, -2.98]:
		for z in [1.99, 2.62]:
			Forms.box(furnishings, Vector3(x, 0.4, z), Vector3(0.065, 0.8, 0.065), wood)
	item(furnishings, "letter", Vector3(-3.55, 0.855, 2.26))
	Forms.target(apartment, Vector3(-3.55, 0.95, 2.26), Vector3(0.7, 0.35, 0.7), "letter")
	Forms.box(furnishings, Vector3(-3.01, 0.86, 2.2), Vector3(0.035, 0.025, 0.34), piano_black).rotation.y = 0.25
	Forms.box(furnishings, Vector3(-4.2, 0.86, 2.15), Vector3(0.25, 0.016, 0.12), cream)
	var ticket := Forms.text(furnishings, Vector3(-4.2, 0.872, 2.15), "ALLER SIMPLE", 10, "596555")
	ticket.rotation.x = -PI / 2
	# Light fixtures, house plants, books and framed studies.
	floor_lamp(Vector3(3.7, 0, -2.7), oak, cream)
	plant(furnishings, Vector3(3.0, 0.91, -4.6), 0.62, true)
	plant(furnishings, Vector3(-4.4, 0, -0.75), 1.15, true)
	Forms.box(furnishings, Vector3(-4.78, 1.85, 0.6), Vector3(0.4, 0.07, 1.9), oak)
	for i in range(9):
		var book := Forms.box(furnishings, Vector3(-4.69, 2.05, -0.13 + i * 0.14), Vector3(0.23, rng.randf_range(0.28, 0.4), 0.105), [green, rust, cream, wood][i % 4])
		book.rotation.x = 0.04 if i % 3 else -0.12
	Forms.picture(furnishings, Vector3(-2.75, 2.6, -4.84), Vector2(0.85, 1.1), preload("res://assets/art/score.png"), wood)
	var pendant := Vector3(0.0, 3.15, 0.0)
	Forms.cylinder(furnishings, Vector3(0, 3.65, 0), 0.012, 0.7, piano_black)
	Forms.cylinder(furnishings, pendant, 0.43, 0.3, cream, 0.18)
	Forms.cylinder(furnishings, pendant - Vector3(0, 0.16, 0), 0.39, 0.02, glow)
	memory_lights.append(Forms.lamp(apartment, Vector3(0, 2.9, 0), "ffdaa0", 1.35, 7, true))
	memory_lights.append(Forms.lamp(apartment, Vector3(1.2, 2.6, -4.0), "bacfdb", 1.65, 8, true))
	memory_lights.append(Forms.lamp(apartment, Vector3(-3, 2.2, -2.5), "ffdeb0", 0.5, 4))

func city() -> void:
	var city_mat := memory_mat("586e70")
	var city_dark := memory_mat("263c38")
	var city_glow := memory_mat("ffdda0")
	city_glow.set_shader_parameter("emission_strength", 1.0)
	var sky := memory_mat("8dacae")
	sky.set_shader_parameter("emission_strength", 0.3)
	Forms.box(apartment, Vector3(0, 4, -16), Vector3(40, 20, 0.1), sky)
	for i in range(13):
		var x := -12.0 + i * 2.0
		var height := rng.randf_range(3, 7)
		var z := rng.randf_range(-12, -8)
		Forms.box(apartment, Vector3(x, height / 2 - 1.5, z), Vector3(1.8, height, 2), city_mat)
		for floor_i in range(5):
			for column in [-0.45, 0.45]:
				if floor_i * 0.9 < height - 0.6:
					Forms.box(apartment, Vector3(x + column, floor_i * 0.9 - 0.9, z + 1.01), Vector3(0.36, 0.49, 0.02), city_glow if rng.randf() > 0.55 else city_dark)
	rain_lines = MultiMeshInstance3D.new()
	var multi := MultiMesh.new()
	multi.transform_format = MultiMesh.TRANSFORM_3D
	var drop := BoxMesh.new()
	drop.size = Vector3(0.008, 0.13, 0.008)
	drop.material = Forms.material("a4c2c1", 1, 0, 0.2)
	multi.mesh = drop
	multi.instance_count = 180
	for i in range(180):
		multi.set_instance_transform(i, Transform3D(Basis.IDENTITY, Vector3(rng.randf_range(-1.1, 3.5), rng.randf_range(0, 5), rng.randf_range(-6.0, -5.2))))
	rain_lines.multimesh = multi
	apartment.add_child(rain_lines)

func _process(delta: float) -> void:
	if rain_lines.visible:
		for i in range(rain_lines.multimesh.instance_count):
			var trans := rain_lines.multimesh.get_instance_transform(i)
			trans.origin.y -= delta * 3.5
			if trans.origin.y < 0:
				trans.origin.y += 5
			rain_lines.multimesh.set_instance_transform(i, trans)

func plant(parent: Node3D, at: Vector3, height: float, fades: bool) -> void:
	var pot := memory_mat("aa7353") if fades else Forms.material("a27655")
	var leaf := memory_mat("526944") if fades else Forms.material("4e6550")
	Forms.cylinder(parent, at + Vector3(0, height * 0.15, 0), height * 0.19, height * 0.3, pot, height * 0.23)
	Forms.cylinder(parent, at + Vector3(0, height * 0.5, 0), 0.018, height * 0.7, dark)
	for i in range(9):
		var angle := i * 2.4
		var y := height * (0.4 + float(i) * 0.065)
		var mesh := Forms.sphere(parent, at + Vector3(cos(angle) * height * 0.19, y, sin(angle) * height * 0.19), height * 0.19, leaf)
		mesh.scale = Vector3(0.65, 0.3, 1.8)
		mesh.rotation = Vector3(0.3, -angle, 0.25)

func floor_lamp(at: Vector3, wood: Material, shade: Material) -> void:
	Forms.cylinder(furnishings, at + Vector3(0, 0.035, 0), 0.3, 0.07, wood)
	Forms.cylinder(furnishings, at + Vector3(0, 0.85, 0), 0.027, 1.7, brass)
	Forms.cylinder(furnishings, at + Vector3(0, 1.75, 0), 0.42, 0.47, shade, 0.22)
	Forms.cylinder(furnishings, at + Vector3(0, 1.51, 0), 0.38, 0.016, glow)
	memory_lights.append(Forms.lamp(apartment, at + Vector3(0, 1.45, 0), "ffd093", 1.2, 4.3, true))

func mug(at: Vector3, mat: Material) -> void:
	Forms.cylinder(furnishings, at + Vector3(0, 0.065, 0), 0.065, 0.13, mat)
	Forms.cylinder(furnishings, at + Vector3(0, 0.133, 0), 0.055, 0.006, Forms.material("4b3a27"))
	var torus := TorusMesh.new()
	torus.inner_radius = 0.027
	torus.outer_radius = 0.044
	Forms.shape(furnishings, at + Vector3(0.075, 0.075, 0), torus, mat).rotation.x = PI / 2

func item(parent: Node3D, id: String, at: Vector3) -> Node3D:
	var root := Node3D.new()
	root.name = id.capitalize()
	parent.add_child(root)
	root.position = at
	match id:
		"cassette":
			Forms.box(root, Vector3(0, 0.055, 0), Vector3(0.31, 0.105, 0.19), dark)
			Forms.box(root, Vector3(0, 0.11, -0.006), Vector3(0.27, 0.008, 0.15), pale)
			for x in [-0.075, 0.075]:
				Forms.cylinder(root, Vector3(x, 0.12, 0.025), 0.027, 0.009, black)
			var label := Forms.text(root, Vector3(0, 0.119, -0.05), "DIMANCHE / 04", 8, "62644f")
			label.rotation.x = -PI / 2
		"photo":
			var photo := Forms.picture(root, Vector3(0, 0.18, 0), Vector2(0.39, 0.28), preload("res://assets/art/photograph.png"), brass)
			photo.rotation.x = -0.12
			Forms.box(root, Vector3(0, 0.09, -0.075), Vector3(0.07, 0.18, 0.05), dark)
		"letter":
			var letter := Forms.picture(root, Vector3(0, 0.02, 0), Vector2(0.32, 0.42), preload("res://assets/art/letter.png"), pale)
			letter.rotation.x = -PI / 2
	return root

func set_loss(value: float) -> void:
	loss = value
	env.background_color = Color("718382").lerp(Color("15231e"), value)
	env.fog_light_color = Color("afb0a0").lerp(Color("18261f"), value)
	env.fog_density = lerpf(0.004, 0.025, value)
	for mat in memory_materials:
		mat.set_shader_parameter("loss", value)
	for light in memory_lights:
		light.light_energy = (1.0 - value) * 1.2
	if value >= 0.99:
		furnishings.visible = false
		rain_lines.visible = false
		window_glass.visible = false
		# Transparent remnants must not leave invisible furniture collisions.
		for body in furnishings.find_children("*", "StaticBody3D", true, false):
			body.collision_layer = 0
		for area in apartment.find_children("*", "Area3D", true, false):
			if area.get_meta("interaction", "") != "exit":
				area.collision_layer = 0

func show_trace(id: String) -> void:
	env.background_color = Color("718382")
	env.fog_light_color = Color("afb0a0")
	env.fog_density = 0.004
	if not id.is_empty():
		item(keepsake, id, Vector3.ZERO)
	trace_light.light_energy = 1.5

func press_key(index: int) -> void:
	var key := piano_keys[10 + index]
	var tween := create_tween()
	tween.tween_property(key, "position:y", 0.875, 0.06)
	tween.tween_property(key, "position:y", 0.886, 0.3)
