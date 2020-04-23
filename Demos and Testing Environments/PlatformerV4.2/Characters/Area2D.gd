extends Area2D


func _ready():
	add_to_group("player_attack")
	$CollisionShape2D.set_disabled(true)

func _physics_process(delta):
#	print(get_parent().attacking)
	if get_parent().attacking == true:
		if get_parent().direction == "LEFT":
			$CollisionShape2D.set_disabled(false)
			$BaseBallBatHitBox.play("BaseBallHitLeft")
		elif get_parent().direction == "RIGHT":
				$CollisionShape2D.set_disabled(false)
				$BaseBallBatHitBox.play("BaseBallHitRight")
	elif get_parent().attacking == false:
		$CollisionShape2D.set_disabled(true)
		$BaseBallBatHitBox.play("Default")
