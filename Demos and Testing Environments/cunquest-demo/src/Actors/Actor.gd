extends KinematicBody2D
class_name Actor



func _physics_process(delta):
	motion.y += gravity * delta
	motion = move_and_slide(motion, UP)
