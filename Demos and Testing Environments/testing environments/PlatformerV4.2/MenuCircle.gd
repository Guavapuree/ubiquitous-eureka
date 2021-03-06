extends Container

#Creates a radial container node

export var button_radius = 60 #in godot position units
export var radial_width = 50 #in godot position units
var c_menu_done = false
var c_menu_character = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	place_buttons()
#Repositions the buttons

func place_buttons():
	var buttons = get_children()

	#Stop before we cause problems when no buttons are available
	if buttons.size() == 0:
		return

	#Amount to change the angle for each button
	var angle_offset = (2*PI)/buttons.size() #in degrees

	var angle = 0 #in radians
	for btn in buttons: 
		#calculate the x and y positions for the button at that angle
		var x = cos(angle)*button_radius
		var y = sin(angle)*button_radius

		#Note: A bit confused but somehow godot corrects the sign on it's own so that isn't needed.

		#set button's position
		#>we want to center the element on the circle. 
		#>to do this we need to offset the calculated x and y respectively by half the height and width
		var corner_pos = Vector2(x, -y)-(btn.get_size()/2) #Screen coordinates so calculated y must be negated
		btn.set_position(corner_pos)

		#Advance to next angle position
		angle += angle_offset

#utility function for adding buttons and recalculating their positions
#TODO: Should probably just use a signal to run place_button on any tree change
func add_button(btn):
	add_child(btn)
	place_buttons()
	
#BUTTONS

func _on_Button_pressed():
	c_menu_character = "1"
	c_menu_done = true


func _on_Button2_pressed():
	c_menu_character = "2"
	c_menu_done = true

func _on_Button3_pressed():
	c_menu_character = "3"
	c_menu_done = true

func _on_Button4_pressed():
	c_menu_character = "4"
	c_menu_done = true

func _on_Button5_pressed():
	c_menu_character = "5"
	c_menu_done = true

func _on_Button6_pressed():
	c_menu_character = "6"
	c_menu_done = true