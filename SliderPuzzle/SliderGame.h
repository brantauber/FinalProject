//
//  SliderGame.h
//  SliderPuzzle
//
//  Created by Brandon on 4/29/14.
//  Copyright (c) 2014 Brandon Tauber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SliderGame : NSObject {
    NSMutableArray *gameArray;
    NSArray *winningArray;
}
@property bool active;

- (void) correctTiles;
- (NSArray *) tilePosition:(NSUInteger)value;
- (void) randomizeTiles;
- (void) moveTile: (NSUInteger)x :(NSUInteger)y :(UIButton *)pressed;
- (NSMutableArray *) gameArray;
- (void) setPosition: (NSUInteger)x :(NSUInteger)y :(NSNumber*)value;
- (NSNumber*) getPosition: (NSUInteger)x :(NSUInteger)y;
- (bool) isAWin;
@end
