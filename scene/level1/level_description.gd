extends CanvasLayer

func _ready():
	$Panel/ContinueButton.text = tr("continue")
	$Panel/RichTextLabel.text = tr("sec_cell_info")
	$Panel/Label.text = tr("info")
	$Panel/Label2.text = tr("sec_cell")

func _on_continue_button_pressed():
	print('Continue')
	queue_free()
	get_tree().paused = false
