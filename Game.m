//
//  Game.m
//  ColourMemory
//

#import "Game.h"
#import "RoundData.h"
#include <stdlib.h>
#import "Card.h"

#define NUMBER_OF_CARD_TYPE 8

@interface Game ()

// This array store the list of cards of the game
@property (strong, nonatomic) NSArray *cards;

// Object containing the data of the round to be return the the UI
@property (strong, nonatomic) RoundData *roundData;

@end

@implementation Game

// Generate the game
- (void)generateAndStart
{
    self.points = 0;
    self.cards = [self createGameCardsDefinition];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.cards forKey:@"preferenceName"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    self.roundData = [[RoundData alloc] init];
    
    // debugging purposes
    [self logCardsArrangementForDebugging];
}


// get the type of the card (from 0 to 7) for the given index. Index should be between [0 and 15]
- (NSInteger)getCardTypeIndex:(NSInteger)index
{
    Card *card = [self.cards objectAtIndex:index];
    return card.codeType;
}

// Want to flip the card at the given index. Return YES if we can and update the internal state of the game.
// return NO if we cant
- (BOOL)flipCardAtIndex:(NSInteger)index
{
    Card *card = [self.cards objectAtIndex:index];
    
    if(![card canBeFlipped])
        return NO;
    
    // flag the card to be returned or founded
    [card flip];
    
    switch (self.roundData.state) {
        // First card we returned in this round
        case NothingPlayed:
            self.roundData.card1 = card;
            self.roundData.state = OneCardReturned;
            break;
        
        // second card returned in this round
        case OneCardReturned:
            self.roundData.card2 = card;
            [self checkOnRoundStatus];
        default:
            break;
    }
    
    return YES;
}

// Function is seting the necessary internal flags and data based on the game played by the user
- (void)checkOnRoundStatus
{
    Card *card1 = self.roundData.card1;
    Card *card2 = self.roundData.card2;
    
    if(card1.codeType == card2.codeType) {
        self.points += 2;
        [card1 cardisFound];
        [card2 cardisFound];
        
        self.roundData.state = [self isGameOver] ? TwoCardsReturnedSimilarAndEndOfTheGame : TwoCardsReturnedSimilarAndMoreToPlay;
    } else {
        self.points -= 1;
        [card1 flip];
        [card2 flip];
        
        self.roundData.state = TwoCardsReturnedButDifferent;
    }
}

- (RoundData *)getLastRoundData
{
    if(self.roundData.state == NothingPlayed || self.roundData.state == OneCardReturned)
        return self.roundData;
    
    RoundData *result = [self.roundData copy];
    [self.roundData reset];
    
    return result;
}

#pragma mark private functions

// Algorithm to generate a random game
- (NSArray *)createGameCardsDefinition
{
    NSMutableArray *cards = [[NSMutableArray alloc] init];
    
    // init the card games
    NSInteger countersForCards[8] = {2, 2, 2, 2, 2, 2, 2, 2};
    for(int i = 0; i < NUMBER_OF_CARD_TYPE * 2; i++) {
        do {
            NSInteger random = arc4random_uniform(NUMBER_OF_CARD_TYPE);
            if(countersForCards[random] > 0) {
                countersForCards[random]--;
                Card *card = [[Card alloc] initWithIndex:i withCodeType:random];
                [cards addObject:card];
                break;
            }
            
        } while(true);
    }
    
    return cards;
}

// return YES of the game is over. we pars all card cna check their status.
// To optimize we could keep a counter to the number of founded pair, but as the array is small we can proceed this way.
- (BOOL)isGameOver
{
    for(Card * card in self.cards) {
        if(![card isFound])
            return NO;
    }
    return YES;
}

// Just for debug purposes
- (void)logCardsArrangementForDebugging
{
    for(int i = 0; i < 4; i ++) {
        NSString *line = @"";
        for(int j = 0; j < 4; j ++) {
            NSInteger index = i * 4 +j;
            Card * card = [self.cards objectAtIndex:index];
            line = [NSString stringWithFormat:@"%@ %ld", line, (long)card.codeType];
        }
        NSLog(@"%@", line);
    }
}


@end
