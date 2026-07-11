extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14
@export var player_score: int = 0

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	
	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_right"):
		position.x += 1
	if Input.is_action_pressed("move_left"):
		position.x -= 1
	if Input.is_action_pressed("move_back"):
		position.z += 1
	if Input.is_action_pressed("move_forward"):
		position.z -= 1


	move_and_slide()


func _on_collection_area_area_entered(area: Area3D) -> void:
	print("f")
	if area.is_in_group("pickup"):
		if "point_value" in area:
		# 1. Access the pickup data and add points
			player_score += area.point_value
			print("Player Score: ", player_score)
			area.queue_free()
		
	pass # Replace with function body.
