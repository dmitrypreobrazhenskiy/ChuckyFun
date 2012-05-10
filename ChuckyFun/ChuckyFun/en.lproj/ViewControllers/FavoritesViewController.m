//
//  FavoritesViewController.m
//  ChuckyFun
//
//  Created by Dmitry Preobrazhenskiy on 10.05.12.
//  Copyright (c) 2012 TTU. All rights reserved.
//

#import "FavoritesViewController.h"
#import "FavoritesHelper.h"
#import "FavoritesCell.h"

@interface FavoritesViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) FavoritesHelper *favoritesHelper;
@property(nonatomic, strong) NSMutableArray *tableViewArray;
@end

@implementation FavoritesViewController
@synthesize mainTableView = _mainTableView;
@synthesize favoritesHelper = _favoritesHelper;
@synthesize tableViewArray = _tableViewArray;

#pragma mark - System Stuff

- (void)loadTableView {
    self.tableViewArray = [[NSMutableArray alloc] initWithContentsOfFile:self.favoritesHelper.plistPath];
    if ([self.tableViewArray count] == 0) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    else {
        NSString *editButtonTitle = NSLocalizedString(@"EditButtonTitle", @"The edit button which triggers the editing");
        UIBarButtonItem *editingButton = [[UIBarButtonItem alloc] initWithTitle:editButtonTitle style:UIBarButtonItemStyleBordered target:self action:@selector(customEditMode:)];
        self.navigationItem.rightBarButtonItem = editingButton;
    }
    
    [self.mainTableView reloadData];
}

- (void)customEditMode:(UIBarButtonItem *)sender {
    if (self.isEditing) {
        NSString *editButtonTitle = NSLocalizedString(@"EditButtonTitle", @"The edit button which triggers the editing");
        [super setEditing:NO animated:YES];
        [self.mainTableView setEditing:NO animated:YES];
        [sender setTitle:editButtonTitle];
        [self.mainTableView reloadData];
    }
    else {
        NSString *finishButtonTitle = NSLocalizedString(@"FinishButtonTitle", @"The finish button to leave the editing mode");
        [super setEditing:YES animated:YES];
        [self.mainTableView setEditing:YES animated:YES];
        [sender setTitle:finishButtonTitle];
    }
}
#pragma mark - Delegates

#define CELLHEIGHT 52
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELLHEIGHT;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableViewArray count];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.mainTableView setEditing:editing animated:animated];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *favoritesCellIdentifier = @"FavoritesCellIdentifier";
    FavoritesCell *favoritesCell = [tableView dequeueReusableCellWithIdentifier:favoritesCellIdentifier];
    if (favoritesCell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FavoritesCellView" owner:nil options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                favoritesCell = (FavoritesCell *)currentObject;
                break;
            }
        }
    }
    favoritesCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return favoritesCell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row <= [self.tableViewArray count]) {
        return UITableViewCellEditingStyleDelete;
    }
    else return UITableViewCellEditingStyleNone;
}


//Deletion
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //Delete here
        NSMutableDictionary *jokesDictionary = [self.tableViewArray objectAtIndex:indexPath.row];
        [self.favoritesHelper removeFromFavorites:jokesDictionary];
        self.tableViewArray = [[NSMutableArray alloc] initWithContentsOfFile:self.favoritesHelper.plistPath];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if ([self.tableViewArray count] == 0) {
            [self customEditMode:self.navigationItem.rightBarButtonItem];
            self.navigationItem.rightBarButtonItem = nil;
            
        }
        else {
            //Do nothing just in case we have different background we might put it here
        }
    }
}

#pragma mark - System Stuff
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.favoritesHelper = [[FavoritesHelper alloc] init];
    [self loadTableView];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    self.favoritesHelper = nil;
}

- (void)viewDidLoad
{   
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor clearColor];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
