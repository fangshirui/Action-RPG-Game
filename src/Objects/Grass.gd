extends Node2D

signal fun


var hp = 5





func died(_area: Area2D):
	
	if hp <= 0:
		return
	
	hp -= 5
	SoundManager.play_bgm("Swipe.wav")
	$Sprite.visible = false
	$AnimatedSprite.visible = true
	$AnimatedSprite.play("died")
	yield($AnimatedSprite,"animation_finished")
	
	emit_signal("fun")
	
	queue_free()
	


# warning-ignore:unused_argument
func _on_Grass_area_entered(area: Area2D) -> void:
	if hp <= 0:
		return
	
	hp -= 5
	SoundManager.play_se("Swipe.wav")
	$Sprite.visible = false
	$AnimatedSprite.visible = true
	$AnimatedSprite.play("died")
	yield($AnimatedSprite,"animation_finished")
	
	emit_signal("fun")
	
	queue_free()
	pass # Replace with function body.

