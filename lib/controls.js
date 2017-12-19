// NOTE: Javascript function object stuff
// this: public
// var: private

// blocker: initial background
// instructions: initial text
THREE.MyPointerLockControls = function ( camera, blocker, instructions ) {


  /// Internal Variables

  var scope = this;

  var PI_2 = Math.PI / 2;

  var controlsEnabled = false;

  var velocity = new THREE.Vector3();
  var direction = new THREE.Vector3();

  var canJump = false;

  var moveForward = false;
  var moveBackward = false;
  var moveLeft = false;
  var moveRight = false;


  /// Magic Numbers

  // movement scale factor
  var scale = 1400;
  // additional x,z movement factor (walking speed)
  var movementFactor = 10.0;
  // player weight (used for gravity calculation)
  var mass = 100.0;
  // jump velocity
  var jumpVelocity = 350;
  // TODO: temporary (use actual ground coord later)
  var groundPositionY = 0;


  // Initialization

  // zero-out camera rotation
  camera.rotation.set( 0, 0, 0 );

  var pitchObject = new THREE.Object3D();
  pitchObject.add( camera );

  var yawObject = new THREE.Object3D();
  // NOTE: set inital position (standing on ground) here
  yawObject.position.y = groundPositionY;
  // NOTE: yawObject is the full control object
  yawObject.add( pitchObject );


  /// Event Handlers

  var onMouseMove = function ( event ) {
    if ( scope.enabled === false ) return;
    var movementX = event.movementX || event.mozMovementX || event.webkitMovementX || 0;
    var movementY = event.movementY || event.mozMovementY || event.webkitMovementY || 0;
    yawObject.rotation.y -= movementX * 0.002;
    pitchObject.rotation.x -= movementY * 0.002;
    pitchObject.rotation.x = Math.max( - PI_2, Math.min( PI_2, pitchObject.rotation.x ) );
  };

  var onKeyDown = function ( event ) {
    switch ( event.keyCode ) {
    case 38: // up
    case 87: // w
      moveForward = true;
      break;
    case 37: // left
    case 65: // a
      moveLeft = true;
      break;
    case 40: // down
    case 83: // s
      moveBackward = true;
      break;
    case 39: // right
    case 68: // d
      moveRight = true;
      break;
    case 32: // space
      if ( canJump === true ) velocity.y += jumpVelocity;
      canJump = false;
      break;
    }
  };

  var onKeyUp = function ( event ) {
    switch ( event.keyCode ) {
    case 38: // up
    case 87: // w
      moveForward = false;
      break;
    case 37: // left
    case 65: // a
      moveLeft = false;
      break;
    case 40: // down
    case 83: // s
      moveBackward = false;
      break;
    case 39: // right
    case 68: // d
      moveRight = false;
      break;
    }
  };


  /// Add Event Listeners

  this.dispose = function() {
    document.removeEventListener( 'mousemove', onMouseMove, false );
    document.removeEventListener( 'keydown', onKeyDown, false );
    document.removeEventListener( 'keyup', onKeyUp, false );
  };

  document.addEventListener( 'mousemove', onMouseMove, false );
  document.addEventListener( 'keydown', onKeyDown, false );
  document.addEventListener( 'keyup', onKeyUp, false );


  // Initialize Pointer Lock

  var havePointerLock = 'pointerLockElement' in document || 'mozPointerLockElement' in document || 'webkitPointerLockElement' in document;

  if ( havePointerLock ) {
    var element = document.body;

    var pointerlockchange = function ( event ) {
      if ( document.pointerLockElement === element || document.mozPointerLockElement === element || document.webkitPointerLockElement === element ) {
        controlsEnabled = true; // camera/control rendering enabled
        this.enabled = true; // pointerLock enabled

        blocker.style.display = 'none';
      } else {
        this.enabled = false;

        blocker.style.display = '-webkit-box';
        blocker.style.display = '-moz-box';
        blocker.style.display = 'box';

        instructions.style.display = '';
      }
    };

    var pointerlockerror = function ( event ) {
      instructions.style.display = '';
    };

    // Hook pointer lock state change events
    // TODO: add listeners to array, add and dispose of all at once
    document.addEventListener( 'pointerlockchange', pointerlockchange, false );
    document.addEventListener( 'mozpointerlockchange', pointerlockchange, false );
    document.addEventListener( 'webkitpointerlockchange', pointerlockchange, false );

    document.addEventListener( 'pointerlockerror', pointerlockerror, false );
    document.addEventListener( 'mozpointerlockerror', pointerlockerror, false );
    document.addEventListener( 'webkitpointerlockerror', pointerlockerror, false );

    // NOTE: onClick used here (maybe not an issue since listening to instructions, not canvas)
    instructions.addEventListener( 'click', function ( event ) {
      // TODO: make sure this removes blocker display as well
      instructions.style.display = 'none';
      // Ask the browser to lock the pointer
      element.requestPointerLock = element.requestPointerLock || element.mozRequestPointerLock || element.webkitRequestPointerLock;
      element.requestPointerLock();
    }, false );
  } else {
    instructions.innerHTML = 'Your browser doesn\'t seem to support Pointer Lock API';
  }

  this.getObject = function () {
    return yawObject;
  };

  // TODO clean up ground velocity logic
  // TODO maybe change call to 'this.getObject()' to just 'yawObject'
  // call w/in animate loop (req clock delta)
  this.animateCamera = function ( delta ) {
    if ( controlsEnabled === true ) {
      velocity.x -= velocity.x * movementFactor * delta;
      velocity.z -= velocity.z * movementFactor * delta;
      // gravity
      velocity.y -= 9.8 * mass * delta;

      direction.z = Number( moveForward ) - Number( moveBackward );
      direction.x = Number( moveLeft ) - Number( moveRight );
      direction.normalize(); // NOTE: ensure consistent movements in all directions (what?)

      if ( moveLeft || moveRight ) velocity.x -= direction.x * delta;
      if ( moveForward || moveBackward ) velocity.z -= direction.z * delta;

      var onObject = this.getObject().position.y === groundPositionY;

      if ( onObject ) {
        velocity.y = Math.max( 0, velocity.y );
        canJump = true;
      }

      this.getObject().translateX( velocity.x * delta );
      this.getObject().translateY( velocity.y * delta );
      this.getObject().translateZ( velocity.z * delta );

      // TODO: use actual ground
      if ( this.getObject().position.y < groundPositionY ) {
        velocity.y = 0;
        this.getObject().position.y = groundPositionY;

        canJump = true;
      }
    }
  };

  // TODO: understand
  // maybe use for aiming bow...
  this.getDirection = function() {
    // assumes the camera itself is not rotated
    var dir = new THREE.Vector3( 0, 0, -1 );
    var rot = new THREE.Euler( 0, 0, 0, "YXZ" );
    // set this.getDirection to this function
    return function( v ) {
      rot.set( pitchObject.rotation.x, yawObject.rotation.y, 0 );
      v.copy( dir ).applyEuler( rot );
      return v;
    };
  }();
};
