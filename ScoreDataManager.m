//
//  ScoreDataManager.m
//  ColourMemoryGame
//

#import "ScoreDataManager.h"
#import "ScoreData+CoreDataClass.h"

@interface ScoreDataManager ()

@property (strong, nonatomic) NSManagedObjectContext *insertionContext;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation ScoreDataManager

#pragma mark - Initialization


/**
 Method to create a singleton class.

 @return return the class.
 */
+ (instancetype)sharedInstance
{
    static ScoreDataManager *dataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[self alloc] init];
    });
    
    return dataManager;
}

/**
 To create managed object context using persistent coordinator

 @param persistentStoreCoordinator the persistent store coordinator.
 */
- (void)createManagedObjectContextsWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    self.persistentStoreCoordinator = persistentStoreCoordinator;
    
    // create insertion context
    self.insertionContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    self.insertionContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    self.insertionContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    
    // create reading context
    self.readingContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    self.readingContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    self.readingContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
}


/**
 To register the score data and save the data in the context.

 @param userName the name of the user.
 @param points the point of the user.
 */
- (void)registerScoreDataWithName:(NSString *)userName withPoints:(NSInteger)points
{
    ScoreData *scoreData =  [NSEntityDescription insertNewObjectForEntityForName:@"ScoreData" inManagedObjectContext:self.insertionContext];
    scoreData.name = userName;
    scoreData.points = points;
    
    NSError *saveError = nil;

    [self.insertionContext save:&saveError];
}

@end
