//
//  MyScene2.m
//  SmashSprite
//
//  Created by 13cm0143 on 2014/12/19.
//  Copyright (c) 2014年 13cm. All rights reserved.
//

#import "MyScene2.h"

@implementation MyScene2

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        SKSpriteNode *image = [SKSpriteNode spriteNodeWithImageNamed:@"earth.jpg"];
        image.position = CGPointMake(self.size.width, self.size.height / 2);
        [image runAction:[SKAction repeatActionForever:
                          [SKAction sequence:@[
                                               [SKAction moveToY:0.0 duration:15.0],
                                               [SKAction moveToY:self.size.width duration:0.0]
                                               ]
                           ]
                          ]
         ];
        [self addChild:image];
        
        
    }
    return self;

}

@end
