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
  double ballXincrements = 0.01;
  double ballYincrements = 0.01;
  var ballXDirection = direction.DOWN;
  var ballYDirection = direction.LEFT;

//Game Settings
bool hasGameStarted = false;
bool isGameOver = false;
bool brickBroken = false;

//player variables
double playerX = -0.2;
double playerWidth = 0.4; //Out of 2

//brick Variables
double brickX = 0;
double brickY = -0.9;
double brickWidth = 0.4;
double brickHeight = 0.08;


//Start Game
void startGame(){
 if (!hasGameStarted) {
    setState(() {
      hasGameStarted = true;
    });

    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      // Update Direction
      updateDirection();

      // Move ball
      moveBall();

      // Check if game is over
      if (isPlayerDead()) {
        timer.cancel();
        setState(() {
          isGameOver = true;
        });
      }

      // Check if brick is broken
      checkForBrokenBricks();
    });
  }
   
}

void checkForBrokenBricks(){
  //Checks for when ball hits bottom of a brick
  if(ballX >= brickX && 
     ballX <= brickX + brickWidth && 
     ballY <= brickY + brickHeight &&
     brickBroken == false){
      setState(() {
        brickBroken = true;
        ballYDirection = direction.DOWN;
      });

  }
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

  //MOVE HORIZONTAL
    if(ballXDirection == direction.LEFT){
    ballX -= ballXincrements;

  }else if(ballXDirection == direction.RIGHT){
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
  if(ballY >= 0.9 && ballX >= playerX && ballX <= playerX + playerWidth){
    ballYDirection = direction.UP;
  }else if(ballY <= -1){
    ballYDirection = direction.DOWN;
  }

  if(ballX >= 1){
    ballYDirection = direction.LEFT;

  }
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
              GameOverScreen(isGameOver: isGameOver),
      
              //ball
             MyBall(ballX: ballX, ballY: ballY,),
      
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

              //Bricks
              MyBrick(
                brickHeight: brickHeight,
                brickWidth: brickWidth,
                brickX: brickX,
                brickY: brickY,
                brickBroken: brickBroken,
              ),


      
      
            ],
          ),
        ),
      )
      ),
    );
  }
}