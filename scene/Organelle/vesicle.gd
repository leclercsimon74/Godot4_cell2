extends RigidBody2D

@export var start_radius := 2
@export var end_radius := 15
@export var rng_speed := 10

@export var initial_color := Color.WHITE_SMOKE
@export var end_color := Color.INDIAN_RED
@export var final_color := Color.CRIMSON

@export var transition_duration := 5


var radius := start_radius
var color := initial_color

var transition_timer := 0.0
var growing := true
var maturing := false
var vesicle_launched := false

var gradient := Gradient.new()
var t := 0.0
var rng := RandomNumberGenerator.new()
var current_radius := 0

var launcher := preload("res://scene/launcher.tscn")
var launch = launcher.instantiate()

func _draw():
	draw_circle(Vector2.ZERO, radius, color)

func _ready():
	gradient.interpolation_mode = Gradient.GRADIENT_INTERPOLATE_LINEAR
	gradient.set_color(0, initial_color)
	gradient.set_color(1, end_color)
	$Growing_timer.start(transition_duration)
	self.linear_damp = 0
	self.linear_damp_mode = 1
	update_collision_shape(end_radius)
	

func _process(_delta):
	if growing:
		if transition_timer < transition_duration:
			transition_timer += _delta
			t = transition_timer / transition_duration
			radius = start_radius + t * (end_radius - start_radius)
			#update_collision_shape(radius)
			color = initial_color
			queue_redraw()

	elif maturing:
		if transition_timer < transition_duration:
			transition_timer += _delta
			t = transition_timer / transition_duration
			radius = end_radius
			color = gradient.sample(t)
			queue_redraw()
			

func _on_growing_timer_timeout():
	transition_timer = 0.0
	growing = false
	maturing = true
	radius = end_radius
	update_collision_shape(radius)
	$Maturation_timer.start(transition_duration)
	var rng_dir = Vector2(rng.randf_range(-rng_speed, rng_speed), rng.randf_range(-rng_speed, rng_speed))
	rng_dir = rng_dir.normalized()
	set_linear_velocity(rng_dir * rng_speed)
	queue_redraw()

func _on_maturation_timer_timeout():	
	color = final_color
	maturing = false
	launch.position = global_position
	$Node2D.add_child(launch)
	launch.connect("vector_created", _launcher_vector)
	queue_redraw()

func _launcher_vector(vector):
	set_linear_velocity(Vector2.ZERO)
	set_linear_velocity(vector)
	vesicle_launched = true
	vector = Vector2.ZERO
	$Node2D.remove_child(launch)
	#Change collision layer and mask so the vesicle can only interact with virus and other launched vesicle
	self.set_collision_mask_value(2, false)
	self.set_collision_mask_value(3, false)
	self.set_collision_mask_value(5, true)
	self.set_collision_layer_value(3, false)
	self.set_collision_layer_value(5, true)

func update_collision_shape(new_radius):
	if $_collid.shape is CircleShape2D:
		$_collid.shape.radius = new_radius


func _on_visible_on_screen_notifier_2d_screen_exited():
	print('Vesicle outside the screen. Destruction')
	queue_free()
