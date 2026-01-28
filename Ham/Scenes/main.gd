extends Node2D

@onready var pos = $Lolly.position.y
var wiggle : bool = false
var lolly : bool = false
var heart : bool = false
var star : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self,"modulate:a",1,2)
	SoundManager.fade_in_bgm("Baby",2.0)
	await get_tree().create_timer(4).timeout
	var cantween = get_tree().create_tween()
	cantween.tween_property($Star,"modulate:a",1,4)
	cantween.parallel().tween_property($Lolly,"modulate:a",1,4)
	cantween.parallel().tween_property($Heart,"modulate:a",1,4)
	await get_tree().create_timer(5).timeout
	var hannahtween = get_tree().create_tween()
	hannahtween.tween_property($Hannah,"modulate:a",0,4)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# HARD LOLLY CANDY
func _on_lolly_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if wiggle == false: 
		if event.is_action_pressed("Click"):
			SoundManager.fade_into_bgm("Neck","Baby",5.0)
			$Lolly.position.y = -140
			camera_sequence($Lolly)


func _on_lolly_mouse_entered() -> void:
	print("mouse entered")
	if wiggle == true:
		var tween = get_tree().create_tween()
		tween.tween_property($Lolly, "rotation_degrees", -15,0.2)
	else:
		var tween = get_tree().create_tween()
		tween.tween_property($Lolly, "position:y", -140,0.3).set_ease(Tween.EASE_IN_OUT)


func _on_lolly_mouse_exited() -> void:
	if wiggle == true:
		var tween = get_tree().create_tween()
		tween.tween_property($Lolly, "rotation_degrees", 0,0.2)
	else:
		var tween = get_tree().create_tween()
		tween.tween_property($Lolly, "position:y", pos, 0.3).set_ease(Tween.EASE_IN_OUT)


# HEART CANDY
func _on_heart_mouse_entered() -> void:
	if wiggle == true:
		var tween = get_tree().create_tween()
		tween.tween_property($Heart, "rotation_degrees", -15,0.2)
	else:
		var tween = get_tree().create_tween()
		tween.tween_property($Heart, "position:y", -140,0.3).set_ease(Tween.EASE_IN_OUT)


func _on_heart_mouse_exited() -> void:
	if wiggle == true:
		var tween = get_tree().create_tween()
		tween.tween_property($Heart, "rotation_degrees", 0,0.2)
	else:
		var tween = get_tree().create_tween()
		tween.tween_property($Heart, "position:y", pos, 0.3).set_ease(Tween.EASE_IN_OUT)


func _on_heart_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if wiggle == false: 
		if event.is_action_pressed("Click"):
			SoundManager.fade_into_bgm("Finneas","Baby",5.0)
			$Heart.position.y = -140
			camera_sequence($Heart)



func _on_star_mouse_entered() -> void:
	if wiggle == true:
		var tween = get_tree().create_tween()
		tween.tween_property($Star, "rotation_degrees", -15,0.2)
	else:
		var tween = get_tree().create_tween()
		tween.tween_property($Star, "position:y", -140,0.3).set_ease(Tween.EASE_IN_OUT)


func _on_star_mouse_exited() -> void:
	if wiggle == true:
		var tween = get_tree().create_tween()
		tween.tween_property($Star, "rotation_degrees", 0,0.2)
	else:
		var tween = get_tree().create_tween()
		tween.tween_property($Star, "position:y", pos, 0.3).set_ease(Tween.EASE_IN_OUT)


func _on_star_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if wiggle == false:
		if event.is_action_pressed("Click"):
			SoundManager.fade_into_bgm("Dandelion","Baby",5.0)
			$Star.position.y = -140
			camera_sequence($Star)


func camera_sequence(candy: Area2D):
	var shape = candy.get_node("CollisionShape2D")
	shape.disabled = true
	var camtween = get_tree().create_tween()
	camtween.tween_property($Camera2D, "position:y", -2400, 4)
	var tween = get_tree().create_tween()
	tween.tween_property(candy, "position:y", -2400, 4)
	tween.parallel().tween_property(candy, "rotation_degrees",-10, 2)
	tween.finished.connect(unwrap.bind(candy))

func unwrap(candy):
	await get_tree().create_timer(2).timeout
	var wrapped = candy.get_node("Wrapped")
	wrapped.visible = false
	SoundManager.play_sfx("Unwrap")
	var shape = candy.get_node("CollisionShape2D")
	wiggle = true
	shape.disabled = false
	if candy.name == "Star": 
		var tween = get_tree().create_tween()
		tween.tween_property($StarWrap, "position:x", 0, 2)
	elif candy.name == "Lolly": 
		var tween = get_tree().create_tween()
		tween.tween_property($LollyWrap, "position:x", 0, 2)
	elif candy.name == "Heart": 
		var tween = get_tree().create_tween()
		tween.tween_property($HeartWrap, "position:x", 0, 2)


func _on_check_box_pressed() -> void:
	SoundManager.play_sfx("Unwrap")
	await get_tree().create_timer(2).timeout
	wiggle = false
	star = true
	if lolly == true and heart == true and star == true:
		end_sequence()
	SoundManager.fade_into_bgm("Baby","Dandelion",5.0)
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Star, "position:x", - 3000, 2)
	tween.tween_property($StarWrap, "position:x", 2229, 2)
	tween.tween_property($Camera2D,"position:y", 0, 4)


# WRAPPERS
func _on_star_wrap_mouse_entered() -> void:
		var tween = get_tree().create_tween()
		tween.tween_property($StarWrap, "position:y", -2450,0.2)
func _on_star_wrap_mouse_exited() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($StarWrap, "position:y", -2400,0.2)
func _on_lolly_wrap_mouse_entered() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($LollyWrap, "position:y", -2450,0.2)
func _on_lolly_wrap_mouse_exited() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($LollyWrap, "position:y", -2400,0.2)
func _on_heart_wrap_mouse_entered() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($HeartWrap, "position:y", -2450,0.2)
func _on_heart_wrap_mouse_exited() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($HeartWrap, "position:y", -2400,0.2)


func _on_lolly_check_pressed() -> void:
	SoundManager.play_sfx("Unwrap")
	await get_tree().create_timer(2).timeout
	wiggle = false
	lolly = true
	if lolly == true and heart == true and star == true:
		end_sequence()
	SoundManager.fade_into_bgm("Baby","Neck",5.0)
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Lolly, "position:x", 3000, 2)
	tween.tween_property($LollyWrap, "position:x", -2229, 2)
	tween.tween_property($Camera2D,"position:y", 0, 4)

func end_sequence():
	print("end")
	await get_tree().create_timer(5).timeout
	var tween = get_tree().create_tween()
	$End.play()
	tween.tween_property($End, "modulate:a",1,4)
	pass


func _on_heart_check_pressed() -> void:
	SoundManager.play_sfx("Unwrap")
	await get_tree().create_timer(2).timeout
	wiggle = false
	heart = true
	if lolly == true and heart == true and star == true:
		end_sequence()
	SoundManager.fade_into_bgm("Baby","Finneas",5.0)
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Heart, "position:x", -3000, 2)
	tween.tween_property($HeartWrap, "position:x", 2229, 2)
	tween.tween_property($Camera2D,"position:y", 0, 4)
