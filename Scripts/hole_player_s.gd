extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14
@export var player_score: int = 0
@export var scale_rate: float = 1.001
@export var scale_up_timer_max: float = .8
var scale_up_timer: float = 0
var new_scale: Vector3 = Vector3(0,0,0)
var scaling: bool = false
var is_moving: bool = false

#need x xp to beat a stage which will up ur size and reset ur xp 
@export var current_stage: int = 0
@export var stage_count: int = 20
@export var xp: int = 0
@export var level_thresholds: Array[int] = [0, 10, 30, 70, 150, 300, 600, 1200, 2500, 5000]
@export var tex_array: Array[Texture2D] = [load("res://Assets/castle8.png"), load("res://Assets/castle7.png"), load("res://Assets/castle9.png"), load("res://Assets/castle6.png"), load("res://Assets/castle10.png")]

enum Mode {ATTACK, DEFEND}
var mode: Mode = Mode.ATTACK

@export var attackModeTimer: int = 100
var attackModeTimerRemaining: float = 0
@export var turret: PackedScene

@onready var level_r: Control = $"../CanvasLayer/Control/VBoxContainer/Level"
@onready var mode_r: Control = $"../CanvasLayer/Control/VBoxContainer/Mode"
@onready var sand_r: Control = $"../CanvasLayer/Control/VBoxContainer/Sand"
@onready var time_r: Control = $"../CanvasLayer/Control/Time"
@onready var popup_r: Control = $"../CanvasLayer/Control/Popup"
@onready var enemies_remaining_r: Control = $"../CanvasLayer/Control/EnemiesRemaining"

@onready var cam = $Camera3D
@onready var ocean: Sprite3D = $"../Sprite3D"

var goToDefend: bool = false
@export var waveCd:float = 3
var waveCdRemaining:float = 0
var wavesSpawned:int = 0
var wavesAllSpawned:bool=false

func _ready() -> void:
	if tex_array.size() > 0:
		$Sprite3D.texture = tex_array[0]
	popup_r.visible = false
	enemies_remaining_r.visible = false

func _input(event: InputEvent) -> void:
	if(GameState.mode == GameState.Mode.DEFEND or GameState.mode == GameState.Mode.SETUP):
		if event.is_action_pressed("left_mouse"):
			print("Tryna build turret")
			if(GameState.player_score >= GameState.turretCost):
				GameState.player_score -= GameState.turretCost
				
				GameState.turretCost *= GameState.turretCostScaling
				
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
					
	if(GameState.mode == GameState.Mode.SETUP):
		if(Input.is_action_pressed("space")):
			goToDefend = true

func _process(delta):
	# scaling
	scale_up_timer += delta
	if (scaling == true):
		if (scale_up_timer <= scale_up_timer_max):
			new_scale = scale * scale_rate
			scale = new_scale + (scale - new_scale) * scale_up_timer
			$CPUParticles3D_level.emitting = true;
		else: 
			scale_up_timer = 0
			scaling = false
			$CPUParticles3D_level.emitting = false;
	  
	# swapping
	if(GameState.mode == GameState.Mode.ATTACK):
		attackModeTimerRemaining += delta	
		
		# moving to setup mode
		if (attackModeTimerRemaining >= attackModeTimer):
			GameState.mode = GameState.Mode.SETUP
			attackModeTimerRemaining = attackModeTimer
			cam.position.y *=2
			popup_r.visible = true
			time_r.visible = false
	# going to defend
	elif(GameState.mode == GameState.Mode.SETUP):
		if(goToDefend):
			goToDefend = false
			GameState.mode = GameState.Mode.DEFEND
			enemies_remaining_r.visible = true
			popup_r.visible = false
			
			waveCdRemaining = waveCd - 1.5
	# moving bacck to attack mode when enemies are dead
	elif (GameState.mode == GameState.Mode.DEFEND):
		if(!wavesAllSpawned):
			waveCdRemaining += delta
			if (waveCdRemaining < waveCd and GameState.spawnWave):
				GameState.spawnWave = false
				
			if (waveCdRemaining >= waveCd):
				waveCdRemaining = 0
				GameState.spawnWave = true
				wavesSpawned += 1
				
			if(wavesSpawned >= GameState.numberOfWavesToSpawn):
				GameState.spawnWave = false
				wavesAllSpawned = true
		else:
			# wait till all enemies defeated to carry on
			if(get_tree().get_nodes_in_group("enemy").size() <= 0):
				GameState.mode = GameState.Mode.SETUPATTACK
				popup_r.visible = true
				enemies_remaining_r.visible = false
				popup_r.get_node("Label").text = "All enemies in wave defated!\n Press space to continue"
		
	elif (GameState.mode == GameState.Mode.SETUPATTACK):
		time_r.visible=true
	
	updateGameState()

func _on_collection_area_area_entered(area: Area3D) -> void:
	if area.is_in_group("pickup"):
		if "point_value" in area && (scale >= area.scale):
		# 1. Access the pickup data and add points
			GameState.player_score += area.point_value
			print("Player Score: ", GameState.player_score)
			$"AudioStreamPlayer-pickup".play()
			
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
				$Sprite3D.texture = tex_array[current_stage/2]
				$"AudioStreamPlayer-levelup".play()

func _physics_process(delta):
	is_moving = false
	if(GameState.mode == GameState.Mode.ATTACK):
		var direction = Vector3.ZERO


		print((ocean.global_position.x + ((ocean.texture.get_width()/2) * ocean.scale.x))*ocean.pixel_size-15)
		print((ocean.global_position.x - ((ocean.texture.get_width()/2) * ocean.scale.x))*ocean.pixel_size+15)
		print((ocean.global_position.z + ((ocean.texture.get_height()/2) * ocean.scale.z))*ocean.pixel_size-15)
		print((ocean.global_position.z -((ocean.texture.get_height()/2) * ocean.scale.z))*ocean.pixel_size+15)
		
		if Input.is_action_pressed("move_right") and position.x < (ocean.global_position.x + ((ocean.texture.get_width()/2) * ocean.scale.x))*ocean.pixel_size-15:
			position.x += 1
			is_moving = true;
		if Input.is_action_pressed("move_left") and position.x > (ocean.global_position.x - ((ocean.texture.get_width()/2) * ocean.scale.x))*ocean.pixel_size+15:
			position.x -= 1
			is_moving = true;
		if Input.is_action_pressed("move_back") and position.z < (ocean.global_position.z + ((ocean.texture.get_height()/2) * ocean.scale.z))*ocean.pixel_size-15:
			position.z += 1
			is_moving = true;
		if Input.is_action_pressed("move_forward") and position.z > (ocean.global_position.z - ((ocean.texture.get_height()/2) * ocean.scale.z))*ocean.pixel_size+15:
			position.z -= 1
			is_moving = true;
		move_and_slide()
		
	else:
		if Input.is_action_pressed("move_right") and cam.position.x < (ocean.global_position.x + ((ocean.texture.get_width()/2) * ocean.scale.x))*ocean.pixel_size-15:
			cam.position.x += 1
		if Input.is_action_pressed("move_left") and cam.position.x > (ocean.global_position.x - ((ocean.texture.get_width()/2) * ocean.scale.x))*ocean.pixel_size+15:
			cam.position.x -= 1
		if Input.is_action_pressed("move_back") and cam.position.z < (ocean.global_position.z + ((ocean.texture.get_height()/2) * ocean.scale.z))*ocean.pixel_size-15:
			cam.position.z += 1
		if Input.is_action_pressed("move_forward") and cam.position.z > (ocean.global_position.z - ((ocean.texture.get_height()/2) * ocean.scale.z))*ocean.pixel_size+15:
			cam.position.z -= 1

func updateGameState():
	GameState.current_stage = current_stage

	level_r.get_node("Label").text = "Size Level: "+str(current_stage)
	sand_r.get_node("Label").text = "Sand: " + str(GameState.player_score)
	mode_r.get_node("Label").text = "Mode: " + "ATTACK" if GameState.mode == GameState.Mode.ATTACK else "DEFENCE"  if GameState.mode == GameState.Mode.DEFEND else "SETUP"
	time_r.get_node("Label").text = "Time Remaining \n: " + str(floor(attackModeTimer - attackModeTimerRemaining))
	GameState.is_moving = is_moving
