//
//  MySprite.h
//  SmashSprite
//
//  Created by 13cm0143 on 2014/11/12.
//  Copyright (c) 2014年 13cm. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol MySpriteDelegate
- (void)spriteTouched:(SKSpriteNode *)sprite;
@end

@interface MySprite : SKSpriteNode
@property (weak) id delegate;
@end