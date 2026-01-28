extends Node2D

@export var ham : AnimatedSprite2D
@export var g1: Sprite2D
@export var g2: Sprite2D
@export var g3: Sprite2D
@export var g4: Sprite2D
@export var g5: Sprite2D

const MIN_VALUE := 0.0
const MAX_VALUE := 130.0
const STEP := 10.0
const MILESTONE_COUNT := 13 # 0..12 (0–120)

var value : float = 0.0
var milestone_index := 0
var last_milestone_index := 0

const MAX_MILESTONE := 120

@export var flying_image_scene: PackedScene

const milestone_images := {
	10: [
		preload("res://Ham_Photos/Feb25_1.jpg"),
		preload("res://Ham_Photos/Feb25_2.jpg"),
	],
	20: [
		preload("res://Ham_Photos/Mar25_1.jpg"),
		preload("res://Ham_Photos/Mar25_2.jpg")
	],
	30: [
		preload("res://Ham_Photos/Apr25_1.jpg"),
		preload("res://Ham_Photos/Apr25_2.jpg")
	],
	40: [
		preload("res://Ham_Photos/May25_1.jpg"),
		preload("res://Ham_Photos/May25_2.jpg")
		
	],
	50: [
		preload("res://Ham_Photos/June25_1.jpg"),
		preload("res://Ham_Photos/June25_2.jpg")
	],
	60: [
		preload("res://Ham_Photos/July25_1.jpg"),
		preload("res://Ham_Photos/July25_2.jpg")
	],
	70: [
		preload("res://Ham_Photos/Aug25_1.jpg"),
		preload("res://Ham_Photos/Aug25_2.jpg")
	],
	80: [
		preload("res://Ham_Photos/Sep25_1.jpg"),
		preload("res://Ham_Photos/Sep25_2.jpg")
	],
	90: [
		preload("res://Ham_Photos/Oct25_1.jpg"),
		preload("res://Ham_Photos/Oct25_2.jpg")
	],
	100: [
		preload("res://Ham_Photos/Nov25_1.jpg"),
		preload("res://Ham_Photos/Nov25_2.jpg")
	],
	110: [
		preload("res://Ham_Photos/Dec25_1.jpg"),
		preload("res://Ham_Photos/Dec25_2.jpg")
	],
	120: [
		preload("res://Ham_Photos/Jan25_1.JPG"),
		preload("res://Ham_Photos/Jan25_2.JPG")
	]
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(5.0).timeout
	tween_cam()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		value += 1.0 * delta
		#print(value)
		ham.scale.x = 0.5
		ham.play("walk")
		g1.rotation -= 0.1 * delta
		g2.rotation -= 0.15 * delta
		g3.rotation -= 0.2 * delta
		g4.rotation -= 0.2 * delta
		g5.rotation -= 0.15 * delta
	if Input.is_action_just_released("ui_right"):
		ham.scale.x = 0.5
		ham.play("idle")
	if Input.is_action_pressed("ui_left"):
		value -= 1.0 * delta
		print(value)
		ham.scale.x = -0.5
		ham.play("walk")
		g1.rotation += 0.1 * delta
		g2.rotation += 0.15 * delta
		g3.rotation += 0.2 * delta
		g4.rotation += 0.2 * delta
		g5.rotation += 0.15 * delta
	if Input.is_action_just_released("ui_left"):
		ham.scale.x = -0.5
		ham.play("idle")
	
	# 1️⃣ Wrap value
	if value < 0.0:
		value += MAX_VALUE
	elif value >= MAX_VALUE:
		value -= MAX_VALUE

	# 2️⃣ Convert float → milestone index
	milestone_index = int(value / STEP)

	# 3️⃣ Detect milestone crossing
	if milestone_index != last_milestone_index:
		var diff = (milestone_index - last_milestone_index + MILESTONE_COUNT) % MILESTONE_COUNT
		var forward = diff == 1

		var milestone_value = milestone_index * STEP
		trigger_milestone(int(milestone_value), forward)

		last_milestone_index = milestone_index

func trigger_milestone(milestone: int, forward: bool):
	if not milestone_images.has(milestone):
		print("no images")
		return
	
	var textures = milestone_images[milestone]
	
	if forward: 
		for tex in textures:
			spawn_flying_image(tex)
			await get_tree().create_timer(1.8).timeout
	else:
		for i in range(textures.size() - 1, -1, -1):
			spawn_flying_image(textures[i])
			await get_tree().create_timer(1.8).timeout

func spawn_flying_image(texture: CompressedTexture2D):
	$SFX.pitch_scale = randf_range(0.8,1.3)
	$SFX.play()
	var img = flying_image_scene.instantiate()
	add_child(img)
	
	img.global_position = Vector2(0, -150)
	
	img.set_texture(texture)
	print("Spawning image:",texture)

func tween_cam():
	var tween = get_tree().create_tween()
	tween.tween_property($Camera2D,"zoom",Vector2(2.55,2.55),5).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property($Camera2D,"position:y",-350,4).set_ease(Tween.EASE_IN_OUT)


func _on_button_2_pressed() -> void:
	get_tree().create_timer(1.0).timeout
	get_tree().quit()


func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$CharlieBrown.stop()
		$Spongebob.play()
	else:
		$Spongebob.stop()
		$CharlieBrown.play()
