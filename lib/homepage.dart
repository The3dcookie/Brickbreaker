import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_brickbreaker/ball.dart';
import 'package:flutter_brickbreaker/brick.dart';
import 'package:flutter_brickbreaker/coverscreen.dart';
import 'package:flutter_brickbreaker/gameoverscreen.dart';
import 'package:flutter_brickbreaker/player.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

enum direction {UP, DOWN, LEFT, RIGHT}



class _HomePageState extends State<HomePage> {

  double ballX = 0;
  double ballY = 0;
  double ballXincrements = 0.02;
  double ballYincrements = 0.01;
  direction ballXDirection = direction.DOWN;
  direction ballYDirection = direction.LEFT;

//Game Settings
bool hasGameStarted = false;
bool isGameOver = false;
// bool brickBroken = false;

//player variables
double playerX = -0.2;
double playerWidth = 0.4; //Out of 2

//brick Variables
static double firstBrickX = -1 + wallGap;
static double firstBrickY = -0.9;
static double brickWidth = 0.4;
static double brickHeight = 0.08;
static double brickGap = 0.01;
static int numberOfBricksInRow = 3;
static double wallGap = 0.5 * (2 - numberOfBricksInRow * brickWidth - (numberOfBricksInRow - 1) * brickGap );

List MyBricks = [
  //[x,y, broken = true/false]
  [firstBrickX + 0 * (brickWidth + brickGap), firstBrickY, false],
  [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY, false],
  [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY, false],
];


//Start Game
void startGame(){
  hasGameStarted = true;
  
  ballYDirection = direction.DOWN;
  ballXDirection = direction.LEFT;
  Timer.periodic(const Duration(milliseconds: 10), (sabiTimer) {


    //Update Direction
    updateDirection();

    //Move ball
    moveBall();

    //Check if game is over
    if(isPlayerDead()){
      sabiTimer.cancel();
      isGameOver = true;
    }

    //Check if brick is broken
    checkForBrokenBricks();


   });
}

void resetGame(){
   setState(() {

   playerX = -0.2;

    ballX = 0;
    ballY = 0;
    isGameOver = false;
    hasGameStarted = false;


     MyBricks = [
  //[x,y, broken = true/false]
  [firstBrickX + 0 * (brickWidth + brickGap), firstBrickY, false],
  [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY, false],
  [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY, false],
];
   });
}

void checkForBrokenBricks(){
  //Checks for when ball hits bottom of a brick
  for(int i = 0; i < MyBricks.length; i++){
      if(ballX >= MyBricks[i][0] && 
     ballX <= MyBricks[i][0] + brickWidth && 
     ballY <= MyBricks[i][1] + brickHeight &&
     MyBricks[i][2] == false){
      setState(() {
        MyBricks[i][2] = true;

        //since brick is broken, updat the direction of the ball
        //based on which side of the brick it hit
        //to do this, calculate the distance of the ball from each of the 4 sides
        //the smallest distance is the side of the ball that has it

        double leftSideDist = (MyBricks[i][0] - ballX).abs();
        double rightSideDist = (MyBricks[i][0] + brickWidth - ballX).abs();
        double topSideDist = (MyBricks[i][1] - ballY).abs();
        double bottomSideDist = (MyBricks[i][1] + brickHeight - ballY).abs();

        String min = findMin(leftSideDist, rightSideDist, topSideDist, bottomSideDist);



        switch (min) {
          case "left" :
           ballXDirection = direction.LEFT;
            
            break;
            
          case "right" :
           ballXDirection = direction.RIGHT;
            
            break;
            
          case "top" :
           ballYDirection = direction.UP;
            
            break;

          case "bottom" :
           ballYDirection = direction.DOWN;
            
            break;
          default:
        }
      });

  }
  }

}

String findMin(double a, double b, double c, double d){
  List<double> myList = [
    a,
    b,
    c,
    d,
  ];


    double currentMin = a;
    for (var i = 0; i < myList.length; i++) {
      if (myList[i] < currentMin) {
        currentMin = myList[i];
      }
    }

    if((currentMin - a).abs() < 0.01){
      return 'left';
    }else if((currentMin - b).abs() < 0.01) {
      return 'right';
    }else if((currentMin - c).abs() < 0.01) {
      return 'top';
    }else if((currentMin - d).abs() < 0.01) {
      return 'bottom';
    }

  return "";
}

//Is player dead
bool isPlayerDead(){

  //Player dies if ball reaches the bottom of the screen
   if (ballY >= 1){
    return true;
   }
   
   return false;
}


//move ball
void moveBall(){
setState(() {

  // MOVE HORIZONTAL
    if(ballXDirection == direction.LEFT){
    ballX -= ballXincrements;

  }
  else if(ballXDirection == direction.RIGHT){
    ballX += ballXincrements;

  }


    //MOVE VERTICAL
    if(ballYDirection == direction.DOWN){
    ballY += ballYincrements;

  }else if(ballYDirection == direction.UP){
    ballY -= ballYincrements;

  }

});
}

//update direction
void updateDirection(){
  //Ball goes up when it hits the player
  if(ballY >= 0.9 && ballX >= playerX && ballX <= playerX + playerWidth){
    ballYDirection = direction.UP;
  }
  
  //Ball goes down when it hits the top of the screen
  else if(ballY <= -1){
    ballYDirection = direction.DOWN;
  }
  
  
  //Ball goes left when it hits the right wall
  if(ballX >= 1){
    ballXDirection = direction.LEFT;
  }
  
  //Ball goes right when it hits the left wall
  else if(ballX <= -1){
    ballXDirection = direction.RIGHT;
  }
}

//Move player Left
void moveLeft(){
  setState(() {
    //Only move left if left doesn't move you off screen
    if(!(playerX - 0.1 <= -1)){
      playerX -= 0.2;
    }
  });

}

//Move player Right
void moveRight(){
  setState(() {
    //Only move left if left doesn't move you off screen
    if(!(playerX + playerWidth >= 1)){
      playerX += 0.2;
    }
  });
}


  @override 
  Widget build(BuildContext context){
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event){
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)){
          moveLeft();

        } else if(event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();

        }

        if(event.isKeyPressed(LogicalKeyboardKey.keyK)){
          isGameOver = true;
        }

        // if(event.isKeyPressed(LogicalKeyboardKey.keyR)){
        //   isGameOver = false;
        //   hasGameStarted = false;
        //   GameOverScreen(isGameOver: isGameOver);
        //   CoverScreen(hasGameStarted: hasGameStarted);

        //   startGame();
        // }
      },





      child: GestureDetector(
        onTap: startGame,
        child: Scaffold(
        backgroundColor: Colors.deepPurple[100],
        body: Center(
          child: Stack(
            children: [
              //Tap To Play
              CoverScreen(hasGameStarted: hasGameStarted),

              //Game Over Screen
              GameOverScreen(isGameOver: isGameOver, function: resetGame,),
      
              //ball
             MyBall(ballX: ballX, ballY: ballY, isGameOver: isGameOver,hasGameStarted: hasGameStarted,),
      
             //Player
             MyPlayer(
              playerX: playerX,
              playerWidth: playerWidth,
             ),

             //Where is player x exactly
             Container(
              alignment: Alignment(playerX, 0.9),
              child: Container(
                color: Colors.red,
                width: 4,
                height: 15,
              ),
              ),

              //Where is player x green             
              Container(
              alignment: Alignment(playerX + playerWidth, 0.9),
              child: Container(
                color: Colors.green,
                width: 4,
                height: 15,
              ),
              ),

              // Bricks
              MyBrick(
                brickHeight: brickHeight,
                brickWidth: brickWidth,
                brickX: MyBricks[0][0],
                brickY: MyBricks[0][1],
                brickBroken: MyBricks[0][2],
              ),

              //Bricks
              MyBrick(
                brickHeight: brickHeight,
                brickWidth: brickWidth,
                brickX: MyBricks[1][0],
                brickY: MyBricks[1][1],
                brickBroken: MyBricks[1][2],
              ),
              
              //Bricks
              MyBrick(
                brickHeight: brickHeight,
                brickWidth: brickWidth,
                brickX: MyBricks[2][0],
                brickY: MyBricks[2][1],
                brickBroken: MyBricks[2][2],
              ),
      
            ],
          ),
        ),
      )
      ),
    );
  }
}