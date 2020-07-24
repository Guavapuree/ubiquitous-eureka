extends KinematicBody2D

var max_run_speed = 180
var jump_height = -300
var gravity = 10
var acceleration = 20
var direction = "LEFT"


var velocity = Vector2()

onready var animation_state = $Sprite/AnimationPlayer/AnimationTree.get("parameters/playback")
var animation_end_state = true

func _ready():
	animation_state.start("1Idle")
	$Sprite/AnimationPlayer/AnimationTree.active = true
	add_to_group("player")

func _process(delta):
	print(animation_state.get_current_node())
	velocity.y += gravity
	var friction = false

	if Input.is_action_pressed("ui_s"):
		animation_state.travel("5Crouch")
		friction = true
	elif Input.is_action_pressed("ui_d"):
		animation_state.travel("2Run")
		velocity.x = min(velocity.x + acceleration, max_run_speed)
		$Sprite.flip_h = true
	elif Input.is_action_pressed("ui_a"):
		animation_state.travel("2Run")
		velocity.x = max(velocity.x - acceleration, -max_run_speed)
		$Sprite.flip_h = false
	elif Input.is_action_pressed("ui_r"):
		animation_state.travel("7Roll")
		velocity.x = min(velocity.x + 100, 280)
	else:
		animation_state.travel("1Idle")
		friction = true

# JUMPING
	if is_on_floor():
		if Input.is_action_just_pressed("ui_select"):
			velocity.y = jump_height
		if friction == true:
			velocity.x = lerp(velocity.x, 0, 0.2)
	else:
		if friction == true:
			velocity.x = lerp(velocity.x, 0, 0.05)
	velocity = move_and_slide(velocity, Vector2.UP)

