//
//  OfflineViewController.m
//  ChuckyFun
//
//  Created by Dmitry Preobrazhenskiy on 10.05.12.
//  Copyright (c) 2012 TTU. All rights reserved.
//


#import "OfflineViewController.h"
#import "Reachability.h"

@interface OfflineViewController () <UIAlertViewDelegate> {
    Reachability *internetReachability;
    Reachability *hostReachability;
    
}

@property(nonatomic, strong) Reachability *internetReachibility;
@property(nonatomic, strong) Reachability *hostReachability;
@property(nonatomic) BOOL isInternetActive;
@property(nonatomic) BOOL isHostReachable;



@end

@implementation OfflineViewController
@synthesize checkConnectionButton = _checkConnectionButton;
@synthesize internetReachibility = _internetReachibility;
@synthesize hostReachability = _hostReachability;
@synthesize isInternetActive = _isInternetActive;
@synthesize isHostReachable = _isHostReachable;



#pragma mark - Methods


- (void)alertTheUserOnStatusChanged {
    if (self.isInternetActive & self.isHostReachable) {
        NSString *successMessage = NSLocalizedString(@"SuccessMesaageOfConnection", @"The message that appears when sucessfully connected");
        NSString *yesString = NSLocalizedString(@"Yes", @"the normal yes");
        NSString *noString = NSLocalizedString(@"No", @"the normal no");
        UIAlertView *uiav = [[UIAlertView alloc] initWithTitle:@"" message:successMessage delegate:self cancelButtonTitle:noString otherButtonTitles:yesString, nil];
        [uiav show];
    }
}

- (IBAction)checkConnectionButtonPressed:(id)sender {
    [self alertTheUserOnStatusChanged];
}

- (void)checkNetworkStatus:(NSNotification *)notification {
    {
        // called after network status changes
        NetworkStatus internetStatus = [self.internetReachibility currentReachabilityStatus];
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

#pragma mark - Delegates
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *successMessage = NSLocalizedString(@"SuccessMesaageOfConnection", @"The message that appears when sucessfully connected");
    if ([alertView.message isEqualToString:successMessage]) {
        if (buttonIndex == 1) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
            }];
        }
    }
}

#pragma mark - System Stuff

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    self.internetReachibility = [Reachability reachabilityForInternetConnection];
    [self.internetReachibility startNotifier];
    // check if a pathway to a random host exists
    self.hostReachability = [Reachability reachabilityWithHostName:@"www.saloninfra.eu"];
    [self.hostReachability startNotifier];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [self.internetReachibility stopNotifier];
    [self.hostReachability stopNotifier];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]];
    NSString *checkButtonTiile = NSLocalizedString(@"CheckConnectionButton", @"the title for the button that checks connection");
    [self.checkConnectionButton setTitle:checkButtonTiile forState:UIControlStateNormal];
    [self.checkConnectionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.isHostReachable = NO;
    self.isInternetActive = NO;
    
    
}

- (void)viewDidUnload {
    
    [self setCheckConnectionButton:nil];
    [super viewDidUnload];
}

@end
