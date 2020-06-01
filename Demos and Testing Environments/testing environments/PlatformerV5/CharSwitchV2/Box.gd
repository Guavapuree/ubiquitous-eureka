extends Node2D

var gravity = 10


var velocity = Vector2()

func _ready():
	add_to_group("RigidBody")
