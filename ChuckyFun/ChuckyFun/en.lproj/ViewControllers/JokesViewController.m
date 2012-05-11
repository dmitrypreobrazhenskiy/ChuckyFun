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
#import "CustomNameView.h"
#import "CustomTextField.h"

@interface JokesViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate>
@property(nonatomic, strong) NSMutableArray *tableViewArray;
@property(nonatomic, strong) JokesHelper *jokesHelper;
@property(nonatomic, strong) CustomNameView *customNameView;
@property(nonatomic) BOOL isCustomViewArranged;
@property(nonatomic) BOOL isCustomViewVisiable;
@property(nonatomic, strong) NSMutableString *personName;
@property(nonatomic, strong) NSMutableString *personFamilyName;
@property(nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property(nonatomic, weak) CustomTextField *selectedTextField;
@end

@implementation JokesViewController
@synthesize mainTableView = _mainTableView;
@synthesize tableViewArray = _tableViewArray;
@synthesize jokesHelper = _jokesHelper;
@synthesize customNameView = _customNameView;
@synthesize tapGestureRecognizer = _tapGestureRecognizer;
@synthesize selectedTextField = _selectedTextField;

@synthesize isCustomViewArranged = _isCustomViewArranged;
@synthesize isCustomViewVisiable = _isCustomViewVisiable;

@synthesize personName = _personName;
@synthesize personFamilyName = _personFamilyName;

#pragma mark - Methods

-(void)removeTheKeyboard {
    [self.selectedTextField resignFirstResponder];
    [self.view removeGestureRecognizer:[self.view.gestureRecognizers lastObject]];
    
}

-(void)editName {
    if (self.isCustomViewVisiable) {
        self.isCustomViewVisiable = YES;
        //TODO move the view
        [self.view addGestureRecognizer:self.tapGestureRecognizer];
    }

}

-(void)acceptNameSelection {
    //TODO move the view and stuff
}

-(void)cancelNameSelection {
    //TODO move the view and stuff
}

#pragma mark - Delegates

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //TODO add to favorites alert will be here
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    self.selectedTextField = (CustomTextField *) textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view removeGestureRecognizer:[self.view.gestureRecognizers lastObject]];
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    else if ([touch.view isKindOfClass:[UITextField class]]) {
        return NO;
    }
    return YES;
}

#define CELLHEIGHT 52
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELLHEIGHT;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableViewArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    return jokesCell;
}

#pragma mark - System Stuff

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.jokesHelper = [[JokesHelper alloc] init];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    self.jokesHelper = nil;
}

- (void)viewDidLoad
{
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeTheKeyboard)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor clearColor];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //Load the name View
    NSString *acceptString = NSLocalizedString(@"AcceptButtonTitle", @"The ok button title");
    NSString *cancelString = NSLocalizedString(@"CancelButtonTitle", @"the cancel button title");
    
    NSString *nameString = NSLocalizedString(@"NameTextField", @"name placeholder text");
    NSString *familyNameString = NSLocalizedString(@"FamilyNameTextField", @"family name placeholder text");
    
    
    self.customNameView = [[[NSBundle mainBundle] loadNibNamed:@"CustomNameView" owner:nil options:nil] lastObject];
    self.customNameView.frame = CGRectMake(0, self.view.frame.size.height, self.customNameView.frame.size.width, self.customNameView.frame.size.height);
    [self.view addSubview:self.customNameView];
    self.customNameView.nameTextField.text = nameString;
    self.customNameView.familyNameTextField.placeholder = familyNameString;
    
    self.customNameView.nameTextField.delegate = self;
    self.customNameView.familyNameTextField.delegate = self;
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:cancelString style:UIBarButtonItemStyleDone target:self action:@selector(cancelNameSelection)];
    UIBarButtonItem *acceptDateBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:acceptString style:
                                                UIBarButtonItemStyleDone target:self action:@selector(acceptNameSelection)];
    UIBarButtonItem *flexibleWidth = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *buttonArray = [NSArray arrayWithObjects:acceptDateBarButtonItem, flexibleWidth, cancelBarButtonItem, nil];
    [self.customNameView.topToolbar setItems:buttonArray animated:NO];
    
    //Finished loading the view
    NSString *editNameButtonTitle = NSLocalizedString(@"EditNameButtonTitle", @"the name of the button that lets changing the name");
    UIBarButtonItem *editNameBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:editNameButtonTitle style:UIBarButtonItemStyleDone target:self action:@selector(editName)];
    self.navigationItem.rightBarButtonItem = editNameBarButtonItem;
    [super viewDidLoad];
	
}

- (void)viewDidUnload

{
    
    self.customNameView = nil;
    [self setMainTableView:nil];
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
