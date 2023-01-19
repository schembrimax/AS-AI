extends Node2D

class_name Agent

var explosion_scene = preload("res://Scenes/Explosion.tscn")

var start_point
var alive = true
var sensors
var input_vector = []
var neural_network
var fitness = 0
var age = 0
var velocity =200
var sensor_field = 120
var MAX_AGE = 300

# Called when the node enters the scene tree for the first time.
func _ready():
	start_point = position
	$SpaceShipSprite.play("default")
	sensors = $SpaceShipSprite/Sensors.get_children()
	var n_sensors = sensors.size()
	neural_network = NeuralNetwork.new(sensors.size())
	neural_network.randomize_weights()
	
	var start_angle = -sensor_field/2
	var angle_step = sensor_field/(n_sensors-1)
	for i in n_sensors:
		sensors[i].rotation_degrees = start_angle+angle_step*i
		input_vector.append(0.0)
	input_vector.append(-1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_left"):
		rotate(-2*delta)
	if Input.is_action_pressed("ui_right"):
		rotate(2*delta)
	if Input.is_action_pressed("ui_up"):
		translate(Vector2.RIGHT.rotated(rotation)*velocity*delta)
	
func step():
	age += 1
	for i in sensors.size():
		input_vector[i] = sensors[i].read_sensor()
		
	neural_network.spread(input_vector)
	
	rotate(neural_network.output_rotation)
	translate( (Vector2.RIGHT*(neural_network.output_speed*5)).rotated(rotation))
	
	position.x = clamp(position.x, 0.0, 1024.0)
	position.y = clamp(position.y, 0.0, 600.0)
	
#	if position.x <0:
#		position.x+=1024
#	if position.x > 1024:
#		position.x = 0
#	if position.y <0:
#		position.y = 600
#	if position.y > 600:
#		position.y = 0
	
	if age>MAX_AGE:
		calc_fitness()
		alive = false

func calc_fitness():
	fitness = (position-start_point).length()
	#fitness = age

static func sort_descending(a1, a2):
	if a1.fitness > a2.fitness:
		return true
	else:
		return false

func explode():
	var expl = explosion_scene.instance()
	get_parent().add_child(expl)
	expl.position = position
	expl.play("explosion")


func _on_Area2D_area_entered(area):
	calc_fitness()
	alive = false
	#explode()
	pass # Replace with function body.

