extends AnimatedSprite

func play_hit_animation():
	# 这种节点需要指定初始帧。
	SoundManager.play_se("Hit.wav")
	frame = 0
	visible = true
	
	play("hit")
	yield(self,"animation_finished")
	
	visible = false
