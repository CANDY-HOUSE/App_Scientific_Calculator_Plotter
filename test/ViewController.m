
#import "ViewController.h"
#define iPhone5series (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)568)<DBL_EPSILON)
#define iOS_from(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define iOS_below(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface ViewController ()<UITextViewDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate>
@end

@implementation ViewController
NSString *youWantTo=@"You want to...",*doNothing=@"Do nothing!",*clearDraft=@"Clear Draft";
NSTimer *timer;int arc=0,hyp=0;//private
int extendedMode=0;
BOOL uiwebviewLOADED=NO;
- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSURL *myUrl=[[NSURL alloc] initWithString:@"www.someURL.calculator.html"];
    NSString *myURLstring=[[NSBundle mainBundle] pathForResource:@"HTML5core/calculator" ofType:@"html"];//路徑不用指定,mainBundle會自己找
    NSURL *myURL=[NSURL fileURLWithPath:myURLstring];
    NSURLRequest *myRequest=[NSURLRequest requestWithURL:myURL];
    [self.viewWebCMKU loadRequest:myRequest];
    self.viewWebCMKU.delegate=self;
    [self dealHistoryOFDraftResult:0];
    
    myText.inputView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];//hide Keyboard
    [myText becomeFirstResponder];//避免一開始就沒游標閃亮
    
    myText.delegate=self;
    
    if(iPhone5series  && iOS_from(@"7.0")){
        CGRect SBframe=slideKeyBoard.frame,mTframe=myText.frame,vwframe=self.viewWebCMKU.frame;
        
        mTframe.size.height=124;
        mTframe.origin.y=253;
        myText.frame=mTframe;
        SBframe.origin.y=386;slideKeyBoard.frame=SBframe;
        
        vwframe.size.height=345+14;
        vwframe.origin.y=0;
/*        vwframe.size.height=345;
        vwframe.origin.y=14;
*/
        self.viewWebCMKU.frame=vwframe;
        [[self.viewWebCMKU scrollView] setBounces: NO];//ios7蠢bug_UIWebView
        
    }else if(iOS_from(@"7.0")){//給iPhone4S以下
        CGRect SBframe=slideKeyBoard.frame,mTframe=myText.frame,vwframe=self.viewWebCMKU.frame;
        
        mTframe.origin.y=194;myText.frame=mTframe;

        SBframe.origin.y=301;slideKeyBoard.frame=SBframe;

        vwframe.origin.y=0;
//        vwframe.origin.y=14;
        self.viewWebCMKU.frame=vwframe;
        [[self.viewWebCMKU scrollView] setBounces: NO];//ios7蠢bug_UIWebView
        
    }
    [x4Button setTitle:@"Solve  ax\u2074+bx\u00b3+cx\u00b2+dx+e=0" forState:UIControlStateNormal];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doWhenNotification1Received:)
                                                 name:@"clickNewton"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doWhenNotification2Received:)
                                                 name:@"clickPlot2D"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doWhenNotification3Received:)
                                                 name:@"clickX4solver"
                                               object:nil];
    
    /*對UIWebview用TapGesture特別麻煩*/
    UITapGestureRecognizer *tapGestureToExtend=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToExtend)];
    tapGestureToExtend.delegate=self;
    [self.viewWebCMKU addGestureRecognizer:tapGestureToExtend];
    /*對UIWebview用TapGesture特別麻煩*/
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.4;
    [reverseButton addGestureRecognizer:longPress];
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

//////////////////////////////////////Notification
- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    /*It is advisable to call the removeObserver: method of NSNotificationCenter in the dealloc method to avoid crashes.*/
    //[super dealloc];Xcode5.0以後會自己執行
}
- (void)doWhenNotification1Received:(NSNotification *) notification
{
    [NewtonButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}
- (void)doWhenNotification2Received:(NSNotification *) notification
{
    [plot2DButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}
- (void)doWhenNotification3Received:(NSNotification *) notification
{
    [x4Button sendActionsForControlEvents:UIControlEventTouchUpInside];
}
/////////////////////////////////////////


-(IBAction)executeButton:(id)sender{
    NSString *JsObjCFormatedStr=[myText.text stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];//objectiveC 轉 javascript必要的code,但是以下都是純粹為了robustDesign
    JsObjCFormatedStr=[self robustTranslater:JsObjCFormatedStr];
    NSString *jsCode = [NSString stringWithFormat:@"execute('%@');",JsObjCFormatedStr];
    [self.viewWebCMKU stringByEvaluatingJavaScriptFromString:jsCode];
    if(!myText.isFirstResponder)[myText becomeFirstResponder];//避免一開始就沒游標閃亮
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
    if(extendedMode==0 && myText.isFirstResponder)[myText insertText:param1];
    else[myText becomeFirstResponder];//避免一開始就沒游標閃亮
}
-(IBAction)deleteButton:(id)sender{
    if(extendedMode==0 && myText.isFirstResponder)[myText deleteBackward];
    else[myText becomeFirstResponder];//避免一開始就沒游標閃亮
}
-(IBAction)clearALLButton:(id)sender{
    
    if(extendedMode==0){
        UIAlertView *CMKUalertview= [[UIAlertView alloc] initWithTitle:youWantTo message:@"" delegate:self cancelButtonTitle:doNothing otherButtonTitles:clearDraft, nil];
        [CMKUalertview show];
    }

}
//-(void)alertView函數是內建的,不用加協定！delegate:self 會讓這個物件自動呼叫-(void)alertView
-(void)alertView:(UIAlertView *)CMKU22222alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:/*cancelButtonTitle:*/
            break;
        case 1:
            [myText setText:@""];
            break;
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
-(IBAction)inputButtonPlus:(id)sender{[self typing:@"+"];}
-(IBAction)inputButtonMinus:(id)sender{[self typing:@"-"];}
-(IBAction)inputButtonMutiply:(id)sender{[self typing:@"×"];}
-(IBAction)inputButtonDivide:(id)sender{[self typing:@"/"];}
-(IBAction)inputButtonPSN:(id)sender{[self typing:@"%"];}
-(IBAction)nextLineButton:(id)sender{
    if(myText.isFirstResponder){
        [self typing:@"\n"];
        [self dealHistoryOFDraftResult:3];
    }else[myText becomeFirstResponder];//避免一開始就沒游標閃亮
}

-(IBAction)arcMODEButton:(id)sender{
    arc=(arc+1)%2;
    if(arc==1)[arcButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    else[arcButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
-(IBAction)hypMODEButton:(id)sender{
    hyp=(hyp+1)%2;
    if(hyp==1)[hypButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    else[hypButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
-(IBAction)inputButtonSIN:(id)sender{[self TriTyping:@"sin"];}
-(IBAction)inputButtonCOS:(id)sender{[self TriTyping:@"cos"];}
-(IBAction)inputButtonTAN:(id)sender{[self TriTyping:@"tan"];}
-(void)TriTyping:(NSString*)param1{
    NSString *str;
    if(arc==0&&hyp==0)str=[NSString stringWithFormat:@"%@(",param1];
    else if(arc==0&&hyp==1)str=[NSString stringWithFormat:@"%@h(",param1];
    else if(arc==1&&hyp==0)str=[NSString stringWithFormat:@"a%@(",param1];
    else if(arc==1&&hyp==1)str=[NSString stringWithFormat:@"a%@h(",param1];
    [self typing:str];
}
-(IBAction)inputButtonLOG:(id)sender{[self typing:@"log("];}
-(IBAction)inputButtonLN:(id)sender{[self typing:@"ln("];}
-(IBAction)inputButtonPI:(id)sender{[self typing:@"π"];}
-(IBAction)inputButtonE:(id)sender{[self typing:@"e"];}
-(IBAction)showKeyBoard:(id)sender{//show Keyboard
    [myText resignFirstResponder];
    myText.inputView=nil;
    [myText becomeFirstResponder];
    
    /*增加空白給鍵盤,因此內容可以拉上來看*/
    UIEdgeInsets SpaceForKeyboard = myText.contentInset;
    SpaceForKeyboard.bottom = 60.0;
    myText.contentInset = SpaceForKeyboard;
}
-(IBAction)inputButtonABS:(id)sender{[self typing:@"|"];}
-(IBAction)inputButtonFAC:(id)sender{[self typing:@"!"];}
-(IBAction)inputButtonP:(id)sender{[self typing:@"P"];}
-(IBAction)inputButtonC:(id)sender{[self typing:@"C"];}
-(IBAction)inputButtonSQR:(id)sender{[self typing:@"√("];}
-(IBAction)inputButtonCBR:(id)sender{[self typing:@"∛("];}
-(IBAction)inputButtonDEG:(id)sender{[self typing:@"°"];}
-(IBAction)inputButtonEqualSign:(id)sender{[self typing:@"="];}
-(IBAction)inputButtonComma:(id)sender{[self typing:@","];}
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

/*對UIWebview用TapGesture特別麻煩*/
-(void)tapToExtend{
    if(extendedMode==0 && uiwebviewLOADED==YES){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.2f];/*0.3 seconds*/
        if(iPhone5series  && iOS_from(@"7.0")){
            CGRect SBframe=slideKeyBoard.frame,mTframe=myText.frame,vwframe=self.viewWebCMKU.frame;
        
            mTframe.origin.y=568-124;myText.frame=mTframe;
            SBframe.origin.y=568;slideKeyBoard.frame=SBframe;
            //vwframe.size.height=500;
            vwframe.size.height=500+14;self.viewWebCMKU.frame=vwframe;
            [self.viewWebCMKU stringByEvaluatingJavaScriptFromString: @"document.getElementById('result').style.height = '434px';"];
//            [self.viewWebCMKU stringByEvaluatingJavaScriptFromString: @"document.getElementById('result').style.height = '420px';"];
        
        }else if(iOS_from(@"7.0")){//給iPhone4S以下
            CGRect SBframe=slideKeyBoard.frame,mTframe=myText.frame,vwframe=self.viewWebCMKU.frame;
        
            mTframe.origin.y=480-104;myText.frame=mTframe;
            SBframe.origin.y=480;slideKeyBoard.frame=SBframe;
            //vwframe.size.height=400;
            vwframe.size.height=400+14;self.viewWebCMKU.frame=vwframe;
            [self.viewWebCMKU stringByEvaluatingJavaScriptFromString: @"document.getElementById('result').style.height = '366px';"];
//            [self.viewWebCMKU stringByEvaluatingJavaScriptFromString: @"document.getElementById('result').style.height = '352px';"];
        }
        [UIView commitAnimations];
        extendedMode=1;
        [myText scrollRangeToVisible:myText.selectedRange];/*自動scroll到游標處*/
        [myText resignFirstResponder];
    }
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer {return YES;}
/*對UIWebview用TapGesture特別麻煩*/

- (void)dealHistoryOFDraftResult:(int)caseN{
    //    NSString *plistPath=[[NSBundle mainBundle]pathForResource:@"history" ofType:@"plist"];/*根本就不能用這個方法,這只有在JB機和模擬器可用,亂教*/

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
            NSString *ResultHtml = [self.viewWebCMKU stringByEvaluatingJavaScriptFromString: @"document.getElementById('result').innerHTML"];
            [plistDict setValue:ResultHtml forKey:@"result"];
        }case 3:{
            [plistDict setValue:myText.text forKey:@"draft"];
            [plistDict writeToFile:plistPath atomically:YES];
            break;
        }case 0:{
            myText.text=[plistDict objectForKey:@"draft"];
            break;
        }case 2:{
            NSString *jsCode = [NSString stringWithFormat:@"document.getElementById('result').innerHTML='%@'",[plistDict objectForKey:@"result"]];
            [self.viewWebCMKU stringByEvaluatingJavaScriptFromString:jsCode];
            break;
        }
    }
}
- (void)webViewDidStartLoad:(UIWebView *)webView {uiwebviewLOADED=NO;}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    uiwebviewLOADED=YES;
    [self dealHistoryOFDraftResult:2];

    NSString *jsCode = [NSString stringWithFormat:@"document.getElementById('result').scrollTop=document.getElementById('result').scrollHeight;"];
    [self.viewWebCMKU stringByEvaluatingJavaScriptFromString:jsCode];
    
    if(iPhone5series){

        [self.viewWebCMKU stringByEvaluatingJavaScriptFromString: @"document.getElementById('result').style.height = '238px';"];//238-14=224
//[self.viewWebCMKU stringByEvaluatingJavaScriptFromString: @"document.getElementById('result').style.height = '228px';"];//238-14=224
    }
    
    NSString *languageCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([languageCode isEqualToString:@"zh-Hant"]||[languageCode isEqualToString:@"zh-Hans"]){
        [self.viewWebCMKU stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"internatioanlVersion(2);"]];
        nextEq.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        nextEq.titleLabel.textAlignment = NSTextAlignmentCenter;
        [nextEq setTitle:@"下一\n算式" forState:UIControlStateNormal];
        [nextEq.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.5]];
        youWantTo=@"您想要...";
        doNothing=@"沒事,按錯了";
        clearDraft=@"清除草稿";
    }else if([languageCode isEqualToString:@"ja"]){
        [self.viewWebCMKU stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"internatioanlVersion(3);"]];
        [nextEq setTitle:@"次の式" forState:UIControlStateNormal];
        [nextEq.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0]];
        youWantTo=@"あなたは...";
        doNothing=@"何もしない";
        clearDraft=@"下書きを消去";
    }
    [nextEq setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

}
-(void) textViewDidBeginEditing:(UITextView *)textView
{
    if(extendedMode==1 && uiwebviewLOADED==YES){
        
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         // Do your animations here.
                     

            if(iPhone5series  && iOS_from(@"7.0")){
                CGRect SBframe=slideKeyBoard.frame,mTframe=myText.frame,vwframe=self.viewWebCMKU.frame;
            
                mTframe.origin.y=253;myText.frame=mTframe;
                SBframe.origin.y=386;slideKeyBoard.frame=SBframe;
                //vwframe.size.height=345;
                vwframe.size.height=345+14;self.viewWebCMKU.frame=vwframe;
                [self.viewWebCMKU stringByEvaluatingJavaScriptFromString: @"document.getElementById('result').style.height = '242px';"];
//                [self.viewWebCMKU stringByEvaluatingJavaScriptFromString: @"document.getElementById('result').style.height = '228px';"];
            
            }else if(iOS_from(@"7.0")){/*給iPhone4S以下*/
                CGRect SBframe=slideKeyBoard.frame,mTframe=myText.frame,vwframe=self.viewWebCMKU.frame;
            
                mTframe.origin.y=194;myText.frame=mTframe;
                SBframe.origin.y=301;slideKeyBoard.frame=SBframe;
                //vwframe.size.height=260;
                vwframe.size.height=260+14;self.viewWebCMKU.frame=vwframe;
                [self.viewWebCMKU stringByEvaluatingJavaScriptFromString: @"document.getElementById('result').style.height = '183px';"];
//[self.viewWebCMKU stringByEvaluatingJavaScriptFromString: @"document.getElementById('result').style.height = '169px';"];

            }
        }completion:^(BOOL finished){
            if (finished) {
                extendedMode=0;
            }
    }];
        
    }
    [textView scrollRangeToVisible:textView.selectedRange];/*自動scroll到游標處*/
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{/*讓return/done鍵關掉keyboard的程式*/
    if ([text isEqualToString:@"\n"]){

        [self doWhenKeyboardTurnedOff:textView];
        return NO;/*return NO 會讓按鈕全部失效,所以此時不會輸入@"\n"*/
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if(textView.inputView==nil){
        [self doWhenKeyboardTurnedOff:textView];
    }
    return YES;
}
-(void)doWhenKeyboardTurnedOff:(UITextView *)textView{
    [textView resignFirstResponder];
    textView.inputView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];//hide Keyboard
    [textView becomeFirstResponder];//避免一開始就沒游標閃亮
    /*解除給鍵盤的空白*/
    UIEdgeInsets SpaceForKeyboard = textView.contentInset;
    SpaceForKeyboard.bottom = 0.0;
    textView.contentInset = SpaceForKeyboard;
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
