@tool
extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

@onready var grid = get_node("/root/main/grid")

func round_pos(pos):
	var mod = [fposmod(pos.x,grid.step),fposmod(pos.y,grid.step)]
	for i in range(2):
		if mod[i] != 0.:
			pos[i] = pos[i] - mod[i]
	return pos


func _input(event):
	if event is InputEventMouseButton and event.pressed:
		print("mouse pos: ",grid.mous_pos,", astar id: ",round_pos(grid.mous_pos)/grid.step, ", weight: ",grid.astar.map.get_point_weight_scale(round_pos(grid.mous_pos)/grid.step))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
