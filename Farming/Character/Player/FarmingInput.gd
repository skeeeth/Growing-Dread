extends Node
@export var movement:Grid_Movement
@export var step_time:float = 0.16
@export var interaction:GridInteraction
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
#	pass

func _input(event):
	if event.is_action_pressed("up"):
		full_move(Vector2.UP)
		
	if event.is_action_pressed("left"):
		full_move(Vector2.LEFT)
		
	if event.is_action_pressed("right"):
		full_move(Vector2.RIGHT)
		
	if  event.is_action_pressed("down"):
		full_move(Vector2.DOWN)
	



func full_move(dir:Vector2,buffered:bool=false):
	#Stop movement on collision
	if movement.check_move(dir) == "c":
		return
	
	#If in the middle of a previous movement, buffer
	if movement.moving:
		await movement.movement_finished
		if buffered: return #only buffer once
		full_move(dir,true) #try again
		return
	
	#Finally, move
	movement.move(dir,step_time)
