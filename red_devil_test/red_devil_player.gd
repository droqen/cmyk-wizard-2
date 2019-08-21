extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var pin = Vector2(0,0)
var jumpbuffered = 0
var floorbuffered = 0
var vel = Vector2(0,0)
var ani = 0

const xmaxspeed = 45;
const ymaxfall = 300;
const yjump = 105;
const ygravity = 200;
const ygravity_fastfall = 300;
const xbaseaccel = 230;

# Called when the node enters the scene tree for the first time.
func _ready():
	self.vel = Vector2(0,0)

func _input(_event):
	if Input.is_action_just_pressed("ui_up"): jumpbuffered = 0.1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if jumpbuffered>0: jumpbuffered -= delta
	if floorbuffered>0: floorbuffered -= delta
	updatePin()
	processMovement(delta)
	updateSprite(delta)
	
func moveTowards(a,b,d):
	if a+d<b: return a+d
	if a-d>b: return a-d
	return b
	
func updatePin():
	self.pin = Vector2(0,0)
	if(Input.is_action_pressed("ui_left")): self.pin.x -= 1
	if(Input.is_action_pressed("ui_right")): self.pin.x += 1
	if(Input.is_action_pressed("ui_up")): self.pin.y -= 1
	
func processMovement(delta):
	if self.is_on_floor():
		floorbuffered = 0.1
	if floorbuffered>0 and jumpbuffered>0:
		self.vel.y = -yjump
		floorbuffered = 0
		jumpbuffered = 0
	
	var yaccel = ygravity
	if self.vel.y < 0 and self.pin.y >= 0: yaccel = ygravity_fastfall
	self.vel.y += yaccel * delta
	
	var xaccel = xbaseaccel
	if self.pin.x == 0: xaccel *= 2
	self.vel.x = moveTowards(self.vel.x, self.pin.x * xmaxspeed, xaccel * delta)
	
	self.vel = move_and_slide(self.vel,Vector2.UP)

func updateSprite(delta):
	if self.pin.x != 0:
		$spr.flip_h = self.pin.x < 0
	
	if floorbuffered > 0:
		if self.pin.x != 0:
			self.ani = wrapf(self.ani + 10*delta, 0, 4)
			$spr.frame = [6,5,7,5][int(self.ani)]
		else:
			self.ani = 0
			$spr.frame = 5
	else:
		self.ani = 2
		if self.vel.y < 0: $spr.frame = 6; # going up!
		else: $spr.frame = 8 # falling down!