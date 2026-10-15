extends Camera2D

@export var target: Node2D
@export var follow_speed: float = 6.0
@export var camera_zoom: float = 0.5  # Smaller = wider view of the room

func _ready() -> void:
	# Set the lens zoom
	zoom = Vector2(camera_zoom, camera_zoom)

	if not target:
		target = get_parent().get_node_or_null("Bob")
	if target:
		global_position = target.global_position

func _physics_process(delta: float) -> void:
	if not target:
		return

	global_position = global_position.lerp(target.global_position, follow_speed * delta)
