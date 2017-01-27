//
//  ScoreTableViewCell.m
//  ColourMemoryGame
//

#import "ScoreTableViewCell.h"
#import "ScoreData+CoreDataClass.h"

@implementation ScoreTableViewCell


/**
 Set the score data on the cell.

 @param scoreData the score data containing the rank, user name and the score of 
 the user
 @param index the index of the ranking
 */
- (void)setScoreData:(ScoreData *)scoreData atIndex:(NSInteger)index
{
    self.labelRank.text = [NSString stringWithFormat:@"%ld.", index + 1];
    self.labelUserName.text = scoreData.name;
    self.labelScore.text = [NSString stringWithFormat:@"%hd", scoreData.points];
}

@end
