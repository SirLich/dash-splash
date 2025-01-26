extends Node


@export var OxygenSprite: PackedScene;
@export var BubbleSprite: PackedScene

var sprite_instances = []

func generate_sprites(sprite_instance,num):
	for _i in range(num):
		var sprite = sprite_instance.instance()
		add_child(sprite)
		sprite_instances.append(sprite)
		randomize_sprite_position(sprite)
		
func _ready():
	generate_sprites(OxygenSprite,5)

func randomize_sprite_position(sprite: Node2D):

	var menu_width = 1080
	var menu_height = 1920
	sprite.position = Vector2(randi() % int(menu_width), randi() % int(menu_height))
