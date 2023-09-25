extends Control

func _ready():
	$AudioStreamPlayer.play()


func _on_quit_button_pressed():
	print('Quit the game')
	get_tree().quit()


func _on_next_button_pressed():
	#to the next level
	pass # Replace with function body.


func _on_mainmenu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/menu2.tscn")
	
