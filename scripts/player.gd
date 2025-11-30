extends Node
class_name Player

signal picked(card: int)
signal shuffled()
signal splitted(index: int)
signal preference(card: int, preference: Array)

enum PlayerState { WAIT, SHUFFLE, SPLIT, PICK }
var current_state: PlayerState = PlayerState.WAIT
var cards: Array[int] = []
var is_picking: bool = false

@export var player_id: int = 0
@export var display_name: String = "Player"
@export var is_human: bool = false

func _ready():
	pass

func picked_card(card: int) -> void:
	# remove card from available cards
	cards.erase(card)
	is_picking = false
	picked.emit(card)

func _on_pick(player_index: int):
	if (player_index != player_id):
		return
	current_state = PlayerState.PICK

	if is_human:
		is_picking = true
		return  # wait for user input
	# TODO: pick a card!
	var random_card = randi() % cards.size()
	await get_tree().create_timer(0.1).timeout
	# remove card from available cards
	var picked_card = cards.pop_at(random_card)
	
	current_state = PlayerState.WAIT
	picked.emit(picked_card)
	
func _on_preference(player_index: int, card: int, preferences: Array):
	if (player_index != player_id):
		return
		
	# TODO: pick a preference!
	var random_preference = randi() % preferences.size()
	await get_tree().create_timer(0.2).timeout
	preference.emit(card, preferences[random_preference])

func _on_shuffle(player_index: int):
	if (player_index != player_id):
		return
	current_state = PlayerState.SHUFFLE
	# TODO: shuffle the deck!
	await get_tree().create_timer(1).timeout
	
	current_state = PlayerState.WAIT
	shuffled.emit()

func _on_split(player_index: int):
	if (player_index != player_id):
		return
	current_state = PlayerState.SPLIT
	# TODO: split the deck!
	await get_tree().create_timer(1).timeout
	var random_split = randi() % 40
	
	current_state = PlayerState.WAIT
	splitted.emit(random_split)
