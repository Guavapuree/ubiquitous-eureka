extends Node2D

var ball_motion = false
var direction = 5
var ball_collision = false
var animation_finished = false
var check_animation_pos = true
var ball_fall = false
var timer_done = false


var from_travel = 0
var TRAVEL_SPEED = 0.65
var SPEED_SPEED = 0.1

func _ready():
# GET DIRECTION FOR BALL THROW

	print(get_parent().get_node("Character1").direction)
	if get_parent().get_node("Character1").direction == "LEFT":
		$Area2D/AnimationPlayer.play("BaseBallThrowLeft")
		direction = -5
	elif get_parent().get_node("Character1").direction == "RIGHT":
		$Area2D/AnimationPlayer.play("BaseBallThrowRight")
		direction = 5


func _physics_process(delta):
# BALL IS STRUCK
	if ball_motion == true:
		position += Vector2(direction, 0)
		$Area2D/AnimatedSprite.rotation_degrees -= 10


# BALL IS NOT STRUCK
	if $Area2D/AnimationPlayer.is_playing():
		if $Area2D/AnimationPlayer.get_current_animation_position() >= 0.4 and check_animation_pos == true:
			$Area2D/AnimationPlayer.stop()
			check_animation_pos = false
			animation_finished = true
	if ball_collision == false and animation_finished == true:
		ball_fall = true
	if ball_fall == true:
		print(TRAVEL_SPEED)
		TRAVEL_SPEED = lerp(TRAVEL_SPEED, 1.25, SPEED_SPEED * delta)
		from_travel = lerp(position.y, position.y + 300, TRAVEL_SPEED * delta )
		position.y = from_travel
		position.x += direction * 0.05
		$Area2D/AnimatedSprite.rotation_degrees += 300


func _on_Area2D_area_entered(area):
# DETECT THE HIT
	if area.is_in_group("player_attack"):
		$Area2D/AnimationPlayer.stop()
		ball_fall = false
		$Area2D/AnimatedSprite.play("Hit")
		ball_motion = true
		area.get_node("CollisionShape2D").set_disabled(true)
		area.get_node("BaseBallBatHitBox").play("Default")


func _on_Area2D_body_entered(body):
# DETECT FLOOR
	if body.is_in_group("ground"):
		$Area2D/AnimationPlayer.stop()
		ball_collision = true
		animation_finished = false
		ball_fall = false


