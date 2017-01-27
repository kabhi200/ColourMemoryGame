//
//  Card.m
//  ColourMemory
//

#import "Card.h"

typedef NS_ENUM(NSInteger, CardStatus) {
    FaceDown,
    FaceUp,
    Found
};

@interface Card ()

@property (assign) CardStatus status;

@end

@implementation Card


/**
 To initialize a card with an index and code type

 @param index index of a card
 @param codeType code type of the card
 @return return self.
 */
- (instancetype)initWithIndex:(NSInteger)index withCodeType:(NSInteger)codeType
{

    self = [super init];
    if(self != nil)
    {
        self.index = index;
        self.codeType = codeType;
    }
    
    return self;
}


/**
 To check the staus of the card, 
 whether the card's face is up or down.

 @return Return Yes if card is facing down
 and vice versa.
 */
- (BOOL)canBeFlipped
{
    return self.status == FaceDown;
}


/**
 Called when flip of card will occur.
 */
- (void)flip
{
    if(self.status == FaceDown)
        self.status = FaceUp;
    else if(self.status == FaceUp)
        self.status = FaceDown;
}


/**
 called when a card is found.
 */
- (void)cardisFound
{
    self.status = Found;
}


/**
 To check whether a card is found.

 @return Return Yes if the card is found.
 */
- (BOOL)isFound
{
    return self.status == Found;
}


@end
