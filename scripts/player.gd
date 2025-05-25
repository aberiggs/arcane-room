extends CharacterBody2D

@export var fireball_scene: PackedScene
@export var max_health = 50

var health = 50

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	var hud = get_node("../UI")
	hud.ui_ready.connect(_on_ui_ready)

func _process(_delta):
	if Input.is_action_just_pressed("shoot"):
		shoot_fireball()

func _physics_process(_delta: float) -> void:
	var horiz_direction = Input.get_axis("move_left", "move_right")
	var vert_direction = Input.get_axis("move_up", "move_down")
	if horiz_direction and vert_direction:
		
		velocity.x = horiz_direction * sqrt((SPEED**2)/2)
		velocity.y = vert_direction * sqrt((SPEED**2)/2)
	elif horiz_direction:
		velocity.x = horiz_direction * SPEED
		velocity.y = move_toward(velocity.y, 0, SPEED)
	elif vert_direction:
		velocity.y = vert_direction * SPEED
	
	if not horiz_direction:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		# Flip the sprite as needed
		$AnimatedSprite2D.flip_h = velocity.x < 0
	
	if not vert_direction:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	move_and_slide()
	
func shoot_fireball():
	var fireball = fireball_scene.instantiate()
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	fireball.global_position = global_position
	fireball.direction = direction
	get_tree().current_scene.add_child(fireball)
	
func take_damage(amount: int):
	health -= amount
	var ui_node = get_node("../UI")
	if (ui_node):
		ui_node.update_health(health, max_health)
	if health <= 0:
		# The player died...
		call_deferred("reload_scene")
	
func reload_scene():
	get_tree().reload_current_scene()
	
func _on_ui_ready():
	# Initialize health bar
	take_damage(0)
