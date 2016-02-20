#import "infoViewController.h"
#define iPhone5series (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)568)<DBL_EPSILON)
#define iOS_from(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
@interface infoViewController ()
@end

@implementation infoViewController

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
    NSString *englishINFO=@"Hi! My name is Che-ming Ku and I am from Taiwan(台灣). I am currently a graduate student in Stanford University with a major in Robotics. This is my first App and will be free forever. I made this app because studying here has made me tired and confused about the meaning of an academic career. While I recently found a way to make myself sleep well! That is, to make some products which are good to people. If you find a bug or have any idea, please tell me and I also hope that we can be friends:                           cmku@stanford.edu ";
    NSString *englishINFO2=@"Jan 10, 2014";
    
    if(iPhone5series  && iOS_from(@"7.0")){
        UITextView *infoTextView=[[UITextView alloc] initWithFrame:CGRectMake(20, 60, 280,355)];
        infoTextView.text=englishINFO;
        [infoTextView setFont:[UIFont fontWithName:@"Optima-Regular" size:17.0f]];
        infoTextView.textAlignment = NSTextAlignmentCenter;
        infoTextView.userInteractionEnabled = NO;
        [self.view addSubview:infoTextView];
        
        NSString *embedHTML =[NSString stringWithFormat:@"\
                              <html><head>\
                              <style type=\"text/css\">\
                              </style>\
                              </head><body style=\"margin:0\">\
                              <iframe width=\"84\" height=\"70\" src=\"https://player.vimeo.com/video/87643751\" frameborder=\"0\"></iframe>\
                              </body></html>"];
        UIWebView *videoView = [[UIWebView alloc] initWithFrame:CGRectMake(118,440, 84,70)];
        videoView.backgroundColor = [UIColor clearColor];
        [videoView loadHTMLString:embedHTML baseURL:nil];
        [self.view addSubview:videoView];
        
        UIButton *xxButton=[[UIButton alloc] initWithFrame:CGRectMake(275, 525, 50, 50)];
        [xxButton setTitle:@"✘" forState:UIControlStateNormal];
        [xxButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        xxButton.titleLabel.font = [UIFont systemFontOfSize: 40];
        [xxButton addTarget:self action:@selector(backToCalculatorButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:xxButton];
        
        UITextView *infoTextView2=[[UITextView alloc] initWithFrame:CGRectMake(125, 393.5, 70,19)];
        infoTextView2.text=englishINFO2;
        [infoTextView2 setFont:[UIFont fontWithName:@"Optima-Regular" size:8.0f]];
        infoTextView2.textAlignment = NSTextAlignmentCenter;
        infoTextView2.userInteractionEnabled = NO;
        [self.view addSubview:infoTextView2];

    }else if(iOS_from(@"7.0")){//給iPhone4S以下
        UITextView *infoTextView=[[UITextView alloc] initWithFrame:CGRectMake(20, 30, 280,355)];
        infoTextView.text=englishINFO;
        [infoTextView setFont:[UIFont fontWithName:@"Optima-Regular" size:17.0f]];
        infoTextView.textAlignment = NSTextAlignmentCenter;
        infoTextView.userInteractionEnabled = NO;
        [self.view addSubview:infoTextView];
        
        NSString *embedHTML =[NSString stringWithFormat:@"\
                              <html><head>\
                              <style type=\"text/css\">\
                              </style>\
                              </head><body style=\"margin:0\">\
                              <iframe width=\"84\" height=\"60\" src=\"https://player.vimeo.com/video/87928830\" frameborder=\"0\"></iframe>\
                              </body></html>"];
        UIWebView *videoView = [[UIWebView alloc] initWithFrame:CGRectMake(118,400, 84,60)];
        videoView.backgroundColor = [UIColor clearColor];
        [videoView loadHTMLString:embedHTML baseURL:nil];
        [self.view addSubview:videoView];
        
        UIButton *xxButton=[[UIButton alloc] initWithFrame:CGRectMake(275, 435, 50, 50)];
        [xxButton setTitle:@"✘" forState:UIControlStateNormal];
        [xxButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        xxButton.titleLabel.font = [UIFont systemFontOfSize: 40];
        [xxButton addTarget:self action:@selector(backToCalculatorButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:xxButton];
        
        UITextView *infoTextView2=[[UITextView alloc] initWithFrame:CGRectMake(125, 363.5, 70,19)];
        infoTextView2.text=englishINFO2;
        [infoTextView2 setFont:[UIFont fontWithName:@"Optima-Regular" size:8.0f]];
        infoTextView2.textAlignment = NSTextAlignmentCenter;
        infoTextView2.userInteractionEnabled = NO;
        [self.view addSubview:infoTextView2];
    }
}
-(void)backToCalculatorButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL) shouldAutorotate {return NO;}/*防止轉90度,要允許轉的話直接刪掉或returnYES*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)prefersStatusBarHidden/*YES: hide;NO:show*/
{
    return YES;
    
}
@end
