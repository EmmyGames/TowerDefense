extends Camera

export var border_top: float
export var border_right: float
export var border_bottom: float
export var border_left: float
export var MAX_ZOOM: float
export var pan_speed: float

var _target_zoom: float
var zoom: float

const MIN_ZOOM: float = 10.0
const ZOOM_INCREMENT: float = 0.5
const ZOOM_RATE: float = 8.0


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	zoom = global_transform.origin.y
	_target_zoom = zoom


func _physics_process(delta: float) -> void:
	zoom = lerp(zoom, _target_zoom, ZOOM_RATE * delta)
	global_transform.origin = Vector3(global_transform.origin.x, zoom, global_transform.origin.z)
	set_physics_process(not is_equal_approx(zoom, _target_zoom))


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == BUTTON_MASK_RIGHT:
			var mouseMovement = Vector3(event.relative.x, 0, event.relative.y)
			var new_transform = global_transform.origin - mouseMovement * pan_speed * 0.01 * zoom
			new_transform.x = max(new_transform.x, border_left)
			new_transform.x = min(new_transform.x, border_right)
			new_transform.z = max(new_transform.z, border_bottom)
			new_transform.z = min(new_transform.z, border_top)
			global_transform.origin = new_transform 
	if event is InputEventMouse:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				zoom_in()
			if event.button_index == BUTTON_WHEEL_DOWN:
				zoom_out()


func zoom_in() -> void:
	_target_zoom = max(_target_zoom - ZOOM_INCREMENT, MIN_ZOOM)
	set_physics_process(true)


func zoom_out() -> void:
	_target_zoom = min(_target_zoom + ZOOM_INCREMENT, MAX_ZOOM)
	set_physics_process(true)
