//
//  FavoritesHelper.h
//  Saloninfra
//
//  Created by Dmitry Preobrazhenskiy on 04.05.12.
//  Copyright (c) 2012 TTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DictionaryDefines.h"

@interface FavoritesHelper : NSObject
@property(nonatomic, strong) NSString *plistPath;
@property(nonatomic, strong) NSString *rootPath;
@property(nonatomic, strong) NSMutableArray *jokesArray;

- (void)addToFavorites:(NSMutableDictionary *)jokesDictionary;

- (void)removeFromFavorites:(NSMutableDictionary *)jokesDictionary;
@end
