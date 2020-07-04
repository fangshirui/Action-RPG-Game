extends Node

export var MAX_HEALTH = 100
var health setget health_update

func _ready() -> void:
	health = MAX_HEALTH

func health_update(value):
	health = value
	pass
