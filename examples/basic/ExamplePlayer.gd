class_name Player extends CharacterBody3D


const SPEED = 0.25

const PLAYER_GROUP = "PLAYER"

func _init():
    add_to_group(PLAYER_GROUP)

func _physics_process(delta):
    # Add the gravity.
    if not is_on_floor():
        velocity += get_gravity() * delta


    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
    var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    if direction:
        velocity.x = direction.x * SPEED
        velocity.z = direction.z * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.z = move_toward(velocity.z, 0, SPEED)
        
    if Input.is_action_pressed("RotateLeft"):
        rotate_y(SPEED * delta * 2)
    if Input.is_action_pressed("RotateRight"):
        rotate_y(-SPEED * delta * 2)

    move_and_slide()
