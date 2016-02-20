

#import "solveX4ViewController.h"
#define iPhone5series (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)568)<DBL_EPSILON)
#define iOS_from(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define iOS_below(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface solveX4ViewController ()<UITextFieldDelegate,UIWebViewDelegate>

@end

@implementation solveX4ViewController
NSString *youWantToS=@"You want to...",*doNothingS=@"Do nothing! Just wrong button",*clearDraftS=@"Clear input",*clearResultS=@"Clear Result";
NSTimer *timer;NSInteger textboxIndex=0,onOff=0,arcS=0,hypS=0;//private
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
    NSString *myURLstring=[[NSBundle mainBundle] pathForResource:@"HTML5core/quartic Solver" ofType:@"html"];
    NSURL *myURL=[NSURL fileURLWithPath:myURLstring];
    NSURLRequest *myRequest=[NSURLRequest requestWithURL:myURL];
    [self.viewWebCMKU loadRequest:myRequest];
    self.viewWebCMKU.delegate=self;
    [self dealHistoryOFDraftResult:0];

    
    xb.inputView=xc.inputView=xd.inputView=xe.inputView=xa.inputView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    
	// Do any additional setup after loading the view.
    if(iPhone5series  && iOS_from(@"7.0")){
        CGRect SBframe=slideKeyBoard.frame,mTframe=myViewText.frame,b1frame=bLabel.frame,b2frame=xb.frame,c1frame=cLabel.frame,c2frame=xc.frame,d1frame=dLabel.frame,d2frame=xd.frame,e1frame=eLabel.frame,e2frame=xe.frame,vwframe=self.viewWebCMKU.frame;
        
        mTframe.size.height=124;
        mTframe.origin.y=253;
        myViewText.frame=mTframe;

        e1frame.origin.y=100;eLabel.frame=e1frame;
        d1frame.origin.y=82;dLabel.frame=d1frame;
        c1frame.origin.y=59.5;cLabel.frame=c1frame;
        b1frame.origin.y=39.25;bLabel.frame=b1frame;
        e2frame.origin.y=104;xe.frame=e2frame;
        d2frame.origin.y=84;xd.frame=d2frame;
        c2frame.origin.y=63;xc.frame=c2frame;
        b2frame.origin.y=42;xb.frame=b2frame;
        xe.font=xd.font=xc.font=xb.font=xa.font = [UIFont fontWithName:@"HiraMinProN-W3" size:17];

        vwframe.size.height=345+14;
        vwframe.origin.y=0;
/*        vwframe.size.height=345;
        vwframe.origin.y=14;
*/
        self.viewWebCMKU.frame=vwframe;
        [[self.viewWebCMKU scrollView] setBounces: NO];//ios7蠢bug_UIWebView

        
        SBframe.origin.y=386;slideKeyBoard.frame=SBframe;
        
    }else if(iOS_from(@"7.0")){//給iPhone4S以下
        CGRect SBframe=slideKeyBoard.frame,mTframe=myViewText.frame,vwframe=self.viewWebCMKU.frame;
        mTframe.size.height=114;
        mTframe.origin.y=184;
        myViewText.frame=mTframe;
        
        vwframe.origin.y=0;
        //vwframe.origin.y=14;
        self.viewWebCMKU.frame=vwframe;
        
        SBframe.origin.y=301;
        slideKeyBoard.frame=SBframe;
        
    }
    [x4Button setTitle:@"Solve  ax\u2074+bx\u00b3+cx\u00b2+dx+e=0" forState:UIControlStateNormal];
    [x4Label setText:@"Solve x for ax\u2074+bx\u00b3+cx\u00b2+dx+e=0"];
    xe.delegate=xd.delegate=xc.delegate=xb.delegate=xa.delegate=self;
    xa.tag=1;xb.tag=2;xc.tag=3;xd.tag=4;xe.tag=5;
    
    clearallButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    clearallButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [clearallButton setTitle: @"clear\nall" forState: UIControlStateNormal];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.4;
    [reverseButton addGestureRecognizer:longPress];
    switch (textboxIndex) {
        case 1:[xa becomeFirstResponder];break;
        case 2:[xb becomeFirstResponder];break;
        case 3:[xc becomeFirstResponder];break;
        case 4:[xd becomeFirstResponder];break;
        case 5:[xe becomeFirstResponder];break;
        default:[xa becomeFirstResponder];break;
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
//////////////////////////////////////////////////////////Notification
-(IBAction)backToCalculatorButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)toNewtonButton:(id)sender{
    [self dismissViewControllerAnimated:NO completion:^{[[NSNotificationCenter defaultCenter] postNotificationName:@"clickNewton" object:self];}];

    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"clickNewton" object:self];
    //    [self dismissViewControllerAnimated:NO completion:nil];
}
-(IBAction)to2DplotterButton:(id)sender{
    [self dismissViewControllerAnimated:NO completion:^{[[NSNotificationCenter defaultCenter] postNotificationName:@"clickPlot2D" object:self];}];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"clickPlot2D" object:self];
    //    [self dismissViewControllerAnimated:NO completion:nil];
}
///////////////////////////////////////////////////////////

-(IBAction)executeButton:(id)sender{
    NSString *aValue=[xa text];
        aValue=[self robustTranslater:aValue];
    NSString *bValue=[xb text];
        bValue=[self robustTranslater:bValue];
    NSString *cValue=[xc text];
        cValue=[self robustTranslater:cValue];
    NSString *dValue=[xd text];
        dValue=[self robustTranslater:dValue];
    NSString *eValue=[xe text];
        eValue=[self robustTranslater:eValue];
    NSString *jsCode = [NSString stringWithFormat:@"QuarticEqSolver('%@','%@','%@','%@','%@');",aValue,bValue,cValue,dValue,eValue];
    [self.viewWebCMKU stringByEvaluatingJavaScriptFromString:jsCode];
    
    [self dealHistoryOFDraftResult:1];
}
-(NSString*)robustTranslater:(NSString*)article{
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
    if(onOff==1){
        switch (textboxIndex) {
            case 1:[xa insertText:param1];break;
            case 2:[xb insertText:param1];break;
            case 3:[xc insertText:param1];break;
            case 4:[xd insertText:param1];break;
            case 5:[xe insertText:param1];break;
        }
    }else if(onOff==0){
        switch (textboxIndex) {
            case 1:[xa becomeFirstResponder];break;
            case 2:[xb becomeFirstResponder];break;
            case 3:[xc becomeFirstResponder];break;
            case 4:[xd becomeFirstResponder];break;
            case 5:[xe becomeFirstResponder];break;
            default:[xa becomeFirstResponder];break;
        }
    }
}
-(IBAction)deleteButton:(id)sender{
    if(onOff==1){
        switch (textboxIndex) {
            case 1:[xa deleteBackward];break;
            case 2:[xb deleteBackward];break;
            case 3:[xc deleteBackward];break;
            case 4:[xd deleteBackward];break;
            case 5:[xe deleteBackward];break;
        }
    }else if(onOff==0){
        switch (textboxIndex) {
            case 1:[xa becomeFirstResponder];break;
            case 2:[xb becomeFirstResponder];break;
            case 3:[xc becomeFirstResponder];break;
            case 4:[xd becomeFirstResponder];break;
            case 5:[xe becomeFirstResponder];break;
            default:[xa becomeFirstResponder];break;
        }
    }
}
-(IBAction)clearALLButton:(id)sender{
    UIAlertView *CMKUalertview= [[UIAlertView alloc] initWithTitle:youWantToS message:@"" delegate:self cancelButtonTitle:doNothingS otherButtonTitles:clearDraftS,clearResultS, nil];
    [CMKUalertview show];
}
//-(void)alertView函數是內建的,不用加協定！delegate:self 會讓這個物件自動呼叫-(void)alertView
-(void)alertView:(UIAlertView *)CMKU22222alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:/*cancelButtonTitle:*/
            break;
        case 1:{
            [xa setText:@""];
            [xb setText:@""];
            [xc setText:@""];
            [xd setText:@""];
            [xe setText:@""];
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
    arcS=(arcS+1)%2;
    if(arcS==1)[arcButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    else[arcButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
-(IBAction)hypMODEButton:(id)sender{
    hypS=(hypS+1)%2;
    if(hypS==1)[hypButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    else[hypButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
-(IBAction)inputButtonSIN:(id)sender{[self TriTyping:@"sin"];}
-(IBAction)inputButtonCOS:(id)sender{[self TriTyping:@"cos"];}
-(IBAction)inputButtonTAN:(id)sender{[self TriTyping:@"tan"];}
-(void)TriTyping:(NSString*)param1{
    NSString *str;
    if(arcS==0&&hypS==0)str=[NSString stringWithFormat:@"%@(",param1];
    else if(arcS==0&&hypS==1)str=[NSString stringWithFormat:@"%@h(",param1];
    else if(arcS==1&&hypS==0)str=[NSString stringWithFormat:@"a%@(",param1];
    else if(arcS==1&&hypS==1)str=[NSString stringWithFormat:@"a%@h(",param1];
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
-(IBAction)inputButtoni:(id)sender{[self typing:@"i"];}
-(IBAction)inputButtonDot:(id)sender{[self typing:@"·"];}
-(IBAction)inputButtonStar:(id)sender{[self typing:@"*"];}



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
            [plistDict setValue:ResultHtml forKey:@"X4solverResult"];
        }case 3:{
            [plistDict setValue:xa.text forKey:@"aHistory"];
            [plistDict setValue:xb.text forKey:@"bHistory"];
            [plistDict setValue:xc.text forKey:@"cHistory"];
            [plistDict setValue:xd.text forKey:@"dHistory"];
            [plistDict setValue:xe.text forKey:@"eHistory"];
            [plistDict writeToFile:plistPath atomically:YES];
            break;
        }case 0:{
            xa.text=[plistDict objectForKey:@"aHistory"];
            xb.text=[plistDict objectForKey:@"bHistory"];
            xc.text=[plistDict objectForKey:@"cHistory"];
            xd.text=[plistDict objectForKey:@"dHistory"];
            xe.text=[plistDict objectForKey:@"eHistory"];
            break;
        }case 2:{
            NSString *jsCode = [NSString stringWithFormat:@"document.getElementById('resultsDisplayOfOthersFunctionality').innerHTML='%@'",[plistDict objectForKey:@"X4solverResult"]];
            [self.viewWebCMKU stringByEvaluatingJavaScriptFromString:jsCode];
            break;
        }
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textboxIndex=textField.tag;
    onOff=1;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    onOff=0;
    [self dealHistoryOFDraftResult:3];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self dealHistoryOFDraftResult:2];
    NSString *jsCode = [NSString stringWithFormat:@"document.getElementById('resultsDisplayOfOthersFunctionality').scrollTop=document.getElementById('resultsDisplayOfOthersFunctionality').scrollHeight;"];
    [self.viewWebCMKU stringByEvaluatingJavaScriptFromString:jsCode];
    
    if(iPhone5series){
        [self.viewWebCMKU stringByEvaluatingJavaScriptFromString: @"document.getElementById('resultsDisplayOfOthersFunctionality').style.height = '242px';"];
        //[self.viewWebCMKU stringByEvaluatingJavaScriptFromString: @"document.getElementById('resultsDisplayOfOthersFunctionality').style.height = '228px';"];//238-14=224
    }else{
        [self.viewWebCMKU stringByEvaluatingJavaScriptFromString: @"document.getElementById('resultsDisplayOfOthersFunctionality').style.lineHeight = '18px';"];
    }
    
    NSString *languageCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([languageCode isEqualToString:@"zh-Hant"]||[languageCode isEqualToString:@"zh-Hans"]){
        [self.viewWebCMKU stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"internatioanlVersion(2);internatioanlVersionOfFunc2(2);"]];
        youWantToS=@"您想要...";
        doNothingS=@"沒事, 按錯了";
        clearDraftS=@"清除輸入欄";
        clearResultS=@"清除計算結果";
    }else if([languageCode isEqualToString:@"ja"]){
        [self.viewWebCMKU stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"internatioanlVersion(3);internatioanlVersionOfFunc2(3);"]];
        youWantToS=@"あなたは...";
        doNothingS=@"何もしない";
        clearDraftS=@"入力欄を消す";
        clearResultS=@"計算結果と履歴を消す";
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
