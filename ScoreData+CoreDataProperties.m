//
//  ScoreData+CoreDataProperties.m
//  ColourMemoryGame
//
//  Created by Abhishek Kumar on 21/01/17.
//  Copyright © 2017 Abhishek Kumar. All rights reserved.
//

#import "ScoreData+CoreDataProperties.h"

@implementation ScoreData (CoreDataProperties)

+ (NSFetchRequest<ScoreData *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ScoreData"];
}

@dynamic name;
@dynamic points;

@end
