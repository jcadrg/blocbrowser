//
//  AwesomeFloatingToolbar.h
//  Alcolator
//
//  Created by Mac on 6/17/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AwesomeFloatingToolbar;

@protocol AwesomeFloatingToolBarDelegate <NSObject>

@optional

-(void) floatingToolBar:(AwesomeFloatingToolbar *)toolbar didSelectButtonWithTitle:(NSString *)title;

@end
@interface AwesomeFloatingToolbar : UIView

-(instancetype) initWithFourTitles: (NSArray *)titles;

-(void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title;

@property (nonatomic,weak) id<AwesomeFloatingToolBarDelegate> delegate;


@end
