//
//  CustomNameView.h
//  ChuckyFun
//
//  Created by Dmitry Preobrazhenskiy on 10.05.12.
//  Copyright (c) 2012 TTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
@interface CustomNameView : UIView
@property (weak, nonatomic) IBOutlet UIToolbar *topToolbar;

@property (weak, nonatomic) IBOutlet CustomTextField *nameTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *familyNameTextField;

@end
