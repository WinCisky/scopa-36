extends Node2D
"""
Attach this to a Main.tscn root Node2D.
Instantiates 4 Players + GameManager to showcase transitions.
"""

@onready var game_manager := $GameManager

func _ready():
	pass
	# Example manual intervention after 2 seconds: restart round
	# await get_tree().create_timer(2.0).timeout
	# game_manager.start_round()
