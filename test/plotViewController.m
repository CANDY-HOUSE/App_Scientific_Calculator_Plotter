
#import "plotViewController.h"
#define iPhone5series (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)568)<DBL_EPSILON)
#define iOS_from(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define iOS_below(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define prepareForHistoryDealer /*plist方法start*/NSString *plistPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];plistPath = [plistPath stringByAppendingPathComponent:@"plotHistory.plist"];/* If the file doesn't exist in the Documents Folder, copy it.*/NSFileManager *fileManager = [NSFileManager defaultManager];if (![fileManager fileExistsAtPath:plistPath]) {NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"plotHistory" ofType:@"plist"];[fileManager copyItemAtPath:sourcePath toPath:plistPath error:nil];}/*plist方法end*/NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];

#define rgba(R,G,B,A) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]

@interface plotViewController ()<UIPickerViewDelegate,UITextFieldDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate>

@end

@implementation plotViewController
NSString *youWantToP=@"You want to...",*doNothingP=@"Do nothing!",*clearDraftP=@"Clear all";
UIButton *theButton;
UIView *DontTouchKeyboard;/*iOS7蠢bug,不加會穿透觸發*/
UIPickerView *thePicker;
id thisTextbox;
int ONoff=0,arcP=0,hypP=0;
NSInteger selectedPickerRow;
NSIndexPath *hitIndex;/*<--我也不想定義這麼多全域變數,但是每次都在function裡面重做的話,app就是會crash*/
NSIndexPath *hitIndex2;
NSTimer *timer;
UIWebView *plotByHtmlPage;
UIButton *afterPlotButton;
UIView *dishforHTML;
NSMutableArray* dataArray1;float dataArray2[8][10];
BOOL track=NO;
float trackingX,trackingY;

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
	// Do any additional setup after loading the view.

    NSString *myURLstring=[[NSBundle mainBundle] pathForResource:@"HTML5core/plotter" ofType:@"html"];
    NSURL *myURL=[NSURL fileURLWithPath:myURLstring];
    NSURLRequest *myRequest=[NSURLRequest requestWithURL:myURL];


    
    if(iPhone5series  && iOS_from(@"7.0")){
        plotByHtmlPage=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320,568)];
        [[plotByHtmlPage scrollView] setBounces: NO];
        plotByHtmlPage.delegate=self;
        [plotByHtmlPage loadRequest:myRequest];
        UIPinchGestureRecognizer *pinchGesture=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureResize:)];
        UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureMove:)];
        [plotByHtmlPage addGestureRecognizer:pinchGesture];
        [plotByHtmlPage addGestureRecognizer:panGesture];
        
        /*對UIWebview用TapGesture特別麻煩*/
        UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesturetrack:)];
        tapGesture1.delegate=self;
        [plotByHtmlPage addGestureRecognizer:tapGesture1];
        /*對UIWebview用TapGesture特別麻煩*/
        
        afterPlotButton=[[UIButton alloc] initWithFrame:CGRectMake(-15, 530, 75, 35)];
        [afterPlotButton setTitle:@"OK" forState:UIControlStateNormal];
        [afterPlotButton setTitleColor:[UIColor colorWithRed:5.0/255.0 green:206.0/255.0 blue:111.0/255.0 alpha:0.8] forState:UIControlStateNormal];
        [afterPlotButton addTarget:self action:@selector(cancelPlot) forControlEvents:UIControlEventTouchUpInside];
        dishforHTML=[[UIView alloc]initWithFrame:CGRectMake(0, 568, 320,568)];
        
        CGRect SBframe=slideKeyBoard.frame,tableFrame=inputTable.frame;
        
        SBframe.origin.y=386;slideKeyBoard.frame=SBframe;
        tableFrame.origin.y=0;
        tableFrame.size.height=359+18;
/*      tableFrame.origin.y=18;
        tableFrame.size.height=359;
*/
        inputTable.frame=tableFrame;
        
/*        UIView *barColorView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 18)];
        [barColorView setBackgroundColor:[UIColor colorWithRed:5.0/255.0 green:206.0/255.0 blue:111.0/255.0 alpha:0.65]];
        [self.view addSubview:barColorView];
*/
    }else if(iOS_from(@"7.0")){//給iPhone4S以下
        plotByHtmlPage=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320,480)];
        [[plotByHtmlPage scrollView] setBounces: NO];
        plotByHtmlPage.delegate=self;
        [plotByHtmlPage loadRequest:myRequest];
        UIPinchGestureRecognizer *pinchGesture=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureResize:)];
        UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureMove:)];
        [plotByHtmlPage addGestureRecognizer:pinchGesture];
        [plotByHtmlPage addGestureRecognizer:panGesture];

        /*對UIWebview用TapGesture特別麻煩*/
        UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesturetrack:)];
        tapGesture1.delegate=self;
        [plotByHtmlPage addGestureRecognizer:tapGesture1];
        /*對UIWebview用TapGesture特別麻煩*/

        afterPlotButton=[[UIButton alloc] initWithFrame:CGRectMake(-15, 442, 75, 35)];
        [afterPlotButton setTitle:@"OK" forState:UIControlStateNormal];
        [afterPlotButton setTitleColor:[UIColor colorWithRed:5.0/255.0 green:206.0/255.0 blue:111.0/255.0 alpha:0.8] forState:UIControlStateNormal];
        [afterPlotButton addTarget:self action:@selector(cancelPlot) forControlEvents:UIControlEventTouchUpInside];
        dishforHTML=[[UIView alloc]initWithFrame:CGRectMake(0, 480, 320,480)];
        
        CGRect SBframe=slideKeyBoard.frame,tableFrame=inputTable.frame;
        
        SBframe.origin.y=301;slideKeyBoard.frame=SBframe;
        tableFrame.origin.y=0;
        tableFrame.size.height=280+18;
/*      tableFrame.origin.y=18;
        tableFrame.size.height=280;
        
*/
        inputTable.frame=tableFrame;
        
/*        UIView *barColorView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 18)];
        [barColorView setBackgroundColor:[UIColor colorWithRed:5.0/255.0 green:206.0/255.0 blue:111.0/255.0 alpha:0.65]];
        [self.view addSubview:barColorView];
*/
    }
    [x4Button setTitle:@"Solve  ax\u2074+bx\u00b3+cx\u00b2+dx+e=0" forState:UIControlStateNormal];
    
    clearallButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    clearallButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [clearallButton setTitle: @"clear\nall" forState: UIControlStateNormal];
    
    [inputTable scrollToRowAtIndexPath:hitIndex2 atScrollPosition:UITableViewScrollPositionNone animated:YES];/*如果tablecell不在畫面裡,會自動轉到畫面上方或下方,如果本來就在畫面裡則不會轉動*/
    
    
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
//////////programmatically create tableView Start
/*以下幾個tableView的函數雖然沒有加入協定也沒有把代理人指定成self,但仍會自動執行,因為已經在storyboard連delegate與datasource*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  120;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;// [tableData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    prepareForHistoryDealer
    
    NSString *identifier =  [NSString stringWithFormat:@"Cell_%ld", (long)[indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//NSLog(@"%@",identifier);
    
    }else{/*删除不在畫面裡的cell的所有子视图,節省記憶體*/
        while ([cell.contentView.subviews lastObject] != nil){
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
//NSLog(@"%@ Killed",identifier);
        }
    }
    
    UILabel *xfromLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 40, 50, 50)];
    xfromLabel.text = @"x = ";
    UILabel *xToLabel=[[UILabel alloc] initWithFrame:CGRectMake(140, 40, 50, 50)];
    xToLabel.text = @"〜";
    UILabel *yfromLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 60, 50, 50)];
    yfromLabel.text = @"y = ";
    UILabel *yToLabel=[[UILabel alloc] initWithFrame:CGRectMake(140, 60, 50, 50)];
    yToLabel.text = @"〜";
    yToLabel.textColor=yfromLabel.textColor=xToLabel.textColor=xfromLabel.textColor=rgba(227,255,212,1);
    [cell.contentView addSubview:xfromLabel];
    [cell.contentView addSubview:xToLabel];
    [cell.contentView addSubview:yfromLabel];
    [cell.contentView addSubview:yToLabel];
    
    UITextField *Textfieldx1 = [[UITextField alloc] initWithFrame:CGRectMake(78, 51,65,30)];
    Textfieldx1.text=[plistDict objectForKey:[NSString stringWithFormat:@"%ld_xfrom", (long)[indexPath row]]];
    UITextField *Textfieldx2 = [[UITextField alloc] initWithFrame:CGRectMake(160, 51,65,30)];
    Textfieldx2.text=[plistDict objectForKey:[NSString stringWithFormat:@"%ld_xTo", (long)[indexPath row]]];
    UITextField *Textfieldy1 = [[UITextField alloc] initWithFrame:CGRectMake(78, 71,65,30)];
    Textfieldy1.text=[plistDict objectForKey:[NSString stringWithFormat:@"%ld_yfrom", (long)[indexPath row]]];
    UITextField *Textfieldy2 = [[UITextField alloc] initWithFrame:CGRectMake(160, 71,65,30)];
    Textfieldy2.text=[plistDict objectForKey:[NSString stringWithFormat:@"%ld_yTo", (long)[indexPath row]]];
    Textfieldx1.font=Textfieldx2.font=Textfieldy1.font=Textfieldy2.font=[UIFont fontWithName:@"HiraMinProN-W3" size:17];
    [cell.contentView addSubview:Textfieldx1];Textfieldx1.tag=1;
    [cell.contentView addSubview:Textfieldx2];Textfieldx2.tag=2;
    [cell.contentView addSubview:Textfieldy1];Textfieldy1.tag=3;
    [cell.contentView addSubview:Textfieldy2];Textfieldy2.tag=4;
    Textfieldx1.delegate=Textfieldx2.delegate=Textfieldy1.delegate=Textfieldy2.delegate=(id)self;
    
    Textfieldx1.inputView=Textfieldx2.inputView=Textfieldy1.inputView=Textfieldy2.inputView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];

    UIButton *typeButton=[[UIButton alloc] initWithFrame:CGRectMake(5, 7, 78, 35)];
    NSString *buttonTitle=[plistDict objectForKey:[NSString stringWithFormat:@"%ld_type",(long)[indexPath row]]];
    [typeButton setTitle:buttonTitle forState:UIControlStateNormal];
    [typeButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [typeButton setBackgroundColor:[UIColor clearColor]];
    [typeButton addTarget:self action:@selector(virtualClick:) forControlEvents:UIControlEventTouchUpInside];
    typeButton.tag=99;
    [cell.contentView addSubview:typeButton];

    
    if([typeButton.titleLabel.text isEqualToString:@"y = f(x) = "]||[typeButton.titleLabel.text isEqualToString:@"r = r(θ) = "]||[typeButton.titleLabel.text isEqualToString:@"x = g(y) = "]||[typeButton.titleLabel.text isEqualToString:@"Any : "]){
        
        [typeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        UITextView *EQtextview=[[UITextView alloc] initWithFrame:CGRectMake(79, 0,247,50)];
        [EQtextview setBackgroundColor:[UIColor clearColor]];
        EQtextview.text=[plistDict objectForKey:[NSString stringWithFormat:@"%ld_func", (long)[indexPath row]]];
        EQtextview.font=[UIFont fontWithName:@"HiraMinProN-W3" size:17];
        [cell.contentView addSubview:EQtextview];EQtextview.tag=7;
        EQtextview.delegate=(id)self;
        EQtextview.inputView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
        if([typeButton.titleLabel.text isEqualToString:@"r = r(θ) = "]){
            UILabel *θfromLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 80, 50, 50)];
            θfromLabel.text = @"θ = ";
            UILabel *θToLabel=[[UILabel alloc] initWithFrame:CGRectMake(140, 80, 50, 50)];
            θToLabel.text = @"〜";
            θToLabel.textColor=θfromLabel.textColor=rgba(227,255,212,1);
            
            UITextField *Textfieldθ1 = [[UITextField alloc] initWithFrame:CGRectMake(78, 91,65,30)];
            UITextField *Textfieldθ2 = [[UITextField alloc] initWithFrame:CGRectMake(160, 91,65,30)];
            Textfieldθ1.text=[plistDict objectForKey:[NSString stringWithFormat:@"%ld_θfrom", (long)[indexPath row]]];
            Textfieldθ2.text=[plistDict objectForKey:[NSString stringWithFormat:@"%ld_θTo", (long)[indexPath row]]];
            Textfieldθ1.inputView=Textfieldθ2.inputView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
            [cell.contentView addSubview:θfromLabel];
            [cell.contentView addSubview:θToLabel];
            [cell.contentView addSubview:Textfieldθ1];Textfieldθ1.tag=5;
            [cell.contentView addSubview:Textfieldθ2];Textfieldθ2.tag=6;
            Textfieldθ1.delegate=Textfieldθ2.delegate=(id)self;
        }
    }else if([typeButton.titleLabel.text isEqualToString:@"ᴑ :"]||[typeButton.titleLabel.text isEqualToString:@") ( :"]||[typeButton.titleLabel.text isEqualToString:@"ꇤ :"]){
        
        [typeButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        
        UILabel *Label01=[[UILabel alloc] initWithFrame:CGRectMake(98, 5, 10, 20)];
        Label01.text = @"(";
        UILabel *Label02=[[UILabel alloc] initWithFrame:CGRectMake(108, 5, 10, 20)];
        Label02.text = @"x";
        UILabel *Label03=[[UILabel alloc] initWithFrame:CGRectMake(123, 7, 10, 20)];
        Label03.text = @"－";
        UILabel *Label04=[[UILabel alloc] initWithFrame:CGRectMake(168, 5, 10, 20)];
        Label04.text = @")";
        UILabel *Label05=[[UILabel alloc] initWithFrame:CGRectMake(171, -1, 10, 20)];
        Label05.text = @"2";
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(97,28, 80, 1)];
        UILabel *Label06=[[UILabel alloc] initWithFrame:CGRectMake(108, 33, 10, 20)];
        Label06.text = @"(";
        UILabel *Label07=[[UILabel alloc] initWithFrame:CGRectMake(163, 33, 10, 20)];
        Label07.text = @")";
        UILabel *Label08=[[UILabel alloc] initWithFrame:CGRectMake(166, 27, 10, 20)];
        Label08.text = @"2";
        UILabel *Label09;
        if([typeButton.titleLabel.text isEqualToString:@") ( :"]){
            Label09=[[UILabel alloc] initWithFrame:CGRectMake(182, 19, 10, 20)];Label09.text = @"－";
            GraphicsByCoding *icon = [[GraphicsByCoding alloc] initWithFrame:CGRectMake(5,3,70,50)];
            icon.iconBango=2.0;
            icon.userInteractionEnabled = NO;/*這層不能響應,則下面一層會響應*/
            [cell.contentView addSubview:icon];
        }
        else if([typeButton.titleLabel.text isEqualToString:@"ᴑ :"]){
            Label09=[[UILabel alloc] initWithFrame:CGRectMake(182, 17, 10, 20)];Label09.text = @"+";
            GraphicsByCoding *icon = [[GraphicsByCoding alloc] initWithFrame:CGRectMake(5,3,70,50)];
            icon.iconBango=1.0;
            icon.userInteractionEnabled = NO;/*這層不能響應,則下面一層會響應*/
            [cell.contentView addSubview:icon];
        }
        else if([typeButton.titleLabel.text isEqualToString:@"ꇤ :"]){
            Label09=[[UILabel alloc] initWithFrame:CGRectMake(182, 17, 10, 20)];Label09.text = @"+";
            UILabel *Label20=[[UILabel alloc] initWithFrame:CGRectMake(78, 19, 10, 20)];
            Label20.text = @"－";
            [cell.contentView addSubview:Label20];
            Label20.textColor=rgba(227,255,212,1);
            GraphicsByCoding *icon = [[GraphicsByCoding alloc] initWithFrame:CGRectMake(5,3,70,50)];
            icon.iconBango=3.0;
            icon.userInteractionEnabled = NO;/*這層不能響應,則下面一層會響應*/
            [cell.contentView addSubview:icon];
        }
        UILabel *Label10=[[UILabel alloc] initWithFrame:CGRectMake(200, 5, 10, 20)];
        Label10.text = @"(";
        UILabel *Label11=[[UILabel alloc] initWithFrame:CGRectMake(210, 5, 10, 20)];
        Label11.text = @"y";
        UILabel *Label12=[[UILabel alloc] initWithFrame:CGRectMake(225, 7, 10, 20)];
        Label12.text = @"－";
        UILabel *Label13=[[UILabel alloc] initWithFrame:CGRectMake(270, 5, 10, 20)];
        Label13.text = @")";
        UILabel *Label14=[[UILabel alloc] initWithFrame:CGRectMake(273, -1, 10, 20)];
        Label14.text = @"2";
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(199,28, 80, 1)];
        UILabel *Label15=[[UILabel alloc] initWithFrame:CGRectMake(210, 33, 10, 20)];
        Label15.text = @"(";
        UILabel *Label16=[[UILabel alloc] initWithFrame:CGRectMake(265, 33, 10, 20)];
        Label16.text = @")";
        UILabel *Label17=[[UILabel alloc] initWithFrame:CGRectMake(268, 27, 10, 20)];
        Label17.text = @"2";
        UILabel *Label18=[[UILabel alloc] initWithFrame:CGRectMake(284, 17, 10, 20)];
        Label18.text = @"=";
        UILabel *Label19=[[UILabel alloc] initWithFrame:CGRectMake(300, 17, 10, 20)];
        Label19.text = @"1";

        
        Label05.font=Label08.font=Label14.font=Label17.font=[Label17.font fontWithSize:12];
        Label01.textColor=Label02.textColor=Label03.textColor=Label04.textColor=Label05.textColor=Label06.textColor=Label07.textColor=Label08.textColor=Label09.textColor=Label10.textColor=Label11.textColor=Label12.textColor=Label13.textColor=Label14.textColor=Label15.textColor=Label16.textColor=Label17.textColor=Label18.textColor=Label19.textColor=lineView.backgroundColor = lineView2.backgroundColor = rgba(227,255,212,1);
        
        [cell.contentView addSubview:Label01];[cell.contentView addSubview:Label02];
        [cell.contentView addSubview:Label03];[cell.contentView addSubview:Label04];
        [cell.contentView addSubview:Label05];[cell.contentView addSubview:Label06];
        [cell.contentView addSubview:Label07];[cell.contentView addSubview:Label08];
        [cell.contentView addSubview:Label09];[cell.contentView addSubview:Label10];
        [cell.contentView addSubview:Label11];[cell.contentView addSubview:Label12];
        [cell.contentView addSubview:Label13];[cell.contentView addSubview:Label14];
        [cell.contentView addSubview:Label15];[cell.contentView addSubview:Label16];
        [cell.contentView addSubview:Label17];[cell.contentView addSubview:Label18];
        [cell.contentView addSubview:Label19];[cell.contentView addSubview:lineView];
        [cell.contentView addSubview:lineView2];
        
        
        UITextField *TextfieldcX = [[UITextField alloc] initWithFrame:CGRectMake(131, 2,43,30)];
        TextfieldcX.text=[plistDict objectForKey:[NSString stringWithFormat:@"%ld_conicX", (long)[indexPath row]]];
        UITextField *TextfieldcY = [[UITextField alloc] initWithFrame:CGRectMake(233, 2,43,30)];
        TextfieldcY.text=[plistDict objectForKey:[NSString stringWithFormat:@"%ld_conicY", (long)[indexPath row]]];
        UITextField *TextfieldcA = [[UITextField alloc] initWithFrame:CGRectMake(113, 30,56,30)];
        TextfieldcA.text=[plistDict objectForKey:[NSString stringWithFormat:@"%ld_conicA", (long)[indexPath row]]];
        UITextField *TextfieldcB = [[UITextField alloc] initWithFrame:CGRectMake(215, 30,56,30)];
        TextfieldcB.text=[plistDict objectForKey:[NSString stringWithFormat:@"%ld_conicB", (long)[indexPath row]]];
        TextfieldcX.placeholder=TextfieldcY.placeholder=@"0";
        TextfieldcX.font=TextfieldcY.font=TextfieldcA.font=TextfieldcB.font=[UIFont fontWithName:@"HiraMinProN-W3" size:17];
        [cell.contentView addSubview:TextfieldcX];TextfieldcX.tag=11;
        [cell.contentView addSubview:TextfieldcY];TextfieldcY.tag=12;
        [cell.contentView addSubview:TextfieldcA];TextfieldcA.tag=13;
        [cell.contentView addSubview:TextfieldcB];TextfieldcB.tag=14;
        TextfieldcX.delegate=TextfieldcY.delegate=TextfieldcA.delegate=TextfieldcB.delegate=(id)self;
        
        TextfieldcX.inputView=TextfieldcY.inputView=TextfieldcA.inputView=TextfieldcB.inputView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
        TextfieldcX.textAlignment=TextfieldcY.textAlignment=TextfieldcA.textAlignment=TextfieldcB.textAlignment=NSTextAlignmentCenter;
    }

    UIButton *colorButton=[[UIButton alloc] initWithFrame:CGRectMake(230, 70, 75, 15)];
    
    if([[plistDict objectForKey:[NSString stringWithFormat:@"%ld_color", (long)[indexPath row]]] isEqualToString:@"Hidden"]){
        [colorButton setBackgroundColor:[UIColor clearColor]];
        [colorButton setTitle:@"Hidden" forState:UIControlStateNormal];
    }else{
        [colorButton setBackgroundColor:[self RGBAtoUIColor:[plistDict objectForKey:[NSString stringWithFormat:@"%ld_color", (long)[indexPath row]]]]];
    }
    [colorButton addTarget:self action:@selector(virtualClick:) forControlEvents:UIControlEventTouchUpInside];
    colorButton.layer.cornerRadius=7.5;
    colorButton.tag=101;
    [cell.contentView addSubview:colorButton];
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];//[cell setUserInteractionEnabled:NO];
    cell.backgroundColor = [UIColor colorWithRed:5.0/255.0 green:206.0/255.0 blue:111.0/255.0 alpha:0.65];
    [tableView setSeparatorColor:[UIColor whiteColor]];
//NSLog(@"---------");

    
    return cell;
}
    
-(void)virtualClick:(id)sender{
    [self OKClicked];
    theButton=(UIButton *)sender;
    CGPoint hitPoint = [theButton convertPoint:CGPointZero toView:inputTable];
    hitIndex = [inputTable indexPathForRowAtPoint:hitPoint];
    
    CGRect SBframe=slideKeyBoard.frame;
    thePicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0,320,SBframe.size.height)];
    [thePicker setBackgroundColor:[UIColor whiteColor]];
    thePicker.delegate = self;
    thePicker.showsSelectionIndicator = YES;
    DontTouchKeyboard=[[UIView alloc] initWithFrame:CGRectMake(0, SBframe.origin.y,320,SBframe.size.height)];[self.view addSubview:DontTouchKeyboard];/*iOS7蠢bug,不加會穿透觸發*/
    [DontTouchKeyboard addSubview:thePicker];
    [self synchronizePickview];/*經過測試,不會執行didSelectRow*/
    
    UIButton *OKbutton=[[UIButton alloc] initWithFrame:CGRectMake(265, 0, 60, 30)];
    [OKbutton setTitle:@"OK" forState:UIControlStateNormal];
    [OKbutton setTitleColor:[UIColor colorWithRed:30.0/255.0 green:144.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
    [OKbutton addTarget:self action:@selector(OKClicked) forControlEvents:UIControlEventTouchUpInside];
    [DontTouchKeyboard addSubview:OKbutton];
}
-(void)OKClicked{[DontTouchKeyboard removeFromSuperview];}
-(void)synchronizePickview{
    if(theButton.tag==99){
        if([theButton.titleLabel.text isEqualToString:@"y = f(x) = "]){
            [thePicker selectRow:0 inComponent:0 animated:YES];
        }else if([theButton.titleLabel.text isEqualToString:@"r = r(θ) = "]){
            [thePicker selectRow:1 inComponent:0 animated:YES];
        }else if([theButton.titleLabel.text isEqualToString:@"x = g(y) = "]){
            [thePicker selectRow:2 inComponent:0 animated:YES];
        }else if([theButton.titleLabel.text isEqualToString:@"ᴑ :"]){
            [thePicker selectRow:3 inComponent:0 animated:YES];
        }else if([theButton.titleLabel.text isEqualToString:@") ( :"]){
            [thePicker selectRow:4 inComponent:0 animated:YES];
        }else if([theButton.titleLabel.text isEqualToString:@"ꇤ :"]){
            [thePicker selectRow:5 inComponent:0 animated:YES];
        }else if([theButton.titleLabel.text isEqualToString:@"Any : "]){
            [thePicker selectRow:6 inComponent:0 animated:YES];}
    }else if(theButton.tag==101){
        if([theButton.backgroundColor isEqual:rgba(238,59,59,1)]){
            [thePicker selectRow:1 inComponent:0 animated:YES];
        }else if([theButton.backgroundColor isEqual:rgba(30,144,255,1)]){
            [thePicker selectRow:2 inComponent:0 animated:YES];
        }else if([theButton.backgroundColor isEqual:rgba(34,139,34,1)]){
            [thePicker selectRow:3 inComponent:0 animated:YES];
        }else if([theButton.backgroundColor isEqual:rgba(255,215,0,1)]){
            [thePicker selectRow:4 inComponent:0 animated:YES];
        }else if([theButton.backgroundColor isEqual:rgba(0,206,209,1)]){
            [thePicker selectRow:5 inComponent:0 animated:YES];
        }else if([theButton.backgroundColor isEqual:rgba(139,69,19,1)]){
            [thePicker selectRow:6 inComponent:0 animated:YES];
        }else if([theButton.backgroundColor isEqual:rgba(153,50,204,1)]){
            [thePicker selectRow:7 inComponent:0 animated:YES];
        }else if([theButton.backgroundColor isEqual:rgba(0,250,154,1)]){
            [thePicker selectRow:8 inComponent:0 animated:YES];
        }else if([theButton.backgroundColor isEqual:rgba(255,20,147,1)]){
            [thePicker selectRow:9 inComponent:0 animated:YES];
        }else if([theButton.titleLabel.text isEqualToString:@"Hidden"]){
            [thePicker selectRow:0 inComponent:0 animated:YES];
        }
    }
}
    
// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    NSInteger numRows=0;
    if(theButton.tag==99){numRows = 7;}
    else if(theButton.tag==101){numRows=10;}
    return numRows;
}
/*tell the picker how many columns it will have*/
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {return 1;}
/*選擇視窗的寬度*/
-(CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{return 60.0f;}
/*tell the picker the title for a given row*/
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    if(theButton.tag==99){
        switch(row){
            case 0:{
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
                label.text = @"y = f(x)";
                label.textAlignment = NSTextAlignmentCenter;return label;break;
            }case 1:{
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
                label.text = @"r = r(θ)";
                label.textAlignment = NSTextAlignmentCenter;return label;break;
            }case 2:{
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
                label.text = @"x = g(y)";
                label.textAlignment = NSTextAlignmentCenter;return label;break;
            }case 3:{
                GraphicsByCoding *icon = [[GraphicsByCoding alloc] initWithFrame:CGRectMake(0,0,70,50)];
                icon.iconBango=1.1;
                return icon;break;
            }case 4:{
                GraphicsByCoding *icon = [[GraphicsByCoding alloc] initWithFrame:CGRectMake(0,0,70,50)];
                icon.iconBango=2.1;
                return icon;break;
            }case 5:{
                GraphicsByCoding *icon = [[GraphicsByCoding alloc] initWithFrame:CGRectMake(0,0,70,50)];
                icon.iconBango=3.1;
                return icon;break;
            }case 6:{
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
                label.text = @"Any f(x,y)=g(x,y)";label.textAlignment = NSTextAlignmentCenter;
                return label;break;}
        }
    }else if(theButton.tag==101){
        switch (row) {
            case 0:{
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
                label.text = @"Hide this.";label.textAlignment = NSTextAlignmentCenter;
                return label;break;}
            case 1:{
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
                label.backgroundColor = rgba(238,59,59,1);return label;break;}
            case 2:{
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
                label.backgroundColor = rgba(30,144,255,1);return label;break;}
            case 3:{
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
                label.backgroundColor = rgba(34,139,34,1);return label;break;}
            case 4:{
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
                label.backgroundColor = rgba(255,215,0,1);return label;break;}
            case 5:{
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
                label.backgroundColor = rgba(0,206,209,1);return label;break;}
            case 6:{
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
                label.backgroundColor = rgba(139,69,19,1);return label;break;}
            case 7:{
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
                label.backgroundColor = rgba(153,50,204,1);return label;break;}
            case 8:{
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
                label.backgroundColor = rgba(0,250,154,1);return label;break;}
            case 9:{
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
                label.backgroundColor = rgba(255,20,147,1);return label;break;}
        }
    }
    return nil;/*不加這一行compiler不會過,不過事實上上面每個case都有自己的return*/
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {// Handle the selection
    
    [inputTable scrollToRowAtIndexPath:hitIndex atScrollPosition:UITableViewScrollPositionNone animated:YES];/*如果tablecell不在畫面裡,會自動轉到畫面上方或下方,如果本來就在畫面裡則不會轉動*/

    if(theButton.tag==99){
        switch (row) {
            case 0:{
                if(![theButton.titleLabel.text isEqualToString:@"y = f(x) = "]){
                    prepareForHistoryDealer
                    [theButton setTitle:@"y = f(x) = " forState:UIControlStateNormal];
                    [plistDict setValue:@"y = f(x) = " forKey:[NSString stringWithFormat:@"%ld_type",(long)[hitIndex row]]];
                    [plistDict writeToFile:plistPath atomically:YES];
                    [inputTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:hitIndex] withRowAnimation:UITableViewRowAnimationNone];
                }break;}
            case 1:{
                if(![theButton.titleLabel.text isEqualToString:@"r = r(θ) = "]){
                    prepareForHistoryDealer
                    [theButton setTitle:@"r = r(θ) = " forState:UIControlStateNormal];
                    [plistDict setValue:@"r = r(θ) = " forKey:[NSString stringWithFormat:@"%ld_type",(long)[hitIndex row]]];
                    [plistDict writeToFile:plistPath atomically:YES];
                    [inputTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:hitIndex] withRowAnimation:UITableViewRowAnimationNone];
                }break;}
            case 2:{
                if(![theButton.titleLabel.text isEqualToString:@"x = g(y) = "]){
                    prepareForHistoryDealer
                    [theButton setTitle:@"x = g(y) = " forState:UIControlStateNormal];
                    [plistDict setValue:@"x = g(y) = " forKey:[NSString stringWithFormat:@"%ld_type",(long)[hitIndex row]]];
                    [plistDict writeToFile:plistPath atomically:YES];
                    [inputTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:hitIndex] withRowAnimation:UITableViewRowAnimationNone];
                }break;}
            case 3:{
                if(![theButton.titleLabel.text isEqualToString:@"ᴑ :"]){
                    prepareForHistoryDealer
                    [theButton setTitle:@"ᴑ :" forState:UIControlStateNormal];
                    [plistDict setValue:@"ᴑ :" forKey:[NSString stringWithFormat:@"%ld_type",(long)[hitIndex row]]];
                    [plistDict writeToFile:plistPath atomically:YES];
                    [inputTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:hitIndex] withRowAnimation:UITableViewRowAnimationNone];
                }break;}
            case 4:{
                if(![theButton.titleLabel.text isEqualToString:@") ( :"]){
                    prepareForHistoryDealer
                    [theButton setTitle:@") ( :" forState:UIControlStateNormal];
                    [plistDict setValue:@") ( :" forKey:[NSString stringWithFormat:@"%ld_type",(long)[hitIndex row]]];
                    [plistDict writeToFile:plistPath atomically:YES];
                    [inputTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:hitIndex] withRowAnimation:UITableViewRowAnimationNone];
                }break;}
            case 5:{
                if(![theButton.titleLabel.text isEqualToString:@"ꇤ :"]){
                    prepareForHistoryDealer
                    [theButton setTitle:@"ꇤ :" forState:UIControlStateNormal];
                    [plistDict setValue:@"ꇤ :" forKey:[NSString stringWithFormat:@"%ld_type",(long)[hitIndex row]]];
                    [plistDict writeToFile:plistPath atomically:YES];
                    [inputTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:hitIndex] withRowAnimation:UITableViewRowAnimationNone];
                }break;}
            case 6:{
                if(![theButton.titleLabel.text isEqualToString:@"Any : "]){
                    [self consumingTimeAlert:2];
                }
                break;}
        }
    }else if(theButton.tag==101){
        prepareForHistoryDealer
        if([[plistDict objectForKey:[NSString stringWithFormat:@"%ld_type", (long)[hitIndex row]]] isEqualToString:@"Any : "]&&[theButton.titleLabel.text isEqualToString:@"Hidden"]&&row!=0){
            selectedPickerRow=row;
            [self consumingTimeAlert:3];
            
        }else{
        switch (row) {
            case 0:
                [theButton setTitle:@"Hidden" forState:UIControlStateNormal];
                [theButton setBackgroundColor:[UIColor clearColor]];
                [plistDict setValue:@"Hidden" forKey:[NSString stringWithFormat:@"%ld_color",(long)[hitIndex row]]];
                [plistDict writeToFile:plistPath atomically:YES];
                break;
            case 1:
                [theButton setTitle:@"" forState:UIControlStateNormal];
                [theButton setBackgroundColor:rgba(238,59,59,1)];
                [plistDict setValue:@"rgba(238,59,59,1)" forKey:[NSString stringWithFormat:@"%ld_color",(long)[hitIndex row]]];
                [plistDict writeToFile:plistPath atomically:YES];
                break;
            case 2:
                [theButton setTitle:@"" forState:UIControlStateNormal];
                [theButton setBackgroundColor:rgba(30,144,255,1)];
                [plistDict setValue:@"rgba(30,144,255,1)" forKey:[NSString stringWithFormat:@"%ld_color",(long)[hitIndex row]]];
                [plistDict writeToFile:plistPath atomically:YES];
                break;
            case 3:
                [theButton setTitle:@"" forState:UIControlStateNormal];
                [theButton setBackgroundColor:rgba(34,139,34,1)];
                [plistDict setValue:@"rgba(34,139,34,1)" forKey:[NSString stringWithFormat:@"%ld_color",(long)[hitIndex row]]];
                [plistDict writeToFile:plistPath atomically:YES];
                break;
            case 4:
                [theButton setTitle:@"" forState:UIControlStateNormal];
                [theButton setBackgroundColor:rgba(255,215,0,1)];
                [plistDict setValue:@"rgba(255,215,0,1)" forKey:[NSString stringWithFormat:@"%ld_color",(long)[hitIndex row]]];
                [plistDict writeToFile:plistPath atomically:YES];
                break;
            case 5:
                [theButton setTitle:@"" forState:UIControlStateNormal];
                [theButton setBackgroundColor:rgba(0,206,209,1)];
                [plistDict setValue:@"rgba(0,206,209,1)" forKey:[NSString stringWithFormat:@"%ld_color",(long)[hitIndex row]]];
                [plistDict writeToFile:plistPath atomically:YES];
                break;
            case 6:
                [theButton setTitle:@"" forState:UIControlStateNormal];
                [theButton setBackgroundColor:rgba(139,69,19,1)];
                [plistDict setValue:@"rgba(139,69,19,1)" forKey:[NSString stringWithFormat:@"%ld_color",(long)[hitIndex row]]];
                [plistDict writeToFile:plistPath atomically:YES];
                break;
            case 7:
                [theButton setTitle:@"" forState:UIControlStateNormal];
                [theButton setBackgroundColor:rgba(153,50,204,1)];
                [plistDict setValue:@"rgba(153,50,204,1)" forKey:[NSString stringWithFormat:@"%ld_color",(long)[hitIndex row]]];
                [plistDict writeToFile:plistPath atomically:YES];
                break;
            case 8:
                [theButton setTitle:@"" forState:UIControlStateNormal];
                [theButton setBackgroundColor:rgba(0,250,154,1)];
                [plistDict setValue:@"rgba(0,250,154,1)" forKey:[NSString stringWithFormat:@"%ld_color",(long)[hitIndex row]]];
                [plistDict writeToFile:plistPath atomically:YES];
                break;
            case 9:
                [theButton setTitle:@"" forState:UIControlStateNormal];
                [theButton setBackgroundColor:rgba(255,20,147,1)];
                [plistDict setValue:@"rgba(255,20,147,1)" forKey:[NSString stringWithFormat:@"%ld_color",(long)[hitIndex row]]];
                [plistDict writeToFile:plistPath atomically:YES];
                break;
        }
        }
    }
    [self viewDidAppear:NO];
}

-(void)consumingTimeAlert:(int)TAG{
    UIAlertView *CMKUalertview= [[UIAlertView alloc] initWithTitle:@"Beta Functionality" message:@"”Plotting any f(x,y)=g(x,y)” is a BETA functionality.　This algorithm checks every point of your screen and see whether the point satisfies your equation or not. Honestly, this is a exhaustive and brute way and the graph is usually not accurate enough and is very slow to plot. Would you still like to try? Or, please email me a better algorithm that can smarterly plot ”ANY” f(x,y)=g(x,y). I will be very grateful." delegate:self cancelButtonTitle:@"Not now" otherButtonTitles:@"Try it !", nil];
    CMKUalertview.tag=TAG;
    [CMKUalertview show];
}
//-(void)alertView函數是內建的！delegate:self 會讓這個物件自動呼叫-(void)alertView
-(void)alertView:(UIAlertView *)CMKU22222alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(CMKU22222alertView.tag==1){
        switch(buttonIndex){
            case 0:
                break;
            case 1:{
                [thisTextbox resignFirstResponder];/*避免全部清掉了又存到這一個*/
                prepareForHistoryDealer
                for(int tableRow=0;tableRow<10;tableRow++){
                    [plistDict setValue:@"" forKey:[NSString stringWithFormat:@"%d_func",tableRow]];
                    [plistDict setValue:@"" forKey:[NSString stringWithFormat:@"%d_xfrom",tableRow]];
                    [plistDict setValue:@"" forKey:[NSString stringWithFormat:@"%d_xTo",tableRow]];
                    [plistDict setValue:@"" forKey:[NSString stringWithFormat:@"%d_yfrom",tableRow]];
                    [plistDict setValue:@"" forKey:[NSString stringWithFormat:@"%d_yTo",tableRow]];
                    [plistDict setValue:@"" forKey:[NSString stringWithFormat:@"%d_θfrom",tableRow]];
                    [plistDict setValue:@"" forKey:[NSString stringWithFormat:@"%d_θTo",tableRow]];
                }
                [plistDict writeToFile:plistPath atomically:YES];
                [inputTable reloadData];
                [self viewDidAppear:NO];
                break;
            }
        }
    }else if(CMKU22222alertView.tag==2){
        switch (buttonIndex) {
            case 0:{[self synchronizePickview];break;}
            case 1:{
                prepareForHistoryDealer
                [theButton setTitle:@"Any : " forState:UIControlStateNormal];
                [plistDict setValue:@"Any : " forKey:[NSString stringWithFormat:@"%ld_type",(long)[hitIndex row]]];
                [plistDict writeToFile:plistPath atomically:YES];
                [inputTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:hitIndex] withRowAnimation:UITableViewRowAnimationNone];
                [self viewDidAppear:NO];
                break;
            }
        }
    }else if(CMKU22222alertView.tag==3){
        switch(buttonIndex){
            case 0:{[self synchronizePickview];break;}
            case 1:{
                theButton.titleLabel.text = @"";
                [self pickerView:thePicker didSelectRow:selectedPickerRow inComponent:0];
                break;
            }
        }
        
    }
}
//////////programmatically create tableView END
    
    
-(IBAction)backToCalculatorButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)toNewtonButton:(id)sender{
    [self dismissViewControllerAnimated:NO completion:^{[[NSNotificationCenter defaultCenter] postNotificationName:@"clickNewton" object:self];}];
}
-(IBAction)toX4solverButton:(id)sender{
    [self dismissViewControllerAnimated:NO completion:^{[[NSNotificationCenter defaultCenter] postNotificationName:@"clickX4solver" object:self];}];
}

/////////////////////////////////////////////////////////
-(IBAction)executeButton:(id)sender{
    [self saveData];
    [plotByHtmlPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var canvas=document.getElementById('canvas');canvas.getContext('2d').clearRect(0, 0, canvas.width, canvas.height);"]];
    dataArray1 = [NSMutableArray array];
    
    prepareForHistoryDealer

for(int tableRow=0;tableRow<10;tableRow++){
    NSString *judgeType=[plistDict objectForKey:[NSString stringWithFormat:@"%d_type",tableRow]];
    NSString *colorValue=[plistDict objectForKey:[NSString stringWithFormat:@"%d_color", tableRow]];
    if([judgeType isEqualToString:@"y = f(x) = "]||[judgeType isEqualToString:@"r = r(θ) = "]||[judgeType isEqualToString:@"x = g(y) = "]||[judgeType isEqualToString:@"Any : "]){
        NSString *funcValue=[plistDict objectForKey:[NSString stringWithFormat:@"%d_func", tableRow]];
        if([colorValue isEqualToString:@"Hidden"]||[funcValue isEqualToString:@""]){
//            NSLog(@"skip%d",tableRow);
        }
        else{
            NSMutableArray *columnArray=[NSMutableArray array];
            [columnArray addObject:judgeType];
            [columnArray addObject:colorValue];
            if([judgeType isEqualToString:@"Any : "]){
                [columnArray addObject:[plotByHtmlPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var s='%@';if(!s.match(/=/)||s.match(/=/g).length!=1){alert(alert1forFunc1);}else{s='abs(('+s.replace(/=/,')-(')+'))/(abs('+s.replace(/=/,')+abs(')+')+0.000074)';makeComputerUnderstandThisMath(s,'ReturnFinalFormula');}",[self robustTranslater:funcValue]]]];
            }else{
                [columnArray addObject:[plotByHtmlPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var s='%@';if(s.match(/=/)){alert(alert2);}else{makeComputerUnderstandThisMath(s,'ReturnFinalFormula');}",[self robustTranslater:funcValue]]]];
            }
            [dataArray1 addObject:columnArray];
            
            NSString *xStart=[self robustTranslater:[plistDict objectForKey:[NSString stringWithFormat:@"%d_xfrom",tableRow]]],
            *xEnd=[self robustTranslater:[plistDict objectForKey:[NSString stringWithFormat:@"%d_xTo",tableRow]]],
            *yStart=[self robustTranslater:[plistDict objectForKey:[NSString stringWithFormat:@"%d_yfrom",tableRow]]],
            *yEnd=[self robustTranslater:[plistDict objectForKey:[NSString stringWithFormat:@"%d_yTo",tableRow]]];
            NSInteger k=[dataArray1 count]-1;
            NSString *jsCode = [NSString stringWithFormat:@"myEval('%@','ReturnFinalReal');",xStart];
            dataArray2[0][k]=[[plotByHtmlPage stringByEvaluatingJavaScriptFromString:jsCode] floatValue];
            jsCode = [NSString stringWithFormat:@"myEval('%@','ReturnFinalReal');",xEnd];
            dataArray2[1][k]=[[plotByHtmlPage stringByEvaluatingJavaScriptFromString:jsCode] floatValue];
            jsCode = [NSString stringWithFormat:@"myEval('%@','ReturnFinalReal');",yStart];
            dataArray2[2][k]=[[plotByHtmlPage stringByEvaluatingJavaScriptFromString:jsCode] floatValue];
            jsCode = [NSString stringWithFormat:@"myEval('%@','ReturnFinalReal');",yEnd];
            dataArray2[3][k]=[[plotByHtmlPage stringByEvaluatingJavaScriptFromString:jsCode] floatValue];
            if([judgeType isEqualToString:@"r = r(θ) = "]){
                NSString *thetaStart=[self robustTranslater:[plistDict objectForKey:[NSString stringWithFormat:@"%d_θfrom", tableRow]]];
                NSString *thetaEnd=[self robustTranslater:[plistDict objectForKey:[NSString stringWithFormat:@"%d_θTo", tableRow]]];
                jsCode = [NSString stringWithFormat:@"myEval('%@','ReturnFinalReal');",thetaStart];
                dataArray2[4][k]=[[plotByHtmlPage stringByEvaluatingJavaScriptFromString:jsCode] floatValue];
                jsCode = [NSString stringWithFormat:@"myEval('%@','ReturnFinalReal');",thetaEnd];
                dataArray2[5][k]=[[plotByHtmlPage stringByEvaluatingJavaScriptFromString:jsCode] floatValue];
            }
            ////////////////////////////////////plotting!!!!////
            if(k==0||dataArray2[0][k]!=dataArray2[0][0]||dataArray2[1][k]!=dataArray2[1][0]||dataArray2[2][k]!=dataArray2[2][0]||dataArray2[3][k]!=dataArray2[3][0]){[plotByHtmlPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"XYaxesGraph(%f,%f,%f,%f);",dataArray2[0][k],dataArray2[1][k],dataArray2[2][k],dataArray2[3][k]]];}
            if([judgeType isEqualToString:@"r = r(θ) = "]){
                [plotByHtmlPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"funcType='%@';iro='%@';func='%@';xStart=%f;xEnd=%f;yStart=%f;yEnd=%f;θStart=%f;θEnd=%f;draw();",judgeType,[[dataArray1 objectAtIndex:k] objectAtIndex:1],[[dataArray1 objectAtIndex:k] objectAtIndex:2],dataArray2[0][k],dataArray2[1][k],dataArray2[2][k],dataArray2[3][k],dataArray2[4][k],dataArray2[5][k]]];
            }else{
                [plotByHtmlPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"funcType='%@';iro='%@';func='%@';xStart=%f;xEnd=%f;yStart=%f;yEnd=%f;draw();",judgeType,[[dataArray1 objectAtIndex:k] objectAtIndex:1],[[dataArray1 objectAtIndex:k] objectAtIndex:2],dataArray2[0][k],dataArray2[1][k],dataArray2[2][k],dataArray2[3][k]]];
            }
            ///////////////////////////////////////////////////
        }
    }
    else if([judgeType isEqualToString:@"ᴑ :"]||[judgeType isEqualToString:@") ( :"]||[judgeType isEqualToString:@"ꇤ :"]){
        NSString *Avalue=[plistDict objectForKey:[NSString stringWithFormat:@"%d_conicA",tableRow]];
        NSString *Bvalue=[plistDict objectForKey:[NSString stringWithFormat:@"%d_conicB",tableRow]];
        if([colorValue isEqualToString:@"Hidden"]||[Avalue isEqualToString:@""]||[Bvalue isEqualToString:@""]){
//             NSLog(@"skip%d",tableRow);
        }
        else{
            NSMutableArray *columnArray=[NSMutableArray array];
            [columnArray addObject:judgeType];
            [columnArray addObject:colorValue];
            [columnArray addObject:@"conic"];
            [dataArray1 addObject:columnArray];
            
            NSString *xStart=[self robustTranslater:[plistDict objectForKey:[NSString stringWithFormat:@"%d_xfrom",tableRow]]],
            *xEnd=[self robustTranslater:[plistDict objectForKey:[NSString stringWithFormat:@"%d_xTo",tableRow]]],
            *yStart=[self robustTranslater:[plistDict objectForKey:[NSString stringWithFormat:@"%d_yfrom",tableRow]]],
            *yEnd=[self robustTranslater:[plistDict objectForKey:[NSString stringWithFormat:@"%d_yTo",tableRow]]],
            *conicX=[self robustTranslater:[plistDict objectForKey:[NSString stringWithFormat:@"%d_conicX",tableRow]]],
            *conicY=[self robustTranslater:[plistDict objectForKey:[NSString stringWithFormat:@"%d_conicY",tableRow]]],
            *conicA=[self robustTranslater:Avalue],
            *conicB=[self robustTranslater:Bvalue];
            NSInteger k=[dataArray1 count]-1;
            NSString *jsCode = [NSString stringWithFormat:@"myEval('%@','ReturnFinalReal');",xStart];
            dataArray2[0][k]=[[plotByHtmlPage stringByEvaluatingJavaScriptFromString:jsCode] floatValue];
            jsCode = [NSString stringWithFormat:@"myEval('%@','ReturnFinalReal');",xEnd];
            dataArray2[1][k]=[[plotByHtmlPage stringByEvaluatingJavaScriptFromString:jsCode] floatValue];
            jsCode = [NSString stringWithFormat:@"myEval('%@','ReturnFinalReal');",yStart];
            dataArray2[2][k]=[[plotByHtmlPage stringByEvaluatingJavaScriptFromString:jsCode] floatValue];
            jsCode = [NSString stringWithFormat:@"myEval('%@','ReturnFinalReal');",yEnd];
            dataArray2[3][k]=[[plotByHtmlPage stringByEvaluatingJavaScriptFromString:jsCode] floatValue];
            jsCode = [NSString stringWithFormat:@"myEval('%@','ReturnFinalReal');",conicX];
            dataArray2[4][k]=[[plotByHtmlPage stringByEvaluatingJavaScriptFromString:jsCode] floatValue];
            jsCode = [NSString stringWithFormat:@"myEval('%@','ReturnFinalReal');",conicY];
            dataArray2[5][k]=[[plotByHtmlPage stringByEvaluatingJavaScriptFromString:jsCode] floatValue];
            jsCode = [NSString stringWithFormat:@"myEval('%@','ReturnFinalReal');",conicA];
            dataArray2[6][k]=[[plotByHtmlPage stringByEvaluatingJavaScriptFromString:jsCode] floatValue];
            jsCode = [NSString stringWithFormat:@"myEval('%@','ReturnFinalReal');",conicB];
            dataArray2[7][k]=[[plotByHtmlPage stringByEvaluatingJavaScriptFromString:jsCode] floatValue];
            ////////////////////////////////////plotting!!!!////
            if(k==0||dataArray2[0][k]!=dataArray2[0][0]||dataArray2[1][k]!=dataArray2[1][0]||dataArray2[2][k]!=dataArray2[2][0]||dataArray2[3][k]!=dataArray2[3][0]){[plotByHtmlPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"XYaxesGraph(%f,%f,%f,%f);",dataArray2[0][k],dataArray2[1][k],dataArray2[2][k],dataArray2[3][k]]];}
            [plotByHtmlPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"funcType='%@';iro='%@';xStart=%f;xEnd=%f;yStart=%f;yEnd=%f;conicX=%f;conicY=%f;conicA=%f;conicB=%f;draw();",judgeType,[[dataArray1 objectAtIndex:k] objectAtIndex:1],dataArray2[0][k],dataArray2[1][k],dataArray2[2][k],dataArray2[3][k],dataArray2[4][k],dataArray2[5][k],dataArray2[6][k],dataArray2[7][k]]];
            ///////////////////////////////////////////////////
        }
    }
    
}
[dishforHTML addSubview:plotByHtmlPage];
[dishforHTML addSubview:afterPlotButton];
[self.view addSubview:dishforHTML];
[UIView beginAnimations:nil context:nil];
[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
[UIView setAnimationDuration:0.3f];//0.3 seconds
CGRect plotFrame=dishforHTML.frame;
plotFrame.origin.y=0;dishforHTML.frame=plotFrame;
[UIView commitAnimations];
[self setNeedsStatusBarAppearanceUpdate];/*Force the statusbar to update */
if(track)[self trackMe];
}


-(void)pinchGestureResize:(UIPinchGestureRecognizer*)sender{
    
    CGPoint midPoint = [sender locationInView:plotByHtmlPage];
    float xRatioHidari=midPoint.x/plotByHtmlPage.frame.size.width;
    float yRatioSita=1-midPoint.y/plotByHtmlPage.frame.size.height;
    float theScale=1/sender.scale;
    sender.scale=1;/*防止二次累加*/
    
    [plotByHtmlPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var canvas=document.getElementById('canvas');canvas.getContext('2d').clearRect(0, 0, canvas.width, canvas.height);"]];
    
    for(int k=0;k<[dataArray1 count];k++){
    
        float xStart0=dataArray2[0][k];
        float xEnd0=dataArray2[1][k];
        float yStart0=dataArray2[2][k];
        float yEnd0=dataArray2[3][k];
    
        float deltaX=xEnd0-xStart0;
        float deltaY=yEnd0-yStart0;
        float newX0=deltaX*xRatioHidari+xStart0;
        float newY0=deltaY*yRatioSita+yStart0;
        xStart0=newX0-deltaX*xRatioHidari*theScale;
        xEnd0=newX0+deltaX*(1-xRatioHidari)*theScale;
        yStart0=newY0-deltaY*yRatioSita*theScale;
        yEnd0=newY0+deltaY*(1-yRatioSita)*theScale;
    
        dataArray2[0][k]=xStart0;
        dataArray2[1][k]=xEnd0;
        dataArray2[2][k]=yStart0;
        dataArray2[3][k]=yEnd0;
        
        if(k==0||dataArray2[0][k]!=dataArray2[0][0]||dataArray2[1][k]!=dataArray2[1][0]||dataArray2[2][k]!=dataArray2[2][0]||dataArray2[3][k]!=dataArray2[3][0]){[plotByHtmlPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"XYaxesGraph(%f,%f,%f,%f);",xStart0,xEnd0,yStart0,yEnd0]];}
        if([[[dataArray1 objectAtIndex:k] objectAtIndex:2]isEqualToString:@"conic"]){
            [plotByHtmlPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"funcType='%@';iro='%@';xStart=%f;xEnd=%f;yStart=%f;yEnd=%f;conicX=%f;conicY=%f;conicA=%f;conicB=%f;draw();",[[dataArray1 objectAtIndex:k] objectAtIndex:0],[[dataArray1 objectAtIndex:k] objectAtIndex:1],xStart0,xEnd0,yStart0,yEnd0,dataArray2[4][k],dataArray2[5][k],dataArray2[6][k],dataArray2[7][k]]];
        }
        else{
            [plotByHtmlPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"funcType='%@';iro='%@';func='%@';xStart=%f;xEnd=%f;yStart=%f;yEnd=%f;draw();",[[dataArray1 objectAtIndex:k] objectAtIndex:0],[[dataArray1 objectAtIndex:k] objectAtIndex:1],[[dataArray1 objectAtIndex:k] objectAtIndex:2],xStart0,xEnd0,yStart0,yEnd0]];
        }
    }
    if(track){
        trackingX=midPoint.x+(trackingX-midPoint.x)/theScale;
        trackingY=midPoint.y+(trackingY-midPoint.y)/theScale;
        [self trackMe];
    }
}
-(void)panGestureMove:(UIPanGestureRecognizer*)sender{
    CGPoint move=[sender translationInView:plotByHtmlPage];
    [sender setTranslation:CGPointMake(0, 0) inView:slideKeyBoard];//此式,蘋果怪邏輯,非同步來防止origin二次以上累加
    
    if(track&&((fabs([sender locationInView:plotByHtmlPage].x-trackingX))<30||(fabs([sender locationInView:plotByHtmlPage].y-trackingY))<30)){
        trackingX+=move.x;
        trackingY+=move.y;
        [self trackMe];
    }else {
        [plotByHtmlPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var canvas=document.getElementById('canvas');canvas.getContext('2d').clearRect(0, 0, canvas.width, canvas.height);"]];
    
        for(int k=0;k<[dataArray1 count];k++){
    
            float deltaX=(dataArray2[1][k]-dataArray2[0][k])*move.x/plotByHtmlPage.frame.size.width;
            float deltaY=(dataArray2[3][k]-dataArray2[2][k])*move.y/plotByHtmlPage.frame.size.height;

            dataArray2[0][k]-=deltaX;
            dataArray2[1][k]-=deltaX;
            dataArray2[2][k]+=deltaY;
            dataArray2[3][k]+=deltaY;
    
            if(k==0||dataArray2[0][k]!=dataArray2[0][0]||dataArray2[1][k]!=dataArray2[1][0]||dataArray2[2][k]!=dataArray2[2][0]||dataArray2[3][k]!=dataArray2[3][0]){[plotByHtmlPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"XYaxesGraph(%f,%f,%f,%f);",dataArray2[0][k],dataArray2[1][k],dataArray2[2][k],dataArray2[3][k]]];}
            if([[[dataArray1 objectAtIndex:k] objectAtIndex:2]isEqualToString:@"conic"]){
                [plotByHtmlPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"funcType='%@';iro='%@';xStart=%f;xEnd=%f;yStart=%f;yEnd=%f;conicX=%f;conicY=%f;conicA=%f;conicB=%f;draw();",[[dataArray1 objectAtIndex:k] objectAtIndex:0],[[dataArray1 objectAtIndex:k] objectAtIndex:1],dataArray2[0][k],dataArray2[1][k],dataArray2[2][k],dataArray2[3][k],dataArray2[4][k],dataArray2[5][k],dataArray2[6][k],dataArray2[7][k]]];
            }
            else{
                [plotByHtmlPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"funcType='%@';iro='%@';func='%@';xStart=%f;xEnd=%f;yStart=%f;yEnd=%f;draw();",[[dataArray1 objectAtIndex:k] objectAtIndex:0],[[dataArray1 objectAtIndex:k] objectAtIndex:1],[[dataArray1 objectAtIndex:k] objectAtIndex:2],dataArray2[0][k],dataArray2[1][k],dataArray2[2][k],dataArray2[3][k]]];
            }
        }
        if(track){
            trackingX+=move.x;
            trackingY+=move.y;
            [self trackMe];
        }
    }
}
/*對UIWebview用TapGesture特別麻煩*/
-(void)tapGesturetrack:(UITapGestureRecognizer*)sender{
    if(track)track=NO;else track=YES;
    if(track){
        if(trackingX<=0||trackingX>=plotByHtmlPage.frame.size.width||trackingY<=0||trackingY>=plotByHtmlPage.frame.size.height){
            trackingX = [sender locationInView:plotByHtmlPage].x;
            trackingY = [sender locationInView:plotByHtmlPage].y;
        }
        [self trackMe];
    }else{
        [plotByHtmlPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var canvas2=document.getElementById('canvas2');canvas2.getContext('2d').clearRect(0, 0, canvas2.width, canvas2.height);"]];
    }
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer {return YES;}
/*對UIWebview用TapGesture特別麻煩*/
-(void)trackMe{
    [plotByHtmlPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var canvas2=document.getElementById('canvas2');canvas2.getContext('2d').clearRect(0, 0, canvas2.width, canvas2.height);trackMe(%f,%f)",trackingX,trackingY]];
    for(int k=0,i=0;k<[dataArray1 count];k++){
        if(k==0||dataArray2[0][k]!=dataArray2[0][0]||dataArray2[1][k]!=dataArray2[1][0]||dataArray2[2][k]!=dataArray2[2][0]||dataArray2[3][k]!=dataArray2[3][0]){
            float xValue=trackingX/(plotByHtmlPage.frame.size.width)*(dataArray2[1][k]-dataArray2[0][k])+dataArray2[0][k];
            float yValue=trackingY/(plotByHtmlPage.frame.size.height)*(dataArray2[2][k]-dataArray2[3][k])+dataArray2[3][k];
            
            [plotByHtmlPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"showTrackingData('%@',%f,%f,%d,%d);",[[dataArray1 objectAtIndex:k] objectAtIndex:1],xValue,yValue,10,20+i*16]];
            i++;
        }
    }
}

-(void)cancelPlot{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3f];//0.3 seconds
    CGRect plotFrame=dishforHTML.frame;
    if(iPhone5series  && iOS_from(@"7.0"))plotFrame.origin.y=568;
    else if(iOS_from(@"7.0"))plotFrame.origin.y=480;
    dishforHTML.frame=plotFrame;
    [UIView commitAnimations];
//    [inputTable reloadData];/*似乎不需這一行了*/
    [self setNeedsStatusBarAppearanceUpdate];/*Force the statusbar to update */
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
    [inputTable scrollToRowAtIndexPath:hitIndex2 atScrollPosition:UITableViewScrollPositionNone animated:YES];/*如果tablecell不在畫面裡,會自動轉到畫面上方或下方,如果本來就在畫面裡則不會轉動*/
    if(ONoff==1&&[inputTable cellForRowAtIndexPath:hitIndex2]){
        [thisTextbox insertText:param1];
    }else{
        [self viewDidAppear:NO];
    }
}
-(IBAction)deleteButton:(id)sender{
    [inputTable scrollToRowAtIndexPath:hitIndex2 atScrollPosition:UITableViewScrollPositionNone animated:YES];/*如果tablecell不在畫面裡,會自動轉到畫面上方或下方,如果本來就在畫面裡則不會轉動*/
    if(ONoff==1&&[inputTable cellForRowAtIndexPath:hitIndex2]){
        [thisTextbox deleteBackward];
    }else if(ONoff==0){
        [self viewDidAppear:NO];
    }
}
-(IBAction)clearALLButton:(id)sender{
    UIAlertView *CMKUalertview= [[UIAlertView alloc] initWithTitle:youWantToP message:@"" delegate:self cancelButtonTitle:doNothingP otherButtonTitles:clearDraftP, nil];
    CMKUalertview.tag=1;
    [CMKUalertview show];
}
//-(void)alertView函數是內建的,不用加協定！delegate:self 會讓這個物件自動呼叫-(void)alertView
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
    arcP=(arcP+1)%2;
    if(arcP==1)[arcButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    else[arcButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
-(IBAction)hypMODEButton:(id)sender{
    hypP=(hypP+1)%2;
    if(hypP==1)[hypButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    else[hypButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
-(IBAction)inputButtonSIN:(id)sender{[self TriTyping:@"sin"];}
-(IBAction)inputButtonCOS:(id)sender{[self TriTyping:@"cos"];}
-(IBAction)inputButtonTAN:(id)sender{[self TriTyping:@"tan"];}
-(void)TriTyping:(NSString*)param1{
    NSString *str;
    if(arcP==0&&hypP==0)str=[NSString stringWithFormat:@"%@(",param1];
    else if(arcP==0&&hypP==1)str=[NSString stringWithFormat:@"%@h(",param1];
    else if(arcP==1&&hypP==0)str=[NSString stringWithFormat:@"a%@(",param1];
    else if(arcP==1&&hypP==1)str=[NSString stringWithFormat:@"a%@h(",param1];
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
-(IBAction)inputButtonY:(id)sender{[self typing:@"y"];}
-(IBAction)inputButtonTheta:(id)sender{[self typing:@"θ"];}

    
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
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if(!iPhone5series){
        [plotByHtmlPage stringByEvaluatingJavaScriptFromString: @"document.getElementById('canvas').height = 480;document.getElementById('canvas2').height = 480;document.getElementById('canvas').width = 320;document.getElementById('canvas2').width = 320;"];
    }

    NSString *languageCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([languageCode isEqualToString:@"zh-Hant"]||[languageCode isEqualToString:@"zh-Hans"]){
        [plotByHtmlPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"internatioanlVersion(2);internatioanlVersionOfFunc2(2);"]];
        youWantToP=@"您想要...";
        doNothingP=@"沒事,按錯了";
        clearDraftP=@"清除全部";
    }else if([languageCode isEqualToString:@"ja"]){
        [plotByHtmlPage stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"internatioanlVersion(3);internatioanlVersionOfFunc2(3);"]];
        youWantToP=@"あなたは...";
        doNothingP=@"何もしない";
        clearDraftP=@"全て消す";
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    ONoff=1;
    thisTextbox=textField;
    CGPoint hitPoint = [textField convertPoint:CGPointZero toView:inputTable];
    hitIndex2 = [inputTable indexPathForRowAtPoint:hitPoint];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self saveData];
    ONoff=0;
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    ONoff=1;
    thisTextbox=textView;
    CGPoint hitPoint = [textView convertPoint:CGPointZero toView:inputTable];
    hitIndex2 = [inputTable indexPathForRowAtPoint:hitPoint];
    [textView scrollRangeToVisible:textView.selectedRange];/*自動scroll到游標處*/
}
- (void)textViewDidChange:(UITextView *)textView {
    [textView scrollRangeToVisible:textView.selectedRange];/*自動scroll到游標處*/
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    [self saveData];
    ONoff=0;
}
-(void)saveData{
    prepareForHistoryDealer
    switch([thisTextbox tag]){
        case 1:{[plistDict setValue:[thisTextbox text] forKey:[NSString stringWithFormat:@"%ld_xfrom",(long)[hitIndex2 row]]];break;}
        case 2:{[plistDict setValue:[thisTextbox text] forKey:[NSString stringWithFormat:@"%ld_xTo",(long)[hitIndex2 row]]];break;}
        case 3:{[plistDict setValue:[thisTextbox text] forKey:[NSString stringWithFormat:@"%ld_yfrom",(long)[hitIndex2 row]]];break;}
        case 4:{[plistDict setValue:[thisTextbox text] forKey:[NSString stringWithFormat:@"%ld_yTo",(long)[hitIndex2 row]]];break;}
        case 5:{[plistDict setValue:[thisTextbox text] forKey:[NSString stringWithFormat:@"%ld_θfrom",(long)[hitIndex2 row]]];break;}
        case 6:{[plistDict setValue:[thisTextbox text] forKey:[NSString stringWithFormat:@"%ld_θTo",(long)[hitIndex2 row]]];break;}
        case 7:{[plistDict setValue:[thisTextbox text] forKey:[NSString stringWithFormat:@"%ld_func",(long)[hitIndex2 row]]];break;}
        case 11:{[plistDict setValue:[thisTextbox text] forKey:[NSString stringWithFormat:@"%ld_conicX",(long)[hitIndex2 row]]];break;}
        case 12:{[plistDict setValue:[thisTextbox text] forKey:[NSString stringWithFormat:@"%ld_conicY",(long)[hitIndex2 row]]];break;}
        case 13:{[plistDict setValue:[thisTextbox text] forKey:[NSString stringWithFormat:@"%ld_conicA",(long)[hitIndex2 row]]];break;}
        case 14:{[plistDict setValue:[thisTextbox text] forKey:[NSString stringWithFormat:@"%ld_conicB",(long)[hitIndex2 row]]];break;}
    }
    [plistDict writeToFile:plistPath atomically:YES];
}
-(UIColor*)RGBAtoUIColor:(NSString*)RBGAcolorString{
    NSScanner *scanner = [NSScanner scannerWithString:RBGAcolorString];
    NSString *junk, *red, *green, *blue, *ALPHA;
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&junk];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet punctuationCharacterSet] intoString:&red];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&junk];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet punctuationCharacterSet] intoString:&green];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&junk];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet punctuationCharacterSet] intoString:&blue];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&junk];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet punctuationCharacterSet] intoString:&ALPHA];
    
    UIColor *UIColorCode = [UIColor colorWithRed:red.floatValue/255.0f green:green.floatValue/255.0f blue:blue.floatValue/255.0f alpha:1.0];
    
    return UIColorCode;
}
    
-(BOOL) shouldAutorotate {return NO;}/*防止轉90度,要允許轉的話直接刪掉或returnYES*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    if(hitIndex2==NULL)hitIndex2 = [NSIndexPath indexPathForRow:0 inSection:0];
    [[[inputTable cellForRowAtIndexPath:hitIndex2] viewWithTag:([thisTextbox tag]==0)?7:[thisTextbox tag]] becomeFirstResponder];
}
- (BOOL)prefersStatusBarHidden/*YES: hide;NO:show*/
    {
        return YES;
/*        if(dishforHTML.frame.origin.y<100)return YES;
        else return NO;
//本頁 xxxx.y=0或18 ; xxxxx.height=加不加18 都是在改這個
*/
}
@end
