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


enum Mode {ATTACK, DEFEND}
var mode: Mode = Mode.ATTACK

@export var attackModeTimer: int = 100
var attackModeTimerRemaining: float = 0
@export var turret: PackedScene
@export var turret_cost = 10

@onready var level_r: Control = $"../CanvasLayer/Control/VBoxContainer/Level"
@onready var mode_r: Control = $"../CanvasLayer/Control/VBoxContainer/Mode"
@onready var sand_r: Control = $"../CanvasLayer/Control/VBoxContainer/Sand"
@onready var time_r: Control = $"../CanvasLayer/Time"



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse") and mode == Mode.DEFEND:
		
		if(player_score >= turret_cost):
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
	  
	  	# swapping
	if (attackModeTimerRemaining >= attackModeTimer):
		mode = Mode.DEFEND

	if(mode == Mode.ATTACK):
		attackModeTimerRemaining += delta
	elif (mode == Mode.DEFEND):
		pass
		
		
		
		
	updateGameState()

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
			if current_stage % 2 == 0:
				$Sprite3D.texture = load("res://Assets/castle6.png")

	
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

func updateGameState():
	GameState.mode = int(mode)
	GameState.player_score = player_score
	GameState.current_stage = current_stage

	level_r.get_node("Label").text = "Size Level: "+str(current_stage)
	sand_r.get_node("Label").text = "Sand: " + str(player_score)
	mode_r.get_node("Label").text = "ATTACK" if mode==Mode.ATTACK else "DEFENCE"
	# time_r.get_node("Label").text = "Time Remaining \n: " + str(floor(attackModeTimer - attackModeTimerRemaining))
