extends Enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	
func _physics_process(delta: float) -> void:
	# move towards point
	var direction: Vector3
	direction =  target - global_position
	position += ((direction.normalized()) * speed * delta)
	pass
