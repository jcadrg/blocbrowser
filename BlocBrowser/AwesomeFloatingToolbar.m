//
//  AwesomeFloatingToolbar.m
//  BlocBrowser
//
//  Created by Mac on 6/17/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "AwesomeFloatingToolbar.h"

@interface AwesomeFloatingToolbar()

//properties used to store the buttons, colors, and titles, and keeping track of what button the user is currently touching

@property (nonatomic,strong) NSArray *currentTitles;
@property (nonatomic,strong) NSMutableArray *colors;
@property (nonatomic,strong) NSArray *buttons;
//@property (nonatomic,weak) UIbutton *currentbutton;
@property (nonatomic,strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic,strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic,strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic,strong) UILongPressGestureRecognizer *longGesture;
@property (nonatomic,weak) UIButton *currentButton;


@end

@implementation AwesomeFloatingToolbar

-(instancetype) initWithFourTitles:(NSArray *)titles{
    //call the superclass (UIVIEW) initializer
    self = [super init];
    
    if (self){
        //save titles and colors
        self.currentTitles=titles;
        self.colors =[@[[UIColor colorWithRed:199/255.0 green:158/255.0 blue:203/255.0 alpha:1],
                       [UIColor colorWithRed:255/255.0 green:105/255.0 blue:97/255.0 alpha:1 ],
                       [UIColor colorWithRed:222/255.0 green:165/255.0 blue:164/255.0 alpha:1],
                       [UIColor colorWithRed: 255/255.0 green:179/255.0 blue:71/255.0 alpha:1]]mutableCopy];
        
        NSMutableArray *buttonsArray =[[NSMutableArray alloc] init];
        
        //make the 4 buttons
        for (NSString *currentTitle in self.currentTitles){
            UIButton *button =[[UIButton alloc] init];
            button.userInteractionEnabled = NO;
            button.alpha = 0.25;
            
            NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle];
            NSString *titleForThisbutton =[self.currentTitles objectAtIndex:currentTitleIndex];
            UIColor *colorForThisbutton =[self.colors objectAtIndex:currentTitleIndex];
            
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.titleLabel.font = [UIFont systemFontOfSize:10];
            [button setTitle:titleForThisbutton forState:UIControlStateNormal];
            button.backgroundColor = colorForThisbutton;
            button.titleLabel.textColor =[UIColor whiteColor];
            
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            [buttonsArray addObject:button];
            
            
            
        }
        
        self.buttons =buttonsArray;
        
        for (UIButton *thisButton in self.buttons){
            [self addSubview:thisButton];
        }
        /*self.tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
        [self addGestureRecognizer:self.tapGesture];*/
        
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFired:)];
        [self addGestureRecognizer:self.panGesture];
        
        self.pinchGesture =[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchFired:)];
        [self addGestureRecognizer:self.pinchGesture];
        
        self.longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapFired:)];
        [self addGestureRecognizer:self.longGesture];
        
    }
    return self;
}

-(void) layoutSubviews{
    //set the frames for all buttons in a 2x2 grid
    
    for (UIButton *thisButton in self.buttons){
        NSUInteger currentButtonIndex = [self.buttons indexOfObject:thisButton];
        
        CGFloat buttonHeight = CGRectGetHeight(self.bounds)/2;
        CGFloat buttonWidth = CGRectGetWidth(self.bounds)/2;
        CGFloat buttonX= 0;
        CGFloat buttonY=0;
        
        //adjust buttonX and buttonY for each button
        if(currentButtonIndex <2){
            //0 or 1, so on top
            buttonY =0;
            
        }else{
            //2 or 3, so on botton
            buttonY = CGRectGetHeight(self.bounds)/2;
        }
        if (currentButtonIndex % 2 ==0){
            buttonX = 0;
        }else{
            buttonX = CGRectGetWidth(self.bounds) /2;
        }
        
        thisButton.frame =CGRectMake(buttonX,buttonY , buttonWidth, buttonHeight);
    }
    
    
}
# pragma mark touch-handling

-(UIButton *) buttonFromTouches:(NSSet *) touches withEvent:(UIEvent *) event {
    UITouch *touch =[touches anyObject];
    CGPoint location =[touch locationInView:self];
    UIView *subview = [self hitTest:location withEvent:event];
    return (UIButton *)subview;
}

/*-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UIbutton *button =[ self buttonFromTouches:touches withEvent:event];
    
    self.currentbutton = button;
    self.currentbutton.alpha = 0.5;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UIbutton *button =[self buttonFromTouches:touches withEvent:event];
    
    if (self.currentbutton !=button) {
        //the button being touched is no longer the original button
        self.currentbutton.alpha=1;
    }else{
        //the button touched is the initial button
        self.currentbutton.alpha=0.5;
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UIbutton *button =[self buttonFromTouches:touches withEvent:event];
    
    if (self.currentbutton==button) {
        
        NSLog(@"button tapped: %@",self.currentbutton.text);
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
            [self.delegate floatingToolbar:self didSelectButtonWithTitle:self.currentbutton.text];
        }
    }
    
    self.currentbutton.alpha=1;
    self.currentbutton =nil;
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    self.currentbutton.alpha=1;
    self.currentbutton=nil;
}
*/
#pragma mark button enabled

-(void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title{
    
    NSUInteger index =[self.currentTitles indexOfObject:title];
    
    if (index !=NSNotFound) {
        UIButton *button =[self.buttons objectAtIndex:index];
        button.userInteractionEnabled=enabled;
        button.alpha=enabled ? 1.0 :0.25;
    }
}

/*-(void) tapFired:(UITapGestureRecognizer *) recognizer{
    
    if(recognizer.state == UIGestureRecognizerStateRecognized){
        CGPoint location = [recognizer locationInView:self];
        UIView * tappedView = [self hitTest:location withEvent:nil];
        
        if ([self.buttons containsObject:tappedView]) {
            
            if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
                
                [self.delegate floatingToolbar:self didSelectButtonWithTitle:((UIbutton *)tappedView).text];
            } else {
                assert(0);
            }
        }
    }
}*/

- (void) panFired:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        
        NSLog(@"New translation: %@", NSStringFromCGPoint(translation));
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPanWithOffset:)]) {
            [self.delegate floatingToolbar:self didTryToPanWithOffset:translation];
        }
        
        [recognizer setTranslation:CGPointZero inView:self];
    }
}

-(void) pinchFired:(UIPinchGestureRecognizer *) recognizer{
    if(recognizer.state ==UIGestureRecognizerStateChanged /*||recognizer.state==UIGestureRecognizerStateBegan*/){
    
        CGFloat newScale = recognizer.scale;
        
        NSLog(@"New scale is; %f",newScale);
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToZoomWithScale:)]) {
            [self.delegate floatingToolbar:self didTryToZoomWithScale:newScale];
        }
        
        NSLog(@"New size is; %@",NSStringFromCGSize(self.frame.size));

        [recognizer setScale:1.0];
    }
}

-(void) longTapFired:(UILongPressGestureRecognizer *) recognizer{
    if(recognizer.state == UIGestureRecognizerStateBegan){
        NSLog(@"Long press detected");
        
        for (NSUInteger i=0; i<[self.colors count]; i++) {
            NSObject *element =[self.colors lastObject];
            
            if(i < 2){
                [self.colors insertObject:element atIndex:i+1];
                [self.colors removeLastObject];
            
            }else if ( i == 2){
                [self.colors insertObject:element atIndex:i];
                [self.colors removeLastObject];
            
            }else if (i == 3){
                [self.colors insertObject:element atIndex:0];
                [self.colors removeLastObject];
            }

        }
        for (UIButton *thisButton in self.buttons) {
            NSUInteger currentButtonIndex =[self.buttons indexOfObject:thisButton];
            UIColor *buttonColor = [self.colors objectAtIndex:currentButtonIndex];
            thisButton.backgroundColor = buttonColor;
        }

    }
}

- (IBAction)buttonPressed:(id)sender {
    NSLog(@"Button %@ pressed",[(UIButton*)sender titleLabel].text);
    
    if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
        
        [self.delegate floatingToolbar:self didSelectButtonWithTitle:[(UIButton*)sender titleLabel].text];
    } else {
        assert(0);
    }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
