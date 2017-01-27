//
//  ScoreListViewController.m
//  ColourMemoryGame
//

#import "ScoreListViewController.h"

#import "ScoreTableViewCell.h"

#import <CoreData/CoreData.h>
#import "ScoreData+CoreDataClass.h"

#import "ScoreDataManager.h"

#define kScoreLimit 15

@interface ScoreListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation ScoreListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fetchScoreData];
    
    [self setupNavigationBar];
}

#pragma mark Setup Navigation Bar 

/**
 To set up the navigation bar.
 */
- (void)setupNavigationBar
{
    UIBarButtonItem *logoButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"logo"] style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeScoreView)];

    
    self.title = @"Scores";
    
    self.navigationItem.leftBarButtonItem = logoButtonItem;
    self.navigationItem.rightBarButtonItem = closeButtonItem;
}

/**
 To close the score view.
 */
- (void)closeScoreView
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}

#pragma mark Fetch Score Data

/**
 To fetch the score of the user.
 */
- (void)fetchScoreData
{
    ScoreDataManager *dataManager = [ScoreDataManager sharedInstance];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ScoreData" inManagedObjectContext:dataManager.readingContext];
    fetchRequest.entity = entity;
    
    [fetchRequest setFetchLimit:kScoreLimit];
    
    // Configure the request's entity, and optionally its predicate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"points" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:fetchRequest
                                     managedObjectContext:dataManager.readingContext
                                     sectionNameKeyPath:nil
                                     cacheName:@"data.highScores"];
    
    // fetch the scores
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
}


#pragma mark Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ScoresCellIdentifier";

    ScoreTableViewCell *cell = (ScoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ScoreTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    ScoreData *scoreData = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell setScoreData:scoreData atIndex:indexPath.row];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
