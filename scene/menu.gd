extends Control


func _on_start_button_pressed():
	print('New game')
	get_tree().change_scene_to_file("res://scene/level1/level1.tscn")
	


func _on_option_button_pressed():
	print('Option menu - empty for the moment')



func _on_quit_button_pressed():
	print('Quit the game')
	get_tree().quit()


func _on_info_button_pressed():
	print('Information menu - empty for the moment')

