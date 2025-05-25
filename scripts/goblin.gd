extends CharacterBody2D

@export var speed = 50.0
@export var target_distance = 20.0
@export var attack_range = 25.0
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
		
func shake(target):
	const amount = 5.0
	const duration = 0.1
	
	var direction = (target - global_position).normalized()
	var offset = direction * amount
	
	var orig_pos = position
	var tween = create_tween()
	tween.tween_property(self, "position", orig_pos + offset, duration / 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", orig_pos, duration / 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func _physics_process(delta: float) -> void:
	attack_timer -= delta
	
	if player:
		var distance = (player.global_position - global_position).length()
		
		if (abs(distance) <= attack_range):
			if (attack_timer <= 0 and player.has_method("take_damage")):
				shake(player.global_position)
				player.take_damage(attack_damage)
				attack_timer = attack_delay
		else:
			# Not in range
			attack_timer = attack_delay
		
		if (abs(distance) > target_distance):
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * speed
		else:
			velocity = Vector2(0,0)

	move_and_slide()
