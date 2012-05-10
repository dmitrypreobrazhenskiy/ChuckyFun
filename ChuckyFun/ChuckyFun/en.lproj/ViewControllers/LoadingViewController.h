//
//  LoadingViewController.h
//  ChuckyFun
//
//  Created by Dmitry Preobrazhenskiy on 10.05.12.
//  Copyright (c) 2012 TTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;

@end
