//
//  OfflineViewController.h
//  ChuckyFun
//
//  Created by Dmitry Preobrazhenskiy on 10.05.12.
//  Copyright (c) 2012 TTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfflineViewController : UIViewController
- (IBAction)checkConnectionButtonPressed:(id)sender;
@property(weak, nonatomic) IBOutlet UIButton *checkConnectionButton;
@end
