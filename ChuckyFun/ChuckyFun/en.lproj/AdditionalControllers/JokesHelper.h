//
//  JokesHelper.h
//  ChuckyFun
//
//  Created by Dmitry Preobrazhenskiy on 10.05.12.
//  Copyright (c) 2012 TTU. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JokesHelper : NSObject
@property(nonatomic, strong) NSString *rootPath;
@property(nonatomic, strong) NSString *plistPath;
-(void)initiateJokesDownload;


-(void)initiateJokesDownloadWithPersonName:(NSString *)personName andPersonFamilyName:(NSString *)personFamilyName;
@end
