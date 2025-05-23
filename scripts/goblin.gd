extends CharacterBody2D

@export var speed = 50.0
@export var target_distance = 10.0
@export var attack_range = 15.0
@export var attack_damage = 10
@export var health = 30
@export var attack_delay = 0.25

var player: Node2D
var attack_timer = 0.0

func take_damage(amount: int) -> void:	
	health -= amount
	if health <= 0:
		# This enemy died...
		queue_free()

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func _physics_process(delta: float) -> void:
	attack_timer -= delta
	
	if player:
		var distance = (player.global_position - global_position).length()
		
		if (abs(distance) <= attack_range and attack_timer <= 0):
			if player.has_method("take_damage"):
				player.take_damage(attack_damage)
				attack_timer = attack_delay
		
		if (abs(distance) > target_distance):
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * speed
		else:
			velocity = Vector2(0,0)

	move_and_slide()
