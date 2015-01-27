//
//  StartScene.m
//  SmashSprite
//
//  Created by 13cm0143 on 2014/10/15.
//  Copyright (c) 2014年 13cm. All rights reserved.
//

#import "StartScene.h"
#import "MySprite.h"
#import "MyScene.h"

@implementation StartScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
         SKSpriteNode *back = [SKSpriteNode spriteNodeWithImageNamed:@"devil.jpeg"];
        back.position = CGPointMake(self.size.width / 2, self.size.height / 2);
        [self addChild:back];
        
        
        self.backgroundColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1.0];
        
//        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"American Typewriter"];
//        myLabel.fontColor = [SKColor redColor];
//        myLabel.text = @"Start!";
//        myLabel.fontSize = 40;
//        myLabel.position = CGPointMake(self.size.width -158 , 125);
//        myLabel.userInteractionEnabled = YES;
//        [self addChild:myLabel];
       
        MySprite *sprite = [MySprite spriteNodeWithImageNamed:@"start.jpeg"];
        sprite.delegate = self;
        sprite.position = CGPointMake(self.size.width / 2, self.size.height / 4);
        sprite.userInteractionEnabled = YES;
        [self addChild:sprite];
        
       
    }
    return self;
}

- (void)spriteTouched:(SKSpriteNode *)myLabel
{
    //[self runAction:[SKAction playSoundFileNamed:@"Smash.caf" waitForCompletion:NO]];
    SKScene *gameScene = [MyScene sceneWithSize:self.size];
    gameScene.scaleMode = SKSceneScaleModeAspectFill;
    SKTransition *transition = [SKTransition doorwayWithDuration:2.0];
    [self.view presentScene:gameScene transition:transition];
}

@end
