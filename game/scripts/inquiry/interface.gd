class_name InquiryInterface
extends CanvasLayer
signal action(id: String)
var root: Control
var overlay: Control
var content: VBoxContainer
var prompt: Label
var message: Label
var crosshair: Label
var caption: Label
var hint: Label
var current := ""
var toast_time := 0.0

func _ready() -> void:
	root = Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)
	var theme := Theme.new()
	theme.default_font = Forms.sans
	theme.default_font_size = 19
	var blank := StyleBoxEmpty.new()
	for type in ["normal", "hover", "pressed", "focus", "disabled"]: theme.set_stylebox(type, "Button", blank)
	theme.set_color("font_color", "Button", Color("c3c3b6"))
	theme.set_color("font_hover_color", "Button", Color("ffffff"))
	theme.set_color("font_focus_color", "Button", Color("ffdaa0"))
	theme.set_constant("outline_size", "Label", 4)
	theme.set_color("font_outline_color", "Label", Color(0.05, 0.08, 0.1, 0.7))
	root.theme = theme
	crosshair = text(root, "·", 26)
	crosshair.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	crosshair.offset_left = -5
	crosshair.offset_top = -14
	prompt = text(root, "", 19)
	prompt.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)
	prompt.offset_left = -350
	prompt.offset_top = -104
	prompt.size = Vector2(700, 34)
	prompt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint = text(root, "ZQSD / WASD · marcher     Souris · regarder     E · agir\nC · photographier     Tab · carnet     Échap · pause", 15)
	hint.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	hint.offset_left = 30
	hint.offset_top = -66
	hint.modulate = Color("bcc4c3")
	message = text(root, "", 19)
	message.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
	message.offset_left = -400
	message.offset_top = 32
	message.size = Vector2(800, 40)
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	caption = text(root, "", 16)
	caption.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	caption.position = Vector2(28, 26)
	caption.modulate = Color("c6c9c4")

func text(parent: Node, words: String, size: int = 20) -> Label:
	var label := Label.new()
	label.text = words
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", Color("eee2c9"))
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(label)
	return label

func _process(delta: float) -> void:
	toast_time -= delta
	message.visible = toast_time > 0

func toast(words: String) -> void:
	message.text = words
	toast_time = 3.2
	message.move_to_front()

func clear() -> void:
	if is_instance_valid(overlay):
		overlay.queue_free()
		overlay = null
	current = ""
	prompt.text = ""
	crosshair.visible = true
	hint.visible = true
	caption.visible = true

func sheet(id: String, title: String) -> VBoxContainer:
	clear()
	current = id
	crosshair.visible = false
	hint.visible = false
	caption.visible = false
	overlay = ColorRect.new()
	overlay.color = Color(0.035, 0.055, 0.075, 0.94)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_child(overlay)
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for edge in ["left", "right"]: margin.add_theme_constant_override("margin_" + edge, 48)
	for edge in ["top", "bottom"]: margin.add_theme_constant_override("margin_" + edge, 30)
	overlay.add_child(margin)
	content = VBoxContainer.new()
	content.add_theme_constant_override("separation", 18)
	margin.add_child(content)
	var title_label := text(content, title, 38)
	title_label.add_theme_font_override("font", Forms.serif)
	var line := HSeparator.new()
	line.modulate = Color(0.6, 0.65, 0.65, 0.4)
	content.add_child(line)
	return content

func button(parent: Node, words: String, id: String) -> Button:
	var result := Button.new()
	result.text = words
	result.alignment = HORIZONTAL_ALIGNMENT_LEFT
	result.custom_minimum_size.y = 36
	result.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	parent.add_child(result)
	result.pressed.connect(func(): action.emit(id))
	return result

func spacer(parent: Node) -> Control:
	var node := Control.new()
	node.size_flags_vertical = Control.SIZE_EXPAND_FILL
	parent.add_child(node)
	return node

func row(parent: Node) -> HBoxContainer:
	var box := HBoxContainer.new()
	box.add_theme_constant_override("separation", 28)
	parent.add_child(box)
	return box

func picture(parent: Node, texture: Texture2D) -> TextureRect:
	var image := TextureRect.new()
	image.texture = texture
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	image.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	image.size_flags_vertical = Control.SIZE_EXPAND_FILL
	image.custom_minimum_size = Vector2(100, 100)
	parent.add_child(image)
	return image

func menu(has_save: bool) -> void:
	var body := sheet("menu", "U N L I V E D")
	overlay.color.a = 0.36
	spacer(body)
	if has_save: button(body, "Continuer", "continue").grab_focus()
	var enter := button(body, "Entrer" if not has_save else "Nouvelle visite", "new")
	if not has_save: enter.grab_focus()
	button(body, "Quitter", "quit")

func pause(volume: float, sensitivity: float) -> void:
	var body := sheet("pause", "Pause")
	button(body, "Reprendre", "close").grab_focus()
	text(body, "Déplacement : ZQSD / WASD ou flèches     •     Souris : regard     •     E : agir", 17).autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text(body, "C : photographie sans interface     •     Tab : carnet     •     M : plan     •     F11 : plein écran", 17).autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	for entry in [{"label": "Son", "id": "volume", "value": volume, "max": 100.0}, {"label": "Sensibilité du regard", "id": "sensitivity", "value": sensitivity, "max": 100.0}]:
		text(body, entry.label, 18)
		var slider := HSlider.new()
		slider.max_value = entry.max
		slider.min_value = 0 if entry.id == "volume" else 10
		slider.value = entry.value
		slider.custom_minimum_size = Vector2(280, 24)
		slider.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		body.add_child(slider)
		slider.value_changed.connect(func(value): action.emit(entry.id + ":" + str(value)))
	spacer(body)
	button(body, "Sauvegarder et quitter", "quit")

func document(title: String, words: String, texture: Texture2D = null, options: Array = []) -> void:
	var body := sheet("document", title)
	if texture: picture(body, texture)
	var copy := text(body, words, 21)
	copy.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if not texture: spacer(body)
	var controls := row(body)
	for entry in options: button(controls, entry[0], entry[1])
	button(controls, "Fermer · Échap", "close")

func notebook(archive: InquiryArchive, index: int, pinned: int, reference: Texture2D = null) -> void:
	var body := sheet("notebook", "Carnet")
	var tabs := row(body)
	button(tabs, "Photographies", "photos")
	button(tabs, "Documents", "documents")
	button(tabs, "Notes", "notes")
	button(tabs, "Plan", "map")
	var photos: Array = archive.data.photos
	if photos.is_empty():
		spacer(body)
		text(body, "Aucune photographie.\nC pour garder une vue, où que vous soyez.", 22)
		spacer(body)
	else:
		var images := row(body)
		images.size_flags_vertical = Control.SIZE_EXPAND_FILL
		picture(images, archive.texture(index))
		if reference: picture(images, reference)
		elif pinned >= 0 and pinned < photos.size(): picture(images, archive.texture(pinned))
		var title := "%d / %d   ·   %s" % [index + 1, photos.size(), {"hall": "Galerie", "city": "Ville", "greenhouse": "Serres"}.get(photos[index].zone, "Service")]
		if archive.data.chosen_photos.get(photos[index].zone, -1) == index: title += "   ·   Retenue"
		text(body, title, 17)
		var nav := row(body)
		button(nav, "← Précédente", "previous")
		button(nav, "Suivante →", "next")
		button(nav, "Comparer" if pinned < 0 and reference == null else "Détacher", "pin")
		if photos[index].zone in ["city", "greenhouse"]: button(nav, "Retenir pour l’alcôve", "reserve_photo")
	button(body, "Refermer · Tab / Échap", "close")

func documents(ids: Array, titles: Dictionary) -> void:
	var body := sheet("documents", "Documents")
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_child(scroll)
	var list := VBoxContainer.new()
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(list)
	if ids.is_empty(): text(list, "Les documents consultés restent ici.")
	for id in ids: button(list, titles.get(id, id), "document:" + id)
	button(body, "Photographies", "photos")
	button(body, "Refermer · Échap", "close")

func notes(words: String) -> TextEdit:
	var body := sheet("notes", "Notes")
	var editor := TextEdit.new()
	editor.text = words
	editor.placeholder_text = "Une adresse, un détail à revoir…"
	editor.size_flags_vertical = Control.SIZE_EXPAND_FILL
	editor.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	body.add_child(editor)
	button(body, "Garder et refermer", "close")
	return editor
