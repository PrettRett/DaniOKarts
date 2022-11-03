extends Spatial

export (int) var loopsNumber = 2
export (NodePath) var mainPlayer = null

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var mainPlayerNode = null

onready var initialCheck = $ChkNodes/StartCheck

func get_loops_to_complete() -> int:
	return loopsNumber

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var players = get_tree().get_nodes_in_group("player")
	
	# Get number of player
	var numPlayers = players.size()
	
	# spawn players on initial positions
	for playerNode in players:
		#get initial position
		#set player to initial position
		
		# set initial checkpoint for the players
		playerNode.set_next_checkpoint(initialCheck)
		playerNode.set_race_manager(self)
	
	for checkObj in $ChkNodes.get_children():
		# connect checkpoints signal to its functions
		checkObj.connect("checkpoint_reached",self,"on_player_passingCheckpoint")
		checkObj.connect("loop_end_reached",self,"on_player_completingLoop")
	
	
	if mainPlayer:
		mainPlayerNode = get_node(mainPlayer)
		# connect main player race finished condition with end of race function 
		mainPlayerNode.connect("race_finished",self,"on_MainPlayer_userFinishedRace")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func on_player_passingCheckpoint(player):
	print("one player passed properly")

func on_player_completingLoop(player):
	if player.get_loop_number() <= loopsNumber:
		print("one player finished Loop")
		player.set_next_checkpoint(initialCheck)
	else:
		print ("player has finished")

func on_MainPlayer_userFinishedRace():
	print("i should close now")
	pass
