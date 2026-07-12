class_name Enemy
extends CharacterBody3D

@export var speed = 5
@export var target: Vector3
@export var maxHealth = 10
var currentHealth = 10
var sprite3d
var flashDamage: bool = false
@export var flashDamageTime = 0.2
var flashDamageTimeRemaining = 0
@export var value = 7
const RED = preload("uid://bw2m1jg45241p")
var original_material
@onready var bote: MeshInstance3D = $Bote/Plane

func takeDamage(damage: int) -> void:
	currentHealth -= damage
	flashDamage = true
	print(currentHealth)
	checkStatus()

func checkStatus():
	if (currentHealth <= 0):
		GameState.player_score += value
		queue_free()
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print($Bote.get_children())
	original_material = bote.get_active_material(0)

	sprite3d = get_node("Bote")
	currentHealth = maxHealth
	print(currentHealth)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(flashDamage):
		bote.set_surface_override_material(0,RED)
		flashDamageTimeRemaining += delta
		if(flashDamageTimeRemaining >= flashDamageTime):
			flashDamage = false
			bote.set_surface_override_material(0, original_material)
