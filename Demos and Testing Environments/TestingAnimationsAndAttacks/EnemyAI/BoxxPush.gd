extends KinematicBody2D

var max_move_speed = 100
var gravity = 10
var acceleration = 20

var start_moving = false
var pushing = false

var smooth_speed = 0
var target_speed = -75
var new_target_speed = 0
const TRAVEL_SPEED = 25

var ground_friction_slide = 0
var air_friction_slide = 0.05

var player_node
var player_node_confirm



var push_direction = -75

var velocity = Vector2()


func _ready():
	pass # Replace with function body.

func _process(delta):
	velocity.y += gravity
	var friction = false
	
#	print(velocity.x)
#	print(pushing)
#	print(smooth_speed)
#	print($PushRight.is_colliding())
#	print($PushRight.get_cast_to())
	


### PUSH BOX LEFT ###
	if pushing == true and player_node == player_node_confirm and player_node.is_in_group("player"):
#		smooth_speed = lerp(smooth_speed, target_speed, TRAVEL_SPEED * delta)
		player_node.velocity.x = velocity.x
		velocity.x = push_direction
### IF LEFT, PUSH BOX ###
	if start_moving == true and player_node == player_node_confirm and player_node.is_in_group("player"):
		if Input.is_action_pressed("ui_a"):
			pushing = true
			push_direction = -75
		elif Input.is_action_pressed("ui_d"):
			pushing = true
			push_direction = 75
#		elif Input.is_action_pressed("ui_space"):
#			player_node.allow_movement = true
#			ground_friction_slide = 0.2
#			player_node.ground_friction_slide = 0.2
#			player_node.animation_state.travel("Idle")
#			start_moving = false
#			pushing = false
			
### STOP PUSHING BOX ###
		else:
			pushing = false
			smooth_speed = lerp(smooth_speed, new_target_speed, TRAVEL_SPEED * delta)
			player_node.velocity.x = velocity.x
			velocity.x = smooth_speed

### DETECT PLAYER NEAR BOX TO PUSH ###
	if  player_node == player_node_confirm and player_node.is_in_group("player") and Input.is_action_just_pressed("ui_space"):
		player_node.get_node("Push").visible = true
		player_node.allow_movement = false
		ground_friction_slide = 1
		player_node.ground_friction_slide = 1
		player_node.animation_state.travel("9Push")
		$Area2D/CollisionShape2D.extent = Vector2(30, 8)
		start_moving = true




				
### ON-GROUND FRICTION ###
	if is_on_floor():
		if friction == true:
			velocity.x = lerp(velocity.x, 0, ground_friction_slide)
### IN-AIR FRICTION ###
	else:
		if friction == true:
			velocity.x = lerp(velocity.x, 0, air_friction_slide)
	velocity = move_and_slide(velocity, Vector2.UP)


#func _on_BoxDelay_timeout():
#	start_moving = false
#	print("AHHHH")


func _on_Area2D_body_entered(body):
	player_node = body
	player_node_confirm = body


func _on_Area2D_body_exited(body):
	player_node = null
