extends KinematicBody2D

export (int) var run_speed = 150
export (int) var jump_speed = -280
export (int) var gravity = 600

var velocity = Vector2()
var jumping = false


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func get_input():
	velocity.x = 0

	if Input.is_action_just_pressed('ui_select') and is_on_floor():
		jumping = true
		velocity.y = jump_speed

	if Input.is_action_pressed("ui_left"):
		velocity.x -= run_speed
		$AnimatedSprite.flip_h = false
	elif Input.is_action_pressed("ui_right"):
		velocity.x += run_speed
		$AnimatedSprite.flip_h = true

func _physics_process(delta):

	get_input()
	velocity.y += delta * gravity

	if jumping and is_on_floor():
		jumping = false

	velocity = move_and_slide(velocity, Vector2(0, -1))
