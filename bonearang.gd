extends Area2D

@export var speed: float = 400.0
var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	# Connects body_entered directly in code so you don't even have to use the UI tab
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	# Fly in the assigned direction
	position += direction * speed * delta
	
	# Optional: Spin the boomerang while flying
	rotation += 15.0 * delta

func _on_body_entered(body: Node2D) -> void:
	# Don't hit Bob when thrown
	if body.name == "Bob":
		return
	
	# If it hits the Golem (or any enemy with frighten)
	if body.has_method("frighten"):
		body.frighten()
		queue_free()
		return
	
	# If it hits a solid wall or obstacle
	if body is StaticBody2D or body is TileMap:
		queue_free()
