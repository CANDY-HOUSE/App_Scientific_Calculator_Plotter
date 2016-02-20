

#import "NewtonViewController.h"
#define iPhone5series (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)568)<DBL_EPSILON)
#define iOS_from(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define iOS_below(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


@interface NewtonViewController ()<UITextFieldDelegate,UIWebViewDelegate,UITextViewDelegate>

@end

@implementation NewtonViewController
NSString *youWantToN=@"You want to...",*doNothingN=@"Do nothing! Just wrong button",*clearDraftN=@"Clear input",*clearResultN=@"Clear Result";
NSTimer *timer;NSInteger textBoxIndex=0,OnOff=0,arcN=0,hypN=0;//private
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *myURLstring=[[NSBundle mainBundle] pathForResource:@"HTML5core/Newton's Method" ofType:@"html"];
    NSURL *myURL=[NSURL fileURLWithPath:myURLstring];
    NSURLRequest *myRequest=[NSURLRequest requestWithURL:myURL];
    [self.viewWebCMKU loadRequest:myRequest];
    self.viewWebCMKU.delegate=self;    
    [self dealHistoryOFDraftResult:0];

    
    Equation.inputView=startX.inputView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    startX.placeholder=@"0";

    if(iPhone5series  && iOS_from(@"7.0")){
        CGRect SBframe=slideKeyBoard.frame,mTframe=myViewText.frame,vwframe=self.viewWebCMKU.frame,explaninationfr=explaination.frame,xstartLabelfr=xstartLabel.frame,eqLabelfr=eqLabel.frame,startXfr=startX.frame,Equationfr=Equation.frame;
        
        mTframe.size.height=124;
        mTframe.origin.y=253;
        myViewText.frame=mTframe;
        explaninationfr.origin.y=4;explaination.frame=explaninationfr;
        eqLabelfr.origin.y=60;eqLabel.frame=eqLabelfr;
        Equationfr.origin.y=54;
        Equationfr.size.height=68;
        Equation.frame=Equationfr;
        xstartLabelfr.origin.y=37;xstartLabel.frame=xstartLabelfr;
        startXfr.origin.y=35;startX.frame=startXfr;
        startX.font=Equation.font = [UIFont fontWithName:@"HiraMinProN-W3" size:18];

        SBframe.origin.y=386;slideKeyBoard.frame=SBframe;
        
        vwframe.size.height=345+14;
        vwframe.origin.y=0;
/*
 vwframe.size.height=345;
 vwframe.origin.y=14;
 */
        self.viewWebCMKU.frame=vwframe;
        [[self.viewWebCMKU scrollView] setBounces: NO];//ios7蠢bug_UIWebView
        
    }else if(iOS_from(@"7.0")){//給iPhone4S以下
        CGRect SBframe=slideKeyBoard.frame,mTframe=myViewText.frame,vwframe=self.viewWebCMKU.frame;
        
        mTframe.origin.y=194;myViewText.frame=mTframe;
        
        SBframe.origin.y=301;slideKeyBoard.frame=SBframe;
        
        vwframe.origin.y=0;
//vwframe.origin.y=14;
        self.viewWebCMKU.frame=vwframe;
        [[self.viewWebCMKU scrollView] setBounces: NO];//ios7蠢bug_UIWebView
        
    }
    [x4Button setTitle:@"Solve  ax\u2074+bx\u00b3+cx\u00b2+dx+e=0" forState:UIControlStateNormal];
    
    clearallButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    clearallButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [clearallButton setTitle: @"clear\nall" forState: UIControlStateNormal];

    Equation.delegate=self;
    startX.delegate=self;
    Equation.tag=1;startX.tag=2;
    
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.4;
    [reverseButton addGestureRecognizer:longPress];
    switch (textBoxIndex) {
        case 1:[Equation becomeFirstResponder];break;
        case 2:[startX becomeFirstResponder];break;
        default:[Equation becomeFirstResponder];break;
    }

}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture {
    if(UIGestureRecognizerStateBegan == gesture.state) {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(deleteButton:) userInfo:nil repeats:YES];
    }
    if(gesture.state==UIGestureRecognizerStateCancelled ||
       gesture.state==UIGestureRecognizerStateFailed ||
       gesture.state==UIGestureRecognizerStateEnded) {
        [timer invalidate];
    }
}

/////////////////////////////////////////////////////
-(IBAction)backToCalculatorButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)to2DplotterButton:(id)sender{
    [self dismissViewControllerAnimated:NO completion:^{[[NSNotificationCenter defaultCenter] postNotificationName:@"clickPlot2D" object:self];}];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"clickPlot2D" object:self];
    //    [self dismissViewControllerAnimated:NO completion:nil];
}
-(IBAction)toX4solverButton:(id)sender{
    [self dismissViewControllerAnimated:NO completion:^{[[NSNotificationCenter defaultCenter] postNotificationName:@"clickX4solver" object:self];}];
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"iPhoneStoryboard" bundle:nil];
//    UIViewController *vc2 = [sb instantiateViewControllerWithIdentifier:@"X4SolverStoryboardid"];
//    UIViewController *vc1 = [sb instantiateViewControllerWithIdentifier:@"NewtonStoryboardid"];
//    UIViewController *vc0 = [sb instantiateViewControllerWithIdentifier:@"calculatorStoryboardid"];
//    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:vc0];
//    [vc1 performSegueWithIdentifier:modalID3 sender:sender]
//    [vc1 presentViewController:vc2 animated:YES completion:nil];
//  [[NSNotificationCenter defaultCenter] postNotificationName:@"clickX4solver" object:self];
//  [self dismissViewControllerAnimated:NO completion:nil];
//    [vc0 presentViewController:vc2 animated:YES completion:nil];
    
}
/////////////////////////////////////////////////////


-(IBAction)executeButton:(id)sender{
    NSString *eqItself=[Equation text];
        eqItself=[self robustTranslater:eqItself];
    NSString *startValue=[startX text];
        startValue=[self robustTranslater:startValue];
    NSString *jsCode = [NSString stringWithFormat:@"NewtonSolver('%@','%@');",eqItself,startValue];
    [self.viewWebCMKU stringByEvaluatingJavaScriptFromString:jsCode];
    [self dealHistoryOFDraftResult:1];
}
-(NSString*)robustTranslater:(NSString*)article{
    article=[article stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    article=[article stringByReplacingOccurrencesOfString:@"，" withString:@","];
    article=[article stringByReplacingOccurrencesOfString:@"（" withString:@"("];
    article=[article stringByReplacingOccurrencesOfString:@"）" withString:@")"];
    article=[article stringByReplacingOccurrencesOfString:@"！" withString:@"!"];
    article=[article stringByReplacingOccurrencesOfString:@"＋" withString:@"+"];//tw
    article=[article stringByReplacingOccurrencesOfString:@"—" withString:@"-"];//tw
    article=[article stringByReplacingOccurrencesOfString:@"－" withString:@"-"];//Jp
//    article=[article stringByReplacingOccurrencesOfString:@"ー" withString:@"-"];//Jp造成オッケー有問題
    article=[article stringByReplacingOccurrencesOfString:@"・" withString:@"·"];
    article=[article stringByReplacingOccurrencesOfString:@"／" withString:@"/"];
    article=[article stringByReplacingOccurrencesOfString:@"％" withString:@"%"];//Jp
    article=[article stringByReplacingOccurrencesOfString:@"＾" withString:@"^"];
    article=[article stringByReplacingOccurrencesOfString:@"｜" withString:@"|"];
    article=[article stringByReplacingOccurrencesOfString:@"＊" withString:@"*"];
    article=[article stringByReplacingOccurrencesOfString:@"＝" withString:@"="];
    article=[article stringByReplacingOccurrencesOfString:@"≡" withString:@"="];
    return article;
}


-(void)typing:(NSString*)param1{
    if(OnOff==1){
        switch (textBoxIndex) {
            case 1:[Equation insertText:param1];break;
            case 2:[startX insertText:param1];break;
        }
    }else if(OnOff==0){
        switch (textBoxIndex) {
            case 2:[startX becomeFirstResponder];break;
            default:[Equation becomeFirstResponder];break;
        }
    }
}
-(IBAction)deleteButton:(id)sender{
    if(OnOff==1){
        switch (textBoxIndex) {
            case 1:[Equation deleteBackward];break;
            case 2:[startX deleteBackward];break;
        }
    }else if(OnOff==0){
        switch (textBoxIndex) {
            case 1:[Equation becomeFirstResponder];break;
            default:[startX becomeFirstResponder];break;
        }
    }
}
-(IBAction)clearALLButton:(id)sender{
    UIAlertView *CMKUalertview= [[UIAlertView alloc] initWithTitle:youWantToN message:@"" delegate:self cancelButtonTitle:doNothingN otherButtonTitles:clearDraftN,clearResultN, nil];
    [CMKUalertview show];
}
//-(void)alertView函數是內建的,不用加協定！delegate:self 會讓這個物件自動呼叫-(void)alertView
-(void)alertView:(UIAlertView *)CMKU22222alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:/*cancelButtonTitle:*/
            break;
        case 1:{
            [Equation setText:@""];
            [startX setText:@""];
            break;
        }case 2:{
            NSString *jsCode = [NSString stringWithFormat:@"document.getElementById('resultsDisplayOfOthersFunctionality').innerHTML=''"];
            [self.viewWebCMKU stringByEvaluatingJavaScriptFromString:jsCode];
            [self dealHistoryOFDraftResult:1];
            break;
        }
    }
}
-(IBAction)inputButtonPoint:(id)sender{[self typing:@"."];}
-(IBAction)inputButton0:(id)sender{[self typing:@"0"];}
-(IBAction)inputButton1:(id)sender{[self typing:@"1"];}
-(IBAction)inputButton2:(id)sender{[self typing:@"2"];}
-(IBAction)inputButton3:(id)sender{[self typing:@"3"];}
-(IBAction)inputButton4:(id)sender{[self typing:@"4"];}
-(IBAction)inputButton5:(id)sender{[self typing:@"5"];}
-(IBAction)inputButton6:(id)sender{[self typing:@"6"];}
-(IBAction)inputButton7:(id)sender{[self typing:@"7"];}
-(IBAction)inputButton8:(id)sender{[self typing:@"8"];}
-(IBAction)inputButton9:(id)sender{[self typing:@"9"];}
-(IBAction)inputButtonLeft:(id)sender{[self typing:@"("];}
-(IBAction)inputButtonRight:(id)sender{[self typing:@")"];}
-(IBAction)inputButtonPower:(id)sender{[self typing:@"^"];}
-(IBAction)inputButtonPlus:(id)sender{[self typing:@"＋"];}/*tw的＋*/
-(IBAction)inputButtonMinus:(id)sender{[self typing:@"－"];}/*jp的－*/
-(IBAction)inputButtonMutiply:(id)sender{[self typing:@"×"];}
-(IBAction)inputButtonDivide:(id)sender{[self typing:@"/"];}
-(IBAction)inputButtonPSN:(id)sender{[self typing:@"%"];}

-(IBAction)arcMODEButton:(id)sender{
    arcN=(arcN+1)%2;
    if(arcN==1)[arcButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    else[arcButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
-(IBAction)hypMODEButton:(id)sender{
    hypN=(hypN+1)%2;
    if(hypN==1)[hypButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    else[hypButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
-(IBAction)inputButtonSIN:(id)sender{[self TriTyping:@"sin"];}
-(IBAction)inputButtonCOS:(id)sender{[self TriTyping:@"cos"];}
-(IBAction)inputButtonTAN:(id)sender{[self TriTyping:@"tan"];}
-(void)TriTyping:(NSString*)param1{
    NSString *str;
    if(arcN==0&&hypN==0)str=[NSString stringWithFormat:@"%@(",param1];
    else if(arcN==0&&hypN==1)str=[NSString stringWithFormat:@"%@h(",param1];
    else if(arcN==1&&hypN==0)str=[NSString stringWithFormat:@"a%@(",param1];
    else if(arcN==1&&hypN==1)str=[NSString stringWithFormat:@"a%@h(",param1];
    [self typing:str];
}
-(IBAction)inputButtonLOG:(id)sender{[self typing:@"log("];}
-(IBAction)inputButtonLN:(id)sender{[self typing:@"ln("];}
-(IBAction)inputButtonPI:(id)sender{[self typing:@"π"];}
-(IBAction)inputButtonE:(id)sender{[self typing:@"e"];}
-(IBAction)inputButtonABS:(id)sender{[self typing:@"|"];}
-(IBAction)inputButtonFAC:(id)sender{[self typing:@"!"];}
-(IBAction)inputButtonP:(id)sender{[self typing:@"P"];}
-(IBAction)inputButtonC:(id)sender{[self typing:@"C"];}
-(IBAction)inputButtonSQR:(id)sender{[self typing:@"√("];}
-(IBAction)inputButtonCBR:(id)sender{[self typing:@"∛("];}
-(IBAction)inputButtonDEG:(id)sender{[self typing:@"°"];}
-(IBAction)inputButtonEqualSign:(id)sender{[self typing:@"="];}
-(IBAction)inputButtonDot:(id)sender{[self typing:@"·"];}
-(IBAction)inputButtonX:(id)sender{[self typing:@"x"];}
-(IBAction)PanGestureKeyboard:(UIPanGestureRecognizer *)sender{
    CGRect frame=slideKeyBoard.frame;
    if(-640<=frame.origin.x&&frame.origin.x<=0){
        CGPoint translation=[sender translationInView:slideKeyBoard];
        frame.origin.x+=translation.x;//有＋
        slideKeyBoard.frame=frame;
        [sender setTranslation:CGPointMake(0, 0) inView:slideKeyBoard];//式,蘋果怪邏輯,非同步來防止origin二次以上累加
        //請分別測試  有＋有式;無＋有式;有＋無式;無＋無式;  然後理解原理
        
    }
    if(sender.state==UIGestureRecognizerStateEnded){
        CGPoint velocityX=[sender velocityInView:slideKeyBoard];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3f];//0.3 seconds
        if(velocityX.x<-2200){
            frame.origin.x=-640;
            slideKeyBoard.frame=frame;
        }else if(velocityX.x<-600){
            if(-320<frame.origin.x){frame.origin.x=-320;}
            else{frame.origin.x=-640;}
            slideKeyBoard.frame=frame;
        }else if(2200<velocityX.x){
            frame.origin.x=0;
            slideKeyBoard.frame=frame;
        }else if(600<velocityX.x){
            if(frame.origin.x<-320){frame.origin.x=-320;}
            else{frame.origin.x=0;}
            slideKeyBoard.frame=frame;
        }
        if(slideKeyBoard.frame.origin.x<=-480){
            frame.origin.x=-640;
            slideKeyBoard.frame=frame;
        }else if(-480<slideKeyBoard.frame.origin.x && slideKeyBoard.frame.origin.x<=-160){
            frame.origin.x=-320;
            slideKeyBoard.frame=frame;
        }else if(-160<slideKeyBoard.frame.origin.x){
            frame.origin.x=0;
            slideKeyBoard.frame=frame;
        }
        [UIView commitAnimations];
        //        NSLog(@"\n速度是%f",velocityX.x);
    }
}
- (void)dealHistoryOFDraftResult:(int)caseN{
    
    /*要用這個方法start*/
    NSString *plistPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    plistPath = [plistPath stringByAppendingPathComponent:@"history.plist"];
    // If the file doesn't exist in the Documents Folder, copy it.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:plistPath]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"history" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:plistPath error:nil];
    }
    /*要用這個方法end*/
    
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    switch (caseN) {
        case 1:{
            NSString *ResultHtml = [self.viewWebCMKU stringByEvaluatingJavaScriptFromString: @"document.getElementById('resultsDisplayOfOthersFunctionality').innerHTML"];
            [plistDict setValue:ResultHtml forKey:@"NewtonResult"];
        }case 3:{
            [plistDict setValue:Equation.text forKey:@"NewtonEq"];
            [plistDict setValue:startX.text forKey:@"NewtonStartX"];
            [plistDict writeToFile:plistPath atomically:YES];
            break;
        }case 0:{
            Equation.text=[plistDict objectForKey:@"NewtonEq"];
            startX.text=[plistDict objectForKey:@"NewtonStartX"];
            break;
        }case 2:{
            NSString *jsCode = [NSString stringWithFormat:@"document.getElementById('resultsDisplayOfOthersFunctionality').innerHTML='%@'",[plistDict objectForKey:@"NewtonResult"]];
            [self.viewWebCMKU stringByEvaluatingJavaScriptFromString:jsCode];
            break;
        }
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textBoxIndex=textField.tag;
    OnOff=1;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    OnOff=0;
    [self dealHistoryOFDraftResult:3];
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    [textView scrollRangeToVisible:textView.selectedRange];/*自動scroll到游標處*/
    textBoxIndex=textView.tag;
    OnOff=1;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    OnOff=0;
    [self dealHistoryOFDraftResult:3];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self dealHistoryOFDraftResult:2];
    NSString *jsCode = [NSString stringWithFormat:@"document.getElementById('resultsDisplayOfOthersFunctionality').scrollTop=document.getElementById('resultsDisplayOfOthersFunctionality').scrollHeight;"];
    [self.viewWebCMKU stringByEvaluatingJavaScriptFromString:jsCode];
    
    if(iPhone5series){
        [self.viewWebCMKU stringByEvaluatingJavaScriptFromString: @"document.getElementById('resultsDisplayOfOthersFunctionality').style.height = '242px';"];
//        [self.viewWebCMKU stringByEvaluatingJavaScriptFromString: @"document.getElementById('resultsDisplayOfOthersFunctionality').style.height = '228px';"];//238-14=224
    }
    
    NSString *languageCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([languageCode isEqualToString:@"zh-Hant"]||[languageCode isEqualToString:@"zh-Hans"]){
        [self.viewWebCMKU stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"internatioanlVersion(2);internatioanlVersionOfFunc2(2);"]];
        youWantToN=@"您想要...";
        doNothingN=@"沒事, 按錯了";
        clearDraftN=@"清除輸入欄";
        clearResultN=@"清除計算結果";
    }else if([languageCode isEqualToString:@"ja"]){
        [self.viewWebCMKU stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"internatioanlVersion(3);internatioanlVersionOfFunc2(3);"]];
        youWantToN=@"あなたは...";
        doNothingN=@"何もしない";
        clearDraftN=@"入力欄を消す";
        clearResultN=@"計算結果と履歴を消す";
    }
}

-(BOOL) shouldAutorotate {return NO;}/*防止轉90度,要允許轉的話直接刪掉或returnYES*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"收到記憶體不足的警訊");
}
- (BOOL)prefersStatusBarHidden/*YES: hide;NO:show*/
{
    return YES;
    //本頁&html xxxx.y=0或14 ; xxxxx.height=加不加14 都是在改這個
}


@end
