//
//  RoundData.m
//  ColourMemory
//

#import "RoundData.h"

@implementation RoundData


/**
 To initialize the object and call reset 
 if it is already initialized.

 @return <#return value description#>
 */
- (instancetype)init
{
    self = [super init];
    if(self != nil)
    {
        [self reset];
    }
    
    return self;
}


/**
 To reset the cards and the state
 */
- (void)reset
{
    self.card1 = nil;
    self.card2 = nil;
    self.state = NothingPlayed;
}


/**
 To get a copy of the Round Data object.

 @param zone the memory space
 @return the copy of the object
 */
-(id)copyWithZone:(NSZone *)zone
{
    RoundData *roundData = [[RoundData alloc] init];
    roundData.card1 = self.card1;
    roundData.card2 = self.card2;
    roundData.state = self.state;
    
    return roundData;
}

@end
