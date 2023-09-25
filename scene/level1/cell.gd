extends Node2D

@export var vesicle_max_n := 10
@export var vesicle_production_speed := 3
@onready var vesicle_produced := $Vesicles_parent.get_children().size()
@onready var vesicle_scene := preload("res://scene/Organelle/vesicle.tscn")



# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer_Vesicle_rate.start(vesicle_production_speed)
	
	
func _on_timer_vesicle_rate_timeout():
	if $Vesicles_parent.get_children().size() < vesicle_max_n:
		generate_vesicle()
		print('Vesicule Produced: '+str(vesicle_produced))

func generate_vesicle():
	var vesicle = vesicle_scene.instantiate()
	vesicle.global_position = $Golgi.position + Vector2(40, randi() %10)
	$Vesicles_parent.add_child(vesicle)
	vesicle_produced += 1
