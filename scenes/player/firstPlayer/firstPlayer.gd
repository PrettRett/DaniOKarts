extends Spatial

# Node references
onready var ball = $Ball
onready var car_mesh = $CarMesh
#onready var ground_ray = $CarMesh/RayCastvariables

# var a = 2
# var b = "text"

# Where to place the car mesh relative to the sphere
var sphere_offset = Vector3(0, -3.0, 0)
# Engine power
var acceleration = 150
# Turn amount, in degrees
var steering = 63.0
# How quickly the car turns
var turn_speed = 15
# Below this speed, the car doesn't turn
var turn_stop_limit = 0.75*3

# Variables for input values
var speed_input = 0
var rotate_input = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(_delta):
	# Keep the car mesh aligned with the sphere
	car_mesh.transform.origin = ball.transform.origin + sphere_offset
	# Accelerate based on car's forward direction
	ball.add_central_force(-car_mesh.global_transform.basis.z * speed_input)
	
func _process(delta):
	# Can't steer/accelerate when in the air
	#if not ground_ray.is_colliding():
	#    return
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
