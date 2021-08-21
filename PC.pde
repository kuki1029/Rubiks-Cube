// Kunal Varkekar
// Final Done: Jan 07, 2020
// End of winter break of first year uni
import java.util.Random; 
Random rand = new Random(); 
import peasy.*;// adjust rot depending on which side without multiple methods
PeasyCam cam;

int cubeDim = 3;                                                  // Amount of blocks per face
float cubeLength = 10;                                            // Lenght of each side       
int tempAxisHolder = 0;                                           // Temp holds the side so other methods can access
int tempSideHolder = 0;                                           // Temp holds the side so other methods can access
// Values for tempSideHolder and Axis/ 1 - X axis, 2 - Y, 3 = Z
boolean counterClock = false;
Cubes[][][] qb = new Cubes[cubeDim][cubeDim][cubeDim];            // Sets up array to hold all the cubie objects 
boolean[] keyHeld = new boolean[16];                               // Holds array for which key was pressed
// Left-0,Middle-1,Right-2,Front-3,S(middle of F and B)-4,Back-5,Down-6,E(middle of D and U)-7,Up-8,Shift-9, Reset(W)-10, Help-11. 12, 13, 14 are numbers (1,2,3), Scrable(Z)-15

// Holds the instructions
String helpLine = "L:Left\nM:Middle\nR:Right\nU:Up\nE:Middle\nD:Down\nF:Front\nS:Middle\nB:Back\nHold Shift for Opposite Rotations\n1:Slow Speed\n2:Medium Speed\n3:High Speed\nZ:Scramble";
int count = 0;      // Holds counter for scrambling cube

// All colors for the block
int green = #009b48;
int white = #ffffff;
int red = #b71234;
int yellow = #ffd500;
int blue = #0046ad;
int orange = #ff5800;

void setup() {
  // Sets up main feautres of screen along with details for peasycam
  size(800, 800, P3D);
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(80);
  cam.setMaximumDistance(800);
  cam.lookAt((cubeLength*cubeDim)/2, (cubeLength*cubeDim)/2, (cubeLength*cubeDim)/2); // Centers the camera at the middle of the cube
  // Creates 27 objects from the Cubes class and assigns it to the qb array
  assignCubies();
}

// Main draw function
void draw() {  
  if ( !keyHeld[11] ) {

    // This rotates the arrays after the turning is done so that the turning isn't interrupted by arrays changing midway
    if ( blocksDoneTurn() ) {
      if ( tempAxisHolder == 1 ) {
        qb = rotateArrayX(qb, tempSideHolder, counterClock);
      } else   if ( tempAxisHolder == 2 ) {
        qb = rotateArrayY(qb, tempSideHolder, counterClock);
      } else  if ( tempAxisHolder == 3 ) {
        qb = rotateArrayZ(qb, tempSideHolder, counterClock);
      }
      setTurningFalse();
    }
    background(255);
    // Displays the cubes
    showCubies();
    // Calls the move command from the Cubes class to allow any cubes to turn/rotate
    doTurns();
    if ( keyHeld[15] ) {
      scramble();
    } else {
      // Check if any keys were pressed to start a rotation
      turnSides();
    }

    cam.beginHUD();
    fill(0);
    textAlign(CENTER);
    textSize(20);
    text("Press H for Help", width/2, 20);
    cam.endHUD();
  } else if ( keyHeld[11] ) {
    background(255);
    cam.beginHUD();
    fill(0);
    textAlign(CENTER);
    textSize(20);
    text(helpLine, width/2, 20);
    cam.endHUD();
  }



  //--------------------------------
}

// Has a for loop to cycle through a 3D array and assign a cubie to each array spot
void assignCubies() {
  for (int x = 0; x < qb.length; x++) {
    for (int y = 0; y < qb.length; y++) {
      for (int z = 0; z < qb.length; z++) {
        // Creates a new object
        qb[x][y][z] = new Cubes(x*cubeLength, y*cubeLength, z*cubeLength);
      }
    }
  }
}

// Calls the display method from the Cubes class for each instance in the array
void showCubies() {
  for (int x = 0; x < qb.length; x++) {
    for (int y = 0; y < qb.length; y++) {
      for (int z = 0; z < qb.length; z++) {
        qb[x][y][z].display(cubeLength, cubeDim);
      }
    }
  }
}

// Check if any key was pressed and calls the appropriate turn method with the appropriate values
// and then sets the keyHeld to false so that it isn't called again
void turnSides() {
  // Values for keyHeld
  // Left-0,Middle-1,Right-2,Front-3,S(middle of F and B)-4,Back-5,Down-6,E(middle of D and U)-7,Up-8,Shift-9, Reset(W)-10
  if (keyHeld[0]) {
    tempSideHolder = 0;
    startTurnX(0);
    keyHeld[0] = false;
  } else if (keyHeld[1]) {
    tempSideHolder = 1;
    startTurnX(1);
    keyHeld[1] = false;
  } else if (keyHeld[2]) {
    tempSideHolder = 2;
    startTurnX(2);
    keyHeld[2] = false;
  } else if (keyHeld[3]) {
    tempSideHolder = 2;
    startTurnZ(2);
    keyHeld[3] = false;
  } else if (keyHeld[4]) {
    tempSideHolder = 1;
    startTurnZ(1);
    keyHeld[4] = false;
  } else if (keyHeld[5]) {
    tempSideHolder = 0;
    startTurnZ(0);
    keyHeld[5] = false;
  } else if (keyHeld[6]) {
    tempSideHolder = 2;
    startTurnY(2);
    keyHeld[6] = false;
  } else if (keyHeld[7]) {
    tempSideHolder = 1;
    startTurnY(1);
    keyHeld[7] = false;
  } else if (keyHeld[8]) {
    tempSideHolder = 0;
    startTurnY(0);
    keyHeld[8] = false;
  } else if (keyHeld[10]) {
    assignCubies();
    keyHeld[10] = false;
  } else if ( keyHeld[12]) {
    editSpeed(1);
    keyHeld[12] = false;
  } else if ( keyHeld[13]) {
    editSpeed(2);
    keyHeld[13] = false;
  } else if ( keyHeld[14]) {
    editSpeed(3);
    keyHeld[14] = false;
  }
}

// This just randomly scrambles the cube
void scramble() {
  // Two variables to hold the rand axis and side number
  int randAxis;
  int randSide;
  if ( !stillTurning() ) {
    // Assigns random values
    randAxis = rand.nextInt(3);
    randSide = rand.nextInt(3);
    // We do the random turns every second time the method is called to allow the array rotating function to do its thing otherwise it all gets mixed up
    if ( count % 2 == 0 ) {
      if ( randAxis == 0 ) {
        tempSideHolder = randSide;
        startTurnX(randSide);
      } else if ( randAxis == 1 ) {
        tempSideHolder = randSide;
        startTurnY(randSide);
      } else if ( randAxis == 2 ) {
        tempSideHolder = randSide;
        startTurnZ(randSide);
      }
    }
    count++;
  }

  // Once 10 turns done then we stop ( Its 20 here but only 10 turns because we do it every second turn above)
  if ( count == 20 ) {
    keyHeld[15] = false;
    count = 0;
  }
}

// Starts the turning of cubes along the X-axis
// THe sideX variable denotes which group of cubes to rotate.
// SideX values -
// 0 for Left group of cubes, 1 for Middle, 2 for Right group of cubes
void startTurnX(int sideX) {
  tempAxisHolder = 1;
  for (int x = sideX; x <= sideX; x++) {
    for (int y = 0; y < qb.length; y++) {
      for (int z = 0; z < qb.length; z++) {
        if ( keyHeld[9] ) {
          counterClock = true;
          // keyHeld[9] represents the shift key which causes a counterclock wise rotation, thus the -1 which implies opposite direction
          qb[x][y][z].storeRot(1, -1);
        } else {
          counterClock = false;
          qb[x][y][z].storeRot(1, 1);
        }
      }
    }
  }
}

// Same as above but this time group of cubes to rotate along Y axis.
// SideY values -
// 0 for Top group of cubes, 1 for Center, 2 for Bottom group of cubes
void startTurnY(int sideY) {
  tempAxisHolder = 2;
  for (int x = 0; x < qb.length; x++) {
    for (int y = sideY; y <= sideY; y++) {
      for (int z = 0; z < qb.length; z++) {
        if ( keyHeld[9] ) {
          counterClock = true;
          // keyHeld[9] represents the shift key which causes a counterclock wise rotation, thus the -1 which implies opposite direction
          qb[x][y][z].storeRot(2, -1);
        } else {
          counterClock = false;
          qb[x][y][z].storeRot(2, 1);
        }
      }
    }
  }
}

// Same as above but this time group of cubes to rotate along Z axis.
// SideY values -
// 0 for Back group of cubes, 1 for Center, 2 for Front group of cubes
void startTurnZ(int sideZ) {
  tempAxisHolder = 3;
  for (int x = 0; x < qb.length; x++) {
    for (int y = 0; y < qb.length; y++) {
      for (int z = sideZ; z <= sideZ; z++) {
        if ( keyHeld[9] ) {
          counterClock = true;
          // keyHeld[9] represents the shift key which causes a counterclock wise rotation, thus the -1 which implies opposite direction
          qb[x][y][z].storeRot(3, -1);
        } else {
          counterClock = false;
          qb[x][y][z].storeRot(3, 1);
        }
      }
    }
  }
}

// Checks which key was pressed and saves it in a array
// Values for keyHeld - 
// Left-0,Middle-1,Right-2,Front-3,S(middle of F and B)-4,Back-5,Down-6,E(middle of D and U)-7,Up-8,Shift-9, Reset(W)-10
void keyPressed() {
  if ( !stillTurning() ) {

    if (keyCode == SHIFT) {
      keyHeld[9] = true;
    }
    if ((key == 'l') || (key == 'L')) {
      keyHeld[0] = true;
    } else if ((key == 'm') || (key == 'M')) {
      keyHeld[1] = true;
    } else if ((key == 'r') || (key == 'R')) {
      keyHeld[2] = true;
    } else if ((key == 'f') || (key == 'F')) {
      keyHeld[3] = true;
    } else if ((key == 's') || (key == 'S')) {
      keyHeld[4] = true;
    } else if ((key == 'b') || (key == 'B')) {
      keyHeld[5] = true;
    } else if ((key == 'd') || (key == 'D')) {
      keyHeld[6] = true;
    } else if ((key == 'e') || (key == 'E')) {
      keyHeld[7] = true;
    } else if ((key == 'u') || (key == 'U')) {
      keyHeld[8] = true;
    } else if ((key == 'w') || (key == 'W')) {
      keyHeld[10] = true;
    } else if ((key == 'h') || (key == 'H')) {
      keyHeld[11] = true;
    } else if ( key-48 == 1) {
      keyHeld[12] = true;
    } else if ( key-48 == 2) {
      keyHeld[13] = true;
    } else if ( key-48 == 3) {
      keyHeld[14] = true;
    } else if ((key == 'z') || (key == 'Z')) {
      keyHeld[15] = true;
    }
  }
}

// This calls the move function from the object and it only runs if the piece was meant to be rotating.
void doTurns() {
  for (int x = 0; x < qb.length; x++) {
    for (int y = 0; y < qb.length; y++) {
      for (int z = 0; z < qb.length; z++) {
        qb[x][y][z].moveX();
      }
    }
  }
}

// Checks if any part of the cube is still rotating. Used to keeo track of when rotations are done
// so that the qb array can be edited with the rotations.
// This cannot be done while the block is rotating as it will change the rotation.
boolean stillTurning() {
  boolean done = false;
  for (int x = 0; x < qb.length; x++) {
    for (int y = 0; y < qb.length; y++) {
      for (int z = 0; z < qb.length; z++) {
        if ( qb[x][y][z].isTurning() ) {
          done = qb[x][y][z].isTurning();
        }
      }
    }
  }
  return done;
}

// Rotates the array that is holding each object of Cubes.
Cubes[][][] rotateArrayX(Cubes[][][] qbEx, int sideX, boolean counterClockWise) {
  Cubes[][][] qbHolder = new Cubes[cubeDim][cubeDim][cubeDim];  
  int holderY = 0;
  int holderZ = 0;
  for (int x = 0; x < qb.length; x++) {
    for (int y = 0; y < qb.length; y++) {
      for (int z = 0; z < qb.length; z++) {
        if ( x == sideX ) {
          if ( counterClockWise ) {

            holderY = qb.length - z - 1;
            holderZ = y;
          } else {
            holderY = z;
            holderZ = qb.length - y - 1;
          }
          qbHolder[x][y][z] = qbEx[x][ holderY ][ holderZ ]; // to do CCW just switch these.
        } else {
          qbHolder[x][y][z] = qbEx[x][y][z];
        }
      }
    }
  }
  tempSideHolder = 0;
  tempAxisHolder = 0;
  return qbHolder;
}

// Rotates the array that is holding each object of Cubes.
Cubes[][][] rotateArrayY(Cubes[][][] qbEx, int sideY, boolean counterClockWise) {
  Cubes[][][] qbHolder = new Cubes[cubeDim][cubeDim][cubeDim];       
  int holderX = 0;
  int holderZ = 0;
  for (int x = 0; x < qb.length; x++) {
    for (int y = 0; y < qb.length; y++) {
      for (int z = 0; z < qb.length; z++) {
        if ( y == sideY ) {
          if ( counterClockWise ) {
            holderX = z;
            holderZ = qb.length - x - 1;
          } else {
            holderX = qb.length - z - 1;
            holderZ = x;
          }
          qbHolder[x][y][z] = qbEx[ holderX ][y][ holderZ ];
        } else {
          qbHolder[x][y][z] = qbEx[x][y][z];
        }
      }
    }
  }
  tempSideHolder = 0;
  tempAxisHolder = 0;
  return qbHolder;
}

// Rotates the array that is holding each object of Cubes.
Cubes[][][] rotateArrayZ(Cubes[][][] qbEx, int sideZ, boolean counterClockWise) {
  Cubes[][][] qbHolder = new Cubes[cubeDim][cubeDim][cubeDim]; 
  int holderX = 0;
  int holderY = 0;
  for (int x = 0; x < qb.length; x++) {
    for (int y = 0; y < qb.length; y++) {
      for (int z = 0; z < qb.length; z++) {
        if ( z == sideZ ) {
          if ( counterClockWise ) {
            holderX = qb.length - y - 1;
            holderY = x;
          } else {
            holderX = y;
            holderY = qb.length - x - 1;
          }
          qbHolder[x][y][z] = qbEx[ holderX ][ holderY ][z];
        } else {
          qbHolder[x][y][z] = qbEx[x][y][z];
        }
      }
    }
  }
  tempSideHolder = 0;
  tempAxisHolder = 0;
  return qbHolder;
}

void editSpeed(int whichSpeed) {
  for (int x = 0; x < qb.length; x++) {
    for (int y = 0; y < qb.length; y++) {
      for (int z = 0; z < qb.length; z++) {
        qb[x][y][z].changeSpeed(whichSpeed);
      }
    }
  }
}

// Checks if all the blocks are done turning before editing anything related to the array
boolean blocksDoneTurn() {
  int count = 0;
  for (int x = 0; x < qb.length; x++) {
    for (int y = 0; y < qb.length; y++) {
      for (int z = 0; z < qb.length; z++) {
        if ( qb[x][y][z].turningDone() ) {
          count++;
        }
      }
    }
  }
  // As at any time during a rotation, we have 9 cubies rotating, we need to check if all of them are done rotating thus the 9.
  if ( count == 9 ) {
    return true;
  } else {
    return false;
  }
}

// Sets the turningDone variable false in the Cubes class.
void setTurningFalse() {
  for (int x = 0; x < qb.length; x++) {
    for (int y = 0; y < qb.length; y++) {
      for (int z = 0; z < qb.length; z++) {
        qb[x][y][z].arrayChange();
      }
    }
  }
}

// Is called when a key is released.
void keyReleased() {
  if (keyCode == SHIFT) {
    keyHeld[9] = false;
  } else if ((key == 'h') || (key == 'H')) {
    keyHeld[11] = false;
  }
}


// Might be used but blocks rotation when mouse is over the cube
void blockCameraRotation() {
  if (((get(mouseX, mouseY)) == 0) || ((get(mouseX, mouseY)) == -1)) {
    cam.setMouseControlled(true);
  } else {
    cam.setMouseControlled(false);
  }
}

void myDelay(int ms) {
  try {    
    Thread.sleep(ms);
  }
  catch(Exception e) {
  }
}
