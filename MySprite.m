//
//  MySprite.m
//  SmashSprite
//
//  Created by 13cm0143 on 2014/11/12.
//  Copyright (c) 2014年 13cm. All rights reserved.
//


#import "MySprite.h"

@implementation MySprite

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(spriteTouched:)]) {
        [self.delegate spriteTouched:self];
    }
}

@end
