//
//  ScoreData+CoreDataProperties.h
//  ColourMemoryGame
//
//  Created by Abhishek Kumar on 21/01/17.
//  Copyright © 2017 Abhishek Kumar. All rights reserved.
//

#import "ScoreData+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ScoreData (CoreDataProperties)

+ (NSFetchRequest<ScoreData *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int16_t points;

@end

NS_ASSUME_NONNULL_END
