//
//  Created by Jerming on 13/7/21.
//  Copyright (c) 2013年 Jerming. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController 
{
    IBOutlet UITextView *myText;
    IBOutlet UIView *slideKeyBoard;
    IBOutlet UIButton *arcButton;
    IBOutlet UIButton *hypButton;
    IBOutlet UIButton *reverseButton;
    IBOutlet UIButton *x4Button;
    IBOutlet UIButton *nextEq;
    IBOutlet UIButton *plot2DButton;
    IBOutlet UIButton *NewtonButton;
}
@property (strong, nonatomic) IBOutlet UIWebView *viewWebCMKU;

-(IBAction)executeButton:(id)sender;
-(IBAction)deleteButton:(id)sender;
-(IBAction)clearALLButton:(id)sender;
-(IBAction)inputButtonPoint:(id)sender;
-(IBAction)inputButton0:(id)sender;
-(IBAction)inputButton1:(id)sender;
-(IBAction)inputButton2:(id)sender;
-(IBAction)inputButton3:(id)sender;
-(IBAction)inputButton4:(id)sender;
-(IBAction)inputButton5:(id)sender;
-(IBAction)inputButton6:(id)sender;
-(IBAction)inputButton7:(id)sender;
-(IBAction)inputButton8:(id)sender;
-(IBAction)inputButton9:(id)sender;
-(IBAction)inputButtonLeft:(id)sender;
-(IBAction)inputButtonRight:(id)sender;
-(IBAction)inputButtonPower:(id)sender;
-(IBAction)inputButtonPlus:(id)sender;
-(IBAction)inputButtonMinus:(id)sender;
-(IBAction)inputButtonMutiply:(id)sender;
-(IBAction)inputButtonDivide:(id)sender;
-(IBAction)inputButtonPSN:(id)sender;
-(IBAction)nextLineButton:(id)sender;

-(IBAction)arcMODEButton:(id)sender;
-(IBAction)hypMODEButton:(id)sender;
-(IBAction)inputButtonSIN:(id)sender;
-(IBAction)inputButtonCOS:(id)sender;
-(IBAction)inputButtonTAN:(id)sender;
-(IBAction)inputButtonLOG:(id)sender;
-(IBAction)inputButtonLN:(id)sender;
-(IBAction)inputButtonPI:(id)sender;
-(IBAction)inputButtonE:(id)sender;
-(IBAction)showKeyBoard:(id)sender;
-(IBAction)inputButtonABS:(id)sender;
-(IBAction)inputButtonFAC:(id)sender;
-(IBAction)inputButtonP:(id)sender;
-(IBAction)inputButtonC:(id)sender;
-(IBAction)inputButtonSQR:(id)sender;
-(IBAction)inputButtonCBR:(id)sender;
-(IBAction)inputButtonDEG:(id)sender;
-(IBAction)inputButtonEqualSign:(id)sender;
-(IBAction)inputButtonComma:(id)sender;
-(IBAction)inputButtoni:(id)sender;
-(IBAction)inputButtonDot:(id)sender;
-(IBAction)inputButtonStar:(id)sender;

-(IBAction)PanGestureKeyboard:(UIGestureRecognizer *)sender;
@end
