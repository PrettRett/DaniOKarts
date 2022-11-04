extends Spatial

signal race_finished

# Node references
onready var ball = $Ball
onready var car_mesh = $CarMesh
onready var ground_ray = $CarMesh/RayCastvariables

# Where to place the car mesh relative to the sphere
var sphere_offset = Vector3(0, -1.8, 0)
# Engine power
var acceleration = 30
# Turn amount, in degrees
var steering = 20.0
# How quickly the car turns
var turn_speed = 7
# Below this speed, the car doesn't turn
var turn_stop_limit = 2

# Variables for input values
var speed_input = 0
var rotate_input = 0

var nextCheckpoint : Spatial = null
var raceManager = null

var loopNumber : int = 0

func get_loop_number() -> int:
	return loopNumber

func increase_loop_number() -> void:
	loopNumber += 1
	if raceManager:
		if raceManager.has_method("get_loops_to_complete"):
			if loopNumber >= raceManager.get_loops_to_complete():
				emit_signal("race_finished")
				print("emitted")

func set_race_manager(raceMng) -> void:
	raceManager = raceMng

func get_next_checkpoint() -> Spatial:
	return nextCheckpoint

func set_next_checkpoint(nextCheck : Spatial) -> void:
	if nextCheck.has_method("get_revive_position"):
		nextCheckpoint = nextCheck
	
func set_next_position(position : Vector3):
	ball.global_transform.origin = position
	car_mesh.transform.origin = ball.transform.origin + sphere_offset

# Called when the node enters the scene tree for the first time.
func _ready():
	ground_ray.add_exception(ball)
	pass # Replace with function body.
	
func _physics_process(_delta):
	# Keep the car mesh aligned with the sphere
	car_mesh.transform.origin = ball.transform.origin + sphere_offset
	# Accelerate based on car's forward direction
	ball.add_central_force(-car_mesh.global_transform.basis.z * speed_input)
	
func _process(delta):
	# Can't steer/accelerate when in the air
	if not ground_ray.is_colliding():
		return
	# Get accelerate/brake input
	speed_input = 0
	speed_input += Input.get_action_strength("accelerate")
	speed_input -= Input.get_action_strength("brake")
	speed_input *= acceleration
	# Get steering input
	rotate_input = 0
	rotate_input += Input.get_action_strength("steer_left")
	rotate_input -= Input.get_action_strength("steer_right")
	rotate_input *= deg2rad(steering)
	
	if ball.linear_velocity.length() > turn_stop_limit:
		var new_basis = car_mesh.global_transform.basis.rotated(car_mesh.global_transform.basis.y,
				rotate_input)
		car_mesh.global_transform.basis = car_mesh.global_transform.basis.slerp(new_basis,
				turn_speed * delta)
		car_mesh.global_transform = car_mesh.global_transform.orthonormalized()
	
	# align with ground
	var n = ground_ray.get_collision_normal()
	var xform = align_with_y(car_mesh.global_transform, n.normalized())
	car_mesh.global_transform = car_mesh.global_transform.interpolate_with(xform, 10 * delta)

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
