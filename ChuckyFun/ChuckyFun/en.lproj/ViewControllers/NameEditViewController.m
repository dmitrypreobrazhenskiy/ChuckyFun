//
//  NameEditViewController.m
//  ChuckyFun
//
//  Created by Dmitry Preobrazhenskiy on 14.05.12.
//  Copyright (c) 2012 TTU. All rights reserved.
//

#import "NameEditViewController.h"

@interface NameEditViewController () <UITextFieldDelegate, UIGestureRecognizerDelegate>
@property(nonatomic, strong) NSMutableString *personName;
@property(nonatomic, strong) NSMutableString *personFamilyName;
@property(nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property(nonatomic) BOOL isMovableViewMoved;
@property(nonatomic, weak) UITextField *currentResponder;

@end

@implementation NameEditViewController
@synthesize nameTextField = _nameTextField;
@synthesize familyNameTextField = _familyNameTextField;
@synthesize movableView = _movableView;
@synthesize delegate = _delegate;
@synthesize topToolbar = _topToolbar;
@synthesize personFamilyName = _personFamilyName;
@synthesize personName = _personName;
@synthesize tapGestureRecognizer = _tapGestureRecognizer;
@synthesize isMovableViewMoved = _isMovableViewMoved;
@synthesize currentResponder = _currentResponder;

#pragma mark - Methods 

-(void)setPersonName:(NSMutableString *)personName {
    if (_personName != personName) {
        _personName = personName;
        self.nameTextField.text = personName;
    }
}

-(void)setPersonFamilyName:(NSMutableString *)personFamilyName {
    if (_personFamilyName != personFamilyName) {
        _personFamilyName = personFamilyName;
        self.familyNameTextField.text = personFamilyName;
    }
}

-(void)removeTheKeyboard {
    [self.currentResponder resignFirstResponder];
    if (self.isMovableViewMoved) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        CGRect currentPostion = self.movableView.frame;
        CGRect newPosition = CGRectMake(currentPostion.origin.x, currentPostion.origin.y + 100, currentPostion.size.width, currentPostion.size.height);
        self.movableView.frame = newPosition;
        [UIView commitAnimations];
        [self.view removeGestureRecognizer:[self.view.gestureRecognizers lastObject]];
        self.isMovableViewMoved = NO;
    }
    
}

-(void)showElements {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    self.nameTextField.alpha = 1;
    self.familyNameTextField.alpha = 1;
    [UIView commitAnimations];
}

-(void)acceptNameSelection {
    if ((self.personName != nil) & (self.personFamilyName != nil)) {
        if ((![self.personName isEqualToString:@""]) & (![self.personFamilyName isEqualToString:@""])) {
            [self.delegate nameEditViewController:self didEnterFirstName:self.personName andLastName:self.personFamilyName];
             [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)cancelNameSelection {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Delegates


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    if ([touch.view isKindOfClass:[UITextField class]]) {
        return NO;
    }
    if ([touch.view isKindOfClass:[UITabBar class]]) {
        return NO;
    }
    if ([touch.view isKindOfClass:[UIBarButtonItem class]]) {
        return NO;
    }
    if ([touch.view isKindOfClass:[UIToolbar class]]) {
        return NO;
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
    if (!self.isMovableViewMoved) {
        self.isMovableViewMoved = YES;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        CGRect currentPostion = self.movableView.frame;
        CGRect newPosition = CGRectMake(currentPostion.origin.x, currentPostion.origin.y - 100, currentPostion.size.width, currentPostion.size.height);
        self.movableView.frame = newPosition;
        [UIView commitAnimations];
        [self.view addGestureRecognizer:self.tapGestureRecognizer];
    }    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.nameTextField) {
        self.personName = [[NSMutableString alloc] initWithFormat:@"%@", textField.text];
        
    }
    else if (textField == self.familyNameTextField) {
        NSLog(@"%@",textField.text);
        self.personFamilyName = [[NSMutableString alloc] initWithFormat:@"%@", textField.text];
        
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (self.isMovableViewMoved) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        CGRect currentPostion = self.movableView.frame;
        CGRect newPosition = CGRectMake(currentPostion.origin.x, currentPostion.origin.y + 100, currentPostion.size.width, currentPostion.size.height);
        self.movableView.frame = newPosition;
        [UIView commitAnimations];
        [self.view removeGestureRecognizer:[self.view.gestureRecognizers lastObject]];
        self.isMovableViewMoved = NO;
    }
    return YES;
}


#pragma mark - System Stuff
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self showElements];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]];
        //Load the name View
        NSString *acceptString = NSLocalizedString(@"AcceptButtonTitle", @"The ok button title");
        NSString *cancelString = NSLocalizedString(@"CancelButtonTitle", @"the cancel button title");
       
        NSString *nameString = NSLocalizedString(@"NameTextField", @"name placeholder text");
        NSString *familyNameString = NSLocalizedString(@"FamilyNameTextField", @"family name placeholder text");
    
        self.nameTextField.placeholder = nameString;
        self.familyNameTextField.placeholder = familyNameString;
        
        self.nameTextField.delegate = self;
        self.familyNameTextField.delegate = self;
    
    
        self.nameTextField.alpha = 0;
        self.familyNameTextField.alpha = 0;
        self.movableView.backgroundColor = [UIColor clearColor];
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:cancelString style:UIBarButtonItemStyleDone target:self action:@selector(cancelNameSelection)];
        UIBarButtonItem *acceptDateBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:acceptString style:
                                                    UIBarButtonItemStyleDone target:self action:@selector(acceptNameSelection)];
        UIBarButtonItem *flexibleWidth = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
       NSArray *buttonArray = [NSArray arrayWithObjects:cancelBarButtonItem, flexibleWidth,acceptDateBarButtonItem, nil];
       [self.topToolbar setItems:buttonArray animated:NO];
      self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeTheKeyboard)];
        self.isMovableViewMoved = NO;
    //Finished loading the view
    [super viewDidLoad];
	
}

- (void)viewDidUnload
{
    [self setTopToolbar:nil];
    [self setNameTextField:nil];
    [self setMovableView:nil];
    [self setNameTextField:nil];
    [self setFamilyNameTextField:nil];
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
