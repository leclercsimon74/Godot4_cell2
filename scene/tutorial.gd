extends Control


func _ready():
	$RichTextLabel.text = tr("tuto_txt")
	$PreviousButton.text = tr("return")


func _on_previous_button_pressed():
	get_tree().change_scene_to_file("res://scene/menu2.tscn")
