extends CanvasLayer




func _on_quit_button_pressed():
	print('Quit the game')
	get_tree().quit()


func _on_try_button_pressed():
	get_tree().change_scene_to_file("res://scene/menu2.tscn")
