extends Area2D

var anim = 0

func _process(delta):
	anim = wrapf(anim+4*delta,0,4)
	$sprite.frame = [2,3,4,3][int(self.anim)]

func _on_coin_body_entered(body):
	queue_free()
	
