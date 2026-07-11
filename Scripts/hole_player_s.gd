extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14
@export var player_score: int = 0
@export var scale_rate: int = 1.05


var target_velocity = Vector3.ZERO


enum Mode {ATTACK, DEFEND}
var mode: Mode = Mode.ATTACK

@export var attackModeTimer: int = 100
var attackModeTimerRemaining: int = 0
@export var turret: PackedScene
@export var turret_cost = 10

func _physics_process(delta):
	
	if(mode == Mode.ATTACK):
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
	if area.is_in_group("pickup"):
		if "point_value" in area:
		# 1. Access the pickup data and add points
			player_score += area.point_value
			print("Player Score: ", player_score)
			scale *= scale_rate
			area.queue_free()
		
	pass # Replace with function body.
	
	
func _process(delta: float) -> void:

	# swapping
	if (attackModeTimerRemaining >= attackModeTimer):
		mode = Mode.DEFEND

	if(mode == Mode.ATTACK):
		attackModeTimerRemaining += delta
	elif (mode == Mode.DEFEND):
		pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse") and mode == Mode.DEFEND:
		player_score -= turret_cost
		print("TEST")
		var mouse_pos = event.position
		print(mouse_pos)
		var camera3d = $Camera3D
		var from = camera3d.project_ray_origin(mouse_pos)
		var to = from + camera3d.project_ray_normal(mouse_pos) * 1000
		var query = PhysicsRayQueryParameters3D.create(from, to)
		query.collision_mask = 1
		var result = get_world_3d().direct_space_state.intersect_ray(query)

		if result:
			var turret_instance = turret.instantiate()
			turret_instance.position = Vector3(result.position.x,0,result.position.z)
			get_parent().add_child(turret_instance)
