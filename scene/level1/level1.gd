extends Node2D

signal final_score(score)

@export var starting_interval := 15
@export var ending_interval := 5
@export var starting_max_virus := 2
@export var ending_max_virus := 8
@export var transition_duration := 30
@export var wave_number := 3.0
@export var level_duration := 20 #in seconds
var score := 0
var first_duration := true
var end_timer := false
var first_duration_timer := 5

@onready var game_over_Screen := preload("res://scene/Game_over.tscn")
@onready var win_Screen := preload("res://scene/level1/victory.tscn")
@onready var description_Screen := preload("res://scene/level1/level_description.tscn")

var VIRUSES := [preload("res://scene/Viruses/virus_ambre.tscn")]

var VIRUS = VIRUSES[0]

var time_interval = starting_interval
var max_virus = starting_max_virus
var transition_timer := 0.0
var wave_n := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var description = description_Screen.instantiate()
	add_child(description)
	get_tree().paused = true
	_start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	transition_timer += _delta
	if first_duration:
		if transition_timer > first_duration_timer:
			transition_timer = transition_duration
			first_duration = false
			print('Grace periode ended')
	else:
		if end_timer == false:
			if transition_timer > transition_duration:
				transition_timer = 0
				time_interval = starting_interval + (ending_interval - starting_interval) / wave_number * wave_n
				max_virus = starting_max_virus + (ending_max_virus - starting_max_virus) / wave_number * wave_n
				print('New interval is '+str(time_interval))
				print('New virus max number is '+str(max_virus))
				for x in range(max_virus):
					$VirusSpawn.start(randi()%int(time_interval))
				if wave_n <= wave_number:
					wave_n += 1
		else:
			max_virus = 0
			if $Viruses.get_children().size() == 0: #no more viruses left
				_win()
					


func random_position():
	var centerpos = $Area2D/CollisionShape2D.global_position
	var size = $Area2D/CollisionShape2D.shape.extents
	var x = (randi() % int(size.x)) - (size.x/2) + centerpos.x
	var y = (randi() % int(size.y)) - (size.y/2) + centerpos.y
	return Vector2(x, y)



func _on_virus_spawn_timeout():
	if $Viruses.get_children().size() < max_virus:
		VIRUS = random_choice(VIRUSES)
		var virus = VIRUS.instantiate()
		virus.position = random_position()
		$Viruses.add_child(virus)
		virus.connect("virus_destroyed", _score)
		virus.connect("death", _lose)
		print('Virus generated')


func _score(s):
	score += s
	print('score is '+str(score))
	$UserInterface/ScoreLabel.text = "Score: %s" % score
	
	
func _lose():
	print('Game over')
	var game_over = game_over_Screen.instantiate()
	add_child(game_over)
	get_tree().paused = true
	
func _win():
	print('Victory!')
	var win = win_Screen.instantiate()
	add_child(win)
	$Victory/Panel/MarginContainer/VBoxContainer/Label/CenterContainer/VBoxContainer/Label.text = "Final score: %s" % score
	get_tree().paused = true
	
func _start():
	print('Main Timer start')
	$Level_Timer.start(level_duration)
	
func random_choice(list: Array):
	return list[ randi() % list.size() ]


func _on_level_timer_timeout():
	print('Infection ends')
	end_timer = true
	max_virus = 0
