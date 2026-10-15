extends Node2D

func _on_enterroom_2_trigger_body_entered(body: Node2D) -> void:
	if body.name == "Bob":
		$room1/Camera2D.global_position = $room2.global_position
