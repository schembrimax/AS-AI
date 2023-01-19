extends Node2D

var agent_scene = preload("res://Scenes/SpaceShip.tscn")
var agents = []
var dead_agents = []
var current_generation = 0
const n_agents = 21


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	new_generation()
	pass # Replace with function body.

func replicate():
	dead_agents.sort_custom(Agent, "sort_descending")
	print_fitness_stats()
	current_generation +=1
		
	for i in 6:
		for k in range(i+1, 7):
			var new_agent = mate(dead_agents[i], dead_agents[k])
			agents.append(new_agent)
	
	for a in dead_agents:
		a.queue_free()
		
	dead_agents.clear()
	
	pass
	
	
func mate(agent1, agent2):
	var new_agent = agent_scene.instance()
	$Path2D/PathFollow2D.unit_offset = randf()
	new_agent.position = $Path2D/PathFollow2D.position
	new_agent.rotate(randf()* 2*PI) #rotate randomly
	add_child(new_agent)
	new_agent.neural_network.merge(agent1.neural_network, agent2.neural_network, 0.1)
	return new_agent

func new_generation():
	current_generation=1
	for i in n_agents:
		var new_agent = agent_scene.instance()
		$Path2D/PathFollow2D.unit_offset = randf()
		new_agent.position = $Path2D/PathFollow2D.position
		new_agent.rotate(randf()* 2*PI)
		add_child(new_agent)
		agents.append(new_agent)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for a in agents:
		if a.alive:
			a.step()
		else:
			kill(a)
			
	if agents.size() == 0:
		replicate()	
		
	pass

func print_fitness_stats():
	var mean_fit = 0
	for a in dead_agents:
		mean_fit += a.fitness
		
	mean_fit = mean_fit / dead_agents.size()
	print(" generation "+str(current_generation)+"  best_fit= "+ str(dead_agents[0].fitness)+ "  mean_fit="+str(mean_fit))

func kill(agent):
	agents.erase(agent)
	agent.visible = false
	agent.explode()
	dead_agents.append(agent)
