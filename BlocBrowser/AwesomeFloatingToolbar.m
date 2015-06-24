//
//  AwesomeFloatingToolbar.m
//  BlocBrowser
//
//  Created by Mac on 6/17/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "AwesomeFloatingToolbar.h"

@interface AwesomeFloatingToolbar()

//properties used to store the labels, colors, and titles, and keeping track of what label the user is currently touching

@property (nonatomic,strong) NSArray *currentTitles;
@property (nonatomic,strong) NSMutableArray *colors;
@property (nonatomic,strong) NSArray *labels;
@property (nonatomic,weak) UILabel *currentLabel;
@property (nonatomic,strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic,strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic,strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic,strong) UILongPressGestureRecognizer *longGesture;


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
        
        NSMutableArray *labelsArray =[[NSMutableArray alloc]init];
        
        //make the 4 labels
        for (NSString *currentTitle in self.currentTitles){
            UILabel *label =[[UILabel alloc] init];
            label.userInteractionEnabled = NO;
            label.alpha = 0.25;
            
            NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle];
            NSString *titleForThisLabel =[self.currentTitles objectAtIndex:currentTitleIndex];
            UIColor *colorForThisLabel =[self.colors objectAtIndex:currentTitleIndex];
            
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:10];
            label.text = titleForThisLabel;
            label.backgroundColor = colorForThisLabel;
            label.textColor =[UIColor whiteColor];
            
            [labelsArray addObject:label];
            
        }
        
        self.labels =labelsArray;
        
        for (UILabel *thisLabel in self.labels){
            [self addSubview:thisLabel];
        }
        self.tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
        [self addGestureRecognizer:self.tapGesture];
        
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
    //set the frames for all labels in a 2x2 grid
    
    for (UILabel *thisLabel in self.labels){
        NSUInteger currentLabelIndex = [self.labels indexOfObject:thisLabel];
        
        CGFloat labelHeight = CGRectGetHeight(self.bounds)/2;
        CGFloat labelWidth = CGRectGetWidth(self.bounds)/2;
        CGFloat labelX= 0;
        CGFloat labelY=0;
        
        //adjust labelX and labelY for each label
        if(currentLabelIndex <2){
            //0 or 1, so on top
            labelY =0;
            
        }else{
            //2 or 3, so on botton
            labelY = CGRectGetHeight(self.bounds)/2;
        }
        if (currentLabelIndex % 2 ==0){
            labelX = 0;
        }else{
            labelX = CGRectGetWidth(self.bounds) /2;
        }
        
        thisLabel.frame =CGRectMake(labelX,labelY , labelWidth, labelHeight);
    }
    
    
}
# pragma mark touch-handling

-(UILabel *) labelFromTouches:(NSSet *) touches withEvent:(UIEvent *) event {
    UITouch *touch =[touches anyObject];
    CGPoint location =[touch locationInView:self];
    UIView *subview = [self hitTest:location withEvent:event];
    return (UILabel *)subview;
}

/*-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UILabel *label =[ self labelFromTouches:touches withEvent:event];
    
    self.currentLabel = label;
    self.currentLabel.alpha = 0.5;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UILabel *label =[self labelFromTouches:touches withEvent:event];
    
    if (self.currentLabel !=label) {
        //the label being touched is no longer the original label
        self.currentLabel.alpha=1;
    }else{
        //the label touched is the initial label
        self.currentLabel.alpha=0.5;
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UILabel *label =[self labelFromTouches:touches withEvent:event];
    
    if (self.currentLabel==label) {
        
        NSLog(@"Label tapped: %@",self.currentLabel.text);
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
            [self.delegate floatingToolbar:self didSelectButtonWithTitle:self.currentLabel.text];
        }
    }
    
    self.currentLabel.alpha=1;
    self.currentLabel =nil;
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    self.currentLabel.alpha=1;
    self.currentLabel=nil;
}
*/
#pragma mark button enabled

-(void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title{
    
    NSUInteger index =[self.currentTitles indexOfObject:title];
    
    if (index !=NSNotFound) {
        UILabel *label =[self.labels objectAtIndex:index];
        label.userInteractionEnabled=enabled;
        label.alpha=enabled ? 1.0 :0.25;
    }
}

-(void) tapFired:(UITapGestureRecognizer *) recognizer{
    
    if(recognizer.state == UIGestureRecognizerStateRecognized){
        CGPoint location = [recognizer locationInView:self];
        UIView * tappedView = [self hitTest:location withEvent:nil];
        
        if ([self.labels containsObject:tappedView]) {
            
            if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
                
                [self.delegate floatingToolbar:self didSelectButtonWithTitle:((UILabel *)tappedView).text];
            } else {
                assert(0);
            }
        }
    }
}

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
        for (UILabel *thisLabel in self.labels) {
            NSUInteger currentLabelIndex =[self.labels indexOfObject:thisLabel];
            UIColor *labelColor = [self.colors objectAtIndex:currentLabelIndex];
            thisLabel.backgroundColor = labelColor;
        }

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
