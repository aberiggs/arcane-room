extends CanvasLayer

var health_bar : ProgressBar
var health_label : Label

signal ui_ready

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar = get_node("Container/ProgressBar")
	health_label = get_node("Container/ProgressBar/Label")

	emit_signal("ui_ready")

func update_health(current_val: int, max_val: int):
	health_bar.max_value = max_val
	health_bar.value = current_val
	health_label.text = "%d / %d" % [current_val, max_val]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
