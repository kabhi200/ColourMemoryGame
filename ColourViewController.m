//
//  ColourViewController.m
//  ColourMemoryGame
//

#import "ColourViewController.h"

#import "ScoreListViewController.h"
#import "EnterNameView.h"

#import "ScoreDataManager.h"
#import "Game.h"
#import "RoundData.h"

@interface ColourViewController () <EnterNameViewDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) Game *game;
@property (strong, nonatomic) NSArray *cardsButtons;
@property (strong, nonatomic) EnterNameView *enterNameView;

@end

@implementation ColourViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createCards];
    [self startGame];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    self.navigationController.delegate = self;
}

-(UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController
{
    return UIInterfaceOrientationMaskPortrait;
}

/**
 To view the score of the user.

 @param sender the button which is clicked.
 */
- (IBAction)viewScoreAction:(id)sender
{
    if(self.enterNameView != nil && self.enterNameView.hidden == NO) { //we are currently trying to enter a name after a game, so we need to wait a bit
        return;
    }
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *scoreVC = (ScoreListViewController*) [storyBoard instantiateViewControllerWithIdentifier:@"ScoreListViewController"];
    
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:scoreVC];
    
    [self.navigationController presentViewController:navC animated:YES completion:nil];
}


#pragma mark Setup Game


/**
 To start the game
 */
- (void)startGame
{
    self.game = [[Game alloc] init];
    [self.game generateAndStart];
    [self updatePointCount];
    [self setupCardsForGame];
}


/**
 To create card buttons
 */
- (void)createCards
{
    CGRect viewFrame = self.view.frame;
    CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
    
    int widthForCard = viewFrame.size.width / 4;
    int navBarHeightAndStatus = navigationBarFrame.size.height + 20;
    int heightForCard = (viewFrame.size.height - navBarHeightAndStatus) / 4;
    
    NSMutableArray *cardList = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < 4; i++) {
        for(int j = 0; j < 4; j++) {
            CGRect buttonFrame = CGRectMake(j * widthForCard, navBarHeightAndStatus + i * heightForCard, widthForCard, heightForCard);
            UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
            [self.view addSubview:button];
            [button addTarget:self action:@selector(cardPressedAction:) forControlEvents:UIControlEventTouchUpInside];

            int indexInArray = i * 4 + j;
            button.tag = indexInArray;
            [cardList addObject:button];
        }
    }
    self.cardsButtons = cardList;
}


/**
 To setup the cards for a game.
 */
- (void)setupCardsForGame
{
    for(int i = 0; i < 4; i++) {
        for(int j = 0; j < 4; j++) {
            int indexInArray = i * 4 + j;
            UIButton *button = [self.cardsButtons objectAtIndex:indexInArray];
            [button setImage:[UIImage imageNamed:@"card_bg"] forState:UIControlStateNormal];
            button.hidden = NO;
            
            [UIView animateWithDuration:0.3 animations:^{
                button.alpha = 1;
            } completion:^(BOOL finished){
            }];
        }
    }
}


/**
 To update the Point count.
 */
- (void)updatePointCount
{
    NSString *pointTitle = [NSString stringWithFormat:@"Score:%ld", (long)self.game.points];
    self.navigationItem.title = pointTitle;
}

#pragma mark Cards Animations

/**
 Called when a card is pressed to update the UI.

 @param btn the button representing the card.
 */
- (void)cardPressedAction:(UIButton*)btn
{
    if([self.game flipCardAtIndex:btn.tag]) {
        
        NSInteger typeIndex = [self.game getCardTypeIndex:btn.tag];
        NSString *imageName = [NSString stringWithFormat:@"colour%ld", (long)(typeIndex + 1)];
        [self animateCard:btn withFinalImage:imageName];
    }
    RoundData *roundData = [self.game getLastRoundData];
    [self refreshCardStatus:roundData];
    [self handleEndOfGame:roundData];
}

/**
 To refresh the card status.

 @param roundData RoundData object to check the status of the card.
 */
- (void)refreshCardStatus:(RoundData *)roundData
{
    if(roundData.state == NothingPlayed || roundData.state == OneCardReturned) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        UIButton *button1 = self.cardsButtons[roundData.card1.index];
        UIButton *button2 = self.cardsButtons[roundData.card2.index];
        if(roundData.state == TwoCardsReturnedButDifferent) {
            
            [self animateCard:button1 withFinalImage:@"card_bg"];
            [self animateCard:button2 withFinalImage:@"card_bg"];

        } else {
            [self hideCard:button1];
            [self hideCard:button2];
        }
        
        [self updatePointCount];
    });
}


/**
 To animate the card button on pressing it and change its image to a final image.

 @param button the card button which will be clicked.
 @param imageName the final image of the card.
 */
- (void)animateCard:(UIButton *)button withFinalImage:(NSString *)imageName
{
    [UIView animateWithDuration:0.3 animations:^{
        button.layer.transform = CATransform3DMakeRotation(M_PI / 2.0, 0.0, 1.0, 0.0);
    } completion:^(BOOL finished){
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            button.layer.transform = CATransform3DMakeRotation(0, 0.0, 1.0, 0.0);
        } completion:^(BOOL finished){
        }];
    }];
}

// nicer animation to hide card by animating alpha value


/**
 To hide the cards.

 @param button the button which will be made hidden.
 */
- (void)hideCard:(UIButton *)button
{
    [UIView animateWithDuration:0.3 animations:^{
        button.alpha = 0;
    } completion:^(BOOL finished){
        button.hidden = YES;
    }];
}

/**
 To ask the name of the user at the end of the game.

 @param roundData To check the state of the cards 
 */
- (void)handleEndOfGame:(RoundData *)roundData
{
    if(roundData.state != TwoCardsReturnedSimilarAndEndOfTheGame) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        NSLog(@"Game is over. You got %ld points", (long)self.game.points);
        self.enterNameView = [[[NSBundle mainBundle] loadNibNamed:@"EnterNameView" owner:self options:nil] lastObject];
        self.enterNameView.delegate = self;
        self.enterNameView.frame = self.view.frame;
        [self.view addSubview:self.enterNameView];
        [self.enterNameView.textFieldUserName becomeFirstResponder];
    });
}

#pragma mark Enter Name View delegate


/**
 Delegate method to dismiss the view after entering the name and pressing the Done button.

 @param enterNameView the view on which name is entered.
 @param userName the name entered by user.
 */

-(void)enterNameView:(EnterNameView *)enterNameView didFinishWithName:(NSString *)userName
{
    [self.enterNameView removeFromSuperview];
    self.enterNameView.hidden = YES;
    
    // Register a score into Core data
    [[ScoreDataManager sharedInstance] registerScoreDataWithName:userName withPoints:self.game.points];
    
    // show the high score panel
    [self viewScoreAction:nil];
    
    //restart a new game
    [self startGame];
}

/**
 To show the keyboard for entering the name
 
 @param notification this indicates the notification for the keyboard.
 */
- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    CGRect currentFrame = self.enterNameView.frame;
    CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
    CGFloat navBarHeightAndStatus = navigationBarFrame.size.height + 20;
    CGRect newFrame = CGRectMake(0, navBarHeightAndStatus, currentFrame.size.width, currentFrame.size.height - keyboardFrameBeginRect.size.height - navBarHeightAndStatus);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.enterNameView.frame = newFrame;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
