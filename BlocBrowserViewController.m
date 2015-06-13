//
//  BlocBrowserViewController.m
//  BlocBrowser
//
//  Created by Mac on 6/11/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "BlocBrowserViewController.h"

#pragma mark - Interface
@interface BlocBrowserViewController ()<UIWebViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITextField *webTextField;
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UIButton *forwardButton;
@property (nonatomic,strong) UIButton *stopButton;
@property (nonatomic,strong) UIButton *reloadButton;
@property (nonatomic, assign) NSInteger frameCount;
@property (nonatomic,strong)  UIActivityIndicatorView *activityIndicator;


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
    
    self.backButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [self.backButton setEnabled:NO];
    
    self.forwardButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [self.backButton setEnabled:NO];
    
    self.stopButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [self.stopButton setEnabled:NO];
    
    self.reloadButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [self.reloadButton setEnabled:NO];
    
    [self.backButton setTitle:NSLocalizedString(@"Back", @"Back Command") forState:UIControlStateNormal];
    [self.backButton addTarget:self.webView action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.forwardButton setTitle:NSLocalizedString(@"Forward", @"Forward Command") forState:UIControlStateNormal];
    [self.backButton addTarget:self.webView action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    
    [self.stopButton setTitle:NSLocalizedString(@"Stop", @"Stop Command") forState:UIControlStateNormal];
    [self.stopButton addTarget:self.webView action:@selector(stopLoading) forControlEvents:UIControlEventTouchUpInside];
    
    [self.reloadButton setTitle:NSLocalizedString(@"Reload", @"Reload Command") forState:UIControlStateNormal];
    [self.stopButton addTarget:self.webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    
    /*NSString *urlString =@"http://wikipedia.org";
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];*/
    
    
    
    
    [mainView addSubview:self.webView];
    [mainView addSubview:self.webTextField];
    [mainView addSubview:self.backButton];
    [mainView addSubview:self.forwardButton];
    [mainView addSubview:self.stopButton];
    [mainView addSubview:self.reloadButton];
    
    

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
    CGFloat browserHeight = CGRectGetHeight(self.view.bounds)-itemHeight-itemHeight;
    CGFloat buttonWidth = CGRectGetWidth(self.view.bounds)/4;
    
    self.webTextField.frame = CGRectMake(0, 0, width, itemHeight);
    self.webView.frame =CGRectMake(0, CGRectGetMaxY(self.webTextField.frame), width, browserHeight);
    
    CGFloat currentButtonX = 0;
    for (UIButton *thisButton in @[self.backButton,self.forwardButton,self.stopButton,self.reloadButton]){
        
        thisButton.frame = CGRectMake(currentButtonX, CGRectGetMaxY(self.webView.frame), buttonWidth, itemHeight);
        currentButtonX += buttonWidth;
        
    }
    
    
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
    
    self.backButton.enabled = [self.webView canGoBack];
    self.forwardButton.enabled = [self.webView canGoForward];
    self.stopButton.enabled = self.frameCount > 0;
    self.reloadButton.enabled = !self.frameCount ==0;
}

@end
