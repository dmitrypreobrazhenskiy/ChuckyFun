//
//  JokesViewController.m
//  ChuckyFun
//
//  Created by Dmitry Preobrazhenskiy on 10.05.12.
//  Copyright (c) 2012 TTU. All rights reserved.
//

#import "JokesViewController.h"
#import "JokesHelper.h"
#import "JokesCell.h"
#import "LoadingCell.h"
#import "FavoritesHelper.h"
#import "SpinnerObject.h"
#import "NameEditViewController.h"

@interface JokesViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, NameViewControllerDelegate>
@property(nonatomic, strong) NSMutableArray *tableViewArray;
@property(nonatomic, strong) NSMutableDictionary *jokesDictionary;
@property(nonatomic, strong) JokesHelper *jokesHelper;
@property(nonatomic, strong) FavoritesHelper *favoritesHelper;
@property(nonatomic, strong) NSMutableString *personName;
@property(nonatomic, strong) NSMutableString *personFamilyName;
@property(nonatomic, strong) NSDictionary *selectedJoke;
@property(nonatomic, strong) SpinnerObject *spinnerObjet;
@property(nonatomic) BOOL isRowSelected;
@property(nonatomic) BOOL isCustomNamePresent;
@end

@implementation JokesViewController
@synthesize mainTableView = _mainTableView;
@synthesize tableViewArray = _tableViewArray;
@synthesize jokesHelper = _jokesHelper;
@synthesize jokesDictionary = _jokesDictionary;
@synthesize favoritesHelper = _favoritesHelper;
@synthesize personName = _personName;
@synthesize personFamilyName = _personFamilyName;
@synthesize selectedJoke = _selectedJoke;
@synthesize spinnerObjet = _spinnerObjet;
@synthesize isRowSelected = _isRowSelected;
@synthesize isCustomNamePresent = _isCustomNamePresent;
#pragma mark - Methods

-(void)editName {
    [self performSegueWithIdentifier:@"ShowNameEditViewController" sender:self];
}

-(void)updateTitle {
    NSMutableString *titleName = [NSMutableString stringWithString:self.personName];
    [titleName appendFormat:@" %@", self.personFamilyName];
    [self.navigationItem setTitle:titleName];
 
}

-(void)loadTableView {
    self.jokesDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:self.jokesHelper.plistPath];
    self.tableViewArray = [self.jokesDictionary objectForKey:@"value"];
    [self.mainTableView reloadData];
}

-(void)loadMoreResults:(NSNotification *)notification {
    if ([notification.name isEqualToString:@"JokesParsed"]) {
        NSMutableArray *currentTableViewArray = [NSMutableArray arrayWithArray:self.tableViewArray];
        NSDictionary *loadedJokesDictionary = [NSDictionary dictionaryWithContentsOfFile:self.jokesHelper.plistPath];
        NSMutableArray *loadedJokesArray = [loadedJokesDictionary objectForKey:@"value"];        
        [currentTableViewArray addObjectsFromArray:loadedJokesArray];
        self.tableViewArray = currentTableViewArray;
        [self.spinnerObjet stopAndRemoveSpinnerForViewController:self];
        self.isRowSelected = NO;
        [self.mainTableView reloadData];

    }
}
#pragma mark - Delegates

-(void)nameEditViewController:(NameEditViewController *)sender didEnterFirstName:(NSString *)firstName andLastName:(NSString *)lastName {
    self.personName = [NSMutableString stringWithString:firstName];
    self.personFamilyName = [NSMutableString stringWithString:lastName];
    self.isCustomNamePresent = YES;
    [self updateTitle];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
      NSString *favoritesMessage = NSLocalizedString(@"FavoritesMessage", @"The message body of the favorites alert");
    if ([alertView.message isEqualToString:favoritesMessage]) {
        if (buttonIndex == 1) {
            [self.favoritesHelper addToFavorites:self.selectedJoke];
        }
    }
}



#define CELLHEIGHT 75
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELLHEIGHT;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableViewArray count] + 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row <= [self.tableViewArray count] -1) {
        NSDictionary *jokesDictionary = [self.tableViewArray objectAtIndex:indexPath.row];
        static NSString *jokesCellIdentifier = @"JokesCellIdentifier";
        JokesCell *jokesCell = [tableView dequeueReusableCellWithIdentifier:jokesCellIdentifier];
        if (jokesCell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"JokesCellView" owner:nil options:nil];
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                    jokesCell = (JokesCell *)currentObject;
                    break;
                }
            }
        }
        jokesCell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *joke = [jokesDictionary objectForKey:@"joke"];
        NSString *jokesCorrected = [joke stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (jokesCorrected != nil) {
            if (![jokesCorrected isEqualToString:@""]) {
                jokesCell.jokesLabel.text = jokesCorrected;
            }
        }
        
        return jokesCell; 
    }
    else if (indexPath.row == [self.tableViewArray count]) {
        static NSString *loadingCellIdentifier = @"LoadingCellIdentifier";
        LoadingCell *loadingCell = [tableView dequeueReusableCellWithIdentifier:loadingCellIdentifier];
        if (loadingCell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LoadingCellView" owner:nil options:nil];
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                    loadingCell = (LoadingCell *)currentObject;
                    break;
                }
            }
        }
        loadingCell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *loadingText = NSLocalizedString(@"LoadingCellText", @"The text for the loading label");
        loadingCell.loadLabel.text = loadingText;
        return loadingCell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row <= [self.tableViewArray count] -1) {
        NSDictionary *jokesDictionary = [self.tableViewArray objectAtIndex:indexPath.row];
        self.selectedJoke = jokesDictionary;
        NSString *favoritesMessage = NSLocalizedString(@"FavoritesMessage", @"The message body of the favorites alert");
        NSString *alertAccept = NSLocalizedString(@"AlertAccept", @"the title of the button to add the joke to favorites");
        NSString *alertCancel = NSLocalizedString(@"AlertCancel", @"the title of the button not to add the joke to favorites");
        UIAlertView *favoritesAlert = [[UIAlertView alloc] initWithTitle:@"" message:favoritesMessage delegate:self cancelButtonTitle:alertCancel
                                                       otherButtonTitles:alertAccept, nil];
        [favoritesAlert show];
        //The regular cells, will be adding to favorites here
    }
    else if (indexPath.row == [self.tableViewArray count]) {
        if (self.isCustomNamePresent) {
            if (!self.isRowSelected) {
                self.isRowSelected = YES;
                [self.spinnerObjet addAndStartSpinnerForViewController:self];
                [self.jokesHelper initiateJokesDownloadWithPersonName:self.personName andPersonFamilyName:self.personFamilyName];
            } 
        }
        else {
            if (!self.isRowSelected) {
                self.isRowSelected = YES;
                [self.spinnerObjet addAndStartSpinnerForViewController:self];
                [self.jokesHelper initiateJokesDownload];
            }
        }
    }
}

#pragma mark - System Stuff

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier hasPrefix:@"ShowNameEditViewController"]) {
        NameEditViewController *nevc = segue.destinationViewController;
        nevc.delegate = self;
    }
    if (self.isCustomNamePresent) {
        if ([segue.destinationViewController respondsToSelector:@selector(setPersonFamilyName:)]) {
            [segue.destinationViewController setPersonFamilyName:self.personFamilyName];
            
        }
        if ([segue.destinationViewController respondsToSelector:@selector(setPersonName:)]) {
            [segue.destinationViewController setPersonName:self.personName];
            
        }
    }
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.jokesHelper = [[JokesHelper alloc] init];
    self.favoritesHelper = [[FavoritesHelper alloc] init];
    [self loadTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMoreResults:) name:@"JokesParsed" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"JokesParsed" object:nil];
    self.favoritesHelper = nil;
    self.jokesHelper = nil;
}

- (void)viewDidLoad
{
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:UITextAttributeFont];
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor clearColor];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSString *editNameButtonTitle = NSLocalizedString(@"EditNameButtonTitle", @"the name of the button that lets changing the name");
    UIBarButtonItem *editNameBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:editNameButtonTitle style:UIBarButtonItemStyleDone target:self action:@selector(editName)];
    self.navigationItem.rightBarButtonItem = editNameBarButtonItem;
    self.spinnerObjet = [[SpinnerObject alloc] init];
    self.isCustomNamePresent = NO;
    [super viewDidLoad];
	
}

- (void)viewDidUnload

{
    
    [self setMainTableView:nil];
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
