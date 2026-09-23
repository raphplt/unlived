class_name Journey
extends RefCounted
## Session state is independent from the scene and UI. No persistence by design.

enum Phase { HALL, APARTMENT, COMMITTED, RETURNED }
enum Variant { KEEP, LEAVE }
const ITEMS := ["cassette", "photo", "letter"]
var phase: Phase = Phase.HALL
var variant: Variant = Variant.KEEP
var kept := ""
var inspected: Array[String] = []
var notes_played := 0

func enter() -> bool:
	if phase != Phase.HALL:
		return false
	phase = Phase.APARTMENT
	return true

func inspect(item: String) -> void:
	if item in ITEMS and item not in inspected:
		inspected.append(item)

func commit(item: String = "") -> bool:
	if phase != Phase.APARTMENT:
		return false
	if variant == Variant.KEEP and item not in ITEMS:
		return false
	if variant == Variant.LEAVE and not item.is_empty():
		return false
	kept = item
	phase = Phase.COMMITTED
	return true

func return_to_hall() -> bool:
	if phase != Phase.COMMITTED:
		return false
	phase = Phase.RETURNED
	return true

func reset(new_variant: Variant) -> void:
	phase = Phase.HALL
	variant = new_variant
	kept = ""
	inspected.clear()
	notes_played = 0
