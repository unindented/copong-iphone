//
//  GameScene.h
//  Copong
//
//  Created by Daniel Perez Alvarez on 11/28/09.
//  Copyright 2009 Daniel Perez Alvarez. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "cocos2d.h"

#import "Paddle.h"
#import "Ball.h"


#define DISTANCE_WALL_PADDLE 50

/** Game states. */
typedef enum
{
    kGameStatePaused,
    kGameStateRunning
} GameState;

/** Players. */
typedef enum
{
    kNoPlayer,
    kLeftPlayer,
    kRightPlayer
} Player;


@interface GameScene : Scene {}

@end


@interface GameLayer : Layer
{
    Paddle* leftPaddle;
    Paddle* rightPaddle;
    Ball* ball;
    LabelAtlas* leftScoreLabel;
    LabelAtlas* rightScoreLabel;
    
    GameState gameState;
    Player lastScored;
    NSInteger leftScore;
    NSInteger rightScore;
}

@property (nonatomic, retain) Paddle* leftPaddle;
@property (nonatomic, retain) Paddle* rightPaddle;
@property (nonatomic, retain) Ball* ball;
@property (nonatomic, retain) LabelAtlas* leftScoreLabel;
@property (nonatomic, retain) LabelAtlas* rightScoreLabel;

@property (nonatomic, assign) GameState gameState;
@property (nonatomic, assign) Player lastScored;
@property (nonatomic, assign) NSInteger leftScore;
@property (nonatomic, assign) NSInteger rightScore;

/** Starts the game. */
- (void)start;
/** Restarts the game, positioning the ball in the center of the screen. */
- (void)restart;
/** Updates the game state on each tick. */
- (void)step:(ccTime)dt;
 /** Checks if a player scored. */
- (void)checkForScore;
/** Checks for collisions between the ball and other elements. */
- (void)checkForCollisions;
/** Updates the paddle positions according to touch events. */
- (void)updatePaddlePositionsFromTouches:(NSSet*)touches;

@end
