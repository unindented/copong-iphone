//
//  Paddle.m
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

#import "Paddle.h"


@implementation Paddle

- (id)init
{
    if ((self = [super init]) == nil)
    {
        return nil;
    }
    
    [self initWithFile:@"paddle.png"];
    
    return self;
}

- (void)reset
{
    self.velocity = ccp(0, 0);
}

- (void)moveFrom:(CGPoint)from to:(CGPoint)to
{
    self.position = ccp(self.position.x, to.y);
    self.velocity = ccp(0, (to.y - from.y) * 25); // magic multiplier, sorry
}

@end
