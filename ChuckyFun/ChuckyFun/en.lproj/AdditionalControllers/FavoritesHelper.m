//
//  JokesHelper.h
//  ChuckyFun
//
//  Created by Dmitry Preobrazhenskiy on 04.05.12.
//  Copyright (c) 2012 TTU. All rights reserved.
//
//

#import "FavoritesHelper.h"

@implementation FavoritesHelper
@synthesize plistPath = _plistPath;
@synthesize rootPath = _rootPath;
@synthesize jokesArray = _jokesArray;

- (id)init {
    self = [super init];
    if (self) {
        NSString *plistPath;
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        plistPath = [rootPath stringByAppendingPathComponent:@"Jokes.plist"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:plistPath]) {
            NSError *error;
            NSString *bundle = [[NSBundle mainBundle] pathForResource:@"Jokes" ofType:@"plist"];
            [fileManager copyItemAtPath:bundle toPath:plistPath error:&error];
        }
        
        self.plistPath = plistPath;
        self.rootPath = rootPath;
        
        
    }
    return self;
}

- (void)addToFavorites:(NSMutableDictionary *)jokesDictionary {
    NSMutableArray *plistArray = [[NSMutableArray alloc] initWithContentsOfFile:self.plistPath];
    if ([plistArray count] > 0) {
        self.jokesArray = [[NSMutableArray alloc] initWithArray:plistArray];
    }
    else {
        self.jokesArray = [[NSMutableArray alloc] init];
    }
    
    
    if ([plistArray containsObject:jokesDictionary]) {
        return;
    }
    else {
        [self.jokesArray addObject:jokesDictionary];
        [self.jokesArray writeToFile:self.plistPath atomically:YES];
    }
}

- (void)removeFromFavorites:(NSMutableDictionary *)jokesDictionary {
    NSMutableArray *plistArray = [[NSMutableArray alloc] initWithContentsOfFile:self.plistPath];
    if ([plistArray count] > 0) {
        self.jokesArray = [[NSMutableArray alloc] initWithArray:plistArray];
    }
    else {
        self.jokesArray = [[NSMutableArray alloc] init];
    }
    if ([self.jokesArray containsObject:jokesDictionary]) {
        [self.jokesArray removeObject:jokesDictionary];
        [self.jokesArray writeToFile:self.plistPath atomically:YES];
    }
    else return;
}


@end
