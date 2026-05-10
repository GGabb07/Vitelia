extends Area2D

@onready var player: CharacterBody2D = %Player
@onready var objects: TileMapLayer = $".."

func _on_body_entered(body: Node2D) -> void:
	print("Ciao")
	objects.set_cell((get_child(0) as Node2D).position / 16, 3, Vector2i(0, 0))

func _on_body_exited(body: Node2D) -> void:
	objects.set_cell((get_child(0) as Node2D).position / 16, 2, Vector2i(1, 0))
	print("NOOOO")
