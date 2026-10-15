extends Area2D
var choices=[
	"Nice try. Nothing in here",
	"Oh. A new nothing",
	"Bread. Non edible"
]
@export var target_scene: String = "res://map_3.tscn"

var player_nearby: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _physics_process(_delta: float) -> void:
	# If Bob is standing in the doorway and presses interact:
	if player_nearby and Input.is_action_just_pressed("interact"):
		print(choices.pick_random())

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = true
		print("Press interact to open box!")

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = false
