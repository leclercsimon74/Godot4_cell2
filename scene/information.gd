extends Control

var speed := 25

func _ready():
	randomize()
	$Virus1.apply_impulse(Vector2(randi()%int(speed),randi()%int(speed)))
	$RigidBody2D.apply_impulse(Vector2(randi()%int(speed),randi()%int(speed)))
	$RigidBody2D3.apply_impulse(Vector2(randi()%int(speed),randi()%int(speed)))
	$RigidBody2D2.apply_impulse(Vector2(randi()%int(speed),randi()%int(speed)))
	$RigidBody2D4.apply_impulse(Vector2(randi()%int(speed),randi()%int(speed)))
	$RigidBody2D5.apply_impulse(Vector2(randi()%int(speed),randi()%int(speed)))

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scene/menu2.tscn")


func _on_next_button_pressed():
	get_tree().change_scene_to_file("res://scene/organelle_info.tscn")
