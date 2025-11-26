extends Node
class_name GameManager

signal shuffle(player_index: int)
signal split(player_index: int)
signal pick(player_index: int)
signal preference(player_index: int, card: int, preferences: Array)

enum Phase { IDLE, ROUND, END }
var current_phase: Phase = Phase.IDLE

var players: Array[Player] = []
var current_player_index: int = 0
var current_game_turn = 0

var deck := Deck.new()

@export var players_path: NodePath
@export var table_manager: TableManager

func setup_childs():
	if players_path != NodePath():
		var parent := get_node(players_path)
		for child in parent.get_children():
			if child is Player:
				players.append(child)
				shuffle.connect(child._on_shuffle)
				split.connect(child._on_split)
				pick.connect(child._on_pick)
				preference.connect(child._on_preference)
				child.shuffled.connect(_on_player_shuffled)
				child.splitted.connect(_on_player_splitted)
				child.picked.connect(_on_player_picked)
				child.preference.connect(_on_player_preference)

func start_game():
	current_phase = Phase.ROUND
	current_player_index = randi() % 4
	shuffle.emit(current_player_index)

func _ready():
	table_manager.setup_rules(true)
	deck.build()
	setup_childs()
	start_game()
	
func next_player_pick():
	current_player_index = (current_player_index + 1) % 4
	await table_manager.update_turn_indicator(current_player_index)
	current_game_turn += 1
	pick.emit(current_player_index)

func next_turn():
	# check if every card was picked
	if current_game_turn != 40:
		# let next player pick
		next_player_pick()
	else:
		table_manager.complete_last_turn()
		print('game end')

func _on_player_picked(card: int):
	# manage turn
	var preferences: Array = table_manager.preferences(card)
	if preferences.size() <= 1:
		var default_preference: Array = []
		if preferences.size() > 0:
			default_preference = preferences[0]
		await table_manager.play_card(current_player_index, card, default_preference)
		next_turn()
	else:
		# needs to select a preference
		preference.emit(current_player_index, card, preferences)
		
func _on_player_preference(card: int, preference: Array):
	print("player has picked a preference")
	await table_manager.play_card(current_player_index, card, preference)
	next_turn()
	
func _on_player_shuffled():
	print("player has shuffled")
	var previous_player_index = (current_player_index + 3) % 4
	split.emit(previous_player_index)
	
func _on_player_splitted(index: int):
	print("player has splitted")
	deck.split(index)
	
	var dealed_cards = deck.deal()
	for i in range(4):
		var player_index = (current_player_index + 1 + i) % 4
		players[player_index].cards.append_array(dealed_cards[i])
		# print("Player ", i, players[player_index].cards)
	
	# give the cards animation
	await table_manager.give_cards_to_players(players[0].cards)
	
	# let the 1st player pick
	next_player_pick()
