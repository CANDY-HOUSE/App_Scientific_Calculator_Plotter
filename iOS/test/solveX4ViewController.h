//
//  solveX4ViewController.h
//  SciCalcPlot
//
//  Created by Jerming on 2013/12/12.
//  Copyright (c) 2013年 Jerming. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface solveX4ViewController : UIViewController
{
    IBOutlet UIView *myViewText;
    IBOutlet UIView *slideKeyBoard;
    IBOutlet UIButton *arcButton;
    IBOutlet UIButton *hypButton;
    IBOutlet UIButton *clearallButton;
    IBOutlet UIButton *reverseButton;
    IBOutlet UIButton *x4Button;
    IBOutlet UILabel *x4Label;
    IBOutlet UILabel *aLabel;
    IBOutlet UILabel *bLabel;
    IBOutlet UILabel *cLabel;
    IBOutlet UILabel *dLabel;
    IBOutlet UILabel *eLabel;
    IBOutlet UITextField *xa;
    IBOutlet UITextField *xb;
    IBOutlet UITextField *xc;
    IBOutlet UITextField *xd;
    IBOutlet UITextField *xe;
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
-(IBAction)arcMODEButton:(id)sender;
-(IBAction)hypMODEButton:(id)sender;
-(IBAction)inputButtonSIN:(id)sender;
-(IBAction)inputButtonCOS:(id)sender;
-(IBAction)inputButtonTAN:(id)sender;
-(IBAction)inputButtonLOG:(id)sender;
-(IBAction)inputButtonLN:(id)sender;
-(IBAction)inputButtonPI:(id)sender;
-(IBAction)inputButtonE:(id)sender;
-(IBAction)inputButtonABS:(id)sender;
-(IBAction)inputButtonFAC:(id)sender;
-(IBAction)inputButtonP:(id)sender;
-(IBAction)inputButtonC:(id)sender;
-(IBAction)inputButtonSQR:(id)sender;
-(IBAction)inputButtonCBR:(id)sender;
-(IBAction)inputButtonDEG:(id)sender;
-(IBAction)inputButtoni:(id)sender;
-(IBAction)inputButtonDot:(id)sender;
-(IBAction)inputButtonStar:(id)sender;
-(IBAction)PanGestureKeyboard:(UIGestureRecognizer *)sender;

-(IBAction)backToCalculatorButton:(id)sender;
-(IBAction)toNewtonButton:(id)sender;
-(IBAction)to2DplotterButton:(id)sender;

@end
