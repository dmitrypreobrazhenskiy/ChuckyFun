//
//  JokesHelper.m
//  ChuckyFun
//
//  Created by Dmitry Preobrazhenskiy on 10.05.12.
//  Copyright (c) 2012 TTU. All rights reserved.
//

#import "JokesHelper.h"
#import "JSONKit.h"

@interface JokesHelper () <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    
}
@property(nonatomic) BOOL isConnecting;
@end

@implementation JokesHelper
@synthesize isConnecting = _isConnecting;
@synthesize plistPath = _plistPath;
@synthesize rootPath = _rootPath;

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
        NSMutableString *connectionString =[NSMutableString stringWithString:@"http://api.icndb.com/jokes/random/10"];
        NSURL *connectionURL = [NSURL URLWithString:connectionString];
        NSMutableURLRequest *connectionRequest = [[NSMutableURLRequest alloc] initWithURL:connectionURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
        NSURLResponse *response;
        NSError *error;
        NSData *returnData = [ NSURLConnection sendSynchronousRequest: connectionRequest returningResponse:&response error:&error];
        NSString *content = [NSString stringWithUTF8String:[returnData bytes]];
        NSLog(@"responseData: %@", content);
        NSDictionary *resultsDictionary = [returnData objectFromJSONData];
        NSLog(@"result dictionary is %@", resultsDictionary);
        [resultsDictionary writeToFile:self.plistPath atomically:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"JokesParsed" object:nil];
       
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
    NSString *content = [NSString stringWithUTF8String:[returnData bytes]];
    NSLog(@"responseData: %@", content);
    NSDictionary *resultsDictionary = [returnData objectFromJSONData];
    NSLog(@"result dictionary is %@", resultsDictionary);
    [resultsDictionary writeToFile:self.plistPath atomically:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JokesParsed" object:nil];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //TODO check why the connection didFailWithError
    NSString *acceptString = NSLocalizedString(@"AcceptButtonTitle", @"The ok button title");
    NSString *errorMessage = NSLocalizedString(@"ConnectionError", @"the connection error button title");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:errorMessage delegate:self cancelButtonTitle:acceptString otherButtonTitles:nil];
    [alertView show];
}

@end


