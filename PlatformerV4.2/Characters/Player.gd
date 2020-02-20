extends KinematicBody2D

var max_run_speed = 200
var jump_height = -280
var gravity = 10
var acceleration = 25
var attacking = false
var direction = "LEFT"

const Baseball_Ball = preload("res://BaseBallThrow.tscn")

var velocity = Vector2()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	add_to_group("player")

func _physics_process(delta):
	velocity.y += gravity
	var friction = false

# INSTANCE THE BASEBALL
	if Input.is_action_just_pressed("ui_right_click"):
		var baseball_ball = Baseball_Ball.instance()
		baseball_ball.position = global_position
		get_parent().add_child(baseball_ball)

# ATTACKING
	if Input.is_action_just_pressed("ui_atk_r"):
		attacking = true
		$AnimatedSprite.play("BaseBallAttack")
	if attacking == true and $AnimatedSprite.frame == 3:
		$AnimatedSprite.play("Idle")
		attacking = false
	if $AnimatedSprite.animation != "BaseBallAttack":
		attacking = false


# MOVEMENT
	if Input.is_action_pressed("ui_left"):
		velocity.x = max(velocity.x - acceleration, -max_run_speed)
		$AnimatedSprite.flip_h = false
		direction = "LEFT"
		$AnimatedSprite.play("Walk")
	elif Input.is_action_pressed("ui_right"):
		velocity.x = min(velocity.x + acceleration, max_run_speed)
		$AnimatedSprite.flip_h = true
		direction = "RIGHT"
		$AnimatedSprite.play("Walk")
	else:
		friction = true
		if $AnimatedSprite.animation != "BaseBallAttack":
			$AnimatedSprite.play("Idle")

# JUMPING
	if is_on_floor():
		if Input.is_action_pressed("ui_select"):
			velocity.y = jump_height
		if friction == true:
			velocity.x = lerp(velocity.x, 0, 0.2)
	else:
		if velocity.y > 0:
			$AnimatedSprite.play("Fall")
		elif velocity.y <= 0:
			$AnimatedSprite.play("Jump")
		if friction == true:
			velocity.x = lerp(velocity.x, 0, 0.05)

	velocity = move_and_slide(velocity, Vector2(0, -1))


#func _on_Timer_timeout():

