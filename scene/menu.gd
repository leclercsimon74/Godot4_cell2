extends Control

@onready var vars = get_node("/root/GameManager")

func _ready():
	change_language()


func _on_start_button_pressed():
	print('New game')
	vars.set_score(0)
	get_tree().change_scene_to_file("res://scene/level1/level1.tscn")


func _on_option_button_pressed():
	print('Go to tutorial')
	get_tree().change_scene_to_file("res://scene/tutorial.tscn")


func _on_quit_button_pressed():
	print('Quit the game')
	get_tree().quit()


func _on_info_button_pressed():
	print('Go to information')
	get_tree().change_scene_to_file("res://scene/information.tscn")


func _on_option_button_2_pressed():
	print('Go to options')
	get_tree().change_scene_to_file("res://scene/options.tscn")


func _on_finland_b_pressed():
	print("Change language to Finnish")
	TranslationServer.set_locale("fi")
	change_language()


func _on_uk_b_pressed():
	print("Change language to English")
	TranslationServer.set_locale("en")
	change_language()


func _on_france_b_pressed():
	print("Change language to French")
	TranslationServer.set_locale("fr")
	change_language()


func change_language():
	$UI/ItemList/CenterContainer/VBoxContainer/start_button.text = tr("new game",)
	$UI/ItemList/CenterContainer/VBoxContainer/option_button.text = tr("tutorial")
	$UI/ItemList/CenterContainer/VBoxContainer/info_button.text = tr("info")
	$UI/ItemList/CenterContainer/VBoxContainer/quit_button.text = tr("quit")
	$UI/ItemList/CenterContainer/VBoxContainer/option_button2.text = tr("option")
