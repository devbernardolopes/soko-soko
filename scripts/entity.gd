@tool
class_name Entity
extends BaseScene

enum State {
	IDLE,
	WALK_UP,
	WALK_RIGHT,
	WALK_DOWN,
	WALK_LEFT,
}

const ANIMATION_IDLE: StringName = &"down"
const ANIMATION_WALK_UP: StringName = &"up"
const ANIMATION_WALK_RIGHT: StringName = &"right"
const ANIMATION_WALK_DOWN: StringName = &"down"
const ANIMATION_WALK_LEFT: StringName = &"left"

@export_tool_button("Snap") var snap: Callable = _snap
# @export var move_speed: float = 32.0
@export var move_duration: float = 0.15   # seconds to travel one tile (tune this)

var controller: EntityController = null
var facing: float = 1.0
var state: State = State.IDLE:
	set(v):
		state = v
		print(v)
var _last_state: State = State.IDLE
var move_from: Vector2 = Vector2.ZERO
var move_to: Vector2 = Vector2.ZERO
var _move_tween: Tween = null


func _snap() -> void:
	position = (position / Helper.BASE_ENTITY_LENGTH).round() * Helper.BASE_ENTITY_LENGTH
	if collision:
		print(collision.shape.get_rect())


func _ready() -> void:
	super._ready()
	if not Engine.is_editor_hint():
		if not controller:
			controller = Helper.find_control(self, "PlayerController")
	_play_state_animation()


func _process_input() -> void:
	if not controller:
		return
	if state != State.IDLE:
		return
	var dir: Vector2 = controller.get_move_intent()
	# Prefer cardinal directions only (Sokoban almost never wants diagonals)
	if abs(dir.x) > abs(dir.y):
		dir = Vector2(sign(dir.x), 0.0)
	elif abs(dir.y) > 0.0:
		dir = Vector2(0.0, sign(dir.y))
	else:
		return
	# Current grid cell (assumes you are already snapped)
	move_from = (position / Helper.BASE_ENTITY_LENGTH).round()
	move_to = move_from + dir
	# Set facing / animation state
	if dir == Vector2.UP:
		state = State.WALK_UP
	elif dir == Vector2.RIGHT:
		state = State.WALK_RIGHT
	elif dir == Vector2.DOWN:
		state = State.WALK_DOWN
	elif dir == Vector2.LEFT:
		state = State.WALK_LEFT
	_start_move()


func _start_move() -> void:
	# Kill any previous tween just in case
	if _move_tween and _move_tween.is_valid():
		_move_tween.kill()
	var target_pos := move_to * Helper.BASE_ENTITY_LENGTH
	_move_tween = create_tween()
	_move_tween.set_trans(Tween.TRANS_LINEAR)   # or TRANS_SINE / TRANS_QUAD for a softer feel
	_move_tween.set_ease(Tween.EASE_IN_OUT)
	_move_tween.tween_property(self, "position", target_pos, move_duration)
	_move_tween.finished.connect(_on_move_finished, CONNECT_ONE_SHOT)


func _on_move_finished() -> void:
	# Guarantee we land exactly on the grid
	position = move_to * Helper.BASE_ENTITY_LENGTH
	state = State.IDLE
	_move_tween = null


func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		_process_input()


func _play_animation(animation: StringName, speed: float = 1.0) -> void:
	if not visual:
		return
	if not visual.sprite_frames.has_animation(animation):
		return
	visual.play(animation, speed)


func _play_state_animation() -> void:
	if state == _last_state:
		return
	_last_state = state
	match state:
		State.IDLE:
			_play_animation(ANIMATION_IDLE, 1.0)
		State.WALK_UP:
			_play_animation(ANIMATION_WALK_UP, 1.0)
		State.WALK_RIGHT:
			_play_animation(ANIMATION_WALK_RIGHT, 1.0)
		State.WALK_DOWN:
			_play_animation(ANIMATION_WALK_DOWN, 1.0)
		State.WALK_LEFT:
			_play_animation(ANIMATION_WALK_LEFT, 1.0)
