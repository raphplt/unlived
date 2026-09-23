extends Node3D
## Representative MVP of project sheet 02, v3. Discoveries never gate a door.
const World = preload("res://scripts/inquiry/world.gd")
const Archive = preload("res://scripts/inquiry/archive.gd")
const Interface = preload("res://scripts/inquiry/interface.gd")
const DOCUMENTS := {
	"print": ["17 / 06 · Tirage", "Au crayon, au dos : « Cour, 17 juin. Bande 06. »"],
	"film": ["Bande 06", "17 juin. Six vues.\nLa bande entière peut être posée sur l’agrandisseur."],
	"address": ["Enveloppe", "Lou Mercier\n8, cour Sud — logement à l’étage\n\nAu dos : « Jeudi, après dix-huit heures. N. »"],
	"receipt": ["Location", "8, cour Sud · Au-dessus de l’arche\nLou Mercier · Du 17 au 20 juin\nDeux clés remises, une tasse ébréchée signalée."],
	"contacts": ["17 juin · Contacts", "Sur la pochette : « Lou — essais avec mon appareil. »\nSous la dernière vue, de la même écriture : « Noa, tu pourrais arrêter de te redresser. »"],
	"ticket": ["Échange", "LOU MERCIER · Référence 0648\nRetour du 20 juin annulé. Remplacé par le 24 juin, 09 h 10.\n\nAu crayon : « Préviens au moins avant que je descende t’attendre. — N. »"],
	"visit": ["Carte pliée", "Lou,\nLes draps sont dans le coffre. Je rentre après six heures.\nTu peux garder la clé jusqu’à dimanche.\nN.\n\nAu dos : 3, passage des Tilleuls · rez-de-chaussée."],
	"album": ["Album", "Sur la page : « Encore la mer. — Élie »\nÀ côté, trois petits essais de lune.\n\nLa boîte porte deux anciennes initiales : N. / L."],
	"object_print": ["Tirage publié", "Cour Sud, 17 juin.\nLe bord du papier porte les marques des caches."],
	"object_lou": ["Photographie de Lou", "Au dos : « Celle-ci, tu la gardes pour nous. »"],
	"object_notebook": ["Carnet de repérages", "Une liste d’heures, des flèches, deux adresses rayées.\n« Revenir quand les fenêtres sont ouvertes. »"],
	"object_box": ["Boîte ajourée", "N. / L.\nLes trous les plus récents traversent encore la peinture."],
	"object_drawing": ["Dessin à plusieurs mains", "Au dos : « La lune de Sam. La mer d’Élie. Le coin de Noa. »"],
	"object_cup": ["Coupe réparée", "Une fine ligne claire traverse le fond bleu."],
}
const OBJECTS := {"object_print": "city", "object_lou": "city", "object_notebook": "city", "object_box": "greenhouse", "object_drawing": "greenhouse", "object_cup": "greenhouse"}
var world: InquiryWorld
var archive: InquiryArchive
var visitor: Visitor
var ui: InquiryInterface
var sound: Soundscape
var zone := "hall"
var started := false
var busy := false
var test_mode := false
var photo_index := 0
var pinned := -1
var selected := ""
var save_clock := 0.0
var volume := 65.0
var sensitivity := 50.0
var sitting := false
var stood_at := Vector3.ZERO
var window_mode_before_fullscreen := Window.MODE_MAXIMIZED
var notes_editor: TextEdit
var album_photo: Texture2D
var contact_photo: Texture2D
var object_photo: Texture2D
var evidence_ready := false
var comparison_reference: Texture2D
var current_reference: Texture2D

func _ready() -> void:
	test_mode = "--inquiry-smoke" in OS.get_cmdline_user_args() or "--inquiry-display" in OS.get_cmdline_user_args()
	get_window().title = "Unlived — Les pièces manquantes"
	get_window().min_size = Vector2i(960, 600)
	archive = Archive.new()
	if test_mode: archive.directory = "user://pieces-manquantes-tests"
	world = World.new()
	add_child(world)
	visitor = Visitor.new()
	add_child(visitor)
	visitor.walk_speed = 3.4
	sound = Soundscape.new()
	add_child(sound)
	visitor.footstep.connect(sound.step)
	ui = Interface.new()
	add_child(ui)
	ui.action.connect(on_action)
	load_settings()
	visitor.place(Vector3(0, 0.05, 5))
	visitor.camera.look_at(Vector3(0, 2.5, -7))
	ui.menu(archive.exists() and not test_mode)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().auto_accept_quit = false
	if DisplayServer.get_name() != "headless": call_deferred("prepare_evidence")
	if "--inquiry-smoke" in OS.get_cmdline_user_args(): call_deferred("run_smoke", false)
	if "--inquiry-display" in OS.get_cmdline_user_args(): call_deferred("run_smoke", true)
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--inquiry-capture="):
			test_mode = true
			archive.directory = "user://pieces-manquantes-tests"
			call_deferred("capture", arg.trim_prefix("--inquiry-capture="))

func _process(delta: float) -> void:
	if visitor == null: return
	if not busy: world.update_mirrors(visitor.camera, zone)
	if visitor.enabled:
		var id := visitor.target()
		ui.prompt.text = "E   ·   " + str(world.interaction_names[id]) if world.interaction_names.has(id) else ""
		ui.caption.text = ""
		# Keep the player safe if an external editor/debug placement bypasses a floor.
		if visitor.position.y < -6: travel(zone)
	if started and not busy:
		save_clock += delta
		if save_clock > 12:
			save_clock = 0
			save_visit()

func _input(event: InputEvent) -> void:
	# Tab belongs to the notebook even when a UI button currently owns focus.
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_TAB and started and not busy:
		if ui.current.is_empty(): notebook()
		else: close_ui()
		get_viewport().set_input_as_handled()

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo: return
	if event.keycode == KEY_F11:
		var window := get_window()
		if window.mode == Window.MODE_FULLSCREEN: window.mode = window_mode_before_fullscreen
		else:
			window_mode_before_fullscreen = window.mode
			window.mode = Window.MODE_FULLSCREEN
		return
	if busy: return
	if event.keycode == KEY_ESCAPE:
		if ui.current == "menu": return
		if ui.current.is_empty():
			lock_player()
			ui.pause(volume, sensitivity)
		else: close_ui()
	elif event.keycode == KEY_TAB and started:
		if ui.current.is_empty(): notebook()
		else: close_ui()
	elif ui.current.is_empty() and started:
		match event.physical_keycode:
			KEY_E: interact("sit" if sitting else visitor.target())
			KEY_C: take_photo()
			KEY_M: map_view()
	elif ui.current == "notebook":
		if event.keycode == KEY_LEFT: on_action("previous")
		if event.keycode == KEY_RIGHT: on_action("next")
	get_viewport().set_input_as_handled()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST and archive != null: on_action("quit")
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT and started and not busy and not test_mode and ui != null and ui.current.is_empty():
		lock_player()
		save_visit()
		ui.pause(volume, sensitivity)

func lock_player() -> void:
	visitor.enabled = false
	visitor.velocity = Vector3.ZERO
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	ui.prompt.text = ""

func close_ui() -> void:
	if not started:
		ui.menu(archive.exists())
		return
	if is_instance_valid(notes_editor):
		archive.data.notes = notes_editor.text
		notes_editor = null
		save_visit()
	ui.clear()
	visitor.enabled = true
	visitor.walk_speed = 0 if sitting else 3.4
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if test_mode else Input.MOUSE_MODE_CAPTURED

func start_visit(restore: bool = false) -> void:
	if restore and not archive.restore():
		ui.toast(archive.last_error)
		return
	if not restore:
		archive = Archive.new()
		if test_mode: archive.directory = "user://pieces-manquantes-tests"
	zone = str(archive.data.zone)
	if zone not in ["hall", "city", "greenhouse", "backstage"]: zone = "hall"
	for key in world.switches:
		world.switches[key] = archive.data.states.get(key, key in ["city_light", "city_low_light", "green_light"])
	world.apply_states()
	world.set_image(world.film_picture, world.reference_full if world.switches.film else world.reference_crop)
	var saved_pose: Array = archive.data.position.duplicate()
	var saved_yaw := float(archive.data.yaw)
	var saved_pitch := float(archive.data.pitch)
	started = true
	sitting = false
	visitor.movement_locked = false
	travel(zone)
	if restore:
		var at: Array = saved_pose
		if at.size() == 3:
			var position_saved := Vector3(float(at[0]), float(at[1]), float(at[2]))
			if position_saved.is_finite() and position_saved.length() < 200:
				visitor.place(position_saved, saved_yaw)
				visitor.camera.rotation.x = clampf(saved_pitch, -1.35, 1.35)
	refresh_collection()
	close_ui()
	ui.toast("C · photographier     Tab · carnet")

func travel(destination: String, at: Vector3 = Vector3.INF, yaw: float = 0) -> void:
	if at == Vector3.INF:
		match destination:
			"hall": at = Vector3(0, 0.05, 5)
			"city": at = World.CITY + Vector3(10.9, 0.05, 17.5)
			"greenhouse": at = World.GREEN + Vector3(7.2, 0.05, 9)
			"backstage": at = World.CITY + Vector3(7, 4.25, 23)
	zone = destination
	visitor.place(at, yaw)
	sound.rain_level = 1.0 if zone == "city" else 0.0
	if zone not in archive.data.places: archive.data.places.append(zone)
	if started: save_visit()

func save_visit() -> bool:
	if not started: return true
	if is_instance_valid(notes_editor): archive.data.notes = notes_editor.text
	archive.data.zone = zone
	var point := stood_at if sitting else visitor.position
	archive.data.position = [point.x, point.y, point.z]
	archive.data.yaw = visitor.rotation.y
	archive.data.pitch = visitor.camera.rotation.x
	archive.data.states = world.switches.duplicate()
	var result := archive.save()
	if not result: ui.toast(archive.last_error)
	return result

func on_action(id: String) -> void:
	if busy: return
	if id.begins_with("volume:"):
		volume = float(id.trim_prefix("volume:"))
		AudioServer.set_bus_volume_db(0, linear_to_db(maxf(volume / 100, 0.0001)))
		save_settings()
		return
	if id.begins_with("sensitivity:"):
		sensitivity = float(id.trim_prefix("sensitivity:"))
		visitor.sensitivity = sensitivity * 0.000044
		save_settings()
		return
	if id.begins_with("document:"):
		show_document(id.trim_prefix("document:"))
		return
	match id:
		"new":
			if archive.exists() and not test_mode:
				ui.document("Recommencer ?", "La visite sauvegardée sera remplacée. Les fichiers des anciennes photographies resteront sur le disque.", null, [["Recommencer", "reset"], ["Annuler", "menu"]])
			else: start_visit()
		"reset": start_visit()
		"menu": ui.menu(archive.exists())
		"continue": start_visit(true)
		"close": close_ui()
		"quit":
			if not save_visit(): return
			sound.shutdown()
			get_tree().quit()
		"photos": notebook()
		"documents":
			var titles := {}
			for key in DOCUMENTS: titles[key] = DOCUMENTS[key][0]
			ui.documents(archive.data.documents, titles)
		"notes": notes_editor = ui.notes(str(archive.data.notes))
		"map": map_view()
		"previous", "next":
			if not archive.data.photos.is_empty(): photo_index = posmod(photo_index + (-1 if id == "previous" else 1), archive.data.photos.size())
			notebook()
		"compare_reference":
			comparison_reference = current_reference
			notebook()
		"pin":
			if comparison_reference != null:
				comparison_reference = null
				pinned = -1
			else: pinned = photo_index if pinned < 0 else -1
			notebook()
		"reserve_photo":
			if archive.reserve_photo(photo_index):
				refresh_collection()
				notebook()
				ui.toast("Photographie retenue. Le choix reste modifiable.")
			else: ui.toast(archive.last_error)
		"slide_box":
			world.toggle("slide")
			save_visit()
			close_ui()
		"reserve_object":
			if OBJECTS.has(selected):
				if not archive.reserve_object(OBJECTS[selected], selected):
					ui.toast(archive.last_error)
					return
				refresh_collection()
				close_ui()
				ui.toast("Objet réservé. Il reste ici, utilisable.")
		"film_full":
			world.switches.film = true
			world.set_image(world.film_picture, world.reference_full)
			save_visit()
			show_film()
		"film_crop":
			world.switches.film = false
			world.set_image(world.film_picture, world.reference_crop)
			save_visit()
			show_film()
		"film_negative":
			var source := world.reference_full.get_image() if world.reference_full else null
			if source:
				source.convert(Image.FORMAT_RGB8)
				for y in range(source.get_height()):
					for x in range(source.get_width()):
						var pixel := source.get_pixel(x, y)
						source.set_pixel(x, y, Color(1 - pixel.r, 1 - pixel.g, 1 - pixel.b))
				ui.document("Bande 06 · Négatif", "17 juin", ImageTexture.create_from_image(source), [["Inverser les valeurs", "film_full"]])

func interact(id: String) -> void:
	if busy or id.is_empty(): return
	match id:
		"to_city": travel("city")
		"to_greenhouse": travel("greenhouse")
		"city_hall": travel("hall", Vector3(5.8, 0.05, -3), PI / 2)
		"green_hall": travel("hall", Vector3(-5.8, 0.05, -3), -PI / 2)
		"backstage": travel("backstage")
		"backstage_city": travel("city", World.CITY + Vector3(7, 4.25, 17.5), PI)
		"backstage_green", "green_backstage":
			if id == "backstage_green": travel("greenhouse", World.GREEN + Vector3(-7.2, 0.05, 9))
			else: travel("backstage", World.CITY + Vector3(-7, 4.25, 25.5), PI)
		"city_light", "city_low_light", "green_light", "curtain", "lamp", "slide", "window":
			world.toggle(id)
			save_visit()
		"enlarger":
			archive.record("film")
			lock_player()
			show_film()
		"sit":
			if sitting:
				visitor.place(stood_at)
				visitor.camera.position.y = 1.64
				sitting = false
				visitor.movement_locked = false
				visitor.enabled = true
				visitor.walk_speed = 3.4
			else:
				stood_at = visitor.position
				visitor.place(World.GREEN + Vector3(-1.5, 0.02, 6))
				visitor.camera.position.y = 1.1
				visitor.camera.look_at(World.GREEN + Vector3(-9.7, 2.0, 5.5))
				sitting = true
				visitor.movement_locked = true
				visitor.enabled = true
				visitor.walk_speed = 0
			ui.toast("E · se relever")
		"alcove_city", "alcove_greenhouse":
			var target_zone := id.trim_prefix("alcove_")
			var object_id: String = archive.data.objects.get(target_zone, "")
			var index: int = int(archive.data.chosen_photos.get(target_zone, -1))
			lock_player()
			ui.document("", DOCUMENTS[object_id][0] if not object_id.is_empty() else "—", archive.texture(index), [["Ouvrir le carnet", "photos"]])
		_:
			if DOCUMENTS.has(id): show_document(id)

func show_document(id: String) -> void:
	selected = id
	archive.record(id)
	lock_player()
	var image: Texture2D = null
	if id in ["print", "object_print"]: image = world.reference_crop
	if id == "contacts": image = contact_photo
	if id == "object_lou": image = object_photo
	if id == "album": image = album_photo
	current_reference = image
	var options: Array = []
	if image: options.append(["Comparer à mes vues", "compare_reference"])
	if OBJECTS.has(id): options.append(["Réserver pour l’alcôve", "reserve_object"])
	if id == "object_box": options.append(["Faire glisser le cylindre", "slide_box"])
	ui.document(DOCUMENTS[id][0], DOCUMENTS[id][1], image, options)

func show_film() -> void:
	ui.document("17 / 06 · Agrandisseur", "", world.reference_full if world.switches.film else world.reference_crop, [["Remettre les caches" if world.switches.film else "Écarter les caches", "film_crop" if world.switches.film else "film_full"], ["Voir le négatif", "film_negative"]])

func notebook() -> void:
	lock_player()
	photo_index = clampi(photo_index, 0, maxi(0, archive.data.photos.size() - 1))
	ui.notebook(archive, photo_index, pinned, comparison_reference)

func map_view() -> void:
	lock_player()
	var words := ""
	if "city" in archive.data.places: words += "COUR\nNord : terrasse · rampe ouest → palier\nSud : fenêtre · rampe est → étage\nLaboratoire : sous le palier nord-ouest\n\n"
	if "greenhouse" in archive.data.places: words += "SERRES\nJardin · chambre\n\n"
	if "backstage" in archive.data.places: words += "SERVICE\nÉtage de la cour ↔ chambre des serres\n\n"
	if words.is_empty(): words = "Galerie\nDeux passages ouverts."
	ui.document("Plan", words, null, [["Carnet", "photos"]])

func take_photo() -> void:
	if busy: return
	busy = true
	var enabled := visitor.enabled
	visitor.enabled = false
	ui.hide()
	await RenderingServer.frame_post_draw
	var image := get_viewport().get_texture().get_image()
	ui.show()
	var index := archive.photograph(image, zone)
	if index >= 0:
		photo_index = index
		ui.toast("Vue %02d gardée · Tab pour la retrouver" % (index + 1))
	else: ui.toast(archive.last_error)
	visitor.enabled = enabled
	busy = false

func refresh_collection() -> void:
	for room in ["city", "greenhouse"]:
		var slot: Dictionary = world.alcoves[room]
		var object_id: String = archive.data.objects.get(room, "")
		slot.label.text = DOCUMENTS[object_id][0] if not object_id.is_empty() else "—"
		var index: int = int(archive.data.chosen_photos.get(room, -1))
		world.set_image(slot.image, archive.texture(index))
		# The small catalogue card is a view of the object; no usable duplicate.
		if slot.has("card"): slot.card.queue_free()
		if not object_id.is_empty():
			var x := 3.6 if room == "city" else -3.6
			var card := Node3D.new()
			world.add_child(card)
			card.position = Vector3(x, 1.06, -5.4)
			Forms.box(card, Vector3.ZERO, Vector3(0.7, 0.03, 0.48), world.mats.paper)
			# Distinct pictograms on paper, never presented as photographic evidence.
			if object_id == "object_box": Forms.box(card, Vector3(0, 0.02, 0), Vector3(0.24, 0.02, 0.22), world.mats.wood)
			elif object_id == "object_cup": Forms.cylinder(card, Vector3(0, 0.025, 0), 0.13, 0.012, world.mats.blue)
			else:
				for i in range(3): Forms.box(card, Vector3(0, 0.023, -0.12 + 0.11 * i), Vector3(0.44 - i * 0.09, 0.008, 0.04), world.mats.blue if room == "city" else world.mats.green)
			slot.card = card

func save_settings() -> void:
	if test_mode: return
	var cfg := ConfigFile.new()
	cfg.set_value("comfort", "volume", volume)
	cfg.set_value("comfort", "sensitivity", sensitivity)
	cfg.save("user://inquiry-settings.cfg")

func load_settings() -> void:
	var cfg := ConfigFile.new()
	if not test_mode: cfg.load("user://inquiry-settings.cfg")
	volume = float(cfg.get_value("comfort", "volume", 65))
	sensitivity = float(cfg.get_value("comfort", "sensitivity", 50))
	AudioServer.set_bus_volume_db(0, linear_to_db(maxf(volume / 100, 0.0001)))
	visitor.sensitivity = sensitivity * 0.000044

func prepare_evidence() -> void:
	busy = true
	var viewport := SubViewport.new()
	viewport.size = Vector2i(1280, 800)
	viewport.world_3d = get_world_3d()
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(viewport)
	var camera := Camera3D.new()
	viewport.add_child(camera)
	camera.fov = 64
	camera.position = World.CITY + World.VIEWS.south_high
	camera.look_at(World.CITY + Vector3(-1.0, 2.8, -0.5))
	world.history.visible = true
	world.update_mirrors(camera, "city")
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	var source := viewport.get_texture().get_image()
	world.reference_full = ImageTexture.create_from_image(source)
	# A genuine crop of the same exposure: no landmarks painted into the evidence.
	var crop := source.get_region(Rect2i(70, 140, 675, 520))
	world.reference_crop = ImageTexture.create_from_image(crop)
	world.history.visible = false
	world.set_image(world.reference_picture, world.reference_crop)
	world.set_image(world.film_picture, world.reference_crop)
	# Other archival photographs use the same scene, its light and its objects.
	var old_states := world.switches.duplicate()
	world.switches.curtain = true
	world.switches.lamp = true
	world.apply_states()
	camera.position = World.GREEN + Vector3(-1.5, 1.2, 6)
	camera.look_at(World.GREEN + Vector3(-9.7, 2.0, 5.5))
	world.update_mirrors(camera, "greenhouse")
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	album_photo = ImageTexture.create_from_image(viewport.get_texture().get_image())
	world.switches = old_states
	world.apply_states()
	# Lou's quiet portrait is staged for a historical exposure, then removed.
	var lou := Node3D.new()
	world.add_child(lou)
	lou.position = World.CITY
	world.person(lou, Vector3(5, 4.2, 15), "rose")
	camera.position = World.CITY + Vector3(2, 5.6, 14.4)
	camera.look_at(World.CITY + Vector3(5, 5.3, 15))
	await RenderingServer.frame_post_draw
	object_photo = ImageTexture.create_from_image(viewport.get_texture().get_image())
	lou.queue_free()
	await get_tree().process_frame
	lou = Node3D.new()
	world.add_child(lou)
	lou.position = World.CITY
	world.person(lou, Vector3(0, 4.2, 15.2), "rose")
	Forms.box(lou, Vector3(0, 5.5, 14.98), Vector3(0.36, 0.24, 0.16), world.mats.dark)
	var lens := Forms.cylinder(lou, Vector3(0, 5.5, 14.84), 0.09, 0.14, world.mats.copper)
	lens.rotation.x = PI / 2
	camera.position = World.CITY + Vector3(0, 5.8, 14)
	camera.look_at(World.CITY + Vector3(0, 5.3, 12))
	world.update_mirrors(camera, "city")
	for mirror in world.mirrors:
		if mirror.id == "city": mirror.material.set_shader_parameter("strength", 0.55)
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	contact_photo = ImageTexture.create_from_image(viewport.get_texture().get_image())
	lou.queue_free()
	viewport.queue_free()
	evidence_ready = true
	busy = false

func run_smoke(graphics: bool) -> void:
	var runner := preload("res://tests/inquiry.gd").new()
	add_child(runner)
	await runner.run(self, graphics)

func capture(view: String) -> void:
	while not evidence_ready: await get_tree().process_frame
	start_visit()
	match view:
		"city":
			travel("city", World.CITY + Vector3(10, 0.05, 9))
			visitor.camera.look_at(World.CITY + Vector3(-3, 2.7, -3))
		"lou":
			travel("city", World.CITY + Vector3(7, 4.25, 17))
			visitor.camera.look_at(World.CITY + Vector3(-3, 5.4, 13))
		"greenhouse":
			travel("greenhouse", World.GREEN + Vector3(7, 0.05, 8))
			visitor.camera.look_at(World.GREEN + Vector3(-2, 1.5, -4))
		"projection":
			travel("greenhouse", World.GREEN + Vector3(-1.5, 0.05, 6))
			world.switches.curtain = true
			world.switches.lamp = true
			world.apply_states()
			visitor.camera.look_at(World.GREEN + Vector3(-9.7, 2, 5.5))
		"print": show_document("print")
		"contacts": show_document("contacts")
		"film":
			lock_player()
			world.switches.film = true
			show_film()
	visitor.enabled = false
	await get_tree().create_timer(0.8).timeout
	await RenderingServer.frame_post_draw
	var path := ProjectSettings.globalize_path("res://../artifacts/inquiry-%s.png" % view)
	get_viewport().get_texture().get_image().save_png(path)
	print("CAPTURE: " + path)
	sound.shutdown()
	get_tree().quit()
