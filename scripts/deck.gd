extends Node
class_name Deck

var cards: Array[int] = [] # 0..39 where value = (id % 10) + 1, suit = id / 10

func build():
	cards.clear()
	for i in 40:
		cards.append(i)

func shuffle():
	randomize()
	cards.shuffle()

static func value_of(card_id: int) -> int:
	return (card_id % 10) + 1

func deal(num_players: int = 4, cards_per_player: int = 10) -> Array:
	var hands := []
	for p in num_players:
		hands.append([])
	var idx := 0
	for i in num_players * cards_per_player:
		hands[i % num_players].append(cards[idx])
		idx += 1
	cards = cards.slice(idx)
	return hands
	
func split(index: int):
	split_and_swap_in_place(cards, index)


# returns a NEW array with the two halves swapped
func split_and_swap(arr: Array, idx: int) -> Array:
	var size := arr.size()
	if size == 0:
		return []
	# support negative indices (optional). -1 means split before last element.
	if idx < 0:
		idx = max(0, size + idx)
	# clamp to valid range [0, size]
	idx = clamp(idx, 0, size)

	var left := []
	var right := []
	for i in range(size):
		if i < idx:
			left.append(arr[i])
		else:
			right.append(arr[i])

	var result := []
	result.append_array(right)
	result.append_array(left)
	return result


# mutate the given array in-place to swap halves
func split_and_swap_in_place(arr: Array, idx: int) -> void:
	var swapped := split_and_swap(arr, idx)
	arr.clear()
	arr.append_array(swapped)
