extends Node
class_name InputManager

@export var camera: Camera2D
@export var card_manager: CardManager

var dragging_card: Node2D = null

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			# convert touch screen position to world position
			var world_position = camera.get_canvas_transform().affine_inverse() * event.position
			print(event.position, " -> ", world_position)
			var cards = card_manager.get_player_cards_at_position(world_position)
			if cards.size() > 0:
				# get card with highest z_index
				dragging_card = cards[0]
				for card in cards:
					if card.z_index > dragging_card.z_index:
						dragging_card = card
				# notify card manager that the card is grabbed
				card_manager.card_grabbed(dragging_card)
		else:
			# print("Screen touch released at: ", event.position)
			card_manager.card_released(dragging_card)
			dragging_card = null
			pass

	elif event is InputEventScreenDrag:
		# print("Screen dragged to: ", event.position, event)
		if dragging_card != null:
			var world_position = camera.get_canvas_transform().affine_inverse() * event.position
			dragging_card.position = world_position
		pass
