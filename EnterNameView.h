//
//  EnterNameView.h
//  ColourMemory
//

#import <UIKit/UIKit.h>

@protocol EnterNameViewDelegate;

@interface EnterNameView : UIView

@property (weak, nonatomic) IBOutlet UITextField *textFieldUserName;

@property (nonatomic, weak) id<EnterNameViewDelegate> delegate;

@end

@protocol EnterNameViewDelegate <NSObject>

// To pass the name entered by the user to the Controller.
- (void)enterNameView:(EnterNameView *)enterNameView didFinishWithName:(NSString *)userName;

@end
