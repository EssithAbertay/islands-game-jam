extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14
@export var player_score: int = 0
@export var scale_rate: float = 1.001
@export var scale_up_timer_max: float = .8
var scale_up_timer: float = 0
var new_scale: Vector3 = Vector3(0,0,0)
var scaling: bool = false

#need x xp to beat a stage which will up ur size and reset ur xp 
@export var current_stage: int = 0
@export var stage_count: int = 20
@export var xp: int = 0
@export var level_thresholds: Array[int] = [0, 10, 30, 70, 150, 300, 600, 1200, 2500, 5000]


func _process(delta):
	# scaling
	scale_up_timer += delta
	if (scaling == true):
		if (scale_up_timer <= scale_up_timer_max):
			new_scale = scale * scale_rate
			scale = new_scale + (scale - new_scale) * scale_up_timer
		else: 
			scale_up_timer = 0
			scaling = false
	
	

func _on_collection_area_area_entered(area: Area3D) -> void:
	if area.is_in_group("pickup"):
		if "point_value" in area && (scale >= area.scale):
		# 1. Access the pickup data and add points
			player_score += area.point_value
			print("Player Score: ", player_score)
			
			xp += area.point_value
			print("XP: ", xp)
			check_level_up()
			
			scale_up_timer = 0
			area.queue_free()
		
	pass # Replace with function body.
	
func check_level_up() -> void:
	if (current_stage < 10):
		if xp >= level_thresholds[current_stage]:
			scaling = true
			current_stage += 1

	
func _physics_process(delta):

	if Input.is_action_pressed("move_right"):
		position.x += 1
	if Input.is_action_pressed("move_left"):
		position.x -= 1
	if Input.is_action_pressed("move_back"):
		position.z += 1
	if Input.is_action_pressed("move_forward"):
		position.z -= 1
	move_and_slide()
