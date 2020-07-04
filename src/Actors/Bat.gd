extends KinematicBody2D

var hp = 15
var alive = true
var velocity = Vector2.ZERO
onready var hit_effects = $HitEffects

enum {
	IDLE,
	WANDER,
	CHASE,
	DIED,
}


var state = IDLE



func _ready() -> void:
	$AnimatedSprite.playing = true
	


func _physics_process(delta: float) -> void:
	if alive == false:
		state = DIED

	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, delta * 200)

			if $PlayerDetector.target != null:
				state = WANDER
			pass
		
		WANDER:
#			print("进入巡航模式")
			if $PlayerDetector.target == null:
				state = IDLE
				return
			var direction = $BodyShape.global_position.direction_to($PlayerDetector.target.global_position)
#			print(direction)
			velocity = velocity.move_toward(direction * 50, 1000 * delta)
#			print("蝙蝠速度为:",velocity)

			
		
		CHASE:
			pass
		DIED:
			died()
			
	if velocity.x > 0:
		$AnimatedSprite.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite.flip_h = true
		
	velocity = move_and_slide(velocity)


# warning-ignore:unused_argument
func _on_BodyShape_area_entered(area: Area2D) -> void:
	if not alive:
		return 
	velocity =  area.knock_vector * 120
	hp -= 5
#	$Audio/Hit.play()


	hit_effects.play_hit_animation()


	if hp <= 0:
		alive = false


func died():
	
	$CollisionShape2D.disabled = true 
	
	velocity = Vector2.ZERO
	
	SoundManager.play_se("died")
	$AnimatedSprite.play("died")
	yield($AnimatedSprite,"animation_finished")

	queue_free()

