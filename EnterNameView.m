//
//  EnterNameView.m
//  ColourMemory
//

#import "EnterNameView.h"

@implementation EnterNameView

/**
 Called when Done button will be clicked. It sends the name entered by user back to 
 the controller.

 @param sender the button which is clicked
 */
- (IBAction)doneAction:(id)sender
{
    NSString *trimmedName = [self.textFieldUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if([trimmedName isEqualToString:@""]) {
        return;
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(enterNameView:didFinishWithName:)]) {
        [self.delegate enterNameView:self didFinishWithName:trimmedName];
    }
}

@end
