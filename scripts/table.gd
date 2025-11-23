extends Node
class_name Table

# keep track of the picked cards by each team
var picked_cards_team_a: Array[int] = []
var picked_cards_team_b: Array[int] = []
# keep track of cards on table
var cards_on_table: Array[int] = []
# keep track of the last team that took a card
var last_took_team_a: bool = false

var compositions_hash = [
	[], # 1
	[], # 2
	{"aa":2}, # 3
	{"ab":2}, # 4
	{"ac":2,"ad":2}, # 5
	{"ae":2,"af":2,"ag":3}, # 6
	{"ah":2,"ai":2,"aj":2,"ak":3}, # 7
	{"al":2,"am":2,"an":2,"ao":3,"ap":3}, # 8
	{"aq":2,"ar":2,"as":2,"at":2,"au":3,"av":3,"aw":3}, # 9
	{"ax":2,"ay":2,"az":2,"ba":2,"bb":3,"bc":3,"bd":3,"be":4}, # 10
]

var hash_lookup_table = {
	"aa":[1,2],"ab":[1,3],"ac":[1,4],"ad":[2,3],
	"ae":[1,5],"af":[2,4],"ag":[1,2,3],"ah":[1,6],
	"ai":[2,5],"aj":[3,4],"ak":[1,2,4],"al":[1,7],
	"am":[2,6],"an":[3,5],"ao":[1,2,5],"ap":[1,3,4],
	"aq":[1,8],"ar":[2,7],"as":[3,6],"at":[4,5],
	"au":[1,2,6],"av":[1,3,5],"aw":[2,3,4],"ax":[1,9],
	"ay":[2,8],"az":[3,7],"ba":[4,6],"bb":[1,2,7],
	"bc":[1,3,6],"bd":[2,3,5],"be":[1,2,3,4],
}

var numbers_hash_lookup_table = [
	["aa","ab","ac","ae","ag","ah","ak","al","ao","ap","aq","au","av","ax","bb","bc","be"], # 1
	["aa","ad","af","ag","ai","ak","am","ao","ar","au","aw","ay","bb","bd","be"], # 2
	["ab","ad","ag","aj","an","ap","as","av","aw","az","bc","bd","be"], # 3
	["ac","af","aj","ak","ap","at","aw","ba","be"], # 4
	["ae","ai","an","ao","at","av","bd"], # 5
	["ah","am","as","au","ba","bc"], # 6
	["al","ar","az","bb"], # 7
	["aq","ay"], # 8
	["ax"], # 9r
	[] #10
]

var aces_takes_all := true

func _ready() -> void:
	pass

func setup_rules(do_aces_takes_all: bool):
	aces_takes_all = do_aces_takes_all

func preferences(card: int):
	var result = []
	var card_value = Deck.value_of(card)
	var instances = compositions_hash[card_value - 1].duplicate()
	
	for c in cards_on_table:
		var c_value = Deck.value_of(c)
		var numbers_hash = numbers_hash_lookup_table[c_value - 1]
		for hash in numbers_hash:
			if instances.has(hash):
				instances[hash] -= 1
				if instances[hash] == 0:
					result.append(hash_lookup_table[hash])
	return result

func add_cards_to_team(player_index: int, cards: Array):
	if player_index % 2 == 0:
		picked_cards_team_a.append_array(cards)
		last_took_team_a = true
	else:
		picked_cards_team_b.append_array(cards)
		last_took_team_a = false

func complete_last_turn():
	# last team that took gets all the cards on table
	if !cards_on_table.is_empty():
		if last_took_team_a:
			picked_cards_team_a.append_array(cards_on_table)
		else:
			picked_cards_team_b.append_array(cards_on_table)
		cards_on_table.clear()
	print_taken_cards()

func print_taken_cards():
	print("team a picked: ", picked_cards_team_a)
	print("team b picked: ", picked_cards_team_b)
	#picked_cards_team_a.append_array(picked_cards_team_b)
	#picked_cards_team_a.sort()
	#print("all: ", picked_cards_team_a)
	
func values_to_table_cards(card_values: Array):
	var result: Array = []
	for card_value in card_values:
		# given a card value return the corresponding card on table
		result.append_array(cards_on_table.filter(func(number): return Deck.value_of(number) == card_value))
	return result

func play_card(player_index: int, card: int, preference: Array = []):
	var card_value = Deck.value_of(card)
	# check if aces takes all
	if aces_takes_all and card_value == 1:
		var picked_cards = cards_on_table.duplicate()
		picked_cards.append(card)
		add_cards_to_team(player_index, picked_cards)
		cards_on_table.clear()
	else:
		for table_card in cards_on_table:
			# check for same card
			if Deck.value_of(table_card) == card_value:
				add_cards_to_team(player_index, [table_card, card])
				cards_on_table.erase(table_card)
				return
			# check for default card combination
			if !preference.is_empty():
				var taken_cards_values = values_to_table_cards(preference)
				for taken_card_value in taken_cards_values:
					cards_on_table.erase(taken_card_value)
				taken_cards_values.append(card)
				add_cards_to_team(player_index, taken_cards_values)
				return
		
		cards_on_table.append(card)
