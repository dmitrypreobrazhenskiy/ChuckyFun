//
//  LoadingViewControllerViewController.m
//  ChuckyFun
//
//  Created by Dmitry Preobrazhenskiy on 10.05.12.
//  Copyright (c) 2012 TTU. All rights reserved.
//

#import "LoadingViewController.h"
#import "Reachability.h"
#import "CustomTabBarController.h"
#import "JokesHelper.h"



@interface LoadingViewController () <UIAlertViewDelegate> {
    JokesHelper *jokesHelper;
    Reachability *internetReachability;
    Reachability *hostReachability;
    BOOL isInternetActive;
    BOOL isHostReachable;
}

@property(nonatomic, strong) JokesHelper *jokersHelper;
@property(nonatomic, strong) Reachability *internetReachability;
@property(nonatomic, strong) Reachability *hostReachability;
@property(nonatomic) BOOL isInternetActive;
@property(nonatomic) BOOL isHostReachable;

@end

@implementation LoadingViewController
@synthesize loadingActivityIndicator = _loadingActivityIndicator;
@synthesize loadingLabel = _loadingLabel;
@synthesize jokersHelper = _jokersHelper;


//Reachability
@synthesize internetReachability = _internetReachability;
@synthesize hostReachability = _hostReachability;
@synthesize isInternetActive = _isInternetActive;
@synthesize isHostReachable = _isHostReachable;

#pragma mark - Methods

-(void)procceesWithOfflineScreen:(NSNotification *)notification {
    if ([notification.name isEqualToString:@"JokesParsingFailed"]) {
        NSString *acceptString = NSLocalizedString(@"AcceptButtonTitle", @"The ok button title");
        NSString *errorMessage = NSLocalizedString(@"ConnectionError", @"the connection error button title");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:errorMessage delegate:self cancelButtonTitle:acceptString otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)procceesWithMainScreen:(NSNotification *)notification {
    if ([notification.name isEqualToString:@"JokesParsed"]) {
        [self showTabBar];
    }
}

-(void)showTabBar {
    [self.loadingActivityIndicator stopAnimating];
    [self.loadingActivityIndicator setHidden:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    CustomTabBarController *customTabBarController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"CustomTabBarController"];
    customTabBarController.modalPresentationStyle = UIModalPresentationFormSheet;
    customTabBarController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [customTabBarController setSelectedIndex:0];
    [self presentViewController:customTabBarController animated:YES completion:^{}];
}

- (void)checkNetworkStatus:(NSNotification *)notification {
    {
        // called after network status changes
        NetworkStatus internetStatus = [self.internetReachability currentReachabilityStatus];
        switch (internetStatus) {
            case NotReachable:
            {
                NSLog(@"The internet is down.");
                self.isInternetActive = NO;
                
                break;
            }
            case ReachableViaWiFi:
            {
                NSLog(@"The internet is working via WIFI.");
                self.isInternetActive = YES;
                
                break;
            }
            case ReachableViaWWAN:
            {
                NSLog(@"The internet is working via WWAN.");
                self.isInternetActive = YES;
                
                break;
            }
        }
        NetworkStatus hostStatus = [self.hostReachability currentReachabilityStatus];
        switch (hostStatus) {
            case NotReachable:
            {
                NSLog(@"A gateway to the host server is down.");
                self.isHostReachable = NO;
                
                break;
            }
            case ReachableViaWiFi:
            {
                NSLog(@"A gateway to the host server is working via WIFI.");
                self.isHostReachable = YES;
                
                break;
            }
            case ReachableViaWWAN:
            {
                NSLog(@"A gateway to the host server is working via WWAN.");
                self.isHostReachable = YES;
                break;
            }
        }
    }
}

- (void)startLoading {
    
    if (self.isHostReachable & self.isInternetActive) {
        self.jokersHelper = [[JokesHelper alloc] init];
        [self.jokersHelper initiateJokesDownload];
    }
    else {
        //TODO check why the connection didFailWithError
        NSString *acceptString = NSLocalizedString(@"AcceptButtonTitle", @"The ok button title");
        NSString *errorMessage = NSLocalizedString(@"ConnectionError", @"the connection error button title");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:errorMessage delegate:self cancelButtonTitle:acceptString otherButtonTitles:nil];
        [alertView show];
        
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *errorMessage = NSLocalizedString(@"ConnectionError", @"the connection error button title");
    if ([alertView.message isEqualToString:errorMessage]) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self performSegueWithIdentifier:@"ShowOfflineViewController" sender:self];
    }
}



#pragma mark - System Stuff

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    // check if a pathway to a random host exists
    self.hostReachability = [Reachability reachabilityWithHostName:@"http://www.icndb.com"];
    [self.hostReachability startNotifier];
    self.loadingActivityIndicator.color = [UIColor colorWithRed:245.0f/255.0f green:12.0f/255.0f blue:0.0f/255.0f alpha:1];
    [self.loadingActivityIndicator setHidden:NO];
    [self.loadingActivityIndicator startAnimating];
    [self.navigationController.navigationBar setHidden:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *loadingLabelText = NSLocalizedString(@"LoadingLabelText", @"the text of the loading button");
    self.loadingLabel.text = loadingLabelText;
    [self performSelector:@selector(startLoading) withObject:nil afterDelay:1];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(procceesWithMainScreen:) name:@"JokesParsed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(procceesWithOfflineScreen:) name:@"JokesParsingFailed" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [self.internetReachability stopNotifier];
    [self.hostReachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"JokesParsed" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"JokesParsingFailed" object:nil];
    self.jokersHelper = nil;
}

-(void)viewDidUnload {
    [self setLoadingActivityIndicator:nil];
    [self setLoadingLabel:nil];
    [super viewDidUnload];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]];
    self.loadingActivityIndicator.backgroundColor = [UIColor clearColor];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

