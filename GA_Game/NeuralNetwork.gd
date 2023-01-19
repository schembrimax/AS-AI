class_name NeuralNetwork

var n_weights
var random_range
var weights = { "rotation":[], "speed":[] }
var output_rotation = 0.0
var output_speed = 0
var k = 3

func _init(n):
	n_weights = n+1
	random_range = 1.0 / n_weights
	for i in n_weights:
		weights["rotation"].append(0.0)
		weights["speed"].append(0.0)

func randomize_weights():
	for i in n_weights:
		weights["rotation"][i] = randf()* random_range *2 - random_range
		weights["speed"][i] = randf()* random_range *2 - random_range


func merge(net1, net2, mut_rate):
	var source_net = net1 if randf()>0.5 else net2
	
	for i in n_weights:
		weights["rotation"][i]= source_net.weights["rotation"][i] + 0 if randf()>mut_rate else randf()* random_range*2 -random_range
		source_net = net1 if randf()>0.5 else net2
		
	for i in n_weights:
		weights["speed"][i]= source_net.weights["speed"][i] + 0 if randf()>mut_rate else randf()* random_range*2 -random_range
		source_net = net1 if randf()>0.5 else net2
	

func spread(inputs):
	var rotation_pot = 0
	var speed_pot = 0
	
	for i in n_weights:
		rotation_pot += inputs[i]*weights["rotation"][i]
		speed_pot += inputs[i]*weights["speed"][i]
	
	output_rotation = sigmoid(rotation_pot) *2 - 1
	output_speed = sigmoid(speed_pot)


func sigmoid(pot):
	return (1/(1+exp(-k*pot)))

