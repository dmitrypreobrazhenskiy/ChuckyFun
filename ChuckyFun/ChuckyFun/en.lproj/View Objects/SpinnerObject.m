//
//  FavoritesCell.h
//  ChuckyFun
//
//  Created by Dmitry Preobrazhenskiy on 10.05.12.
//  Copyright (c) 2012 TTU. All rights reserved.
//

#import "SpinnerObject.h"

@interface SpinnerObject () {
    
}
@property(nonatomic, weak) UIAlertView *spinnerAlertView;
@property(nonatomic, weak) UIActivityIndicatorView *spinnerIndicatorView;
@end

@implementation SpinnerObject
@synthesize spinnerAlertView = _spinnerAlertView;
@synthesize spinnerIndicatorView = _spinnerIndicatorView;


-(void)addAndStartSpinnerForViewController:(UIViewController *)sender {
    UIAlertView *spinningAlertView = [[UIAlertView alloc] initWithFrame:CGRectMake((sender.view.bounds.size.width - 100)/ 2, (sender.view.bounds.size.height - 100) / 2, 100, 100)];
    spinningAlertView.backgroundColor = [UIColor blackColor];
    spinningAlertView.alpha = 0;
    self.spinnerAlertView = spinningAlertView;
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect currentActivityView = activityView.frame;
    CGRect newActivityFrame = CGRectMake((spinningAlertView.frame.size.width - currentActivityView.size.width)/2, (spinningAlertView.frame.size.height -currentActivityView.size.height)/2, currentActivityView.size.width, currentActivityView.size.height);
    activityView.frame = newActivityFrame;
    UIColor *indicatorColor = [UIColor colorWithRed:245.0f/255.0f green:12.0f/255.0f blue:0.0f/255.0f alpha:1];
    activityView.color = indicatorColor;
    self.spinnerIndicatorView = activityView;
    [self.spinnerAlertView addSubview:self.spinnerIndicatorView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [self.spinnerIndicatorView startAnimating];
    [sender.view addSubview:self.spinnerAlertView];
    spinningAlertView.alpha = 0.8;
    activityView.alpha = 1;
    [UIView commitAnimations];
}
-(void)stopAndRemoveSpinnerForViewController:(UIViewController *)sender {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [self.spinnerIndicatorView stopAnimating];
    self.spinnerAlertView.alpha = 0;
    self.spinnerIndicatorView.alpha = 0;
    [self.spinnerAlertView removeFromSuperview];
    [UIView commitAnimations];
}

@end
