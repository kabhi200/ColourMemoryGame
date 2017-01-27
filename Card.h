//
//  Card.h
//  ColourMemory
//


#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (assign) NSInteger index;
@property (assign) NSInteger codeType;

- (instancetype)initWithIndex:(NSInteger)index withCodeType:(NSInteger)codeType;

// return YES if the card can be returned
- (BOOL)canBeFlipped;

// flip the card
- (void)flip;

// This card has been founded by the user
- (void)cardisFound;

// return YES if the card has been founded
- (BOOL)isFound;

@end
