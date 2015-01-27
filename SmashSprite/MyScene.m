//
//  MyScene.m
//  SmashSprite
//
//  Created by 13cm0143 on 2014/10/15.
//  Copyright (c) 2014年 13cm. All rights reserved.
//

#import "StartScene.h"
#import "MySprite.h"
#import "MyScene.h"
#import "MyScene2.h"
#import <AVFoundation/AVFoundation.h>

@interface MyScene () <SKPhysicsContactDelegate>


@property (nonatomic, strong) SKPhysicsWorld *pysicsWorld;
@property (nonatomic, strong) NSTimer *bulletTimer;
@property (nonatomic, strong) NSTimer *enemyTimer;
@property (nonatomic, strong) NSTimer *sakanaTimer;
@property (nonatomic, strong) NSTimer *backgroud;
@property (nonatomic, strong) NSTimer *bossTimer;
@property (nonatomic, strong) NSTimer *bossTimer01;
@property (nonatomic, strong) NSTimer *bossTimer02;
@property (nonatomic, strong) NSTimer *bossShotTimer;

@property (nonatomic, strong) NSTimer *enemy1Timer;
@property (nonatomic, strong) NSTimer *enemy2Timer;
@property (nonatomic, strong) NSTimer *enemy3Timer;

@property (nonatomic) SKLabelNode *pointLabel;
@property (nonatomic) int point;
@property (nonatomic) float r;
@property (nonatomic) float x;
@property (nonatomic) float y;
@property (nonatomic) BOOL isLastUpdatetimeInitialized;
@property (nonatomic) NSTimeInterval lastUpdateTime;
@property (nonatomic) double gameTime;
@property (nonatomic) double lastEnemyTime;
@property (nonatomic) double lastItemTime;
@property (nonatomic) BOOL isGameOver;
@property (nonatomic) BOOL bossFlag;
@property (nonatomic) BOOL bossFlag2;
@property (nonatomic) BOOL warningFlag;
@property (nonatomic) BOOL warningFlag2;
@property (nonatomic) BOOL enemyFlag;
@property (nonatomic) SKSpriteNode *boss;
@property (nonatomic) SKSpriteNode *boss02;
@property (nonatomic) NSInteger bossHP;
@property (nonatomic) NSInteger boss2HP;
@property (nonatomic) SKSpriteNode *stone;
@property (nonatomic) SKSpriteNode *enemy01;
@property (nonatomic) SKSpriteNode *enemyH;
@property (nonatomic) SKSpriteNode *image;
@property (nonatomic) SKSpriteNode *sakana;

@property (nonatomic) SKSpriteNode *enemy0;
@property (nonatomic) SKSpriteNode *enemy00;
@property (nonatomic) SKSpriteNode *enemy000;



@property (nonatomic, strong)AVAudioPlayer *bgmPlayer;

//列挙型の変数定義
//列挙型とは、ざっくり言ってしまえば、「選択肢」を表す整数の定数を定義するための変数型
enum {
    kDragNone,
    kDragStart,
    kDragEnd,
};

@end

@implementation MyScene
{
    int lastShotTime1;
    int lastShotTime2;
    int lastShotTime3;
    SKSpriteNode *player;
    int playerstatus;
    
}

static const uint32_t playerCategory = 0x1 << 0;
static const uint32_t bulletCategory = 0x1 << 1;
static const uint32_t enemyCategory = 0x1 << 2;
static const uint32_t itemCategory = 0x1 << 3;
static const uint32_t doroidCategory = 0x1 << 4;
static const uint32_t BossCategory = 0x1 << 5;
static const uint32_t Boss2Category = 0x1 << 6;



static inline CGFloat skRandf() {
    return rand() / (CGFloat)RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.point = 0;
        self.isLastUpdatetimeInitialized = NO;
        self.lastUpdateTime = 0;
        self.gameTime = 0;
        self.isGameOver = NO;
        self.bossFlag = NO;
        self.bossFlag2 = NO;
        self.warningFlag = NO;
        self.warningFlag2 = NO;
        self.bossHP = 18;
        self.boss2HP = 17;
        
        
        //self.backgroud = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(back:) userInfo:nil repeats:YES];
        //self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        //SKTransition *image2 = [SKTransition fadeWithDuration:10.0]
        if (self.gameTime > 1.0) {
        
        NSError *error;
        //NSString *bgmPath = [[NSBundle mainBundle] pathForResource:@"game bgm.wav" ofType:@"caf"];
        NSURL *URL = [[NSBundle mainBundle]URLForResource:@"game bgm"withExtension:@".wav"];
        self.bgmPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:&error];
        self.bgmPlayer.numberOfLoops = -100;
        [self.bgmPlayer play];
        
        }
        
        
        //背景画像移動
        self.image = [SKSpriteNode spriteNodeWithImageNamed:@"sos"];
        self.image.position = CGPointMake(self.size.width, self.size.height / 2);
        [self.image runAction:[SKAction repeatActionForever:
                               [SKAction sequence:@[
                                                    [SKAction moveToY:0.0 duration:13.0],
                                                    [SKAction moveToY:self.size.width duration:0.0]
                                                    ]
                                ]
                               ]
         ];
        [self addChild:self.image];
        
        //ポイントラベル
        self.pointLabel = [SKLabelNode labelNodeWithFontNamed:@"American Typewriter"];
        self.pointLabel.text = [NSString stringWithFormat:@"point:%d", self.point];
        self.pointLabel.fontSize = 26;
        self.pointLabel.fontColor = [SKColor whiteColor];
        //self.pointLabel.position = CGPointMake(self.size.width / 2, 100);
        //self.pointLabel.position = CGPointMake(self.size.width - 260, 520); 左上
        self.pointLabel.position = CGPointMake(self.size.width -260 , 60);
        [self addChild:self.pointLabel];
        
        
        
        SKLabelNode *titleLabel1 = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        titleLabel1.text = @"stage1";
        //titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        //titleLabel1.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        titleLabel1.position = CGPointMake(self.size.width + 100, self.frame.size.height / 2);
        
        [self addChild:titleLabel1];
        SKAction *move1 = [SKAction moveToX:self.size.width / 2 duration:1.0];
        SKAction *wait = [SKAction waitForDuration:1.0];
        SKAction *move2 = [SKAction moveToX:-100 duration:1.0];
        SKAction *remove = [SKAction removeFromParent];
        
        [titleLabel1 runAction:[SKAction sequence:@[move1, wait, move2, remove]]];
        
        
        
        //initWithSizeなどのinitメソッドにおいて、自分自身を物理世界であることを認識さる。
        //重力無効
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        
        //        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        //
        //        myLabel.text = @"Hello, World!";
        //        myLabel.fontSize = 30;
        //        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
        //                                       CGRectGetMidY(self.frame));
        //
        //        [self addChild:myLabel];
        
        [self setUpPlayer];
        
        //
        //         SKAction *fadein = [SKAction fadeInWithDuration:0.8];
        //        SKAction *fadeout = [SKAction fadeOutWithDuration:0.8];
        //        NSArray *actions = [NSArray arrayWithObjects:fadeout, fadein, nil];
        //        SKAction *fadeinout = [SKAction sequence:actions];
        //          [ball runAction:[SKAction repeatActionForever:fadeinout]];
        
        // [self shot];
        // [ball runAction:remove];
        
        self.bulletTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(shot:) userInfo:nil repeats:YES];
        self.enemyTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(shotAtPoint:) userInfo:nil repeats:YES];
        self.sakanaTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sakanaPoint:) userInfo:nil repeats:YES];
        self.bossTimer01 = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(bossShot:) userInfo:nil repeats:YES];
        //self.minibossTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(minibossShot:) userInfo:nil repeats:YES];
        
    }
    return self;
}

//ゲームオーバー表示
- (void)createSceneContents {
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    titleLabel.text = @"ゲームオーバー";
    //titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    titleLabel.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [self addChild:titleLabel];
    
    //SJButtonNode *startButton = [SJButtonNode labe]
    
    
}



//自機
-(void)setUpPlayer {
    player = [SKSpriteNode spriteNodeWithImageNamed:@"shuttle"];
    player.size = CGSizeMake(75, 75);
    player.position = CGPointMake(160, 50);
    player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:player.size];
    
    player.physicsBody.categoryBitMask = playerCategory;
    player.physicsBody.contactTestBitMask = enemyCategory;
    player.physicsBody.dynamic = NO;
    player.name = @"player";
    [self addChild:player];
    
}

//弾丸
-(void)shot:(NSTimer *)timer
{
    
    if (self.gameTime > 1.0) {

    SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"tama.gif"];
    ball.size = CGSizeMake(30, 30);
    ball.position = player.position;
    ball.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ball.size];
    ball.physicsBody.affectedByGravity = NO;
    //自分のcategory
    ball.physicsBody.categoryBitMask = bulletCategory;
    //隕石とのcategory
    ball.physicsBody.contactTestBitMask = enemyCategory;
    ball.physicsBody.collisionBitMask = 0;
    [self addChild:ball];
    
    SKAction *move = [SKAction moveToY:800.0 duration:2.6];
    SKAction *remove = [SKAction removeFromParent];
    [ball runAction:[SKAction sequence:@[move, remove]]];
    }
    
}

//ボスの弾丸
-(void)bossShot:(NSTimer *)timer
{
    if (self.gameTime > 70.0) {
    SKSpriteNode *bossball = [SKSpriteNode spriteNodeWithImageNamed:@"maru.jpg"];
    bossball.size = CGSizeMake(30, 30);
    bossball.position = self.boss.position;
    bossball.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bossball.size];
    bossball.physicsBody.affectedByGravity = NO;
    //自分のcategory
    bossball.physicsBody.categoryBitMask = enemyCategory;
    //隕石とのcategory
    bossball.physicsBody.contactTestBitMask = bulletCategory;
    
    bossball.physicsBody.collisionBitMask = 0;
    [self addChild:bossball];
    
    int random_number;
    random_number = arc4random() % 5 + 5;
    
    SKAction *move = [SKAction moveToY:-400.0 duration:random_number];
    SKAction *remove = [SKAction removeFromParent];
    [bossball runAction:[SKAction sequence:@[move, remove]]];
    
    }
}

-(void)bossShot2:(NSTimer *)timer
{
    int separate = 30;
    //CGPoint point = CGPointMake(point.x + arc4random_uniform(10) , point.y + + arc4random_uniform(10));
    
    for(int i=0;i<separate;i++) {
        SKSpriteNode *bossball2 = [SKSpriteNode spriteNodeWithImageNamed:@"Bullet4.png"];
        bossball2.size = CGSizeMake(30, 30);
        bossball2.position = self.boss02.position;
        bossball2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bossball2.size];
        bossball2.physicsBody.affectedByGravity = NO;
        //自分のcategory
        bossball2.physicsBody.categoryBitMask = enemyCategory;
        //隕石とのcategory
        bossball2.physicsBody.contactTestBitMask = bulletCategory;
        
        bossball2.physicsBody.collisionBitMask = 0;
        
        //        float r  = self.size.height;
        //        float x  = r * cos( i * (2 * M_PI ) / separate );
        //        float y  = r * sin( i * (2 * M_PI ) / separate );
        
        [self addChild:bossball2];
        
        
        int random_number;
        random_number = arc4random() % 5 + 5;
        
        SKAction *move = [SKAction moveToY:-400.0 duration:random_number];
        SKAction *remove = [SKAction removeFromParent];
        [bossball2 runAction:[SKAction sequence:@[move, remove]]];
    }
    
}



//敵機
-(void)shotAtPoint:(NSTimer *)timer
{
    
    if (self.gameTime > 6.0) {
        
        NSLog(@"time = %f", timer.timeInterval);
        self.stone = [SKSpriteNode spriteNodeWithImageNamed:@"stone.png"];
        self.stone.size = CGSizeMake(30, 30);
        //ball.position = player.position;
        //stone.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height);
        self.stone.position = CGPointMake(skRand(0, self.size.width), self.size.height);
        self.stone.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.stone.size];
        self.stone.physicsBody.affectedByGravity = NO;
        //stone.physicsBody.velocity = CGVectorMake(0, -ENEMY_SPEED - _timeSinceStart * 3);
        self.stone.physicsBody.categoryBitMask = enemyCategory;
        self.stone.physicsBody.contactTestBitMask = bulletCategory;
        self.stone.physicsBody.collisionBitMask = 0;
        self.stone.physicsBody.usesPreciseCollisionDetection = YES;
        
        [self addChild:self.stone];
        
        int random_number;
        random_number = arc4random() % 5 + 5;
        
        
        // SKAction *move = [SKAction moveByX:0 y:-800 duration:4.0];
        SKAction *move = [SKAction moveToY:-400.0 duration:random_number];
        SKAction *remove = [SKAction removeFromParent];
        [self.stone runAction:[SKAction sequence:@[move, remove]]];
    }
    
}

-(void)sakanaPoint:(NSTimer *)timer
{
    
    if (self.gameTime > 12.0) {
        int deru = arc4random() % 3 + 1;
        
        if (deru == 1) {
            NSLog(@"time = %f", timer.timeInterval);
            self.sakana = [SKSpriteNode spriteNodeWithImageNamed:@"sakana.jpg"];
            self.sakana.size = CGSizeMake(30, 30);
            //ball.position = player.position;
            //stone.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height);
            self.sakana.position = CGPointMake(skRand(0, self.size.width), self.size.height);
            self.sakana.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.sakana.size];
            self.sakana.physicsBody.affectedByGravity = NO;
            //stone.physicsBody.velocity = CGVectorMake(0, -ENEMY_SPEED - _timeSinceStart * 3);
            self.sakana.physicsBody.categoryBitMask = enemyCategory;
            self.sakana.physicsBody.contactTestBitMask = bulletCategory;
            self.sakana.physicsBody.collisionBitMask = 0;
            self.sakana.physicsBody.usesPreciseCollisionDetection = YES;
            
            [self addChild:self.sakana];
            
            int random_number;
            random_number = arc4random() % 5 + 5;
            
            
            // SKAction *move = [SKAction moveByX:0 y:-800 duration:4.0];
            SKAction *move = [SKAction moveToY:-400.0 duration:random_number];
            SKAction *remove = [SKAction removeFromParent];
            [self.sakana runAction:[SKAction sequence:@[move, remove]]];
        }
    }
    
}

-(void)enemy1AtPoint:(NSTimer *)timer
{
    
    if (self.gameTime > 103.0) {
        
        int deru = arc4random() % 5 + 1;
        
        if (deru == 1 || deru == 2 || deru == 3) {
        
        NSLog(@"time = %f", timer.timeInterval);
        self.enemy0 = [SKSpriteNode spriteNodeWithImageNamed:@"androidify09.jpg"];
        self.enemy0.size = CGSizeMake(30, 30);
        //ball.position = player.position;
        //stone.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height);
        self.enemy0.position = CGPointMake(skRand(0, self.size.width), self.size.height);
        self.enemy0.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.enemy0.size];
        self.enemy0.physicsBody.affectedByGravity = NO;
        //stone.physicsBody.velocity = CGVectorMake(0, -ENEMY_SPEED - _timeSinceStart * 3);
        self.enemy0.physicsBody.categoryBitMask = enemyCategory;
        self.enemy0.physicsBody.contactTestBitMask = bulletCategory;
        self.enemy0.physicsBody.collisionBitMask = 0;
        self.enemy0.physicsBody.usesPreciseCollisionDetection = YES;
        
        [self addChild:self.enemy0];
        
        int random_number;
        random_number = arc4random() % 5 + 5;
        
        
        // SKAction *move = [SKAction moveByX:0 y:-800 duration:4.0];
        SKAction *scaleTo = [SKAction scaleTo:2.0 duration:1.0];
        SKAction *move = [SKAction moveToY:-400.0 duration:random_number];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *rotateForever =  [SKAction repeatActionForever:scaleTo];
        [self.enemy0 runAction:[SKAction sequence:@[[SKAction group:@[rotateForever, move]], move, remove]]];
        }
    }
    
}

-(void)enemy2AtPoint:(NSTimer *)timer
{
    
    if (self.gameTime > 110.0) {
        
        int deru = arc4random() % 5 + 1;
        
        if (deru == 1 || deru == 2 || deru == 3) {
        NSLog(@"time = %f", timer.timeInterval);
        self.enemy00 = [SKSpriteNode spriteNodeWithImageNamed:@"android12.jpeg"];
        self.enemy00.size = CGSizeMake(30, 30);
        //ball.position = player.position;
        //stone.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height);
        self.enemy00.position = CGPointMake(skRand(0, self.size.width),  (self.frame.size.height / 2) + 150);
        self.enemy00.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.enemy00.size];
        self.enemy00.physicsBody.affectedByGravity = NO;
        //stone.physicsBody.velocity = CGVectorMake(0, -ENEMY_SPEED - _timeSinceStart * 3);
        self.enemy00.physicsBody.categoryBitMask = enemyCategory;
        self.enemy00.physicsBody.contactTestBitMask = bulletCategory;
        self.enemy00.physicsBody.collisionBitMask = 0;
        self.enemy00.physicsBody.usesPreciseCollisionDetection = YES;
        
        [self addChild:self.enemy00];
        
        int random_number;
        random_number = arc4random() % 5 + 5;
        
        SKAction *kaiten = [SKAction rotateByAngle:M_PI duration:1.0];
        SKAction *rotateForever =  [SKAction repeatActionForever:kaiten];
        // SKAction *move = [SKAction moveByX:0 y:-800 duration:4.0];
        SKAction *move = [SKAction moveToY:-400.0 duration:random_number];
        SKAction *remove = [SKAction removeFromParent];
        [self.enemy00 runAction:[SKAction sequence:@[[SKAction group:@[rotateForever, move]], remove]]];
    
        }
    }
    
}

-(void)enemy3AtPoint:(NSTimer *)timer
{
    
    if (self.gameTime > 120.0) {
        int deru = arc4random() % 5 + 1;
        
        if (deru == 1 || deru == 2) {
        NSLog(@"time = %f", timer.timeInterval);
        self.enemy000 = [SKSpriteNode spriteNodeWithImageNamed:@"images.jpeg"];
        self.enemy000.size = CGSizeMake(30, 30);
        //ball.position = player.position;
        //stone.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height);
        self.enemy000.position = CGPointMake(skRand(0, self.size.width), self.size.height);
        self.enemy000.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.enemy000.size];
        self.enemy000.physicsBody.affectedByGravity = NO;
        //stone.physicsBody.velocity = CGVectorMake(0, -ENEMY_SPEED - _timeSinceStart * 3);
        self.enemy000.physicsBody.categoryBitMask = enemyCategory;
        self.enemy000.physicsBody.contactTestBitMask = bulletCategory;
        self.enemy000.physicsBody.collisionBitMask = 0;
        self.enemy000.physicsBody.usesPreciseCollisionDetection = YES;
        
        [self addChild:self.enemy000];
        
        int random_number;
        random_number = arc4random() % 5 + 5;
        
        SKAction *moveTo1 = [SKAction moveTo:CGPointMake(360, -300) duration:1.0];
        SKAction *moveTo2 = [SKAction moveTo:CGPointMake(-10, 300) duration:1.0];
        SKAction *moveAll = [SKAction sequence:@[moveTo1, moveTo2]];
        
        SKAction *moveTo3 = [SKAction moveTo:CGPointMake(320, -300) duration:1.0];
        SKAction *moveTo4 = [SKAction moveTo:CGPointMake(-20, 300) duration:1.0];
        SKAction *moveAlls = [SKAction sequence:@[moveTo3, moveTo4]];
        
        SKAction *moveAllss = [SKAction sequence:@[moveAll, moveAlls]];
        //SKAction *rotateForever =  [SKAction repeatActionForever:moveAllss];
        
        // SKAction *move = [SKAction moveByX:0 y:-800 duration:4.0];
        SKAction *move = [SKAction moveToY:-400.0 duration:random_number];
        SKAction *remove = [SKAction removeFromParent];
        [self.enemy000 runAction:[SKAction sequence:@[[SKAction group:@[moveAllss, move]], remove]]];
    }
    }
    
}

-(void)bossPoint:(NSTimer *)timer
{
    if (self.gameTime > 171.0) {
        SKAction *remove = [SKAction removeFromParent];
        [self.enemy0 runAction:remove];
        [self.enemy00 runAction:remove];
        [self.enemy000 runAction:remove];
        
        if (self.gameTime > 174.0) {
            if (!self.warningFlag2) {
                
                
                SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
                titleLabel.text = @"WARNING";
                titleLabel.fontColor = [SKColor redColor];
                titleLabel.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
                [self addChild:titleLabel];
                
                self.warningFlag2 = YES;
                
                SKAction *scaleUp = [SKAction scaleTo:1.5 duration:0.2];
                SKAction *scaleDefault = [SKAction scaleTo:1.0 duration:0.2];
                SKAction *scaleRepeat = [SKAction repeatAction:[SKAction sequence:@[scaleUp, scaleDefault]] count:10];
                [titleLabel runAction:[SKAction sequence:@[scaleRepeat, remove]]];
            }
        }
        
        if (self.gameTime > 180.0) {
            if (!self.bossFlag2) {
                self.boss02 = [SKSpriteNode spriteNodeWithImageNamed:@"usi.jpg"];
                self.boss02.size = CGSizeMake(100, 100);
                //ball.position = player.position;
                //stone.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height);
                self.boss02.position = CGPointMake(self.boss.size.width / 2 , self.size.height - 40);
                self.boss02.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.boss02.size];
                self.boss02.physicsBody.affectedByGravity = NO;
                //stone.physicsBody.velocity = CGVectorMake(0, -ENEMY_SPEED - _timeSinceStart * 3);
                self.boss02.physicsBody.categoryBitMask = Boss2Category;
                self.boss02.physicsBody.contactTestBitMask = bulletCategory;
                self.boss02.physicsBody.collisionBitMask = 0;
                self.boss02.physicsBody.usesPreciseCollisionDetection = YES;
                self.boss2HP = 17;
                
                [self addChild:self.boss02];
                
                self.bossFlag2 = YES;
                
                [self bossMove2];
            }
        }
    }
}

-(CGFloat)randFloat:(int)x
{
    return ( arc4random_uniform(x) + 1 )+ (arc4random_uniform(RAND_MAX) / (RAND_MAX * 1.0)) ;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    //    for (UITouch *touch in touches) {
    //        CGPoint location = [touch locationInNode:self];
    //
    //        SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"tama"];
    //
    //        ball.position = [self childNodeWithName:@"smash"].position;
    //
    //        SKAction *action = [SKAction rotateByAngle:M_PI duration:0.8];
    //
    //        [ball runAction:[SKAction repeatActionForever:action]];
    //
    //        [self addChild:ball];
    //    }
    
    //    CGPoint p = [[touches anyObject] locationInNode:self];
    //    SKNode *node = [self childNodeWithName:@"smash"];
    //
    //    if ([node containsPoint:p]) {
    //        [self fire];
    //    } else {
    //        node.position = CGPointMake(p.x, node.position.y);
    //    }
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        if(node != nil && [node.name isEqualToString:@"player"]) {
            playerstatus = kDragStart;
            break;
        }
    }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if(playerstatus == kDragStart ){
        UITouch *touch = [touches anyObject];
        CGPoint touchPos = [touch locationInNode:self];
        player.position = CGPointMake(touchPos.x, touchPos.y);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(playerstatus == kDragStart ){
        playerstatus = kDragEnd;
    }
}

- (void)update:(NSTimeInterval)currentTime {
    if (!self.isLastUpdatetimeInitialized) {
        self.isLastUpdatetimeInitialized = YES;
        self.lastUpdateTime = currentTime;
    }
    
    NSTimeInterval timeSinceLast = currentTime - self.lastUpdateTime;
    self.lastUpdateTime = currentTime;
    self.gameTime += timeSinceLast;
    self.lastEnemyTime += timeSinceLast;
    self.lastItemTime += timeSinceLast;
    
    [self addenemy];
}

-(void)addenemy {
    if (self.isGameOver) {
        return;
    }
    
    
    if (self.lastItemTime > 5.0) {
        int deru = arc4random() % 5 + 1;
        
        if (deru == 1) {
            //NSLog(@"time = %f", timer.timeInterval);
            SKSpriteNode *item = [SKSpriteNode spriteNodeWithImageNamed:@"item.jpg"];
            item.size = CGSizeMake(30, 30);
            //ball.position = player.position;
            //stone.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height);
            item.position = CGPointMake(skRand(0, self.size.width), self.size.height);
            item.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:item.size];
            item.physicsBody.affectedByGravity = NO;
            //item.physicsBody.velocity = CGVectorMake(0, -ENEMY_SPEED - _timeSinceStart * 3);
            item.physicsBody.categoryBitMask = itemCategory;
            item.physicsBody.contactTestBitMask = playerCategory;
            item.physicsBody.collisionBitMask = 0;
            item.physicsBody.usesPreciseCollisionDetection = YES;
            
            [self addChild:item];
            
            int random_number;
            random_number = arc4random() % 5 + 5;
            
            
            
            // SKAction *move = [SKAction moveByX:0 y:-800 duration:4.0];
            SKAction *move = [SKAction moveToY:-700.0 duration:random_number];
            //move = [SKAction waitForDuration:30.0 withRange:5.0];
            SKAction *remove = [SKAction removeFromParent];
            [item runAction:[SKAction sequence:@[move, remove]]];
        }
        
        self.lastItemTime = 0;
    }
    
    if (self.gameTime > 3.0) {
        if (self.lastEnemyTime > 5.0) {
            //[self.enemyTimer invalidate];
            
            self.enemy01 = [SKSpriteNode spriteNodeWithImageNamed:@"android.jpeg"];
            self.enemy01.size = CGSizeMake(30, 30);
            //ball.position = player.position;
            //stone.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height);
            self.enemy01.position = CGPointMake(skRand(0, self.size.width), self.size.height);
            self.enemy01.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.enemy01.size];
            self.enemy01.physicsBody.affectedByGravity = NO;
            //stone.physicsBody.velocity = CGVectorMake(0, -ENEMY_SPEED - _timeSinceStart * 3);
            self.enemy01.physicsBody.categoryBitMask = enemyCategory;
            self.enemy01.physicsBody.contactTestBitMask = bulletCategory;
            self.enemy01.physicsBody.collisionBitMask = 0;
            self.enemy01.physicsBody.usesPreciseCollisionDetection = YES;
            
            [self addChild:self.enemy01];
            
            int random_number;
            random_number = arc4random() % 5 + 5;
            
            
            // SKAction *move = [SKAction moveByX:0 y:-800 duration:4.0];
            SKAction *move = [SKAction moveToY:-500.0 duration:random_number];
            //SKAction *rotateTo = [SKAction rotateToAngle:270.0 / 180.0 * M_PI duration:2.0 shortestUnitArc:YES];
            //move = [SKAction waitForDuration:30.0 withRange:5.0];
            SKAction *remove = [SKAction removeFromParent];
            SKAction *kaiten = [SKAction rotateByAngle:M_PI duration:1.0];
            SKAction *rotateForever =  [SKAction repeatActionForever:kaiten];
            
            
            [self.enemy01 runAction:[SKAction sequence:@[[SKAction group:@[rotateForever, move]], remove]]];
            
            
            //SKAction *scaleTo = [SKAction scaleTo:2.0 duration:1.0];
            
            //            SKAction *move = [SKAction moveToY:-500.0 duration:random_number];
            //            SKAction *rotateTo = [SKAction rotateToAngle:270.0 / 180.0 * M_PI duration:2.0 shortestUnitArc:YES];
            //            SKAction *remove = [SKAction removeFromParent];
            //            [self.enemy01 runAction:[SKAction sequence:@[rotateTo, move, remove]]];
            
            self.lastEnemyTime = 0;
            
            
        }
        
        if (self.gameTime > 60.0) {
            SKAction *remove = [SKAction removeFromParent];
            [self.stone runAction:remove];
            [self.enemy01 runAction:remove];
            [self.sakana runAction:remove];
            
            if (self.gameTime > 65.0) {
                if (!self.warningFlag) {
                    
                    
                    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
                    titleLabel.text = @"WARNING";
                    titleLabel.fontColor = [SKColor redColor];
                    titleLabel.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
                    [self addChild:titleLabel];
                    
                    self.warningFlag = YES;
                    
                    SKAction *scaleUp = [SKAction scaleTo:1.5 duration:0.2];
                    SKAction *scaleDefault = [SKAction scaleTo:1.0 duration:0.2];
                    SKAction *scaleRepeat = [SKAction repeatAction:[SKAction sequence:@[scaleUp, scaleDefault]] count:10];
                    [titleLabel runAction:[SKAction sequence:@[scaleRepeat, remove]]];
                }
            }
            
            
            
            if (self.gameTime > 70.0) {
                if (!self.bossFlag) {
                    self.boss = [SKSpriteNode spriteNodeWithImageNamed:@"boss.jpg"];
                    self.boss.size = CGSizeMake(100, 100);
                    //ball.position = player.position;
                    //stone.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height);
                    self.boss.position = CGPointMake(self.boss.size.width / 2 , self.size.height - 40);
                    self.boss.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.boss.size];
                    self.boss.physicsBody.affectedByGravity = NO;
                    //stone.physicsBody.velocity = CGVectorMake(0, -ENEMY_SPEED - _timeSinceStart * 3);
                    self.boss.physicsBody.categoryBitMask = BossCategory;
                    self.boss.physicsBody.contactTestBitMask = bulletCategory;
                    self.boss.physicsBody.collisionBitMask = 0;
                    self.boss.physicsBody.usesPreciseCollisionDetection = YES;
                    
                    [self addChild:self.boss];
                    
                    self.bossFlag = YES;
                    
                    [self bossMove];
                }
            }
            
        }
        
    }
    
}


-(void)bossMove {
    
    int nextPositionX = arc4random() % (int)self.size.width;
    int nextPositionY = arc4random() % (int)(self.size.height / 3) + (self.size.height * 2 / 3);
    CGPoint position = CGPointMake(nextPositionX, nextPositionY);
    
    float random_number = arc4random() % 1 + 0.5;
    
    SKAction *moveAction = [SKAction moveTo:position duration:random_number];
    [self.boss runAction:moveAction];
    
    self.bossTimer = [NSTimer scheduledTimerWithTimeInterval:random_number target:self selector:@selector(bossMove) userInfo:nil repeats:NO];
}

-(void)bossMove2 {
    
    int nextPositionX = arc4random() % (int)self.size.width;
    int nextPositionY = arc4random() % (int)(self.size.height / 3) + (self.size.height * 2 / 3);
    CGPoint position = CGPointMake(nextPositionX, nextPositionY);
    
    float random_number = arc4random() % 1 + 0.5;
    
    SKAction *moveAction = [SKAction moveTo:position duration:random_number];
    [self.boss02 runAction:moveAction];
    
    self.bossTimer = [NSTimer scheduledTimerWithTimeInterval:random_number target:self selector:@selector(bossMove2) userInfo:nil repeats:NO];
}


//衝突判定
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else if(contact.bodyA.categoryBitMask ){
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    } else {
        
    }
    
    //弾丸と敵との衝突判定
    if ((firstBody.categoryBitMask & bulletCategory) != 0) {
        
        if ((secondBody.categoryBitMask & enemyCategory) != 0) {
            NSString *sparkPath = [[NSBundle mainBundle] pathForResource:@"spark" ofType:@"sks"];
            SKEmitterNode *spark = [NSKeyedUnarchiver unarchiveObjectWithFile:sparkPath];
            spark.position = secondBody.node.position;
            spark.xScale = spark.yScale = 0.2f;
            [self addChild:spark];
            
            SKAction *fadeOut = [SKAction fadeOutWithDuration:0.3f];
            SKAction *remove = [SKAction removeFromParent];
            SKAction *sequence = [SKAction sequence:@[fadeOut, remove]];
            [spark runAction:sequence];
            
            [firstBody.node removeFromParent];
            [secondBody.node removeFromParent];
            NSLog(@"contact with world");
            
            //ポイント判定
            self.point++;
            self.pointLabel.text = [NSString stringWithFormat:@"point:%d", self.point];
            
            
        }
    }
    
    
    //弾丸とボスキャラとの衝突判定
    if ((firstBody.categoryBitMask & bulletCategory) != 0) {
        
        if ((secondBody.categoryBitMask & BossCategory) != 0) {
            self.bossHP--;
            self.boss2HP--;
            if (self.bossHP > 0 || self.boss2HP > 0) {
                [firstBody.node removeFromParent];
                
                if (self.bossHP == 6) {
                    //[self runAction:[SKAction playSoundFileNamed:@"Smash.caf" waitForCompletion:NO]];
                    SKTexture *smashTexture = [SKTexture textureWithImageNamed:@"majin.jpg"];
                    //SKTexture *defaultTexture = [SKTexture textureWithImageNamed:@"majin.jpg"];
                    //[self.boss runAction:[SKAction animateWithTextures:@[smashTexture, defaultTexture] timePerFrame:0.15]];
                    [self.boss runAction:[SKAction setTexture:smashTexture]];
                    
                    
                }
                
                if ((self.boss2HP == 3)) {
                    SKTexture *smashTexture = [SKTexture textureWithImageNamed:@"magic.jpg"];
                    SKTexture *defaultTexture = [SKTexture textureWithImageNamed:@"magic.jpg"];
                    [self.boss02 runAction:[SKAction animateWithTextures:@[smashTexture, defaultTexture] timePerFrame:0.15]];
                    [self.boss02 runAction:[SKAction setTexture:smashTexture]];
                }
                
                
                
            } else{
                NSString *sparkPath = [[NSBundle mainBundle] pathForResource:@"spark" ofType:@"sks"];
                SKEmitterNode *spark = [NSKeyedUnarchiver unarchiveObjectWithFile:sparkPath];
                spark.position = secondBody.node.position;
                spark.xScale = spark.yScale = 0.2f;
                [self addChild:spark];
                
                SKAction *fadeOut = [SKAction fadeOutWithDuration:0.3f];
                SKAction *remove = [SKAction removeFromParent];
                SKAction *sequence = [SKAction sequence:@[fadeOut, remove]];
                [spark runAction:sequence];
                
                [firstBody.node removeFromParent];
                [secondBody.node removeFromParent];
                NSLog(@"contact with world");
                
                [self.bossTimer01 invalidate];
                
                //ポイント判定
                self.point+= 100;
                self.pointLabel.text = [NSString stringWithFormat:@"point:%d", self.point];
                
                SKTexture *smashTexture = [SKTexture textureWithImageNamed:@"earth.jpg"];
                SKTexture *defaultTexture = [SKTexture textureWithImageNamed:@"earth.jpg"];
                [self.image runAction:[SKAction animateWithTextures:@[smashTexture, defaultTexture] timePerFrame:0.15]];
                [self.image runAction:[SKAction setTexture:smashTexture]];
                
                if (self.gameTime > 100.0) {
                SKLabelNode *titleLabel1 = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
                titleLabel1.text = @"stage2";
                titleLabel1.position = CGPointMake(self.size.width + 100, self.frame.size.height / 2);
               
                [self addChild:titleLabel1];
                SKAction *move1 = [SKAction moveToX:self.size.width / 2 duration:1.0];
                SKAction *wait = [SKAction waitForDuration:1.0];
                SKAction *move2 = [SKAction moveToX:-100 duration:1.0];
                
                
                [titleLabel1 runAction:[SKAction sequence:@[move1, wait, move2, remove]]];
                }
                
                self.enemy1Timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(enemy1AtPoint:) userInfo:nil repeats:YES];
                self.enemy2Timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(enemy2AtPoint:) userInfo:nil repeats:YES];
                self.enemy3Timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(enemy3AtPoint:) userInfo:nil repeats:YES];
                
                self.bossTimer02 = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(bossPoint:) userInfo:nil repeats:YES];
                
                self.bossShotTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(bossShot2:) userInfo:nil repeats:YES];
                
//                if (self.boss2HP == 0) {
//                    [self.bossShotTimer invalidate];
//                }
                
            }
            
        }
        
        if ((secondBody.categoryBitMask & Boss2Category) != 0) {
           
            self.boss2HP--;
            if (self.boss2HP > 0) {
                [firstBody.node removeFromParent];
                
                if ((self.boss2HP == 3)) {
                    SKTexture *smashTexture = [SKTexture textureWithImageNamed:@"magic.jpg"];
                    SKTexture *defaultTexture = [SKTexture textureWithImageNamed:@"magic.jpg"];
                    [self.boss02 runAction:[SKAction animateWithTextures:@[smashTexture, defaultTexture] timePerFrame:0.15]];
                    [self.boss02 runAction:[SKAction setTexture:smashTexture]];
                }
                
                
                
            } else{
                NSString *sparkPath = [[NSBundle mainBundle] pathForResource:@"spark" ofType:@"sks"];
                SKEmitterNode *spark = [NSKeyedUnarchiver unarchiveObjectWithFile:sparkPath];
                spark.position = secondBody.node.position;
                spark.xScale = spark.yScale = 0.2f;
                [self addChild:spark];
                
                SKAction *fadeOut = [SKAction fadeOutWithDuration:0.3f];
                SKAction *remove = [SKAction removeFromParent];
                SKAction *sequence = [SKAction sequence:@[fadeOut, remove]];
                [spark runAction:sequence];
                
                [firstBody.node removeFromParent];
                [secondBody.node removeFromParent];
                NSLog(@"contact with world");
                
                [self.bossTimer01 invalidate];
                
                //ポイント判定
                self.point+= 100;
                self.pointLabel.text = [NSString stringWithFormat:@"point:%d", self.point];
                
                if ((firstBody.categoryBitMask & playerCategory) != 0) {
                    
                    if ((secondBody.categoryBitMask & enemyCategory) != 0) {
                        SKAction *fadeOut = [SKAction fadeOutWithDuration:0.3f];
                        SKAction *remove = [SKAction removeFromParent];
                        SKAction *sequence = [SKAction sequence:@[fadeOut, remove]];
                        [secondBody.node removeAllActions];
                        [secondBody.node runAction:[SKAction moveTo:CGPointMake(firstBody.node.position.x, firstBody.node.position.y) duration:0.3]];
                        [secondBody.node runAction:[SKAction repeatActionForever:[SKAction rotateToAngle:2 * M_PI duration:0.2]]];
                        [secondBody.node runAction:sequence];
                        secondBody.node.physicsBody = nil;

                        
                    }
                }
                if (self.boss2HP == 0) {
                    [self.bossShotTimer invalidate];
                }
                
                
//                SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
//                titleLabel.text = @"Congratulationsヽ(^Д^*)/";
//                titleLabel.fontSize = 24;
//                titleLabel.fontColor = [SKColor blueColor];
//                titleLabel.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
//                [self addChild:titleLabel];
                
                MySprite *sprite = [MySprite spriteNodeWithImageNamed:@"clear.jpeg"];
                sprite.delegate = self;
                sprite.position = CGPointMake(self.size.width / 2, self.size.height / 2);
                sprite.userInteractionEnabled = YES;
                [self addChild:sprite];
                
            }

        }
    }
    
    
    //自機と敵との衝突判定
    if ((firstBody.categoryBitMask & playerCategory) != 0) {
        
        if ((secondBody.categoryBitMask & enemyCategory) != 0) {
            NSString *firePath = [[NSBundle mainBundle] pathForResource:@"fire" ofType:@"sks"];
            SKEmitterNode *fire = [NSKeyedUnarchiver unarchiveObjectWithFile:firePath];
            fire.position = secondBody.node.position;
            fire.xScale = fire.yScale = 0.2f;
            [self addChild:fire];
            
            SKAction *fadeOut = [SKAction fadeOutWithDuration:0.3f];
            SKAction *remove = [SKAction removeFromParent];
            SKAction *sequence = [SKAction sequence:@[fadeOut, remove]];
            [fire runAction:sequence];
            [firstBody.node removeFromParent];
            [secondBody.node removeFromParent];
            
            NSLog(@"contact with world");
            
            [self.bulletTimer invalidate];
            [self.enemyTimer invalidate];
            [self.sakanaTimer invalidate];
            
            [self.enemy1Timer invalidate];
            [self.enemy2Timer invalidate];
            [self.enemy3Timer invalidate];
            
            [self.bossTimer01 invalidate];
            [self.bossTimer02 invalidate];
            
            
            
            
            
            [self createSceneContents];
            
            [self.bgmPlayer stop];
            self.bgmPlayer = nil;
            
                        NSError *error;
                        NSURL *URL = [[NSBundle mainBundle]URLForResource:@"bom"withExtension:@".wav"];
                        self.bgmPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:&error];
                        self.bgmPlayer.numberOfLoops = 0;
                        [self.bgmPlayer play];
            
            self.isGameOver = YES;
            
            
            
        }
    }
    
    if ((firstBody.categoryBitMask & playerCategory) != 0) {
        
        if ((secondBody.categoryBitMask & doroidCategory) != 0) {
            
            
            NSString *firePath = [[NSBundle mainBundle] pathForResource:@"fire" ofType:@"sks"];
            SKEmitterNode *fire = [NSKeyedUnarchiver unarchiveObjectWithFile:firePath];
            fire.position = secondBody.node.position;
            fire.xScale = fire.yScale = 0.2f;
            [self addChild:fire];
            
            SKAction *fadeOut = [SKAction fadeOutWithDuration:0.3f];
            SKAction *remove = [SKAction removeFromParent];
            SKAction *sequence = [SKAction sequence:@[fadeOut, remove]];
            [fire runAction:sequence];
            [firstBody.node removeFromParent];
            [secondBody.node removeFromParent];
            
            NSLog(@"contact with world000");
            
            [self.bulletTimer invalidate];
            [self.enemyTimer invalidate];
            [self.sakanaTimer invalidate];
            
            [self.enemy1Timer invalidate];
            [self.enemy2Timer invalidate];
            [self.enemy3Timer invalidate];
            
            [self.bossTimer01 invalidate];
            [self.bossTimer02 invalidate];
            
            
            [self createSceneContents];
            
            [self.bgmPlayer stop];
            self.bgmPlayer = nil;
            
            
            self.isGameOver = YES;
            
            
            
        }
    }
    
    
    //自機とアイテムとの衝突判定
    if ((firstBody.categoryBitMask & playerCategory) != 0) {
        
        if ((secondBody.categoryBitMask & itemCategory) != 0) {
            //NSString *firePath = [[NSBundle mainBundle] pathForResource:@"fire" ofType:@"sks"];
            //SKEmitterNode *fire = [NSKeyedUnarchiver unarchiveObjectWithFile:firePath];
            //fire.position = secondBody.node.position;
            //fire.xScale = fire.yScale = 0.2f;
            //[self addChild:fire];
            
            //
            
            SKAction *fadeOut = [SKAction fadeOutWithDuration:0.3f];
            SKAction *remove = [SKAction removeFromParent];
            SKAction *sequence = [SKAction sequence:@[fadeOut, remove]];
            [secondBody.node removeAllActions];
            [secondBody.node runAction:[SKAction moveTo:CGPointMake(firstBody.node.position.x, firstBody.node.position.y) duration:0.3]];
            [secondBody.node runAction:[SKAction repeatActionForever:[SKAction rotateToAngle:2 * M_PI duration:0.2]]];
            [secondBody.node runAction:sequence];
            secondBody.node.physicsBody = nil;
            NSLog(@"contact with world");
            
            SKSpriteNode *ball1 = [SKSpriteNode spriteNodeWithImageNamed:@"tama.gif"];
            ball1.size = CGSizeMake(30, 30);
            ball1.position = player.position;
            ball1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ball1.size];
            ball1.physicsBody.affectedByGravity = NO;
            //自分のcategory
            ball1.physicsBody.categoryBitMask = bulletCategory;
            //隕石とのcategory
            ball1.physicsBody.contactTestBitMask = enemyCategory;
            ball1.physicsBody.collisionBitMask = 0;
            [self addChild:ball1];
            
            SKSpriteNode *ball2 = [SKSpriteNode spriteNodeWithImageNamed:@"tama.gif"];
            ball2.size = CGSizeMake(30, 30);
            ball2.position = player.position;
            ball2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ball2.size];
            ball2.physicsBody.affectedByGravity = NO;
            //自分のcategory
            ball2.physicsBody.categoryBitMask = bulletCategory;
            //隕石とのcategory
            ball2.physicsBody.contactTestBitMask = enemyCategory;
            ball2.physicsBody.collisionBitMask = 0;
            [self addChild:ball2];
            
            //SKAction *move = [SKAction moveToY:800.0 duration:1.6];
            //SKAction *remove = [SKAction removeFromParent];
            SKAction *move1 = [SKAction moveByX:(CGFloat)800 y:(CGFloat)800  duration:3.1];
            SKAction *move2 = [SKAction moveByX:(CGFloat)-800 y:(CGFloat)800 duration:3.1];
            
            [ball1 runAction:[SKAction sequence:@[move1, remove]]];
            [ball2 runAction:[SKAction sequence:@[move2, remove]]];
            
            
        }
    }
    
}

- (void)spriteTouched:(SKSpriteNode *)myLabel
{
    //[self runAction:[SKAction playSoundFileNamed:@"Smash.caf" waitForCompletion:NO]];
    SKScene *gameScene = [StartScene sceneWithSize:self.size];
    gameScene.scaleMode = SKSceneScaleModeAspectFill;
    //SKTransition *transition = [SKTransition doorwayWithDuration:2.0];
    [self.view presentScene:gameScene];
}

@end