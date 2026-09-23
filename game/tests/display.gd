extends Node
## Real window-manager and layout regression checks. Requires a graphical session.
var failures: Array[String] = []
var count := 0

func check(condition: bool, description: String) -> void:
	count += 1
	if not condition:
		failures.append(description)
		push_error(description)

func settle() -> void:
	await get_tree().create_timer(0.15).timeout
	await RenderingServer.frame_post_draw

func check_controls(ui: MuseumInterface, context: String) -> void:
	var bounds := Rect2(Vector2.ZERO, ui.root.size).grow(2)
	for control in ui.root.find_children("*", "Control", true, false):
		if not control.is_visible_in_tree(): continue
		if control is Button or control is Label or control is HSlider:
			check(bounds.encloses(control.get_global_rect()), context + ": control outside viewport: " + str(control.get_global_rect()))

func run(game: Node) -> void:
	await settle()
	var window := get_window()
	check(window.mode == Window.MODE_MAXIMIZED, "starts maximized")
	check(not window.unresizable, "window is resizable")
	var usable := DisplayServer.screen_get_usable_rect(window.current_screen)
	check(window.size.x >= usable.size.x * 0.9, "uses available screen width")
	game.on_action("settings")
	await settle()
	check(not game.visitor.enabled, "settings do not start gameplay")
	game.close_ui()
	check(game.ui.current == "menu" and not game.visitor.enabled, "settings return to menu")
	window.mode = Window.MODE_WINDOWED
	for resolution in [Vector2i(960, 600), Vector2i(1280, 1024), Vector2i(1920, 1080), Vector2i(2560, 1080)]:
		window.size = resolution
		await settle()
		check(window.size == resolution, "resize to " + str(resolution))
		for screen_name in ["menu", "pause", "inspection", "piano", "confirm", "trace"]:
			match screen_name:
				"menu": game.ui.menu()
				"pause": game.ui.pause_menu()
				"inspection": game.ui.inspection("letter", true)
				"piano": game.ui.piano()
				"confirm": game.ui.confirmation("cassette")
				"trace": game.ui.empty_trace()
			await settle()
			check_controls(game.ui, "%s %s" % [resolution, screen_name])
			if screen_name in ["menu", "pause", "inspection"] and resolution.x in [960, 2560]:
				var path := "res://../artifacts/display-%s-%dx%d.png" % [screen_name, resolution.x, resolution.y]
				get_viewport().get_texture().get_image().save_png(ProjectSettings.globalize_path(path))
	game.toggle_fullscreen()
	await settle()
	check(window.mode == Window.MODE_FULLSCREEN, "F11 enters fullscreen")
	game.toggle_fullscreen()
	await settle()
	check(window.mode == Window.MODE_WINDOWED, "F11 restores windowed mode")
	window.mode = Window.MODE_MAXIMIZED
	await settle()
	game.toggle_fullscreen()
	await settle()
	game.toggle_fullscreen()
	await settle()
	check(window.mode == Window.MODE_MAXIMIZED, "F11 restores maximized mode")
	game.sound.shutdown()
	# Let the audio thread release its stream playbacks before process teardown.
	await get_tree().create_timer(0.15).timeout
	await get_tree().process_frame
	print("DISPLAY: %d checks, %d failures" % [count, failures.size()])
	get_tree().quit(0 if failures.is_empty() else 1)
