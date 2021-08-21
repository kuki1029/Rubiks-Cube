// Kunal Varkekar
// Final Done: Jan 07, 2020
// End of winter break of first year uni
class Cubes {
  // All colors needed for drawing the cube
  int green = #009b48;
  int white = #ffffff;
  int red = #b71234;
  int yellow = #ffd500;
  int blue = #0046ad;
  int orange = #ff5800;
  int black = #000000;
  PVector pos;                                        // Holds position of each cube
  PVector rot = new PVector(0, 0, 0);                 // Holds the rotation in each axis of each cube.
  PVector tempRot = new PVector(0, 0, 0);             // Holds the temporary rotation for when doing rotation
  ArrayList<Integer> listOfRot = new ArrayList<Integer>();      // Holds what rotations have taken place
  PVector[] coordSys =new PVector[3];                 // Holds the coordinate system and how it is oriented to help do rotations
  int speed = 50;                                     // Holds the speed of rotation.
  boolean turning = false;                            // Holds weather or not the block is turning
  boolean turningDone = false;                        // Holds if the block is done turning or not          
  int turnAxis;                                       // Holds which axis is turning
  // 1 - X-axis, 2 - Y-axis, 3 - Z-axis
  int dir = 1;                                        // negative for counter clockwise

  // Constructor - Takes in the coordinates to draw each block
  Cubes(float x, float y, float z) {
    // Saves position where each block is supposed to start
    pos = new PVector(x, y, z);

    // Assigns values to the pvectors which represent each of the axises
    coordSys[0] = new PVector(1, 0, 0);
    coordSys[1] = new PVector(0, 1, 0);
    coordSys[2] = new PVector(0, 0, 1);
  }

  // Draws the individual cubies
  void display(float cubeLength, int cubeDim) {
    strokeWeight(5);
    pushMatrix();
    // These two methods restore old rotations and start the new ones.
    restoreRot();
    doNewRot();

    // Translates to where the block is suppoed to go in the 3D space.
    translate(pos.x, pos.y, pos.z);
    // ==========================================================================================
    // The if commands for each face are to make the hidden faces black.
    // This is done so that the inner faces that cannot be seen are black to make it look cleaner
    // Back Face
    fill(orange);
    if (pos.z > 0) {
      fill(black);
    }
    rect(0, 0, cubeLength, cubeLength);

    // Top face
    fill(yellow);
    if (pos.y > 0) {
      fill(black);
    }
    rotateX(PI/2);
    rect(0, 0, cubeLength, cubeLength);

    // Left Face
    fill(blue);
    if (pos.x > 0) {
      fill(black);
    }
    rotateY(PI/2);
    rect(0, 0, cubeLength, cubeLength);

    // Right face
    fill(green);
    if (pos.x < ((cubeLength  * cubeDim) - cubeLength)) {
      fill(black);
    }
    translate(0, 0, cubeLength);
    rect(0, 0, cubeLength, cubeLength);

    // Front Face
    fill(red);
    if (pos.z < ((cubeLength  * cubeDim) - cubeLength)) {
      fill(black);
    }
    rotateX(-PI/2);
    translate(0, 0, cubeLength);
    rect(0, 0, cubeLength, cubeLength);

    // Bottom Face
    fill(white);
    if (pos.y < ((cubeLength  * cubeDim) - cubeLength)) {
      fill(black);
    }
    rotateY(PI/2);
    translate(0, 0, cubeLength);
    rect(0, 0, cubeLength, cubeLength);
    // ==========================================================================================
    popMatrix();
  }

  // Does the actual rotation by adding a small amount to the rot variable
  void moveX() {
    if ( turning ) {
      // This if statements sees which axis needs to be turned.
      if ( turnAxis == 1) {
        // This if statements check which direction the cube needs to be rotates.
        // 1 for clockwise, -1 for counter clockwise
        if ( dir == 1 ) {
          rot.x += PI/speed;
          // This if statements decides if the rotation of the block is done
          if ( rot.x > ( tempRot.x + (PI/2))) {
            rot.x = ( tempRot.x + (PI/2) );
            turning = false;
            turningDone = true;
            // Saves what rotations have been applied to each block
            listOfRot.add(whichRotX());
            // Changes the axis vectors
            coordSys = xRotation(coordSys, false);
          }
        } else if ( dir == -1 ) {
          // As dir == -1 is counter clockwise, we subtract the amount from rot.x
          rot.x -= PI/speed;
          if ( rot.x < ( tempRot.x - (PI/2))) {
            rot.x = ( tempRot.x - (PI/2) );
            turning = false;
            turningDone = true;
            listOfRot.add(whichRotX() * dir);
            coordSys = xRotation(coordSys, true);
          }
        }
      }
      // Same as above but different axis
      if ( turnAxis == 2) {
        if ( dir == 1 ) {
          rot.y += PI/speed;
          // This if statements decides if the rotation of the block is done
          if ( rot.y > ( tempRot.y + (PI/2))) {
            rot.y = ( tempRot.y + (PI/2) );
            turning = false;
            turningDone = true;
            listOfRot.add(whichRotY());
            coordSys = yRotation(coordSys, false);
          }
        } else if ( dir == -1 ) {
          // As dir == -1 is counter clockwise, we subtract the amount from rot.x
          rot.y -= PI/speed;
          if ( rot.y < ( tempRot.y - (PI/2))) {
            rot.y = ( tempRot.y - (PI/2) );
            turning = false;
            turningDone = true;
            listOfRot.add(whichRotY() * dir);
            coordSys = yRotation(coordSys, true);
          }
        }
      }
      // Same as above but different axis
      if ( turnAxis == 3) {
        if ( dir == 1 ) {
          rot.z += PI/speed;
          // This if statements decides if the rotation of the block is done
          if ( rot.z > ( tempRot.z + (PI/2))) {
            rot.z = ( tempRot.z + (PI/2) );
            turning = false;
            turningDone = true;
            listOfRot.add(whichRotZ());
            coordSys = zRotation(coordSys, false);
          }
        } else if ( dir == -1 ) {
          // As dir == -1 is counter clockwise, we subtract the amount from rot.x
          rot.z -= PI/speed;
          if ( rot.z < ( tempRot.z - (PI/2))) {
            rot.z = ( tempRot.z - (PI/2) );
            turning = false;
            turningDone = true;
            listOfRot.add(whichRotZ() * dir);
            coordSys = zRotation(coordSys, true);
          }
        }
      }
    }
  }

  // turnAxis: 1 for X, 2 for Y, 3 for Z
  // This is called from the main code when rotation wants to start
  // Rot is set to zero because we restore each rotation after and if its not set to zero,
  // It will repeat previous rotations bcoz we save all of it
  void storeRot( int turnAxis, int dir) {
    this.turnAxis = 0;
    rot.x = 0;
    rot.y = 0;
    rot.z = 0;
    tempRot.x = rot.x;
    tempRot.y = rot.y;
    tempRot.z = rot.z;
    this.dir = dir;
    this.turnAxis = turnAxis;
    turningDone = false;
    turning = true;
  }

  // Returns which rotation was done according to which axis is where in space after rotations
  // ==========================================================================================
  int whichRotX() {
    for ( int i = 0; i < coordSys.length; i++ ) {
      if (( int(coordSys[i].x) == 1) || ( int(coordSys[i].x) == -1)) {
        return ((i+1) * int(coordSys[i].x));
      }
    } 
    return 0;
  }
  int whichRotY() {
    for ( int i = 0; i < coordSys.length; i++ ) {
      if (( int(coordSys[i].y) == 1) || ( int(coordSys[i].y) == -1)) {
        return ((i+1) * int(coordSys[i].y));
      }
    } 
    return 0;
  }
  int whichRotZ() {
    for ( int i = 0; i < coordSys.length; i++ ) {
      if (( int(coordSys[i].z) == 1) || ( int(coordSys[i].z) == -1)) {
        return ((i+1) * int(coordSys[i].z));
      }
    } 
    return 0;
  }
  // ==========================================================================================

  // This will do the actual rotation once the user clicks on the key
  // Axis num refers to where the required axis is in space. This is done because of the way processing does rotations
  // ==========================================================================================
  void diffAxisRotX(int axisNum, float direction) {
    if ( axisNum == 0 ) {
      translate(0, 15, 15);
      rotateX(rot.x * direction);
      translate(0, -15, -15);
    } else if ( axisNum == 1 ) {
      translate(15, 0, 15);
      rotateY(rot.x * direction);
      translate(-15, 0, -15);
    } else if ( axisNum == 2 ) {
      translate(15, 15, 0);
      rotateZ(rot.x * direction);
      translate(-15, -15, 0);
    }
  }
  void diffAxisRotY(int axisNum, float direction) {
    if ( axisNum == 0 ) {
      translate(0, 15, 15);
      rotateX(rot.y * direction);
      translate(0, -15, -15);
    } else if ( axisNum == 1 ) {
      translate(15, 0, 15);
      rotateY(rot.y * direction);
      translate(-15, 0, -15);
    } else if ( axisNum == 2 ) {
      translate(15, 15, 0);
      rotateZ(rot.y * direction);
      translate(-15, -15, 0);
    }
  }
  void diffAxisRotZ(int axisNum, float direction) {
    if ( axisNum == 0 ) {
      translate(0, 15, 15);
      rotateX(rot.z * direction);
      translate(0, -15, -15);
    } else if ( axisNum == 1 ) {
      translate(15, 0, 15);
      rotateY(rot.z * direction);
      translate(-15, 0, -15);
    } else if ( axisNum == 2 ) {
      translate(15, 15, 0);
      rotateZ(rot.z * direction);
      translate(-15, -15, 0);
    }
  }
  // ==========================================================================================

  // This section first checks which axis has to be moved.
  // After that it checks where that axis currently is after all the rotations that have been applied to the cubies
  // Then it applies the necessary rotations to fix it.
  void doNewRot() {
    if (turnAxis == 1 && turning) {
      for ( int i = 0; i < coordSys.length; i++ ) {
        if (( int(coordSys[i].x) == 1) || ( int(coordSys[i].x) == -1)) {
          diffAxisRotX(i, coordSys[i].x);
        }
      }
    }
    if (turnAxis == 2 && turning) {
      for ( int i = 0; i < coordSys.length; i++ ) {
        if (( coordSys[i].y == 1) || ( coordSys[i].y == -1)) {
          diffAxisRotY(i, coordSys[i].y);
        }
      }
    }
    if (turnAxis ==3 && turning) {
      for ( int i = 0; i < coordSys.length; i++ ) {
        if (( coordSys[i].z == 1) || ( coordSys[i].z == -1)) {
          diffAxisRotZ(i, coordSys[i].z);
        }
      }
    }
  }

  // This restores any previous rotations so that new rotations can be made
  void restoreRot() {
    for (int whichAxis = 0; whichAxis < listOfRot.size(); whichAxis++) {
      if (abs(listOfRot.get(whichAxis)) == 1) {
        translate(0, 15, 15);
        rotateX(PI/2 * listOfRot.get(whichAxis));
        translate(0, -15, -15);
      } else   if (abs(listOfRot.get(whichAxis)) == 2) {
        translate(15, 0, 15);
        rotateY((PI/2) * ((listOfRot.get(whichAxis))/(abs(listOfRot.get(whichAxis)))));
        translate(-15, 0, -15);
      } else   if (abs(listOfRot.get(whichAxis)) == 3) {
        translate(15, 15, 0);
        rotateZ((PI/2) * ((listOfRot.get(whichAxis))/(abs(listOfRot.get(whichAxis)))));
        translate(-15, -15, 0);
      }
    }
  }

  // Rotation Matrices
  // ==========================================================================================
  // Rotates our vectors that represent the axis for each cubie
  // This rotates the vectors that rotates along the x-axis
  PVector[] xRotation(PVector[] tempCoord, boolean clockWise) {
    PVector[] coordHolder =new PVector[3];
    coordHolder[0] = new PVector(0, 0, 0);
    coordHolder[1] = new PVector(0, 0, 0);
    coordHolder[2] = new PVector(0, 0, 0);
    float angle;
    // Depending on the angle we can flip the axis either way.
    if ( clockWise ) {
      angle = PI/2;
    } else {
      angle = -PI/2;
    }
    coordHolder[0].x = (tempCoord[0].x);
    coordHolder[0].y = (round(((cos(angle)) * tempCoord[0].y) + ((sin(angle)) * tempCoord[0].z)));
    coordHolder[0].z = (round(((-sin(angle)) * tempCoord[0].y) + ((cos(angle)) * tempCoord[0].z)));

    coordHolder[1].x = (tempCoord[1].x);
    coordHolder[1].y = (round(((cos(angle)) * tempCoord[1].y) + ((sin(angle)) * tempCoord[1].z)));
    coordHolder[1].z = (round(((-sin(angle)) * tempCoord[1].y) + ((cos(angle)) * tempCoord[1].z)));

    coordHolder[2].x = (tempCoord[2].x);
    coordHolder[2].y = (round(((cos(angle)) * tempCoord[2].y) + ((sin(angle)) * tempCoord[2].z)));
    coordHolder[2].z = (round(((-sin(angle)) * tempCoord[2].y) + ((cos(angle)) * tempCoord[2].z)));

    return coordHolder;
  }
  // Rotates our vectors that represent the axis for each cubie
  // This rotates the vectors that rotates along the y-axis
  PVector[] yRotation(PVector[] tempCoord, boolean clockWise) {
    PVector[] coordHolder =new PVector[3];
    coordHolder[0] = new PVector(0, 0, 0);
    coordHolder[1] = new PVector(0, 0, 0);
    coordHolder[2] = new PVector(0, 0, 0);
    float angle;
    if ( clockWise ) {
      angle = PI/2;
    } else {
      angle = -PI/2;
    }
    coordHolder[0].x = (round(((cos(angle)) * tempCoord[0].x) + ((-sin(angle)) * tempCoord[0].z)));
    coordHolder[0].y = (tempCoord[0].y);
    coordHolder[0].z = (round(((sin(angle)) * tempCoord[0].x) + ((cos(angle)) * tempCoord[0].z)));
    coordHolder[1].x = (round(((cos(angle)) * tempCoord[1].x) + ((-sin(angle)) * tempCoord[1].z)));
    coordHolder[1].y = (tempCoord[1].y);
    coordHolder[1].z = (round(((sin(angle)) * tempCoord[1].x) + ((cos(angle)) * tempCoord[1].z)));
    coordHolder[2].x = (round(((cos(angle)) * tempCoord[2].x) + ((-sin(angle)) * tempCoord[2].z)));
    coordHolder[2].y = (tempCoord[2].y);
    coordHolder[2].z = (round(((sin(angle)) * tempCoord[2].x) + ((cos(angle)) * tempCoord[2].z)));
    return coordHolder;
  }
  // Rotates our vectors that represent the axis for each cubie
  // This rotates the vectors that rotates along the y-axis
  PVector[] zRotation(PVector[] tempCoord, boolean clockWise) {
    PVector[] coordHolder =new PVector[3];
    coordHolder[0] = new PVector(0, 0, 0);
    coordHolder[1] = new PVector(0, 0, 0);
    coordHolder[2] = new PVector(0, 0, 0);
    float angle;
    if ( clockWise ) {
      angle = PI/2;
    } else {
      angle = -PI/2;
    }
    coordHolder[0].x = (round(((cos(angle)) * tempCoord[0].x) + ((sin(angle)) * tempCoord[0].y)));
    coordHolder[0].y = (round(((-sin(angle)) * tempCoord[0].x) + ((cos(angle)) * tempCoord[0].y)));
    coordHolder[0].z = (tempCoord[0].z);
    coordHolder[1].x = (round(((cos(angle)) * tempCoord[1].x) + ((sin(angle)) * tempCoord[1].y)));
    coordHolder[1].y = (round(((-sin(angle)) * tempCoord[1].x) + ((cos(angle)) * tempCoord[1].y)));
    coordHolder[1].z = (tempCoord[1].z);
    coordHolder[2].x = (round(((cos(angle)) * tempCoord[2].x) + ((sin(angle)) * tempCoord[2].y)));
    coordHolder[2].y = (round(((-sin(angle)) * tempCoord[2].x) + ((cos(angle)) * tempCoord[2].y)));
    coordHolder[2].z = (tempCoord[2].z);
    return coordHolder;
  }
  // ==========================================================================================

  void changeSpeed(int speed1) {
println("S");
    if ( !isTurning() ) {
      if ( speed1 == 1 ) {
        this.speed = 200;
      } else if ( speed1 == 2 ) {
        this.speed = 50;
      } else if ( speed1 == 3 ) {
        this.speed = 10;
      }
    }
  }

  // Returns if the block is still turning or not
  boolean isTurning() {
    return turning;
  }
  // Returns if the block is done turning or not
  boolean turningDone() {
    return turningDone;
  }
  // Sets the block done turning variable to false after it has been used for its purpose.
  void arrayChange() {
    turningDone = false;
  }
}
