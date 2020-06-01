extends KinematicBody2D
class_name Actor

var velocity = Vector2.ZERO
export var gravity = 500.0

func _physics_process(delta):
	velocity.y += gravity * delta
	move_and_slide(velocity)
