extends Node2D

var c_menu_open = false
var c_menu_slow_down = false
var c_close = false

var previous_character_pos = Vector2(0,0)
var pre_menu_mouse_pos = Vector2(0,0)

var character = ""

var crosshair_waiting = false
var crosshair_timer = false

#LERP STUFF
var time_smooth_travel = 1
var time_target_travel = 0.02
var time_speed = 8

var cam_smooth_travel = 1
var cam_target_travel = 1.2
var cam_speed = 8

var vignette_smooth_travel = 0
var vignette_target_travel = 1
var vignette_speed = 10

var crosshair_smooth_travel = Vector2(0,0)
var crosshair_target_travel = Vector2(160,90)
var crosshair_speed = 50


const Character_Menu = preload("res://MenuCircle.tscn")
const Ghost_Crosshair = preload("res://GhostCrosshair.tscn")

var Character1 = load("res://Characters/Character1.tscn")
var Character2 = load("res://Characters/Character2.tscn")


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _physics_process(delta):
#START CHARACTER MENU SELCTION/RESET LERP VALUES
	if c_menu_open == false and $Timer.is_stopped():
		if Input.is_action_pressed("ui_c_menu"):
			c_menu_open = true
# warning-ignore:standalone_expression
			c_close == false
			c_menu_slow_down = true
			pre_menu_mouse_pos = get_viewport().get_mouse_position()
			var c_menu = Character_Menu.instance()
			add_child(c_menu)
			
			time_smooth_travel = 1
			time_target_travel = 0.02
			time_speed = 8
			
			cam_smooth_travel = 1
			cam_target_travel = 1.2
			cam_speed = 8
			
			vignette_smooth_travel = 0
			vignette_target_travel = 1
			vignette_speed = 10
			
			crosshair_waiting = true
			crosshair_smooth_travel = pre_menu_mouse_pos

#ON CHARACTER SELECTION, KILL MENU INSTANCE. AND FADE-OUT LERP
	if c_menu_slow_down == true:
		if get_node("MenuCircle").c_menu_done == true:
			character = get_node("MenuCircle").c_menu_character
			print(character)
			$Timer.start()
			c_menu_slow_down = false
			c_menu_open = false
			c_close = true

#LERP TimeScale Zoom and Vignette (Fade-in)
		time_smooth_travel = lerp(time_smooth_travel, time_target_travel, time_speed * delta)
		cam_smooth_travel = lerp(cam_smooth_travel, cam_target_travel, cam_speed * delta)
		vignette_smooth_travel = lerp(vignette_smooth_travel, vignette_target_travel, vignette_speed * delta)

		if crosshair_waiting == true:
			crosshair_smooth_travel = lerp(crosshair_smooth_travel, crosshair_target_travel, crosshair_speed * delta)
			get_viewport().warp_mouse(crosshair_smooth_travel)
			crosshair_timer = true
			if crosshair_timer == true and $CrosshairTimer.is_stopped():
				$CrosshairTimer.start()
		
		Engine.time_scale = time_smooth_travel
		$Camera2D.set_zoom(Vector2(cam_smooth_travel, cam_smooth_travel))
		$TextureRect.set_modulate(Color(1, 1, 1, vignette_smooth_travel))

#LERP TimeScale Zoom and Vignette (Fade-out)
	if c_menu_slow_down == false:
		if c_close == true:
			time_smooth_travel = time_smooth_travel
			time_target_travel = 1
			time_speed = 20
			
			cam_smooth_travel = cam_smooth_travel
			cam_target_travel = 1
			cam_speed = 20
			
			vignette_smooth_travel = vignette_smooth_travel
			vignette_target_travel = 0
			vignette_speed = 25
			
			time_smooth_travel = lerp(time_smooth_travel, time_target_travel, time_speed * delta)
			cam_smooth_travel = lerp(cam_smooth_travel, cam_target_travel, cam_speed * delta)
			vignette_smooth_travel = lerp(vignette_smooth_travel, vignette_target_travel, vignette_speed * delta)
			Engine.time_scale = time_smooth_travel
			$Camera2D.set_zoom(Vector2(cam_smooth_travel, cam_smooth_travel))
			$TextureRect.set_modulate(Color(1, 1, 1, vignette_smooth_travel))
			if has_node("MenuCircle"):
				get_node("MenuCircle").set_modulate(Color(1, 1, 1, vignette_smooth_travel))


#DELETE MENU CIRCLE INSTANCE
func _on_Timer_timeout():
	$Timer.stop()
	crosshair_waiting = true
	crosshair_timer = false
	previous_character_pos = get_parent().position
	get_node("MenuCircle").queue_free()
	if character == "1":
		var char_1 = Character1.instance()
		char_1.position = previous_character_pos
		get_parent().get_parent().add_child(char_1)
		get_parent().queue_free()
	elif character == "2":
		var char_2 = Character2.instance()
		char_2.position = previous_character_pos
		get_parent().get_parent().add_child(char_2)
		get_parent().queue_free()

#STOP CROSSHAIR LERP
func _on_CrosshairTimer_timeout():
	crosshair_waiting = false
	get_viewport().warp_mouse(Vector2(160, 90))
	$Timer.stop()
