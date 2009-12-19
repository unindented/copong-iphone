//
//  GameScene.m
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

#import "GameScene.h"


#pragma mark -
#pragma mark Scene


@implementation GameScene

- (id)init
{
    if ((self = [super init]) != nil)
    {
        CGSize winSize = [[Director sharedDirector] winSize];
        
        // set the background
        Sprite* bg = [Sprite spriteWithFile:@"game.png"];
        [bg setPosition:ccp(winSize.width / 2, winSize.height / 2)];
        [self addChild:bg z:0];    
        
        // add the menu layer
        GameLayer* gameLayer = [GameLayer node];
        [self addChild:gameLayer z:1];
    }
    
    return self;
}

@end


#pragma mark -
#pragma mark Layer


@implementation GameLayer

@synthesize leftPaddle;
@synthesize rightPaddle;
@synthesize ball;
@synthesize leftScoreLabel;
@synthesize rightScoreLabel;
@synthesize leftScore;
@synthesize rightScore;
@synthesize lastScored;
@synthesize gameState;

- (id)init
{
    if ((self = [super init]) == nil)
    {
        return nil;
    }
    
    CGSize winSize = [[Director sharedDirector] winSize];
    
    // create paddles
    Paddle* tmpLeftPaddle = [[Paddle alloc] init];
    self.leftPaddle = tmpLeftPaddle;
    [tmpLeftPaddle release];
    Paddle* tmpRightPaddle = [[Paddle alloc] init];
    self.rightPaddle = tmpRightPaddle;
    [tmpRightPaddle release];
    
    // place paddles
    self.leftPaddle.position = ccp(DISTANCE_WALL_PADDLE, winSize.height / 2);
    [self addChild:leftPaddle z:1];
    self.rightPaddle.position = ccp(winSize.width - DISTANCE_WALL_PADDLE, winSize.height / 2);
    [self addChild:rightPaddle z:1];
    
    // create ball
    Ball* tmpBall = [[Ball alloc] init];
    self.ball = tmpBall;
    [tmpBall release];
    
    // place ball
    self.ball.position = ccp(winSize.width / 2, winSize.height / 2);
    [self addChild:ball z:1];
    
    // create labels
    LabelAtlas* tmpLeftLabel = [[LabelAtlas alloc] initWithString:@"00" charMapFile:@"score_images.png" itemWidth:38 itemHeight:40 startCharMap:'0'];
    self.leftScoreLabel = tmpLeftLabel;
    [tmpLeftLabel release];
    LabelAtlas* tmpRightLabel = [[LabelAtlas alloc] initWithString:@"00" charMapFile:@"score_images.png" itemWidth:38 itemHeight:40 startCharMap:'0'];
    self.rightScoreLabel = tmpRightLabel;
    [tmpRightLabel release];
    
    // place labels
    self.leftScoreLabel.position = ccp(winSize.width / 2 - 100, winSize.height - 50);
    [self addChild:leftScoreLabel z:0];
    self.rightScoreLabel.position = ccp(winSize.width / 2 + 24, winSize.height - 50);
    [self addChild:rightScoreLabel z:0];
    
    // enable touch events for this layer
    self.isTouchEnabled = YES;
    
    // schedule updates
    [self schedule: @selector(step:)];
    
    // the game will start after 2 seconds
    self.gameState = kGameStatePaused;
    [self performSelector:@selector(start) withObject:nil afterDelay:2];
    
    return self;
}

- (void)dealloc
{
    [leftPaddle release];
    [rightPaddle release];
    [ball release];
    [leftScoreLabel release];
    [rightScoreLabel release];
    [super dealloc];
}

#pragma mark Properties

- (void)setLeftScore:(NSInteger)score
{
    leftScore = score;
    // update label
    NSString* tmpString = [[NSString alloc] initWithFormat:@"%.2d", score];
    [leftScoreLabel setString:tmpString];
    [tmpString release];
}

- (void)setRightScore:(NSInteger)score
{
    rightScore = score;
    // update label
    NSString* tmpString = [[NSString alloc] initWithFormat:@"%.2d", score];
    [rightScoreLabel setString:tmpString];
    [tmpString release];
}

#pragma mark Step

- (void)start
{
    srandom(time(NULL));
    
    // reset the scores
    self.leftScore = 0;
    self.rightScore = 0;
    self.lastScored = kNoPlayer;
    
    // and begin the game
    [self restart];
}


- (void)restart
{
    // the ball starts in the middle of the screen, towards the player who last lost a point
    if (self.lastScored == kRightPlayer)
    {
        [self.ball resetToLeft];
    }
    else
    {
        [self.ball resetToRight];
    }
    
    // the paddles haven't moved
    [self.leftPaddle reset];
    [self.rightPaddle reset];
    
    // everything is ready, let's go
    self.gameState = kGameStateRunning;
}

- (void)step:(ccTime)dt
{
    if (self.gameState != kGameStateRunning)
    {
        return;
    }
    
    // move the ball
    [self.ball move:dt];
    // check for score
    [self checkForScore];
    // check for collisions
    [self checkForCollisions];
}

- (void)checkForScore
{
    BOOL scored = [self.ball collideWithVerticalWall];
    
    // somebody scored?
    if (scored)
    {
        if (self.ball.velocity.x < 0)
        {
            // right player scored!
            self.rightScore++;
            self.lastScored = kRightPlayer;
        }
        else if (self.ball.velocity.x > 0)
        {
            // left player scored!
            self.leftScore++;
            self.lastScored = kLeftPlayer;
        }
        
        // pause and restart the game after 1 second
        self.gameState = kGameStatePaused;
        [self performSelector:@selector(restart) withObject:nil afterDelay:1];
    }
}

- (void)checkForCollisions
{
    // check for collisions with walls
    [self.ball collideWithHorizontalWall];
    
    // and with paddles
    if (self.ball.velocity.x < 0)
    {
        [self.ball collideWithSprite:leftPaddle];
    }
    else if (self.ball.velocity.x > 0)
    {
        [self.ball collideWithSprite:rightPaddle];
    }
}

#pragma mark Touch events

- (BOOL)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self updatePaddlePositionsFromTouches:touches];
    
    // this layer handled the touch events
    return kEventHandled;
}

- (BOOL)ccTouchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self updatePaddlePositionsFromTouches:touches];
    
    // this layer handled the touch events
    return kEventHandled;
}

- (BOOL)ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    // this layer handled the touch events
    return kEventHandled;
}

- (void)updatePaddlePositionsFromTouches:(NSSet*)touches
{
    CGSize winSize = [[Director sharedDirector] winSize];
    
    for (UITouch* touch in touches)
    {
        CGPoint previousPosition = [touch previousLocationInView:touch.view];
        // convert coordinate from UIKit to OpenGL
        previousPosition = [[Director sharedDirector] convertToGL:previousPosition];
        
        CGPoint currentPosition = [touch locationInView:touch.view];
        // convert coordinate from UIKit to OpenGL
        currentPosition = [[Director sharedDirector] convertToGL:currentPosition];
        
        if (currentPosition.x < winSize.width / 2)
        {
            // finger on left side of the screen, so move left paddle
            [self.leftPaddle moveFrom:previousPosition to:currentPosition];
        }
        else
        {
            // finger on right side of the screen, so move right paddle
            [self.rightPaddle moveFrom:previousPosition to:currentPosition];
        }
    }
}

@end
