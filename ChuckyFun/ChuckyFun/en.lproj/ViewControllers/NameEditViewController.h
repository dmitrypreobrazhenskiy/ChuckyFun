//
//  NameEditViewController.h
//  ChuckyFun
//
//  Created by Dmitry Preobrazhenskiy on 14.05.12.
//  Copyright (c) 2012 TTU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NameEditViewController;
@protocol NameViewControllerDelegate
@required
-(void)nameEditViewController:(NameEditViewController *)sender didEnterFirstName:(NSString *)firstName andLastName:(NSString *)lastName andIsNamePresent:(BOOL)isCustomNamePresent;

@end

@interface NameEditViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *movableView;
@property(nonatomic, weak) id<NameViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIToolbar *topToolbar;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *familyNameTextField;

@end
