extends KinematicBody2D

const UP = Vector2(0, -1) # Determines what side is up at all times
export var gravity = 750 # Determines how fast the character will fall
export var acceleration = 50 # Determines how fast the character starts moving or changes direction
export var max_speed = 200 # Maximum speed of the character
export var jump_height = -300 # Determines character jump height
var motion = Vector2()

func _physics_process(delta):
# Movement
	var friction = false 
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + acceleration, max_speed)
	elif Input.is_action_pressed("ui_left"):
		motion.x -= acceleration
		motion.x = max(motion.x - acceleration, -max_speed)
	else:
		friction = true
		motion.x = lerp(motion.x, 0, 0.2) # Slows character until they stop moving
# Jumping 
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = jump_height
