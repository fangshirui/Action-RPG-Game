extends Area2D

export var radius = 50
var target =  null

func _ready() -> void:
	var circle = CircleShape2D.new()
	circle.radius = radius
	$CollisionShape2D.shape = circle






func _on_PlayerDetector_body_entered(body: Node) -> void:
	if body.name == "Player":
		target = body


func _on_PlayerDetector_body_exited(body: Node) -> void:
	if body == target:
		target = null
