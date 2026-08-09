extends Area2D

var speed = 2000
var direction = Vector2.RIGHT
var bul = 0
@onready var sprite = $AnimatedSprite2D 

func setup(spawn_position: Vector2, spawn_rotation: float):
	global_position = spawn_position
	rotation = spawn_rotation
	direction = Vector2.RIGHT.rotated(spawn_rotation)
	

func _physics_process(delta):
	position += direction * speed * delta
	if (Player.is_hyper):
		speed = 2400
		sprite.play("hyper")
	else:
		speed = 1500
		sprite.play("regular")

func _on_area_entered(area: Area2D) -> void:
	if "obstacle" in area.name.to_lower() or area.is_in_group("obstacles"):

		if area.get_meta("is_breaking", false):
			return

		var obstacle_sprite = area.get_node_or_null("AnimatedSprite2D")
		if obstacle_sprite:
			var current_anim = obstacle_sprite.animation
			var breakable_animations = ["ore1", "ore2", "ore3", "ore4", "ore5", "ore7","gas tank", "oref1", "oref2", "gem"]
			
			if current_anim in breakable_animations:
				if not area.has_meta("hp"):
					area.set_meta("hp", 2)
				
				var current_hp = area.get_meta("hp") - 1
				area.set_meta("hp", current_hp)
				
				
				var tween = create_tween()
				tween.tween_property(obstacle_sprite, "modulate", Color.RED, 0.05)
				tween.tween_property(obstacle_sprite, "modulate", Color.WHITE, 0.05)
				
				if current_hp <= 0:
					trigger_obstacle_destruction(area, obstacle_sprite)
				if current_anim in ["gas tank", "oref1", "oref2", "gem"]:
					if Player.charge + 500 <= 2000:
						Player.charge += 500
					else:
						Player.charge = 2000
				Player.score += 10000
				queue_free() 
			else:
				queue_free()

func trigger_obstacle_destruction(obstacle: Area2D, obstacle_sprite: AnimatedSprite2D):
	obstacle.set_meta("is_breaking", true)
	obstacle.set_physics_process(false) 
	obstacle.monitoring = false
	obstacle.monitorable = false
	
	if obstacle_sprite.sprite_frames.has_animation("explosion"):
		obstacle_sprite.play("explosion")
		if not obstacle_sprite.animation_finished.is_connected(obstacle.queue_free):
			obstacle_sprite.animation_finished.connect(obstacle.queue_free)
	else:
		obstacle.queue_free()
