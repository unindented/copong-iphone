//
//  Sprite+Utils.m
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

#import "Sprite+Utils.h"


@implementation Sprite (Utils)

- (BOOL)intersect:(Sprite*)other
{
    CGRect selfBox = self.boundingBox;
    CGRect otherBox = other.boundingBox;
    
    return !(selfBox.origin.x + selfBox.size.width < otherBox.origin.x
             || selfBox.origin.x > otherBox.origin.x + otherBox.size.width
             || selfBox.origin.y + selfBox.size.height < otherBox.origin.y
             || selfBox.origin.y > otherBox.origin.y + otherBox.size.height);
}

@end
