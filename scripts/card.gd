extends Node2D

var has_reached_position = false
var has_reached_rotation = false
var target_position = Vector2()
var target_rotation = 0
var speed_movement = 5
var speed_rotation = 3
var treshold = 0.1

var card: int = -1:
	set(c):
		update_sprite(c)
		card = c

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if !has_reached_position:
		position = position.lerp(target_position, delta * speed_movement)
		if position.distance_to(target_position) < treshold:
			has_reached_position = true
			position = target_position
	if !has_reached_rotation:
		rotation_degrees = lerpf(rotation_degrees, target_rotation, delta * speed_rotation)
		if abs(rotation_degrees - target_rotation) < treshold:
			has_reached_rotation = true
			rotation_degrees = target_rotation

func update_sprite(card: int):
	var card_value = Deck.value_of(card) - 1
	var card_seed = card / 10
	var x = (card_value * 16) + (1 * card_value) 
	var y = (card_seed * 16) + (1 * card_seed)
	# set default values for covered card
	if card == -1:
		x = 119
		y = 68
	$Sprite2D.region_rect = Rect2(x, y, 16, 16)
	
	
