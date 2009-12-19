//
//  CopongAppDelegate.m
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

#import "CopongAppDelegate.h"

#import "cocos2d.h"

#import "MenuScene.h"


@implementation CopongAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication*)application
{
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [window setUserInteractionEnabled:YES];
    [window setMultipleTouchEnabled:YES];
    
    if (![Director setDirectorType:CCDirectorTypeDisplayLink])
    {
        [Director setDirectorType:CCDirectorTypeDefault];
    }
    
    [[Director sharedDirector] setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
    
    [[Director sharedDirector] setAnimationInterval:1.0/FPS];
    [[Director sharedDirector] setDisplayFPS:NO];
    
    [[Director sharedDirector] setPixelFormat:kRGBA8];
    [Texture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];    
    
    [[Director sharedDirector] attachInView:window];
    
    [window makeKeyAndVisible];
    
    // fix initial flicker
    Sprite* sprite = [[Sprite spriteWithFile:@"Default.png"] retain];
    sprite.anchorPoint = CGPointZero;
    [sprite draw];
    [[[Director sharedDirector] openGLView] swapBuffers];
    [sprite release];
    
    // start the fun
    MenuScene* menuScene = [MenuScene node];
    [[Director sharedDirector] runWithScene:menuScene];
}


// Getting a call, pause the game
- (void)applicationWillResignActive:(UIApplication*)application
{
    [[Director sharedDirector] pause];
}

// Call got rejected
- (void)applicationDidBecomeActive:(UIApplication*)application
{
    [[Director sharedDirector] resume];
}

// Purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
    [[TextureMgr sharedTextureMgr] removeAllTextures];
}

// Next delta time will be zero
- (void)applicationSignificantTimeChange:(UIApplication*)application
{
    [[Director sharedDirector] setNextDeltaTimeZero:YES];
}


- (void)dealloc
{
    [window release];
    [super dealloc];
}


@end
