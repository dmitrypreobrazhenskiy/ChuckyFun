//
//  JokesHelper.m
//  ChuckyFun
//
//  Created by Dmitry Preobrazhenskiy on 10.05.12.
//  Copyright (c) 2012 TTU. All rights reserved.
//

#import "JokesHelper.h"
#import "JSONKit.h"

@interface JokesHelper () <NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSURLConnectionDataDelegate> {
    
}
@property(nonatomic) BOOL isConnecting;
@property(nonatomic, strong) NSMutableDictionary *currentJokesDictionary;
@end

@implementation JokesHelper
@synthesize isConnecting = _isConnecting;
@synthesize plistPath = _plistPath;
@synthesize rootPath = _rootPath;
@synthesize currentJokesDictionary = _currentJokesDictionary;

- (id)init {
    self = [super init];
    if (self) {
        NSString *plistPath;
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        plistPath = [rootPath stringByAppendingPathComponent:@"Jokes.plist"];
        self.plistPath = plistPath;
        self.rootPath = rootPath;
        
    }
    return self;
}

-(void)initiateJokesDownload {
    self.currentJokesDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:self.plistPath];
    NSMutableString *connectionString =[NSMutableString stringWithString:@"http://api.icndb.com/jokes/random/10"];
    NSURL *connectionURL = [NSURL URLWithString:connectionString];
    NSMutableURLRequest *connectionRequest = [[NSMutableURLRequest alloc] initWithURL:connectionURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    NSURLResponse *response;
    NSError *error;
    NSData *returnData = [ NSURLConnection sendSynchronousRequest: connectionRequest returningResponse:&response error:&error];
    if (returnData != nil) {
        //NSString *content = [NSString stringWithUTF8String:[returnData bytes]];
        //NSLog(@"responseData: %@", content);
        NSDictionary *resultsDictionary = [returnData objectFromJSONData];
        //NSLog(@"result dictionary is %@", resultsDictionary);
        NSMutableArray *newJokesArray = [[NSMutableArray alloc] init];
        NSMutableArray *resultArray = [resultsDictionary objectForKey:@"value"];
        
        if (self.currentJokesDictionary != nil) {
            NSMutableArray *currentJokesArray = [self.currentJokesDictionary objectForKey:@"value"];
            if (currentJokesArray != nil) {
                for (NSDictionary *newDictionary in resultArray) {
                    if (![currentJokesArray containsObject:newDictionary]) {
                        [newJokesArray addObject:newDictionary];
                    }
                    else {
                        NSLog(@"%@", newDictionary);
                    }
                }
                if ([newJokesArray count] > 0 ) {
                    if (self.currentJokesDictionary != nil) {
                        NSMutableArray *currentJokesArray = [self.currentJokesDictionary objectForKey:@"value"];
                        [currentJokesArray addObjectsFromArray:newJokesArray];
                        [self.currentJokesDictionary writeToFile:self.plistPath atomically:NO];
                    }
                    else {
                        [self.currentJokesDictionary writeToFile:self.plistPath atomically:NO];
                    }
                    
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"JokesParsed" object:nil]; 
            }
            else {
                [resultsDictionary writeToFile:self.plistPath atomically:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"JokesParsed" object:nil]; 
            }
        }
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"JokesParsingFailed" object:nil];
    }
}

-(void)initiateJokesDownloadWithPersonName:(NSString *)personName andPersonFamilyName:(NSString *)personFamilyName {
    NSMutableString *connectionString =[NSMutableString stringWithString:@"http://api.icndb.com/jokes/random/10?firstName="];
    [connectionString appendString:personName];
    [connectionString appendString:@"&lastName="];
    [connectionString appendString:personFamilyName];
    NSURL *connectionURL = [NSURL URLWithString:connectionString];
    NSMutableURLRequest *connectionRequest = [[NSMutableURLRequest alloc] initWithURL:connectionURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    NSURLResponse *response;
    NSError *error;
    NSData *returnData = [ NSURLConnection sendSynchronousRequest: connectionRequest returningResponse:&response error:&error];
    if (returnData != nil) {
        NSString *content = [NSString stringWithUTF8String:[returnData bytes]];
        NSLog(@"responseData: %@", content);
        NSDictionary *resultsDictionary = [returnData objectFromJSONData];
        NSLog(@"result dictionary is %@", resultsDictionary);
        [resultsDictionary writeToFile:self.plistPath atomically:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"JokesParsed" object:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"JokesParsingFailed" object:nil];
    }
    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //TODO check why the connection didFailWithError
    NSString *acceptString = NSLocalizedString(@"AcceptButtonTitle", @"The ok button title");
    NSString *errorMessage = NSLocalizedString(@"ConnectionError", @"the connection error button title");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:errorMessage delegate:self cancelButtonTitle:acceptString otherButtonTitles:nil];
    [alertView show];
}

@end


