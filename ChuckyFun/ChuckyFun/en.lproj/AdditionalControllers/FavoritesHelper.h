//
//  FavoritesCell.h
//  ChuckyFun
//
//  Created by Dmitry Preobrazhenskiy on 10.05.12.
//  Copyright (c) 2012 TTU. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface FavoritesHelper : NSObject
@property(nonatomic, strong) NSString *plistPath;
@property(nonatomic, strong) NSString *rootPath;
@property(nonatomic, strong) NSMutableArray *jokesArray;

- (void)addToFavorites:(NSDictionary *)jokesDictionary;

- (void)removeFromFavorites:(NSDictionary *)jokesDictionary;
@end
