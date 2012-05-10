//
//  JokesViewController.m
//  ChuckyFun
//
//  Created by Dmitry Preobrazhenskiy on 10.05.12.
//  Copyright (c) 2012 TTU. All rights reserved.
//

#import "JokesViewController.h"

@interface JokesViewController ()

@end

@implementation JokesViewController

#pragma mark - System Stuff
#pragma mark - Delegates
#pragma mark - System Stuff




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

    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
