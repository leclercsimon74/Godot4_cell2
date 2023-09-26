extends Control


func _ready():
	$Panel/MarginContainer/VBoxContainer/Label/CenterContainer/VBoxContainer/Returnmenu.text = tr("return")
	$Panel/MarginContainer/VBoxContainer/Label/CenterContainer/VBoxContainer/QuitButton.text = tr("quit")

func _on_returnmenu_pressed():
	hide()
	get_tree().paused = false
	


func _on_quit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/menu2.tscn")
