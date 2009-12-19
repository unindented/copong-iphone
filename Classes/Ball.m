//
//  Ball.m
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

#import "Ball.h"
#import "Paddle.h"


@interface Ball ()

- (void)reset:(CGFloat)velocityX;

@end


@implementation Ball

- (id)init
{
    if ((self = [super init]) == nil)
    {
        return nil;
    }
    
    [self initWithFile:@"ball.png"];
    
    return self;
}

- (void)resetToLeft
{
    [self reset:-INITIAL_BALL_VELOCITY_X];
}

- (void)resetToRight
{
    [self reset:INITIAL_BALL_VELOCITY_X];
}

- (void)reset:(CGFloat)velocityX
{
    CGSize winSize = [[Director sharedDirector] winSize];
    
    // the ball starts in the middle of the screen
    self.position = ccp(winSize.width / 2, winSize.height / 2);
    
    // the horizontal component of the velocity of the ball is given by the last player to score
    
    // the vertical component of the velocity of the ball is random
    CGFloat velocityY = (random() % (2 * INITIAL_BALL_VELOCITY_Y + 1)) - INITIAL_BALL_VELOCITY_Y;
    
    self.velocity = ccp(velocityX, velocityY);
}

- (BOOL)collideWithVerticalWall
{
    CGSize winSize = [[Director sharedDirector] winSize];
    
    if (!((self.velocity.x < 0 && self.boundingBox.origin.x <= 0)
            || (self.velocity.x > 0 && self.boundingBox.origin.x + self.boundingBox.size.width >= winSize.width)))
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)collideWithHorizontalWall
{
    CGSize winSize = [[Director sharedDirector] winSize];
    
    if (!((self.velocity.y < 0 && self.boundingBox.origin.y <= 0)
            || (self.velocity.y > 0 && self.boundingBox.origin.y + self.boundingBox.size.height >= winSize.height)))
    {
        return NO;
    }
    
    self.velocity = ccp(self.velocity.x, -self.velocity.y);
    
    return YES;
}

- (BOOL)collideWithSprite:(MovingSprite*)other
{
    if (![self intersect:other])
    {
        return NO;
    }
    
    // increase the horizontal speed 10% and reverse direction
    CGFloat velocityX = clamp(-self.velocity.x * 1.1f, -MAX_BALL_VELOCITY_X, MAX_BALL_VELOCITY_X);
    // transfer 50% of the vertical speed of the other sprite to the ball
    CGFloat velocityY = clamp(self.velocity.y + other.velocity.y * 0.5f, -MAX_BALL_VELOCITY_Y, MAX_BALL_VELOCITY_Y);
    
    self.velocity = ccp(velocityX, velocityY);
    
    return YES;
}

@end
