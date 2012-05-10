//
//  FavoritesViewController.m
//  ChuckyFun
//
//  Created by Dmitry Preobrazhenskiy on 10.05.12.
//  Copyright (c) 2012 TTU. All rights reserved.
//

#import "FavoritesViewController.h"

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

#pragma mark - System Stuff
#pragma mark - Delegates
#pragma mark - System Stuff
@synthesize topToolbar;



-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
}

- (void)viewDidLoad
{   
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]];
    [super viewDidLoad];
	
}

- (void)viewDidUnload
{
    [self setTopToolbar:nil];
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end