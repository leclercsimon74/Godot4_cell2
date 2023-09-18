extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.shape.radius = 15 # Replace with function body.
	print('Vesicle launched!')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw():
	draw_circle(Vector2.ZERO, 15, Color.RED)

