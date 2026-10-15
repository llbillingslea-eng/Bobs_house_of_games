extends Camera2D

# Assign Bob in the Inspector, or let it auto-find him
@export var target: Node2D
@export var follow_speed: float = 6.0
@export var camera_zoom: float = 0.5  # Smaller = wider view of the room

func _ready() -> void:
	# Set the lens zoom
	zoom = Vector2(camera_zoom, camera_zoom)
	
	# If not assigned in Inspector, find Bob automatically
	if not target:
		target = get_parent().get_node_or_null("Bob")
	
	# Immediately snap to Bob on spawn (no weird opening drift)
	if target:
		global_position = target.global_position

func _physics_process(delta: float) -> void:
	if not target:
		return
	
	# Smoothly interpolate towards Bob's exact center
	# Using lerp inside _physics_process eliminates jitter with CharacterBody2D
	global_position = global_position.lerp(target.global_position, follow_speed * delta)
