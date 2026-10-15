extends Area2D

# Just paste your destination scene path here!
@export var target_scene: String = "res://map_1.tscn"

var player_nearby: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _physics_process(_delta: float) -> void:
	# If Bob is standing in the doorway and presses interact:
	if player_nearby and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://map_1.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = true
		print("Press interact to enter door!")

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = false
