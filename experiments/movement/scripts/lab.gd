extends Node2D

const Courses = preload("res://scripts/levels.gd")
const Mover = preload("res://scripts/mover.gd")
const Sound = preload("res://scripts/sound.gd")
const TITLE_FONT = preload("res://assets/fonts/Cormorant.ttf")
const TEXT_FONT = preload("res://assets/fonts/Inter.ttf")
const INK := Color("e3dcc9")
const MUTED := Color("94a6a8")
const SAVE_PATH := "user://movement-studies.json"

var mover: CharacterBody2D
var sound: Node
var geometry: Node2D
var ui: Control
var mode := 0
var course_index := 0
var level: Dictionary
var completed := false
var paused := false
var show_times := false
var show_help := true
var timer := 0.0
var started := false
var deaths := 0
var transition := 0.0
var time := 0.0
var stats: Dictionary = {}
var attempts: Array = []
var buttons: Array[Button] = []
var automatic := false
var previous_window_mode := Window.MODE_MAXIMIZED
var respawn_pending := false

func _ready() -> void:
	var arguments := OS.get_cmdline_user_args()
	automatic = "--smoke" in arguments or "--capture" in arguments or "--display-smoke" in arguments
	get_window().min_size = Vector2i(960, 600)
	get_window().title = "Unlived — Études de mouvement"
	configure_input()
	load_stats()
	sound = Sound.new()
	add_child(sound)
	sound.enabled = not automatic
	geometry = Node2D.new()
	add_child(geometry)
	mover = Mover.new()
	add_child(mover)
	mover.sounded.connect(sound.play)
	build_ui()
	load_course(0, 0)
	get_window().focus_exited.connect(on_focus_lost)
	get_window().focus_entered.connect(on_focus_returned)
	if "--smoke" in OS.get_cmdline_user_args():
		var test: Node = load("res://tests/smoke.gd").new()
		add_child(test)
		test.call_deferred("run", self)
	elif "--capture" in OS.get_cmdline_user_args():
		call_deferred("capture_studies")
	elif "--display-smoke" in arguments:
		var test: Node = load("res://tests/display.gd").new()
		add_child(test)
		test.call_deferred("run", self)

func configure_input() -> void:
	var bindings := {
		"left": [KEY_A, KEY_LEFT], "right": [KEY_D, KEY_RIGHT],
		"up": [KEY_W, KEY_UP], "down": [KEY_S, KEY_DOWN],
		"jump": [KEY_SPACE], "ability": [KEY_E, KEY_SHIFT],
	}
	for action: String in bindings:
		if InputMap.has_action(action): InputMap.erase_action(action)
		InputMap.add_action(action, 0.22)
		for key: int in bindings[action]:
			var event := InputEventKey.new()
			event.physical_keycode = key
			InputMap.action_add_event(action, event)
	for pair in [["jump", JOY_BUTTON_A], ["ability", JOY_BUTTON_X], ["left", JOY_BUTTON_DPAD_LEFT], ["right", JOY_BUTTON_DPAD_RIGHT], ["up", JOY_BUTTON_DPAD_UP], ["down", JOY_BUTTON_DPAD_DOWN]]:
		var event := InputEventJoypadButton.new()
		event.button_index = pair[1]
		InputMap.action_add_event(pair[0], event)
	for pair in [["left", JOY_AXIS_LEFT_X, -1.0], ["right", JOY_AXIS_LEFT_X, 1.0], ["up", JOY_AXIS_LEFT_Y, -1.0], ["down", JOY_AXIS_LEFT_Y, 1.0]]:
		var event := InputEventJoypadMotion.new()
		event.axis = pair[1]
		event.axis_value = pair[2]
		InputMap.action_add_event(pair[0], event)

func build_ui() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	ui = Control.new()
	ui.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ui.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(ui)
	for i in 3:
		var button := Button.new()
		button.text = "F%d   %s" % [i + 1, Courses.NAMES[i]]
		button.position = Vector2(695 + i * 180, 33)
		button.size = Vector2(168, 43)
		button.add_theme_font_override("font", TEXT_FONT)
		button.add_theme_font_size_override("font_size", 16)
		for style in ["normal", "hover", "pressed", "focus"]:
			button.add_theme_stylebox_override(style, StyleBoxEmpty.new())
		button.add_theme_color_override("font_hover_color", INK)
		button.focus_mode = Control.FOCUS_NONE
		button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		button.pressed.connect(func(): load_course(i, 0))
		ui.add_child(button)
		buttons.append(button)

func load_course(next_mode: int, next_course: int) -> void:
	if started and not completed: record_attempt("changed")
	mode = posmod(next_mode, 3)
	course_index = posmod(next_course, 3)
	level = Courses.course(mode, course_index)
	for child in geometry.get_children():
		geometry.remove_child(child)
		child.queue_free()
	for rect: Rect2 in level.solids:
		add_solid(rect)
	# Side and top bounds, intentionally outside the playable region.
	add_solid(Rect2(-40, 95, 40, 720))
	add_solid(Rect2(1280, 95, 40, 720))
	add_solid(Rect2(0, 82, 1280, 12))
	mover.mode = mode
	mover.accent = Courses.COLORS[mode]
	mover.anchors = level.anchors
	mover.winds = level.winds
	mover.ability_count = 0
	mover.reset_at(level.spawn)
	mover.active = true
	completed = false
	paused = false
	started = false
	timer = 0.0
	deaths = 0
	transition = 0.35
	respawn_pending = false
	for i in buttons.size():
		buttons[i].add_theme_color_override("font_color", Courses.COLORS[i] if i == mode else MUTED)
	queue_redraw()

func add_solid(rect: Rect2) -> void:
	var body := StaticBody2D.new()
	body.position = rect.get_center()
	body.collision_layer = 1
	body.collision_mask = 2
	var collider := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = rect.size
	collider.shape = shape
	body.add_child(collider)
	geometry.add_child(body)

func _process(delta: float) -> void:
	if not paused: time += delta
	transition = maxf(0.0, transition - delta)
	queue_redraw()

func _physics_process(delta: float) -> void:
	if paused or completed or respawn_pending: return
	if not started:
		var controls: Dictionary = mover.input_state()
		started = controls.axis.length() > 0.1 or controls.jump or controls.action
	if started: timer += delta
	if mover.position.y > 800 or mover.position.x < -30 or mover.position.x > 1310:
		respawn_pending = true
		call_deferred("retry", false)
		return
	var body_rect := Rect2(mover.position - Vector2(10, 16), Vector2(20, 32))
	if body_rect.intersects(level.goal):
		complete_course()

func retry(full := false) -> void:
	if full:
		if started and not completed: record_attempt("restarted")
		deaths = 0
		timer = 0.0
		started = false
		mover.ability_count = 0
	else:
		deaths += 1
	mover.reset_at(level.spawn)
	completed = false
	paused = false
	mover.active = true
	respawn_pending = false
	transition = 0.16
	sound.play("retry")

func complete_course() -> void:
	completed = true
	mover.active = false
	sound.play("finish")
	record_attempt("completed")
	var key := "%d/%d" % [mode, course_index]
	var previous: float = float(stats.get(key, {}).get("best", INF))
	stats[key] = {"best": minf(previous, timer), "last": timer, "falls": deaths}
	save_stats()

func record_attempt(result: String) -> void:
	if automatic: return
	attempts.append({"study": Courses.NAMES[mode], "course": course_index + 1,
		"result": result, "seconds": snappedf(timer, 0.01), "falls": deaths,
		"actions": mover.ability_count, "at": Time.get_datetime_string_from_system()})
	if attempts.size() > 200: attempts.pop_front()
	save_stats()

func load_stats() -> void:
	if automatic or not FileAccess.file_exists(SAVE_PATH): return
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(SAVE_PATH))
	if parsed is Dictionary:
		if parsed.get("best", null) is Dictionary: stats = parsed.best
		if parsed.get("attempts", null) is Array: attempts = parsed.attempts

func save_stats() -> void:
	if automatic: return
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file: file.store_string(JSON.stringify({"best": stats, "attempts": attempts}, "\t"))

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if started and not completed: record_attempt("closed")

func set_paused(value: bool) -> void:
	paused = value
	mover.active = not value and not completed
	if value:
		mover.jump_buffer = 0.0

func on_focus_lost() -> void:
	if not automatic: set_paused(true)

func on_focus_returned() -> void:
	# Explicit resume keeps the player from falling while finding the window.
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventJoypadButton and event.pressed:
		match event.button_index:
			JOY_BUTTON_START: set_paused(not paused)
			JOY_BUTTON_BACK: retry(true)
			JOY_BUTTON_RIGHT_SHOULDER: advance()
	if not event is InputEventKey or not event.pressed or event.echo: return
	match event.keycode:
		KEY_F1: load_course(0, 0)
		KEY_F2: load_course(1, 0)
		KEY_F3: load_course(2, 0)
		KEY_R: retry(true)
		KEY_BRACKETRIGHT, KEY_PAGEDOWN: load_course(mode, course_index + 1)
		KEY_BRACKETLEFT, KEY_PAGEUP: load_course(mode, course_index - 1)
		KEY_ENTER, KEY_KP_ENTER:
			if paused: set_paused(false)
			elif completed: advance()
		KEY_ESCAPE: set_paused(not paused)
		KEY_T: show_times = not show_times
		KEY_H: show_help = not show_help
		KEY_M: sound.enabled = not sound.enabled
		KEY_F11: toggle_fullscreen()

func advance() -> void:
	if course_index < 2: load_course(mode, course_index + 1)
	else: load_course(mode + 1, 0)

func toggle_fullscreen() -> void:
	var window := get_window()
	if window.mode == Window.MODE_FULLSCREEN:
		window.mode = previous_window_mode
	else:
		previous_window_mode = window.mode
		window.mode = Window.MODE_FULLSCREEN

func text_at(value: String, point: Vector2, size: int, color: Color = INK, title := false) -> void:
	draw_string(TITLE_FONT if title else TEXT_FONT, point, value, HORIZONTAL_ALIGNMENT_LEFT, -1, size, color)

func _draw() -> void:
	if level.is_empty(): return
	var accent: Color = Courses.COLORS[mode]
	draw_rect(Rect2(0, 0, 1280, 800), Color("111d24"))
	# Quiet depth and a shared material language across all three studies.
	for i in range(12):
		var x := float(i * 127 - 40)
		var height := float(150 + (i * 73) % 250)
		draw_rect(Rect2(x, 740 - height, 90, height), Color("19282f"))
		draw_line(Vector2(x + 8, 740 - height), Vector2(x + 8, 730), Color("1e2e35"), 1)
	for i in 22:
		var x := float((i * 193 + 77) % 1260)
		var y := 170.0 + float((i * 87) % 430) + sin(time * 0.22 + i) * 4
		draw_circle(Vector2(x, y), 1, Color(accent, 0.09))
	draw_line(Vector2(40, 95), Vector2(1240, 95), Color("3a494d"), 1)
	text_at("Unlived", Vector2(40, 60), 36, INK, true)
	text_at("ÉTUDES DE MOUVEMENT", Vector2(169, 57), 12, MUTED)
	draw_line(Vector2(707 + mode * 180, 82), Vector2(827 + mode * 180, 82), accent, 2)
	text_at("0%d   /   %s" % [course_index + 1, level.name], Vector2(42, 136), 23, accent, true)
	for i in 3:
		draw_circle(Vector2(1201 + i * 16, 126), 3, accent if i <= course_index else Color("465358"))
	for region: Rect2 in level.winds:
		draw_rect(region, Color(accent, 0.035))
		for i in 14:
			var x := region.position.x + 12 + fmod(i * 37.0, region.size.x - 24)
			var y := region.end.y - fmod(time * 78 + i * 43, region.size.y)
			draw_line(Vector2(x, y), Vector2(x + sin(time + i) * 3, maxf(region.position.y, y - 27)), Color(accent, 0.30), 1, true)
	for rect: Rect2 in level.solids:
		draw_rect(Rect2(rect.position + Vector2(7, 9), rect.size), Color(0.025, 0.04, 0.05, 0.35))
		draw_rect(rect, Color("35464b"))
		draw_rect(Rect2(rect.position, Vector2(rect.size.x, 5)), Color("9ba59b"))
		draw_line(rect.position, Vector2(rect.end.x, rect.position.y), Color(accent, 0.65), 1)
		for i in int(rect.size.x / 48):
			var x := rect.position.x + i * 48 + 20
			draw_line(Vector2(x, rect.position.y + 13), Vector2(x, minf(rect.end.y, 720)), Color("3c4c50"), 1)
		# Visible wall seams also establish that surfaces share one rule.
		if mode == 0:
			draw_line(rect.position + Vector2(1, 8), Vector2(rect.position.x + 1, minf(rect.end.y, rect.position.y + 70)), Color(accent, 0.35), 1)
	for i in level.anchors.size():
		var point: Vector2 = level.anchors[i]
		var selected: bool = mover.candidate == i and mover.rope_index < 0
		draw_line(Vector2(point.x, 154), point, Color(accent, 0.18), 1)
		draw_circle(point, 16, Color(accent, 0.06))
		draw_arc(point, 8, 0, TAU, 28, accent if selected else Color("657d86"), 2, true)
		draw_circle(point, 2, accent)
		if selected:
			draw_arc(point, 14, 0, TAU, 32, Color(accent, 0.45), 1, true)
			text_at("E", point + Vector2(-4, -23), 12, accent)
	var door: Rect2 = level.goal
	draw_rect(door.grow(10), Color(accent, 0.035))
	draw_rect(door, Color(accent, 0.13))
	draw_line(door.position, Vector2(door.position.x, door.end.y), accent, 2)
	draw_line(door.position, Vector2(door.end.x, door.position.y), accent, 2)
	draw_line(Vector2(door.end.x, door.position.y), door.end, Color(accent, 0.45), 1)
	draw_line(Vector2(level.spawn.x - 15, level.spawn.y + 16), Vector2(level.spawn.x + 15, level.spawn.y + 16), accent, 2)
	# HUD draws after the scene, never in front of traversal geometry.
	draw_rect(Rect2(0, 733, 1280, 67), Color("111d24"))
	draw_line(Vector2(40, 733), Vector2(1240, 733), Color("3a494d"), 1)
	text_at("← → / Q D   marcher     Espace   sauter     E / Maj   geste", Vector2(40, 758), 13, INK)
	text_at("R  reprendre    Pg↑ Pg↓  parcours    H  aide    T  chrono    M  son    Échap  pause", Vector2(40, 783), 12, MUTED)
	text_at("ESSAI  /  2D", Vector2(1134, 782), 11, MUTED)
	if show_help and not paused and not completed:
		text_at(Courses.RULES[mode], Vector2(42, 175), 14, INK)
		text_at(level.hint, Vector2(42, 708), 13, MUTED)
	if show_times:
		var key := "%d/%d" % [mode, course_index]
		var best := "—"
		if stats.has(key): best = "%.2f s" % float(stats[key].best)
		text_at("%.2f s  ·  %d chutes  ·  meilleur %s" % [timer, deaths, best], Vector2(760, 136), 12, MUTED)
	if completed or paused:
		draw_rect(Rect2(0, 95, 1280, 638), Color(0.035, 0.06, 0.075, 0.88))
		text_at("Parcours terminé" if completed else "Pause", Vector2(440, 353), 52, INK, true)
		if completed:
			text_at("Entrée   continuer     R   rejouer", Vector2(441, 414), 17, accent)
			text_at("F1 · F2 · F3   changer de geste", Vector2(441, 451), 14, MUTED)
			if show_times: text_at("%.2f s  /  %d chutes" % [timer, deaths], Vector2(441, 490), 15, MUTED)
		else:
			text_at("Entrée / Échap   reprendre     R   recommencer", Vector2(441, 414), 15, accent)
			text_at("Manette : stick / croix · A sauter · X geste · Start pause", Vector2(360, 464), 13, MUTED)
			text_at("F11 plein écran · M son · fermer la fenêtre pour quitter", Vector2(360, 495), 13, MUTED)
	if transition > 0.0:
		draw_rect(Rect2(0, 95, 1280, 638), Color(0.06, 0.09, 0.11, transition * 0.65))

func capture_studies() -> void:
	var capture_dir := ProjectSettings.globalize_path("res://../../artifacts/movement")
	DirAccess.make_dir_recursive_absolute(capture_dir)
	for study in 3:
		load_course(study, 0)
		await get_tree().create_timer(0.5).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(capture_dir.path_join("study-%d.png" % (study + 1)))
		mover.controlled_by_test = true
		if study == 0:
			await capture_input(60, Vector2(1, -1).normalized(), false, true)
		elif study == 1:
			await capture_input(77, Vector2.RIGHT)
			await capture_input(14, Vector2.RIGHT, true)
			await capture_input(34, Vector2.RIGHT, false, true)
		else:
			await capture_input(77, Vector2.RIGHT)
			await capture_input(1, Vector2.RIGHT, true)
			await capture_input(88, Vector2.RIGHT, false, true)
		mover.active = false
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(capture_dir.path_join("gesture-%d.png" % (study + 1)))
	print("CAPTURE: three studies saved to ", capture_dir)
	get_tree().quit()

func capture_input(frames: int, axis: Vector2, jump := false, action := false) -> void:
	mover.test_axis = axis
	mover.test_jump = jump
	mover.test_action = action
	for frame in frames: await get_tree().physics_frame
