extends KinematicBody2D


export var max_velocity = 100 # 影响最大速度，150像素位移每秒
export var friction_cof = 2000  # 影响减速效果
export var acc_cof  = 2000  # 加速度系数，影响加速度效果


onready var state_machine = $AnimationTree.get("parameters/playback")

onready var player_stat = $Stat

enum {
	IDLE,
	MOVE,
	ROLL,
	ATTACK
}


enum {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

var state = IDLE
var direction = RIGHT


var velocity = Vector2.ZERO   # 每秒位移像素个数   pixls / s 
var input_vector = Vector2.ZERO   # 输入方向    



onready var stick = $HUD/Joystick



func _ready() -> void:
	$Sword/CollisionShape2D.disabled = true
	$AnimationTree.active = true



func _physics_process(delta: float) -> void:


	var current_state = state_machine.get_current_node()
#	print(current_state)
	$Label.text = current_state

	get_input()
	
	judge_direction()
	
	match state :
		IDLE:
			idle_state(delta)
			
			# 有方向输入且目前当前动画属于idle状态
			if input_vector.length() >0 and current_state.find("idle") != -1: 
				state = MOVE

			# 按了一下攻击键（长按识别为按一下）
			if Input.is_action_just_pressed("attack"):
				state = ATTACK
		MOVE:
			move_state(delta)
			
			if Input.is_action_just_pressed("roll") and input_vector.length() > 0:
				# 赋予一个翻滚的初速度，为三倍正常速度
				velocity = max_velocity * input_vector * 4
				state = ROLL
				
			# 按了一下攻击键（长按识别为按一下）
			if Input.is_action_just_pressed("attack"):
				state = ATTACK
				
			# 速度为0 且不按键才会进入idle,这是避免撞墙时速度为0 而误入idle模式
			if velocity.length() == 0 and input_vector.length() == 0:
				state = IDLE
		ROLL:
			roll_state(delta)
			if velocity.length() == 0 :
				state = IDLE
		ATTACK:
			attack_state(delta)
			if velocity.length() == 0:
				state = IDLE

			
	

	
func idle_state(delta : float):
	

	
	velocity = velocity.move_toward(Vector2.ZERO, delta * friction_cof)

	match direction:
		UP:
#					$AnimationPlayer.play("idle_up")
			state_machine.travel("idle_up")
		DOWN:
#					$AnimationPlayer.play("idle_down")
			state_machine.travel("idle_down")

		LEFT:
			state_machine.travel("idle_left")
#					$AnimationPlayer.play("idle_left")
		RIGHT:
			state_machine.travel("idle_right")




func move_state(delta: float):

	match direction:
		UP:
			state_machine.travel("run_up")
#				$AnimationPlayer.play("run_up")
		DOWN:
			state_machine.travel("run_down")
#				$AnimationPlayer.play("run_down")
		LEFT:
			state_machine.travel("run_left")
#				$AnimationPlayer.play("run_left")
		RIGHT:
			state_machine.travel("run_right")
#				$AnimationPlayer.play("run_right")
	
	
	velocity = velocity.move_toward(max_velocity * input_vector , delta * acc_cof)	

	velocity = move_and_slide(velocity)
	

#	print(velocity)


# warning-ignore:unused_argument
func attack_state(delta : float):

	# 攻击前如果有速度，会使得攻击时有小幅前移，否则攻击时不能移动
#	velocity = velocity.move_toward(Vector2.ZERO, delta * friction_cof* 0.1)
	velocity = Vector2.ZERO
	
#	print("攻击")
#	velocity = Vector2.ZERO

	match direction:
		UP:
			state_machine.travel("attack_up")
#			$AnimationPlayer.play("attack_up")
		DOWN:
			state_machine.travel("attack_down")
#			$AnimationPlayer.play("attack_down")
			
		LEFT:
			state_machine.travel("attack_left")
#			$AnimationPlayer.play("attack_left")
		RIGHT:
			state_machine.travel("attack_right")			
#			$AnimationPlayer.play("attack_right")
			
			
	velocity = move_and_slide(velocity)



func roll_state(delta):


	# 赋予翻滚时的减速度,为地面的0.5倍
	velocity = velocity.move_toward(Vector2.ZERO, delta * friction_cof * 0.5)
	
	match direction:
		UP:
			state_machine.travel("roll_up")
	#			$AnimationPlayer.play("attack_up")
		DOWN:
			state_machine.travel("roll_down")
	#			$AnimationPlayer.play("attack_down")
			
		LEFT:
			state_machine.travel("roll_left")
	#			$AnimationPlayer.play("attack_left")
			
		RIGHT:
			state_machine.travel("roll_right")			
	#			$AnimationPlayer.play("attack_right")
	
	
	
	velocity = move_and_slide(velocity)




func get_input():
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") 
	
	if stick.is_working :
		input_vector = stick.output
	
	input_vector = input_vector.normalized()
	

func judge_direction():
	if input_vector.x > 0:
		if input_vector.x >= abs(input_vector.y):
			direction = RIGHT
		elif input_vector.y > 0:
			direction = DOWN
		else:
			direction = UP
	
	if input_vector.x < 0:
		if -input_vector.x >= abs(input_vector.y):
			direction = LEFT
		elif input_vector.y > 0:
			direction = DOWN
		else:
			direction = UP

	if input_vector.x == 0:
		if input_vector.y > 0:
			direction = DOWN
		if input_vector.y < 0:
			direction = UP



# 受到攻击
func _on_PlayerHurtBox_area_entered(area: Area2D) -> void:
#	print(area.name)
	player_stat.health -=10
	$HitEffects.play_hit_animation()
