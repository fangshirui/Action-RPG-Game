extends Node2D


onready var grass = get_tree().get_nodes_in_group("grass")


func _ready() -> void:
	for i in grass:
		i.connect("fun",self,"_on_Grass_fun")
		


func _on_Grass_fun() -> void:
	print("I'm fun")

