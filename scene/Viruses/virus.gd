extends RigidBody2D

signal death
signal virus_destroyed(score)

@export var speed := 30
@export var pos_rnd := 50

@export var penalty_time_incell := 10.0
@export var degradation_time := 3.0
@export var cell_entry_time := 5.0
@export var stun_duration := 2.0
@export var score := 10
@export var hp := 1

var rng := RandomNumberGenerator.new()
var speed_out := rng.randf_range(speed-(speed/3.0), speed+(speed/3.0))
var speed_in := speed_out/2

@onready var target := get_parent().get_parent().get_node("cell") #target character node
@onready var direction = (target.position - position).normalized() * speed_out

var out_cell := true
var stun := false
var target_pos := Vector2.ZERO

var virus_img := [preload("res://img/Viruses/Virus-Maija-1_trans.png"),
preload("res://img/Viruses/Virus-Visa-1_trans.png"),
preload("res://img/Viruses/Virus-Visa-3_trans.png"),
preload("res://img/Viruses/Virus-Visa-4_trans.png"),
preload("res://img/Viruses/Virus-Visa-5_trans.png"),
preload("res://img/Viruses/Virus-Visa-8_trans.png"),
preload("res://img/Viruses/Virus-Visa-9_trans.png"),
preload("res://img/Viruses/Virus-Visa-10_trans.png"),
preload("res://img/Viruses/Virus-Visa-11_trans.png"),
preload("res://img/Viruses/Virus-Visa-12_trans.png"),
preload("res://img/Viruses/Virus_Kari-1_trans.png"),
preload("res://img/Viruses/Virus_Simon-2_trans.png")]

# Called when the node enters the scene tree for the first time.
func _ready():
	$"1s timer".start(1)
	$Sprite2D.texture = random_choice(virus_img)
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not stun:
		move_and_collide(delta * direction)

func _on_area_2d_body_entered(body):
	hp -= 1
	if hp == 0:
		#vesicle
		body.set_collision_mask_value(4, false)
		body.set_collision_mask_value(5, false)
		body.set_collision_mask_value(6, false)
		body.set_collision_layer_value(5, false)
		#virus
		self.set_collision_layer_value(4, false)
		self.set_collision_mask_value(1, false)
		self.set_collision_mask_value(2, false)
		self.set_collision_mask_value(4, false)
		$CollisionShape2D.queue_free()
		$Area2D.queue_free()
		$Cell_detection.queue_free()

		if out_cell: #quickly destroy virus
			if ($Cell_atach.time_left > 0):
				$Cell_atach.stop()
			print('Virus destroyed!')
			direction = Vector2.ZERO
			speed_out = 0
			if body != null:
				body.set_linear_velocity(Vector2.ZERO)
				#animation
				var tween2 = get_tree().create_tween()
				tween2.tween_property(body, "global_position", global_position, 1)
				await tween2.finished
				body.global_transform.origin = self.position
				tween2 = get_tree().create_tween()
				tween2.tween_property($Sprite2D, "modulate", Color.RED, degradation_time)
				await tween2.finished
				body.queue_free()
			$Sprite2D.visible = false
			$Explosion.emitting = true
			$explosion_sfx.play()
			$explosion.start(1)
			emit_signal("virus_destroyed", score)
			
		else: #virus not destroyed immediatelly in the cell
			print("Destroying a virus in the cell")
			if body != null:
				body.set_linear_velocity(Vector2.ZERO)
				direction = Vector2.ZERO
				speed_in = 0
				#animation
				var tween3 = get_tree().create_tween()
				tween3.tween_property(body, "global_position", global_position, 1)
				await tween3.finished
				body.global_transform.origin = self.position
				tween3 = get_tree().create_tween()
				tween3.tween_property($Sprite2D, "modulate", Color.RED, penalty_time_incell)
				await tween3.finished
				body.queue_free()
			$Sprite2D.visible = false
			$Explosion.emitting = true
			$explosion_sfx.play()
			$explosion.start(1)
			score = 0
			emit_signal("virus_destroyed", score)
			
	else: #HP left, make the virus flash white and unable to move for the Stun duration
		flash_boss()
		body.queue_free()

func _on_cell_detection_body_entered(body): #cell!
	print(self.name+" interacts with "+body.name) #for debug
	if body.name == 'cellinner':
		if hp > 1:
			print('Boss touch the cell!')
			emit_signal("death")
		else:
			print('Virus on the cell!')
			$Cell_atach.start(cell_entry_time)

	if body.name == 'Nucleus':
		print('Virus touch the nucleus!')
		emit_signal("death")


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
		$InTheCell.play()
		out_cell = false
		self.set_collision_mask_value(1, false) #world
		self.set_collision_mask_value(2, false) #cell
		self.set_collision_mask_value(3, true) #organelle
		$Area2D.set_collision_mask_value(6, true) #vesicle
		$Cell_detection.set_collision_mask_value(1, false)
		$Cell_detection.set_collision_mask_value(2, false)
		$Cell_detection.set_collision_mask_value(3, true)
		target = get_parent().get_parent().get_node("cell").get_node('Nucleus') #target character node
		_on_s_timer_timeout()


func flash_boss():
	print("Boss Flashing!")
	stun = true
	$AudioStreamPlayer.play()
	#inactivate virus collision
	self.set_collision_mask_value(4, false)
	$Area2D.set_collision_mask_value(5, false)
	$Area2D.set_collision_mask_value(6, false)
	# Define the duration of each flash and the number of times to flash
	var flash_duration = 0.5  # Adjust as needed
	var flash_count = 5      # Adjust as needed
	var scale_factor = 2.0
	var tween = get_tree().create_tween()
	tween.set_loops(flash_count)
	# Create a sequence of tweens for the flashing effect
	tween.tween_property($Sprite2D, "modulate", Color.RED, flash_duration)
	tween.tween_property($Sprite2D, "modulate", Color.WHITE, flash_duration)
	await tween.finished
	tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2($Sprite2D.scale/scale_factor), 1)
	await tween.finished
#	$Sprite2D.scale = $Sprite2.scale/scale_factor
	$CollisionShape2D.scale =$CollisionShape2D.scale/scale_factor
	$Cell_detection/CollisionShape2D.scale = $Cell_detection/CollisionShape2D.scale/scale_factor
	$Area2D/CollisionShape2D.scale = $Area2D/CollisionShape2D.scale/scale_factor
	stun = false
	
	#reactivate virus collision
	self.set_collision_mask_value(4, true)
	$Area2D.set_collision_mask_value(5, true)
	$Area2D.set_collision_mask_value(6, true)

func random_choice(list: Array):
	return list[ randi() % list.size() ]
