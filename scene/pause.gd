extends Control


func _on_returnmenu_pressed():
	hide()
	get_tree().paused = false
	


func _on_quit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/menu2.tscn")
