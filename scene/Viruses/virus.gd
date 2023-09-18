extends RigidBody2D

signal virus_destroyed(score)
signal death_screen

@export var speed := 30
@export var pos_rnd := 50

@export var penalty_time_incell := 10.0
@export var degradation_time := 3.0
@export var cell_entry_time := 5.0

@export var score := 10

var rng := RandomNumberGenerator.new()
var speed_out := rng.randf_range(speed-(speed/3), speed+(speed/3))
var speed_in := speed_out/2

@onready var target := get_parent().get_parent().get_node("cell") #target character node
@onready var direction = (target.position - position).normalized() * speed_out

var out_cell := true


var target_pos := Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	$"1s timer".start(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_collide(delta * direction)
	

func _on_area_2d_body_entered(body):
	#vesicle
	body.set_collision_mask_value(5, false)
	body.set_collision_layer_value(5, false)
	#virus
	self.set_collision_layer_value(4, false)
	self.set_collision_mask_value(1, false)
	self.set_collision_mask_value(4, false)
	$Area2D.set_collision_mask_value(5, false)
	$Area2D.set_collision_mask_value(6, false)
	
	if out_cell: #quickly destroy virus
		if ($Cell_atach.time_left > 0):
			$Cell_atach.stop()
		print('Virus destroyed!')
		direction = Vector2.ZERO
		speed_out = 0
		body.set_linear_velocity(Vector2.ZERO)
		#animation
		var tween2 = get_tree().create_tween()
		tween2.tween_property(body, "global_position", global_position, 1)
		await tween2.finished
		tween2 = get_tree().create_tween()
		tween2.tween_property($Sprite2D, "modulate", Color.RED, degradation_time)
		await tween2.finished
		if body != null: #want to detect if the the body has not been already destoyed...
			body.queue_free()
		$Sprite2D.visible = false
		$Explosion.emitting = true
		$explosion.start(1)
		emit_signal("virus_destroyed", score)
		
	else: #virus not destroyed immediatelly in the cell
		body.set_linear_velocity(Vector2.ZERO)
		direction = Vector2.ZERO
		speed_in = 0
		#animation
		var tween3 = get_tree().create_tween()
		tween3.tween_property(body, "global_position", global_position, 1)
		tween3.tween_property($Sprite2D, "modulate", Color.RED, penalty_time_incell)
		await tween3.finished
		body.queue_free()
		$Sprite2D.visible = false
		$Explosion.emitting = true
		$explosion.start(1)
		score = 0
		emit_signal("virus_destroyed", score)
		

func _on_cell_detection_body_entered(body): #cell!
	#print(body.name) #for debug
	if body.name == 'cellinner':
		print('Virus on the cell!')
		$Cell_atach.start(cell_entry_time)

	if body.name == 'Nucleus':
		print('Virus touch the nucleus!')
		emit_signal("death_screen")
		

func _on_s_timer_timeout():
	target_pos = target.global_position + Vector2(rng.randf_range(-pos_rnd, pos_rnd), rng.randf_range(-pos_rnd, pos_rnd))
	if out_cell:
		direction = (target_pos - position).normalized() * speed_out
	else:
		direction = (target_pos - position).normalized() * speed_in

func _on_explosion_timeout():
	queue_free()

func _on_cell_atach_timeout():
		print('Virus in the cell!')
		out_cell = true
		self.set_collision_mask_value(1, false) #cell
		self.set_collision_mask_value(3, true) #organelle
		$Area2D.set_collision_mask_value(6, true) #vesicle
		$Cell_detection.set_collision_mask_value(2, false)
		$Cell_detection.set_collision_mask_value(3, true)
		target = get_parent().get_parent().get_node("cell").get_node('Nucleus') #target character node
		_on_s_timer_timeout()
