extends Node

@export var camera: Camera2D
@export var cards: Array[Node2D]

var viewport_rect: Rect2
var players_position: Array[Vector2]


# angle normalization
func normalize(a: float) -> float:
	var res = fmod(a + TAU, TAU)
	return res
	
func place_cards_row(player_index: int, start: Vector2, end: Vector2):
	var delta := (end - start) / 9
	for i in range(10):
		cards[(10 * player_index) + i].position = start + (delta * i)

func _ready() -> void:
	viewport_rect = camera.get_viewport_rect()
	print(viewport_rect.size.x)
	var half_w = viewport_rect.size.x / 2
	var half_h = viewport_rect.size.y / 2
	var distance_from_border = (0.1 * viewport_rect.size.x)
	# p0 = [0, -(h/2) + (0.1 * w)]
	players_position.append(Vector2(0, -half_h + distance_from_border))
	# p1 = [(w/2) - (0.1 * w), 0]
	players_position.append(Vector2(half_w - distance_from_border, 0))
	# p2 = [0, (h/2) - (0.1 * w)]
	players_position.append(Vector2(0, half_h - distance_from_border))
	# p3 = [- (w/2) + (0.1 * w), 0]
	players_position.append(Vector2(- half_w + distance_from_border, 0))
	
	var spread = Vector2(100, 20)
	
	place_cards_row(0, players_position[0] - Vector2(spread.x, 0), players_position[0] + Vector2(spread.x, 0))
	place_cards_row(1, players_position[1] - Vector2(0, spread.x), players_position[1] + Vector2(0, spread.x))
	place_cards_row(2, players_position[2] + Vector2(spread.x, 0), players_position[2] - Vector2(spread.x, 0))
	place_cards_row(3, players_position[3] + Vector2(0, spread.x), players_position[3] - Vector2(0, spread.x))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
