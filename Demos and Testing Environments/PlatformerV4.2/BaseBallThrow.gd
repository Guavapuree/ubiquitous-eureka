extends Node2D

var ball_motion = false
var direction = 5
var ball_collision = false
var animation_finished = false



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
	if ball_collision == false and animation_finished == true:
		position += Vector2(0, 3)
		$Area2D/AnimatedSprite.rotation_degrees -= 10

func _on_Area2D_area_entered(area):
# DETECT THE HIT
	if area.is_in_group("player_attack"):
		$Area2D/AnimationPlayer.stop()
		$Area2D/AnimatedSprite.play("Hit")
		ball_motion = true
		area.get_node("CollisionShape2D").set_disabled(true)
		area.get_node("BaseBallBatHitBox").play("Default")


func _on_AnimationPlayer_animation_finished(anim_name):
	animation_finished = true
	print("this is done")


func _on_Area2D_body_entered(body):
# DETECT FLOOR
	if body.is_in_group("ground"):
		$Area2D/AnimationPlayer.stop()
		ball_collision = true
