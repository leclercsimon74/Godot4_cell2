extends Control

@onready var vars = get_node("/root/GameManager")
@onready var duration_list = [60, 90, 120, 180, 240]


func _ready():
	var lvl_B = $MarginContainer/VBoxContainer/Label/CenterContainer/VBoxContainer/Level_duration_Button
	var idx = lvl_B.get_selected_id()
	for x in range(len(duration_list)):
		if duration_list[x] == vars.level_duration:
			print('Preselected time is: '+str(duration_list[x]))
			lvl_B.select(x)
			break
			
	if idx == -1: #in case of error
		lvl_B.select(2)
		vars.level_duration = 120
		
	var check_B = $MarginContainer/VBoxContainer/Label/CenterContainer/VBoxContainer/FullScreen_Button
	check_B.button_pressed = vars.fullscreen
	
	$MarginContainer/VBoxContainer/Label.text = tr("option")
	$MarginContainer/VBoxContainer/Label/CenterContainer/VBoxContainer/Label.text = tr("about")
	$MarginContainer/VBoxContainer/Label/CenterContainer/VBoxContainer/FullScreen_Button.text = tr("fullscreen")
	$MarginContainer/VBoxContainer/Label/CenterContainer/VBoxContainer/ReturnButton.text = tr("return")
	$MarginContainer/VBoxContainer/RichTextLabel.text = tr("general info")
	$Label2.text = tr("lvl_duration")


func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://scene/menu2.tscn")


func _on_level_duration_button_item_selected(index):
	vars.level_duration = duration_list[index]
	print('New level time is: '+str(vars.level_duration))


func _on_full_screen_button_toggled(button_pressed):
	if button_pressed == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if button_pressed == false:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	vars.fullscreen = button_pressed
	print("Set fullscreen to: "+str(button_pressed))

