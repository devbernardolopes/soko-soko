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

@export var move_speed: float = 100.0

var controller: EntityController = null
var facing: float = 1.0
var state: State = State.IDLE:
	set(v):
		state = v
		print(v)
var _last_state: State = State.IDLE
var move_from: Vector2 = Vector2.ZERO
var move_to: Vector2 = Vector2.ZERO


func _ready() -> void:
	super._ready()
	if not Engine.is_editor_hint():
		if not controller:
			controller = Helper.find_control(self, "PlayerController")
	_play_state_animation()


func _process_input() -> void:
	if not controller:
		return
	if not state == State.IDLE:
		return
	var dir: Vector2 = controller.get_move_intent()
	if not dir.is_zero_approx():
		move_from = position / Helper.BASE_ENTITY_LENGTH
		if dir.is_equal_approx(Vector2.UP):
			move_to = move_from + Vector2.UP
			state = State.WALK_UP
		if dir.is_equal_approx(Vector2.RIGHT):
			move_to = move_from + Vector2.RIGHT
			state = State.WALK_RIGHT
		if dir.is_equal_approx(Vector2.DOWN):
			move_to = move_from + Vector2.DOWN
			state = State.WALK_DOWN
		if dir.is_equal_approx(Vector2.LEFT):
			move_to = move_from + Vector2.LEFT
			state = State.WALK_LEFT


func _process_movement(delta: float) -> void:
	if state == State.IDLE:
		return
	if position.is_equal_approx(move_to * Helper.BASE_ENTITY_LENGTH):
		state = State.IDLE
		return
	position = position.lerp(move_to * Helper.BASE_ENTITY_LENGTH, 0.9 * delta * 32)


func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		_process_input()
		_process_movement(delta)


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
