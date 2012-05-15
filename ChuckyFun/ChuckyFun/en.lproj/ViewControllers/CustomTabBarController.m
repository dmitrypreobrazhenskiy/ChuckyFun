//
//  CustomTabBarController.m
//  ChuckyFun
//
//  Created by Dmitry Preobrazhenskiy on 10.05.12.
//  Copyright (c) 2012 TTU. All rights reserved.
//

#import "CustomTabBarController.h"

@interface CustomTabBarController ()

@end

@implementation CustomTabBarController


#pragma mark - System Stuff
#pragma mark - Delegates
#pragma mark - System Stuff

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINavigationController *jvc = [self.viewControllers objectAtIndex:0];    
    UINavigationController *fvc = [self.viewControllers objectAtIndex:1];
    NSString *jokesTabName = NSLocalizedString(@"Jokes", @"The tab name of jokes page");
    UITabBarItem *jokesTab = [[UITabBarItem alloc] initWithTitle:jokesTabName image:nil tag:0];
    jvc.tabBarItem = jokesTab;
    NSString *favoritesTabName = NSLocalizedString(@"Favorites", @"The tab name of favorites page");
    UITabBarItem *favoritesTab = [[UITabBarItem alloc] initWithTitle:favoritesTabName image:nil tag:1]; 
    fvc.tabBarItem = favoritesTab;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
