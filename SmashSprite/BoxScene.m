//
//  BoxScene.m
//  SmashSprite
//
//  Created by 13cm0143 on 2014/11/12.
//  Copyright (c) 2014年 13cm. All rights reserved.
//

#import "BoxScene.h"

@interface BoxScene : SKScene

@property (strong, nonatomic) NSString *number;
@end

@implementation BoxScene

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    SKNode *helloNode = [self childNodeWithName:@"boxNode"];
    if (helloNode) {
        SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:1.0];
        BoxScene *openBox = [[BoxScene alloc] initWithSize:self.size];
       
        [self.view presentScene:openBox transition:doors];
    }
}

@end
