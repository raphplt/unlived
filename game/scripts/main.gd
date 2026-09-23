extends Node3D
## Scene orchestration; irreversible transitions are guarded by Journey.

var journey := Journey.new()
var museum: Museum
var visitor: Visitor
var ui: MuseumInterface
var sound: Soundscape
var busy := false
var started := false
var selected := ""
var test_mode := false
var settings := ConfigFile.new()
var carried: Node3D
var window_mode_before_fullscreen := Window.MODE_MAXIMIZED
var settings_from_menu := false

func _ready() -> void:
	test_mode = "--smoke" in OS.get_cmdline_user_args() or "--display-smoke" in OS.get_cmdline_user_args()
	get_window().min_size = Vector2i(960, 600)
	get_window().title = "Unlived"
	# A/B configuration belongs to the test launcher, not the opening fiction.
	if "--variant=leave" in OS.get_cmdline_user_args():
		journey.variant = Journey.Variant.LEAVE
	museum = Museum.new()
	add_child(museum)
	visitor = Visitor.new()
	add_child(visitor)
	sound = Soundscape.new()
	add_child(sound)
	ui = MuseumInterface.new()
	add_child(ui)
	visitor.footstep.connect(sound.step)
	sound.note_played.connect(func(index): ui.illuminate_key(index))
	ui.action.connect(on_action)
	ui.volume_changed.connect(set_volume)
	ui.sensitivity_changed.connect(set_sensitivity)
	ui.motion_changed.connect(func(value): save_setting("motion", value))
	load_settings()
	menu_view()
	if "--smoke" in OS.get_cmdline_user_args():
		call_deferred("smoke")
	elif "--display-smoke" in OS.get_cmdline_user_args():
		call_deferred("display_smoke")
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--capture="):
			call_deferred("capture", arg.trim_prefix("--capture="))

func load_settings() -> void:
	if not test_mode:
		settings.load("user://settings.cfg")
	ui.volume = float(settings.get_value("comfort", "volume", 75.0))
	ui.sensitivity = float(settings.get_value("comfort", "sensitivity", 50.0))
	ui.reduced_motion = bool(settings.get_value("comfort", "motion", false))
	AudioServer.set_bus_volume_db(0, linear_to_db(ui.volume / 100.0))
	visitor.sensitivity = ui.sensitivity * 0.000044

func save_setting(key: String, value: Variant) -> void:
	if test_mode:
		return
	settings.set_value("comfort", key, value)
	settings.save("user://settings.cfg")

func set_volume(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(maxf(value / 100.0, 0.0001)))
	save_setting("volume", value)

func set_sensitivity(value: float) -> void:
	visitor.sensitivity = value * 0.000044
	save_setting("sensitivity", value)

func duration(value: float) -> float:
	return 0.025 if test_mode else (minf(value, 0.22) if ui.reduced_motion else value)

func menu_view() -> void:
	started = false
	visitor.enabled = false
	visitor.place(Vector3(4.0, 0.12, 5.0))
	visitor.camera.look_at(Vector3(-0.8, 1.9, -3.5))
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	ui.menu()

func _process(_delta: float) -> void:
	if visitor.enabled and ui.current.is_empty() and not busy:
		ui.set_prompt(prompt_for(visitor.target()))

func prompt_for(id: String) -> String:
	match id:
		"enter": return "Ouvrir" if journey.phase == Journey.Phase.HALL else ""
		"exit":
			return "Sortir"
		"piano": return "S’asseoir au piano" if journey.phase == Journey.Phase.APARTMENT else ""
		"cassette": return "Examiner la cassette" if journey.phase == Journey.Phase.APARTMENT else ""
		"photo": return "Regarder la photographie" if journey.phase == Journey.Phase.APARTMENT else ""
		"letter": return "Lire la lettre" if journey.phase == Journey.Phase.APARTMENT else ""
		"plinth": return "Observer" if journey.phase == Journey.Phase.RETURNED else ""
	return ""

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F11:
			toggle_fullscreen()
			return
		if busy:
			return
		if event.keycode == KEY_ESCAPE:
			if ui.current == "menu": return
			if ui.current == "confirm":
				on_action("cancel")
			elif ui.current.is_empty():
				lock_player()
				ui.pause_menu()
			else:
				close_ui()
			get_viewport().set_input_as_handled()
		elif ui.current == "piano" and event.physical_keycode >= KEY_1 and event.physical_keycode <= KEY_7:
			play_note(event.physical_keycode - KEY_1)
		elif ui.current.is_empty() and event.physical_keycode == KEY_E:
			interact(visitor.target())

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT and started and not test_mode and not busy and is_instance_valid(ui) and ui.current.is_empty():
		lock_player()
		ui.pause_menu()

func lock_player() -> void:
	visitor.enabled = false
	visitor.velocity = Vector3.ZERO
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	ui.set_prompt("")

func toggle_fullscreen() -> void:
	var window := get_window()
	if window.mode in [Window.MODE_FULLSCREEN, Window.MODE_EXCLUSIVE_FULLSCREEN]:
		window.mode = window_mode_before_fullscreen
	else:
		window_mode_before_fullscreen = window.mode
		window.mode = Window.MODE_FULLSCREEN

func close_ui() -> void:
	sound.sequence_id += 1
	if settings_from_menu:
		settings_from_menu = false
		ui.menu()
		return
	ui.clear("")
	visitor.enabled = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func start_visit() -> void:
	busy = true
	lock_player()
	await fade_to(1.0)
	if started or journey.phase != Journey.Phase.HALL:
		remove_child(museum)
		museum.queue_free()
		museum = Museum.new()
		add_child(museum)
	journey.reset(journey.variant)
	clear_carried()
	sound.hush()
	selected = ""
	started = true
	visitor.place(Vector3(0, 0.06, 3.8))
	ui.clear("")
	ui.set_location("", "")
	await fade_to(0.0)
	busy = false
	close_ui()

func fade_to(alpha: float) -> void:
	var tween := create_tween()
	tween.tween_property(ui.fade, "modulate:a", alpha, duration(0.65))
	await tween.finished

func enter_apartment() -> void:
	if not journey.enter():
		return
	busy = true
	lock_player()
	await fade_to(1.0)
	visitor.place(Vector3(30, 0.06, 3.65))
	sound.rain_level = 1
	ui.set_location("", "")
	ui.clear("")
	await fade_to(0.0)
	busy = false
	close_ui()

func interact(id: String) -> void:
	if busy:
		return
	match id:
		"enter":
			if journey.phase == Journey.Phase.HALL:
				enter_apartment()
			else:
				ui.toast("Fermé.")
		"cassette", "photo", "letter":
			if journey.phase != Journey.Phase.APARTMENT: return
			selected = id
			journey.inspect(id)
			lock_player()
			ui.inspection(id, journey.variant == Journey.Variant.KEEP)
		"piano":
			if journey.phase != Journey.Phase.APARTMENT: return
			lock_player()
			ui.piano()
		"exit":
			if journey.phase == Journey.Phase.COMMITTED:
				return_to_hall()
			elif journey.phase == Journey.Phase.APARTMENT:
				if journey.variant == Journey.Variant.LEAVE:
					lock_player()
					ui.confirmation("leave")
				else:
					ui.toast("La porte ne s’ouvre pas.")
		"plinth":
			if journey.phase != Journey.Phase.RETURNED: return
			lock_player()
			if journey.phase == Journey.Phase.RETURNED:
				if journey.kept.is_empty():
					ui.empty_trace()
				else:
					ui.inspection(journey.kept, false, true)

func on_action(id: String) -> void:
	if busy: return
	if id.begins_with("choose:"):
		selected = id.trim_prefix("choose:")
		ui.confirmation(selected)
		return
	if id.begins_with("commit:"):
		commit(id.trim_prefix("commit:"))
		return
	if id.begins_with("note:"):
		play_note(int(id.trim_prefix("note:")))
		return
	match id:
		"start": start_visit()
		"close": close_ui()
		"settings":
			settings_from_menu = true
			ui.pause_menu(true)
		"fullscreen": toggle_fullscreen()
		"cancel":
			if journey.variant == Journey.Variant.KEEP and not selected.is_empty():
				ui.inspection(selected, true)
			else:
				close_ui()
		"listen":
			sound.motif()
		"restart":
			ui.simple_dialog("restart", "Recommencer ?", "La visite en cours sera perdue.", "Recommencer", "reset")
		"reset":
			sound.hush()
			# Keep started true until start_visit rebuilds the old scene.
			ui.menu()
			visitor.enabled = false
			visitor.place(Vector3(4, 0.12, 5))
			visitor.camera.look_at(Vector3(-0.8, 1.9, -3.5))
		"ask_quit":
			ui.simple_dialog("quit", "Quitter ?", "La visite en cours n’est pas sauvegardée.", "Quitter", "quit")
		"quit":
			sound.shutdown()
			get_tree().quit()

func play_note(index: int) -> void:
	if journey.phase != Journey.Phase.APARTMENT: return
	journey.notes_played += 1
	sound.note(index)
	museum.press_key(index)

func commit(id: String) -> void:
	var kept := "" if id == "leave" else id
	if not journey.commit(kept): return
	busy = true
	lock_player()
	ui.clear("")
	sound.hush()
	if journey.variant == Journey.Variant.KEEP:
		carried = museum.item(visitor.camera, kept, Vector3(0.39, -0.38, -0.72))
		carried.scale = Vector3.ONE * 0.65
		carried.rotation = Vector3(0.22, -0.22, -0.07)
		if kept == "letter": carried.rotation.x = 0.9
		var tween := create_tween()
		tween.tween_method(museum.set_loss, 0.0, 1.0, duration(5.0))
		await tween.finished
		busy = false
		close_ui()
	else:
		visitor.place(Vector3(30, 0.06, 4.15))
		museum.shutter.visible = true
		museum.shutter.position.y = 5
		var tween := create_tween()
		tween.tween_property(museum.shutter, "position:y", 1.5, duration(2.5))
		await tween.finished
		await get_tree().create_timer(duration(1.8)).timeout
		busy = false
		await return_to_hall()

func return_to_hall() -> void:
	if not journey.return_to_hall(): return
	busy = true
	lock_player()
	await fade_to(1.0)
	visitor.place(Vector3(0, 0.06, -3.5), PI)
	clear_carried()
	museum.show_trace(journey.kept)
	sound.rain_level = 0
	ui.clear("")
	ui.set_location("", "")
	await fade_to(0.0)
	busy = false
	close_ui()

func clear_carried() -> void:
	if is_instance_valid(carried):
		carried.queue_free()
	carried = null

func smoke() -> void:
	var runner := preload("res://tests/smoke.gd").new()
	add_child(runner)
	await runner.run(self)

func display_smoke() -> void:
	var runner := preload("res://tests/display.gd").new()
	add_child(runner)
	await runner.run(self)

func capture(view: String) -> void:
	# Deterministic framing for visual QA; never changes an ordinary session.
	if view != "menu":
		await start_visit()
	if view in ["apartment", "inspection", "piano", "erased", "confirmation", "departure"]:
		await enter_apartment()
		visitor.place(Vector3(30.2, 0.03, 3.2))
		visitor.camera.look_at(Vector3(29.5, 1.3, -2.3))
	if view == "inspection": interact("letter")
	if view == "piano": interact("piano")
	if view == "pause":
		lock_player()
		ui.pause_menu()
	if view == "confirmation":
		lock_player()
		ui.confirmation("photo")
	if view == "departure":
		visitor.place(Vector3(30, 0.06, 4.15))
		museum.shutter.visible = true
	if view == "erased": await commit("photo")
	if view == "trace":
		await enter_apartment()
		journey.commit("photo")
		await return_to_hall()
		visitor.place(Vector3(-0.4, 0.05, 2.5))
		visitor.camera.look_at(Vector3(-2.45, 1.3, 0.1))
	visitor.enabled = false
	await get_tree().create_timer(1).timeout
	await RenderingServer.frame_post_draw
	var path := ProjectSettings.globalize_path("res://../artifacts/%s.png" % view)
	get_viewport().get_texture().get_image().save_png(path)
	print("CAPTURE: " + path)
	sound.shutdown()
	get_tree().quit()
