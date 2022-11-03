extends Spatial

signal checkpoint_reached(body)
signal loop_end_reached(body)

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

func get_revive_position() -> Vector3:
	return ($Position3D as Position3D).global_translation

func on_myArea_body_entered(body : Spatial):
	# is body player?
	if body.get_parent().is_in_group("player"):
		# yes:
		var player = body.get_parent()
		## Are we the next checkpoint for the player?
		if player.get_next_checkpoint() == self:
			## yes:
			### Am I end of the race?
			if isEnd:
				### yes:
				#### signal loop_end_reached
				player.increase_loop_number()
				emit_signal("loop_end_reached", player)
			else:
				### no:
				### trigger checkpoint_reached
				### set next checkpoint for the player
				player.set_next_checkpoint(get_node(nextCheck))
				emit_signal("checkpoint_reached", player)
		else:
			print("not today")
			player.set_next_position(get_revive_position())
