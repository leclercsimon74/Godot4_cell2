extends Control



func _ready():
	var tween2 = get_tree().create_tween()
	tween2.tween_property($NucleusKariTrans, "rotation", 10, 20)
	
	$RichTextLabel.text = tr("organelle_info")
	$Button.text = tr("return")
	$PreviousButton.text = tr("previous_virus")
	


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scene/menu2.tscn")


func _on_previous_button_pressed():
	get_tree().change_scene_to_file("res://scene/information.tscn")
