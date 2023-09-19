extends CanvasLayer


func _on_continue_button_pressed():
	print('Continue')
	queue_free()
	get_tree().paused = false
