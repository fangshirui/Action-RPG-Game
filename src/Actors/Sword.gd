extends Area2D

var knock_vector = Vector2.RIGHT



func _physics_process(_delta: float) -> void:

	knock_vector = Vector2.DOWN.rotated(rotation)



