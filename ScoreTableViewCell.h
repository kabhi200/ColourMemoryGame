//
//  ScoreTableViewCell.h
//  ColourMemoryGame
//

#import <UIKit/UIKit.h>

@class ScoreData;

@interface ScoreTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelRank;
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UILabel *labelScore;

// Set score data of the user on the cell.
- (void)setScoreData:(ScoreData *)scoreData atIndex:(NSInteger)index;

@end
