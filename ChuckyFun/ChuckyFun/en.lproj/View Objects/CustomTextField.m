//
//  CustomTextField.m
//  Saloninfra
//
//  Created by Dmitry Preobrazhenskiy on 03.04.12.
//  Copyright (c) 2012 TTU. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField


-(CGRect)placeholderRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y , bounds.size.width, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y , bounds.size.width, bounds.size.height);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y , bounds.size.width, bounds.size.height);
}

@end
