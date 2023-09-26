extends Node2D


var level_duration := 120 #in seconds
var player_score := 0
var fullscreen := false
var language := "en"

# Functions to modify and access global data
func add_score(score):
	player_score += score

func set_score(score):
	player_score = score

func get_score():
	return player_score
