//
//  ScoreDataManager.h
//  ColourMemoryGame
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ScoreDataManager : NSObject

@property (strong, nonatomic) NSManagedObjectContext *readingContext;

// Singleton class creation
+ (instancetype)sharedInstance;

// Managed object context creation
- (void)createManagedObjectContextsWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator;

// register and save the score data
- (void)registerScoreDataWithName:(NSString *)userName withPoints:(NSInteger)points;

@end
