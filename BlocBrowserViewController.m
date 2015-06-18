//
//  BlocBrowserViewController.m
//  BlocBrowser
//
//  Created by Mac on 6/11/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "BlocBrowserViewController.h"
#import "AwesomeFloatingToolbar.h"


#define WebBrowserBackString NSLocalizedString(@"Back", @"Back command")
#define WebBrowserForwardString NSLocalizedString(@"Forward", @"Forward command")
#define WebBrowserStopString NSLocalizedString(@"Stop", @"Stop command")
#define WebBrowserRefreshString NSLocalizedString(@"Refresh", @"Reload command")

#pragma mark - Interface
@interface BlocBrowserViewController ()<UIWebViewDelegate, UITextFieldDelegate, AwesomeFloatingToolBarDelegate>

@property (nonatomic,strong) UITextField *webTextField;
@property (nonatomic,strong) UIWebView *webView;
//@property (nonatomic,strong) UIButton *backButton;
//@property (nonatomic,strong) UIButton *forwardButton;
//@property (nonatomic,strong) UIButton *stopButton;
//@property (nonatomic,strong) UIButton *reloadButton;
@property (nonatomic, assign) NSInteger frameCount;
@property (nonatomic,strong)  UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) AwesomeFloatingToolbar *awesomeToolbar;


@end


@implementation BlocBrowserViewController

#pragma mark - UIViewController

- (void) loadView{
    UIView *mainView= [UIView new];
    self.view=mainView;
    
    self.webView = [[UIWebView alloc]init];
    self.webView.delegate = self;
    
    self.webTextField =[[UITextField alloc] init];
    
    self.webTextField.keyboardType=UIKeyboardTypeURL;
    self.webTextField.returnKeyType=UIReturnKeyDone;
    self.webTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    self.webTextField.autocorrectionType=UITextAutocorrectionTypeNo;
    self.webTextField.placeholder=NSLocalizedString(@"URL or Search Query", @"Placeholder text for web browser URL field");
    self.webTextField.backgroundColor=[UIColor colorWithWhite:220/225.0f alpha:1];
    self.webTextField.delegate = self;
    
    /*self.backButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [self.backButton setEnabled:NO];
    
    self.forwardButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [self.backButton setEnabled:NO];
    
    self.stopButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [self.stopButton setEnabled:NO];
    
    self.reloadButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [self.reloadButton setEnabled:NO];*/
    
    self.awesomeToolbar = [[AwesomeFloatingToolbar alloc] initWithFourTitles:@[WebBrowserBackString,WebBrowserForwardString,WebBrowserStopString,WebBrowserRefreshString]];
    self.awesomeToolbar.delegate =self;
    
    /*[self.backButton setTitle:NSLocalizedString(@"Back", @"Back Command") forState:UIControlStateNormal];
    [self.backButton addTarget:self.webView action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.forwardButton setTitle:NSLocalizedString(@"Forward", @"Forward Command") forState:UIControlStateNormal];
    [self.backButton addTarget:self.webView action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    
    [self.stopButton setTitle:NSLocalizedString(@"Stop", @"Stop Command") forState:UIControlStateNormal];
    [self.stopButton addTarget:self.webView action:@selector(stopLoading) forControlEvents:UIControlEventTouchUpInside];
    
    [self.reloadButton setTitle:NSLocalizedString(@"Reload", @"Reload Command") forState:UIControlStateNormal];
    [self.stopButton addTarget:self.webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    
    [self addButtonTargets];*/
    
    /*NSString *urlString =@"http://wikipedia.org";
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];*/
    
    
    
    
    /*[mainView addSubview:self.webView];
    [mainView addSubview:self.webTextField];
    [mainView addSubview:self.backButton];
    [mainView addSubview:self.forwardButton];
    [mainView addSubview:self.stopButton];
    [mainView addSubview:self.reloadButton];*/
    
    for (UIView *viewToAdd in @[self.webView, self.webTextField, self.awesomeToolbar]) {
        [mainView addSubview:viewToAdd];
    }
    
    self.view = mainView;

}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.activityIndicator =[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];

}


-(void) viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    //self.webView.frame=self.view.frame;
    
    static const CGFloat itemHeight =50;
    
    CGFloat width =CGRectGetWidth(self.view.bounds);
    //CGFloat browserHeight = CGRectGetHeight(self.view.bounds)-itemHeight-itemHeight;
    //CGFloat buttonWidth = CGRectGetWidth(self.view.bounds)/4;
    
    CGFloat browserHeight = CGRectGetHeight(self.view.bounds) - itemHeight;
    
    self.webTextField.frame = CGRectMake(0, 0, width, itemHeight);
    self.webView.frame =CGRectMake(0, CGRectGetMaxY(self.webTextField.frame), width, browserHeight);
    
    /*CGFloat currentButtonX = 0;
    for (UIButton *thisButton in @[self.backButton,self.forwardButton,self.stopButton,self.reloadButton]){
        
        thisButton.frame = CGRectMake(currentButtonX, CGRectGetMaxY(self.webView.frame), buttonWidth, itemHeight);
        currentButtonX += buttonWidth;
        
    }*/
    self.awesomeToolbar.frame = CGRectMake(20, 380, 280, 60);
    
}

#pragma mark - UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    NSString *URLString = textField.text;
    NSRange whiteSpaceRange = [URLString rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    NSURL *URL = [NSURL URLWithString:URLString];
    if (!URL.scheme) {
        URL=[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",URLString]];
    }
 
    
    if(URL){
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        [self.webView loadRequest:request];
    }

    
    if (whiteSpaceRange.location != NSNotFound) {
        NSString *newString = [ URLString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        NSString *urlAddress = [NSString stringWithFormat:@"http://www.google.com/search?q=%@",newString];
        NSURL *url = [NSURL URLWithString:urlAddress];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:requestObj];
    }

    

    
    
    return NO;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    //self.isLoading = YES;
    self.frameCount ++;
    [self updateButtonsAndTitle];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //self.isLoading = NO;
    self.frameCount --;
    [self updateButtonsAndTitle];
}




-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (error.code != -999) {
    
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
    [alert show];
    
    }
    self.frameCount --;
    [self updateButtonsAndTitle];
}


#pragma mark - Miscellaneous

- (void) updateButtonsAndTitle {
    NSString *webPageTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    if (webPageTitle){
        self.title = webPageTitle;
    
    }else{
        self.title = self.webView.request.URL.absoluteString;
    }
    
    if (self.frameCount>0) {
        [self.activityIndicator startAnimating];
    } else {
        [self.activityIndicator stopAnimating];
    }
    
    /*self.backButton.enabled = [self.webView canGoBack];
    self.forwardButton.enabled = [self.webView canGoForward];
    self.stopButton.enabled = self.frameCount > 0;
    self.reloadButton.enabled = self.webView.request.URL && self.frameCount == 0;*/
    
    [self.awesomeToolbar setEnabled:[self.webView canGoBack] forButtonWithTitle:WebBrowserBackString];
    [self.awesomeToolbar setEnabled:[self.webView canGoForward] forButtonWithTitle:WebBrowserForwardString];
    [self.awesomeToolbar setEnabled:self.frameCount > 0 forButtonWithTitle:WebBrowserStopString];
    [self.awesomeToolbar setEnabled:self.webView.request.URL && self.frameCount==0 forButtonWithTitle:WebBrowserRefreshString];
}


-(void) resetWebView{
    [self.webView removeFromSuperview];
    UIWebView *newWebView =[[UIWebView alloc] init];
    newWebView.delegate = self;
    [self.view addSubview:newWebView];
    
    self.webTextField.text=nil;
    [self updateButtonsAndTitle];
    
    
    
}


/*-(void) addButtonTargets{
    for (UIButton *button in @[self.backButton, self.forwardButton, self.stopButton, self.reloadButton]){
        [button removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.backButton addTarget:self.webView action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.forwardButton addTarget:self.webView action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    [self.stopButton addTarget:self.webView action:@selector(stopLoading) forControlEvents:UIControlEventTouchUpInside];
    [self.reloadButton addTarget:self.webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    
    
}*/


#pragma mark AwesomeFloatingToolbarDelegate

-(void) floatingToolBar:(AwesomeFloatingToolbar *)toolbar didSelectButtonWithTitle:(NSString *)title{
    if ([title isEqual:WebBrowserBackString]) {
        [self.webView goB   ack];
    } else if ([title isEqual:WebBrowserForwardString]) {
        [self.webView goForward];
    } else if ([title isEqual:WebBrowserStopString]) {
        [self.webView stopLoading];
    } else if ([title isEqual:WebBrowserRefreshString]) {
        [self.webView reload];
    }
}

@end
