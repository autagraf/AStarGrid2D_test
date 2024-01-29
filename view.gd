@tool
extends Camera2D

func _ready():
	pass

var zoom_target:float = 1:
	set(val):
		zoom_target = val

var move_step:float = 16
var start_point = null
var start_position = null
var mous_pos
var new_mous_pos

var zoom_speed = 0.5
var panning = false
var delta = Vector2(0,0)

signal view_change(zoom_target, offset_target)
signal view_change_compl(zoom_target, offset_target)

func _input(event):
	if event.is_action_pressed("MIDDLE"):
		start_point = event.position
		start_position = offset
	if event.is_action_released("MIDDLE"):
		start_point = null
		view_change_compl.emit(zoom_target, offset)
	if start_point != null:
		offset = start_position + (start_point - event.position)/zoom_target
		view_change.emit(zoom_target, offset)
	if event.is_action("UP") or event.is_action("DOWN"):
		offset.y = offset.y + Input.get_axis("DOWN","UP")*move_step
		view_change.emit(zoom_target, offset)
		view_change_compl.emit(zoom_target, offset)
	if event.is_action("LEFT") or event.is_action("RIGHT"):
		offset.x = offset.x + Input.get_axis("LEFT","RIGHT")*move_step
		view_change.emit(zoom_target, offset)
		view_change_compl.emit(zoom_target, offset)
	if event.is_action_pressed("ZOOM_IN") or event.is_action_pressed("ZOOM_OUT"):
		zoom_target = clamp(zoom_target*pow(1.1, Input.get_axis("ZOOM_OUT","ZOOM_IN")), .21, 100)
		mous_pos = get_global_mouse_position()
	pass


func _process(delta):
	if mous_pos!=null:
		_zoom(delta)
	pass

func _zoom(delta):
	if snapped(zoom.x/zoom_target, 0.00001) != snapped(zoom_target/zoom_target, 0.00001):
		var zoomTmp = lerp(zoom.x, zoom_target, 10 * delta)
		mous_pos = get_global_mouse_position()
		zoom = Vector2(zoomTmp,zoomTmp)
		new_mous_pos = get_global_mouse_position()
		offset += (mous_pos-new_mous_pos)
		view_change.emit(zoom_target, offset)
	elif snapped(zoom.x/zoom_target, 0.00001) == snapped(zoom_target/zoom_target, 0.00001):
		view_change_compl.emit(zoom_target, offset)
		mous_pos = null
	pass
