//
//  FavoritesCell.h
//  ChuckyFun
//
//  Created by Dmitry Preobrazhenskiy on 10.05.12.
//  Copyright (c) 2012 TTU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpinnerObject : NSObject
-(void)addAndStartSpinnerForViewController:(UIViewController *)sender;
-(void)stopAndRemoveSpinnerForViewController:(UIViewController *)sender;
@end
