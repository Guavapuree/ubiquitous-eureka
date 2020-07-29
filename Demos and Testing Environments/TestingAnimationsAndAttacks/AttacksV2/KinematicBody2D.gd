extends KinematicBody2D

var max_run_speed = 180
var jump_height = -300
var gravity = 10
var acceleration = 20
var direction = "LEFT"

var slow_down = false
var slow_down_amount = 4

var allow_movement = true
var roll_direction = 300
var smooth_roll_speed = 300
var target_roll_speed = 0
const ROLL_TRAVEL_SPEED = 50

var attack_direction = 20
var smooth_attack_speed = 20
var target_attack_speed = 0
const ATTACK_TRAVEL_SPEED = 2



var moving = false
var can_crouch = true
var can_roll = true
var airborn = false

var ground_friction_slide = 0.2
var air_friction_slide = 0.05

var velocity = Vector2()

onready var animation_state = $Sprite/AnimationPlayer/AnimationTree.get("parameters/playback")
var animation_end_state = true

func _ready():
	animation_state.start("1Idle")
	$Sprite/AnimationPlayer/AnimationTree.active = true
	add_to_group("player")

func _process(delta):
	velocity.y += gravity
	var friction = false
#	print(velocity.x)
#	print(velocity.y)
#	print($DelayTillRoll.get_time_left())
#	print($AnimatedSprite.get_frame())
#	print(animation_state.get_current_node())
#	print(smooth_roll_speed)
#	print(smooth_attack_speed)
#	print(velocity.x)
#	print(allow_movement)
#	print(can_roll)
#	print($Sprite.flip_h)
	if $AnimatedSprite.get_frame() == 5:
		$AnimatedSprite.play("Nothing")
### DETERMINE DIRECTION ###
	if $Sprite.flip_h == true:
		attack_direction = 20
		roll_direction = 300
	else:
		attack_direction = -20
		roll_direction = -300
		
	if slow_down == true and allow_movement == false:
		if velocity.x != 0 and $Sprite/AnimationPlayer.get_current_animation() == "1Idle":
			if velocity.x > 0:
				velocity.x -= slow_down_amount
			else:
				velocity.x += slow_down_amount

	if allow_movement == false:
		smooth_roll_speed = lerp(smooth_roll_speed, target_roll_speed, ROLL_TRAVEL_SPEED * delta)
		smooth_attack_speed = lerp(smooth_attack_speed, target_attack_speed, ATTACK_TRAVEL_SPEED * delta)



	if allow_movement == true:
### ROLL ###
		if Input.is_action_just_pressed("ui_shift") and allow_movement == true and can_roll == true and airborn == false:
			can_roll = false
			allow_movement = false
			$RollTime.start()
			animation_state.travel("7Roll")
			if roll_direction == 300:
				velocity.x = max(velocity.x + -smooth_roll_speed, roll_direction)
			elif roll_direction == -300:
				velocity.x = min(velocity.x + smooth_roll_speed, roll_direction)
### CROUCH ###
		elif Input.is_action_pressed("ui_s"):
			animation_state.travel("5Crouch")
			friction = true
			if Input.is_action_pressed("ui_d"):
				$Sprite.flip_h = true
			elif Input.is_action_pressed("ui_a"):
				$Sprite.flip_h = false
### ATTACK ###
		elif Input.is_action_just_pressed("ui_m1") and allow_movement == true:
			if $DelayTillRoll.time_left > 0 and velocity.x < -65 or $DelayTillRoll.time_left > 0 and velocity.x > 65:
				if $Sprite.flip_h == false:
					$AnimatedSprite.set_offset(Vector2(13, 17))
					$AnimatedSprite.flip_h = false
					$AnimatedSprite.play("Dash")
				elif $Sprite.flip_h == true:
					$AnimatedSprite.set_offset(Vector2(-14, 17))
					$AnimatedSprite.flip_h = true
					$AnimatedSprite.play("Dash")
			smooth_roll_speed = 0
			slow_down = true
			allow_movement = false
			animation_state.travel("8Attack1")
			$AttackTime.start()
			
### RUN ###
		elif Input.is_action_pressed("ui_d"):
			direction = "Right"
			moving = true
			animation_state.travel("2Run")
			velocity.x = min(velocity.x + acceleration, max_run_speed)
			$Sprite.flip_h = true
		elif Input.is_action_pressed("ui_a"):
			direction = "Left"
			moving = true
			animation_state.travel("2Run")
			velocity.x = max(velocity.x - acceleration, -max_run_speed)
			$Sprite.flip_h = false

### IDLE ###
		else:
			animation_state.travel("1Idle")
			moving = false
			friction = true

### JUMPING ###
	if airborn == true:
		if velocity.y < 0:
			animation_state.travel("3Jump")
		elif velocity.y > 0:
			animation_state.travel("4Fall")
	if is_on_floor():
		airborn = false
		if Input.is_action_just_pressed("ui_space") and allow_movement == true:
			airborn = true
			velocity.y = jump_height
### ON-GROUND FRICTION ###
		if friction == true:
			velocity.x = lerp(velocity.x, 0, ground_friction_slide)
### IN-AIR FRICTION ###
	else:
		if friction == true:
			velocity.x = lerp(velocity.x, 0, air_friction_slide)
	velocity = move_and_slide(velocity, Vector2.UP)

### TIMERS ###

func _on_AttackTime_timeout():
	slow_down = false
	smooth_attack_speed = 10
	allow_movement = true
	

func _on_RollTime_timeout():
	smooth_roll_speed = 300
	allow_movement = true
	$DelayTillRoll.start()


func _on_DelayTillRoll_timeout():
	can_roll = true


