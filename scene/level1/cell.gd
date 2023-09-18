extends Node2D

@export var vesicle_max_n := 10
@onready var vesicle_produced := 0

@onready var vesicle_scene := preload("res://scene/Organelle/vesicle.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer_Vesicle_rate.start(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
	
func _on_timer_vesicle_rate_timeout():
	if $Golgi/Vesicles.get_children().size() < vesicle_max_n:
		generate_vesicle()
		print('Vesicule Produced: '+str(vesicle_produced))
	
func generate_vesicle():
	var vesicle = vesicle_scene.instantiate()
	vesicle.position = $Golgi.position+Vector2(20,0)
	$Golgi/Vesicles.add_child(vesicle)
	vesicle_produced += 1




