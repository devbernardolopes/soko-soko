class_name PlayerController
extends EntityController

func get_move_intent() -> Vector2:
	return Input.get_vector("left", "right", "up", "down")
