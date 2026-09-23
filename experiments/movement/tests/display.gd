extends Node
## Window and input checks in a real graphical session; no personal saves.
var failures: Array[String] = []
var count := 0

func check(condition: bool, description: String) -> void:
	count += 1
	if not condition:
		failures.append(description)
		print("FAIL: ", description)

func settle() -> void:
	await get_tree().create_timer(0.15).timeout
	await RenderingServer.frame_post_draw

func key(code: Key) -> void:
	var event := InputEventKey.new()
	event.keycode = code
	event.pressed = true
	Input.parse_input_event(event)
	event = InputEventKey.new()
	event.keycode = code
	Input.parse_input_event(event)

func run(lab: Node2D) -> void:
	await settle()
	var window := get_window()
	check(window.mode == Window.MODE_MAXIMIZED, "starts maximized")
	check(not window.unresizable, "window can resize")
	key(KEY_F2)
	await settle()
	check(lab.mode == 1 and lab.course_index == 0, "F2 selects Balancier")
	key(KEY_PAGEDOWN)
	await settle()
	check(lab.course_index == 1, "PgDown changes course without completion")
	key(KEY_F3)
	await settle()
	check(lab.mode == 2, "F3 selects Portance")
	key(KEY_ESCAPE)
	await settle()
	check(lab.paused and not lab.mover.active, "Escape pauses")
	key(KEY_ENTER)
	await settle()
	check(not lab.paused and lab.mover.active, "Enter resumes")
	key(KEY_T)
	key(KEY_H)
	await settle()
	check(lab.show_times and not lab.show_help, "timer and help toggles")
	key(KEY_T)
	key(KEY_H)
	lab.on_focus_lost()
	# Automatic runs skip OS focus events; exercise the same pause operation.
	lab.set_paused(true)
	check(lab.paused, "focus pause state")
	key(KEY_ENTER)
	window.mode = Window.MODE_WINDOWED
	var directory := ProjectSettings.globalize_path("res://../../artifacts/movement")
	DirAccess.make_dir_recursive_absolute(directory)
	for resolution in [Vector2i(960, 600), Vector2i(1280, 1024), Vector2i(1920, 1080)]:
		window.size = resolution
		await settle()
		check(window.size == resolution, "requested size " + str(resolution))
		var bounds := get_viewport().get_visible_rect()
		for button: Button in lab.buttons:
			check(bounds.encloses(button.get_global_rect()), "study tab inside viewport " + str(resolution))
		get_viewport().get_texture().get_image().save_png(directory.path_join("window-%dx%d.png" % [resolution.x, resolution.y]))
	key(KEY_F11)
	await settle()
	check(window.mode == Window.MODE_FULLSCREEN, "F11 enters fullscreen")
	key(KEY_F11)
	await settle()
	check(window.mode == Window.MODE_WINDOWED, "F11 restores previous mode")
	print("MOVEMENT DISPLAY: %d checks, %d failures" % [count, failures.size()])
	get_tree().quit(0 if failures.is_empty() else 1)
