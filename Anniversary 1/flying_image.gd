extends CharacterBody2D

@export var gravity := 150.0
@export var min_throw_velocity := -300.0
@export var max_throw_velocity := -310.0
@export var horizontal_variation := 50.0

@onready var sprite: Sprite2D = $Sprite2D

func set_texture(texture: CompressedTexture2D):
	sprite.texture = texture

func _ready():
	velocity.y = randf_range(max_throw_velocity, min_throw_velocity)
	velocity.x = randf_range(-horizontal_variation, horizontal_variation)

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	move_and_slide()
	
	#rotation += velocity.x * 0.001
	
	if position.y > 1200:
		queue_free()
