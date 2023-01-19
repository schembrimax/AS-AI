extends RayCast2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func read_sensor()->float:
	var return_value = 0.0
	
	if is_colliding():
		return_value = 1.0 - (get_collision_point()-global_position).length() / cast_to.x
		#print(" sensor value ="+ str(return_value))
	return return_value
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
