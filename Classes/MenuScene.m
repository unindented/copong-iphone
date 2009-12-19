//
//  MenuScene.m
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

#import "MenuScene.h"
#import "GameScene.h"


@implementation MenuScene

- (id)init
{
    if ((self = [super init]) != nil)
    {
        CGSize size = [[Director sharedDirector] winSize];
        
        // set the background
        Sprite* bg = [Sprite spriteWithFile:@"title.png"];
        [bg setPosition:ccp(size.width/2, size.height/2)];
        [self addChild:bg z:0];
        
        // add the menu layer
        MenuLayer* menuLayer = [MenuLayer node];
        [self addChild:menuLayer z:1];
    }
    
    return self;
}

@end


@implementation MenuLayer

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        CGSize winSize = [[Director sharedDirector] winSize];
        
        // build the menu options
        [MenuItemFont setFontSize:32];
        [MenuItemFont setFontName:@"Arial Rounded MT Bold"];
        
        MenuItem* startItem = [MenuItemFont itemFromString:@"Start Game"
                                                    target:self
                                                  selector:@selector(start:)];
        
        // and the menu itself
        Menu* menu = [Menu menuWithItems:startItem, nil];
        [menu alignItemsVertically];
        [menu setPosition:ccp(winSize.width/2, 100)];
        
        [self addChild:menu];
    }
    
    return self;
}

- (void)start:(id)sender
{
    // change to game scene using fade transition
    GameScene* gameScene = [GameScene node];
    TransitionScene* transition = [FadeTransition transitionWithDuration:1.5f scene:gameScene];
    [[Director sharedDirector] replaceScene:transition];
}

@end
