//
//  Game.h
//  ColourMemory
//

#import <Foundation/Foundation.h>
#import "RoundData.h"


@interface Game : NSObject

@property (assign) NSInteger points;

// Initialization of the game
- (void)generateAndStart;

// get the type of the card for the given index (from 0 to 7)
- (NSInteger)getCardTypeIndex:(NSInteger)index;

// Flip the card at the given index if possible and return YES. return NO if we can't return it.
- (BOOL)flipCardAtIndex:(NSInteger)index;

// Return the round data corresponding to the ongoing round containing status and indexes of returrned cards.
- (RoundData *)getLastRoundData;


@end
