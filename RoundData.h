//
//  RoundData.h
//  ColourMemory
//

#import <Foundation/Foundation.h>
#import "Card.h"

typedef NS_ENUM(NSInteger, RoundState) {
    NothingPlayed,
    OneCardReturned,
    TwoCardsReturnedButDifferent,
    TwoCardsReturnedSimilarAndMoreToPlay,
    TwoCardsReturnedSimilarAndEndOfTheGame,
};

@interface RoundData : NSObject <NSCopying>

@property (strong, nonatomic) Card *card1; // first card returned on the round
@property (strong, nonatomic) Card *card2; // second card returned on the round
@property (assign) RoundState state;       // Status of the round

- (instancetype)init;
- (void)reset;

@end
