//
//  CustomNameView.h
//  ChuckyFun
//
//  Created by Dmitry Preobrazhenskiy on 10.05.12.
//  Copyright (c) 2012 TTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNameView : UIView
@property (weak, nonatomic) IBOutlet UIToolbar *topToolbar;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *familyNameTextField;

@end
