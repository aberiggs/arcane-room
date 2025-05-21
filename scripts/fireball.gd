extends Area2D

@export var speed: float = 400.0
var direction: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_timer_timeout():
	queue_free()
	
func _on_body_entered(body):
	# TODO: Check for enemies or walls here
	if body.name != "Player":
		queue_free()
