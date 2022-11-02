extends Spatial

signal checkpoint_reached
signal loop_end_reached

export (NodePath) var checkArea = null
export (NodePath) var nextCheck = null

export (bool) var StartingCheck = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var isEnd : bool = true
var myArea : Area = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if checkArea:
		myArea = get_node(checkArea)
		
		myArea.connect("body_entered",self,"on_myArea_body_entered")
	
	if nextCheck:
		isEnd = false
	pass # Replace with function body.

func get_revive_position() -> Vector3:
	return ($Position3D as Position3D).global_translation


func on_myArea_body_entered(body : Node):
	# is body player?
	if body.is_in_group("player"):
		# yes:
		## Are we the next checkpoint for the player?
		if body.has_method("get_next_checkpoint"):
			if body.get_next_checkpoint() == self:
				## yes:
				### Am I end of the race?
				if isEnd:
					### yes:
					#### signal loop_end_reached
					emit_signal("loop_end_reached")
				else:
					### no:
					### trigger checkpoint_reached
					### set next checkpoint for the player
					emit_signal("checkpoint_reached")
					body.set_next_checkpoint(get_node(nextCheck))
