//
//  SliderGame.m
//  SliderPuzzle
//
//  Created by Brandon on 4/29/14.
//  Copyright (c) 2014 Brandon Tauber. All rights reserved.
//

#import "SliderGame.h"

@implementation SliderGame
@synthesize active;

- (id)init {
    self = [super init];
    if (self) {
        gameArray = [NSMutableArray arrayWithCapacity:4];
        [gameArray addObject:[NSMutableArray arrayWithCapacity:4]];
        [gameArray addObject:[NSMutableArray arrayWithCapacity:4]];
        [gameArray addObject:[NSMutableArray arrayWithCapacity:4]];
        [gameArray addObject:[NSMutableArray arrayWithCapacity:4]];
        [self correctTiles];
        
        winningArray = [NSArray arrayWithObjects:
                        [NSArray arrayWithObjects:
                         [NSNumber numberWithInt:1],
                         [NSNumber numberWithInt:2],
                         [NSNumber numberWithInt:3],
                         [NSNumber numberWithInt:4],
                         nil],
                        [NSArray arrayWithObjects:
                         [NSNumber numberWithInt:5],
                         [NSNumber numberWithInt:6],
                         [NSNumber numberWithInt:7],
                         [NSNumber numberWithInt:8],
                         nil],
                        [NSArray arrayWithObjects:
                         [NSNumber numberWithInt:9],
                         [NSNumber numberWithInt:10],
                         [NSNumber numberWithInt:11],
                         [NSNumber numberWithInt:12],
                         nil],
                        [NSArray arrayWithObjects:
                         [NSNumber numberWithInt:13],
                         [NSNumber numberWithInt:14],
                         [NSNumber numberWithInt:15],
                         [NSNumber numberWithInt:0],
                         nil],
                        nil];
        
        self.active = false;
        return self;
    }
    return self;
}

- (void)setPosition:(NSUInteger)x :(NSUInteger)y :(NSNumber*)value {
    [[gameArray objectAtIndex:x] setObject:value atIndex:y];
}

- (NSNumber*)getPosition:(NSUInteger)x :(NSUInteger)y {
    return [[gameArray objectAtIndex:x] objectAtIndex:y];
}

- (NSMutableArray *)gameArray {
    return self.gameArray;
}

- (NSArray *)winningArray {
    return self.winningArray;
}

- (void)correctTiles {
    NSNumber *value;
    for (int x = 0; x < 4; x++) {
        for (int y = 0; y < 4; y++) {
            value = [NSNumber numberWithInt:x * 4 + y + 1];
            [self setPosition:x :y :value];
        }
    }
    [self setPosition:3 :3 :[NSNumber numberWithInt:0]];
}

- (NSArray *)tilePosition:(NSUInteger)value {
    int x = -1;
    int y = -1;
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            if ([[self getPosition:i :j] intValue] == value) {
                x = i;
                y = j;
                break;
            }
        }
        if (x > -1) {
            break;
        }
    }
    NSArray* positionArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:x],
                              [NSNumber numberWithInt:y],
                              nil];
    return positionArray;

}

- (void)randomizeTiles {
    bool isActive = self.active;
    self.active = true;
    [self correctTiles];
    int numMoves = 100;
    NSArray* zeroPosition;
    int x;
    int y;
    int lastX = -1;
    int lastY = -1;
    int lastX2 = -1;
    int lastY2 = -1;
    int chosen;
    for (int count = 0; count < numMoves; count++) {
        // find zero
        zeroPosition = [self tilePosition:0];
        x = [[zeroPosition objectAtIndex:0] intValue];
        y = [[zeroPosition objectAtIndex:1] intValue];
        // randomly pick tile to move into zero (no backsies)
        NSMutableArray *choices = [NSMutableArray array];
        if (x > 0) {
            [choices addObject:[NSArray arrayWithObjects:
                                [NSNumber numberWithInt:x - 1],
                                [NSNumber numberWithInt:y]
                                ,nil]];
        }
        if (x < 3) {
            [choices addObject:[NSArray arrayWithObjects:
                                [NSNumber numberWithInt:x + 1],
                                [NSNumber numberWithInt:y]
                                ,nil]];
        }
        if (y > 0) {
            [choices addObject:[NSArray arrayWithObjects:
                                [NSNumber numberWithInt:x],
                                [NSNumber numberWithInt:y - 1]
                                ,nil]];
        }
        if (y < 3) {
            [choices addObject:[NSArray arrayWithObjects:
                                [NSNumber numberWithInt:x],
                                [NSNumber numberWithInt:y + 1]
                                ,nil]];
        }
        chosen = arc4random() % ([choices count]);
        while (([[[choices objectAtIndex:chosen] objectAtIndex:0] intValue] == lastX
                && [[[choices objectAtIndex:chosen] objectAtIndex:1] intValue] == lastY)
               ||
               ([[[choices objectAtIndex:chosen] objectAtIndex:0] intValue] == lastX2
                && [[[choices objectAtIndex:chosen] objectAtIndex:1] intValue] == lastY2)) {
                   chosen = arc4random() % ([choices count]);
               }
        x = [[[choices objectAtIndex:chosen] objectAtIndex:0] intValue];
        y = [[[choices objectAtIndex:chosen] objectAtIndex:1] intValue];
        
        // move tile
        [self moveTile:x :y :nil];
        lastX2 = lastX;
        lastY2 = lastY;
        lastX = x;
        lastY = y;
    }
    self.active = isActive;
}

- (void)moveTile:(NSUInteger)x :(NSUInteger)y : (UIButton *)pressed {
    if (self.active) {
        NSNumber *tileValue = [self getPosition:x :y];
        NSNumber *zero = [NSNumber numberWithInt:0];
        if (tileValue > 0) {
            // move up
            if (x > 0 && [[self getPosition:x - 1 :y] intValue] == 0) {
                [self setPosition:x - 1 :y :tileValue];
                [self setPosition:x :y :zero];
                CGRect newFrame = CGRectMake(pressed.frame.origin.x, pressed.frame.origin.y-52, 52, 52);
                [UIView animateWithDuration:0.5 animations:^{
                    pressed.frame = newFrame;
                }];
            }
            // move down
            if (x < 3 && [[self getPosition:x + 1 :y] intValue] == 0) {
                [self setPosition:x + 1 :y :tileValue];
                [self setPosition:x :y :zero];
                CGRect newFrame = CGRectMake(pressed.frame.origin.x, pressed.frame.origin.y+52, 52, 52);
                [UIView animateWithDuration:0.5 animations:^{
                    pressed.frame = newFrame;
                }];
            }
            // move left
            if (y > 0 && [[self getPosition:x :y - 1] intValue] == 0) {
                [self setPosition:x :y - 1 :tileValue];
                [self setPosition:x :y :zero];
                CGRect newFrame = CGRectMake(pressed.frame.origin.x-52, pressed.frame.origin.y, 52, 52);
                [UIView animateWithDuration:0.5 animations:^{
                    pressed.frame = newFrame;
                }];
            }
            // move right
            if (y < 3 && [[self getPosition:x :y + 1] intValue] == 0) {
                [self setPosition:x :y + 1 :tileValue];
                [self setPosition:x :y :zero];
                CGRect newFrame = CGRectMake(pressed.frame.origin.x+52, pressed.frame.origin.y, 52, 52);
                [UIView animateWithDuration:0.5 animations:^{
                    pressed.frame = newFrame;
                }];
            }
        }
    }
}

- (bool)isAWin {
    return self.active && [gameArray isEqualToArray:winningArray];
}
@end
