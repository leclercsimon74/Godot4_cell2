extends Node2D

signal vector_created(vector)

@export var maximum_length := 200

var touch_down := false
var position_start := Vector2.ZERO
var position_end := Vector2.ZERO

var vector := Vector2.ZERO
#BUG in the orientation of the helper - related to the Golgi orientation

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("input_event", _on_input_event)
	global_position = position

func _draw():
	draw_line(position_start - global_position,
	(position_end-global_position), Color.BLUE, 4)
	draw_line(position_start - global_position,
	(position_start-global_position+vector), Color.RED, 8)

func _reset():
	position_start = Vector2.ZERO
	position_end = Vector2.ZERO
	vector = Vector2.ZERO
	queue_redraw()

func _input(event):
	if not touch_down:
		return
		
	if event.is_action_released("ui_touch"):
		if vector.length() != 0:
			touch_down = false
			emit_signal("vector_created", vector)
			_reset()
	
	if event is InputEventMouseMotion:
		position_end = event.position
		vector = -(position_end - position_start).limit_length(maximum_length)
		queue_redraw()


func _on_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("ui_touch"):
		touch_down = true
		position_start = event.position
		

