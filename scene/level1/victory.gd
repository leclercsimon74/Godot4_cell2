extends Control
@onready var vars = get_node("/root/GameManager")

func _ready():
	$AudioStreamPlayer.play()
	$Panel/MarginContainer/VBoxContainer/Label.text = tr("victory")
	$Panel/MarginContainer/VBoxContainer/Label/CenterContainer/VBoxContainer/Label.text = tr("final_score")+str(vars.get_score())
	$Panel/MarginContainer/VBoxContainer/Label/CenterContainer/VBoxContainer/Mainmenu.text = tr("main_menu")
	$Panel/MarginContainer/VBoxContainer/Label/CenterContainer/VBoxContainer/QuitButton.text = tr("quit")
	$Panel/MarginContainer/VBoxContainer/Label/CenterContainer/VBoxContainer/NextButton.text = tr("next")


func _on_quit_button_pressed():
	print('Quit the game')
	get_tree().quit()


func _on_next_button_pressed():
	#to the next level
	pass # Replace with function body.


func _on_mainmenu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/menu2.tscn")
	
