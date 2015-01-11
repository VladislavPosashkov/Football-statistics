//
//  AddPlayerTableViewController.m
//  Task1
//
//  Created by Vladislav Posashkov on 07.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import "PlayerDetailTableViewController.h"
#import "DataManager.h"
#import "Team.h"
#import "Player.h"

@interface PlayerDetailTableViewController ()


@end

@implementation PlayerDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setDetailItem:(Player *)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        [self configureView];
    }
}

- (void)configureView {
    if (self.detailItem) {
        self.lastNameTextField.text = [self.detailItem valueForKeyPath:@"lastName"];
        self.teamTextField.text = [self.detailItem valueForKeyPath:@"team.name"];
        self.numberTextField.text = [NSString stringWithFormat:@"%@",[self.detailItem valueForKeyPath:@"number"]];
        self.goalsTextField.text = [NSString stringWithFormat:@"%@",[self.detailItem valueForKeyPath:@"goals"]];
    }
}

- (BOOL)isTextFieldValide{
    
    if(![self.lastNameTextField.text length]){
        [self showAlertWithMessage:@"Last name can't be empty"];
        return NO;
    }
    
    if (![self.teamTextField.text length]) {
        [self showAlertWithMessage:@"Team can't be empty"];
        return NO;
    }
    
    if (![self.numberTextField.text length] && ![self.lastNameTextField.text integerValue]){
        [self showAlertWithMessage:@"Number can't be empty"];
        return NO;
    }
    
    return YES;
}


-(void)showAlertWithMessage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Invalide value" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - IBAction

- (IBAction)saveButtonClicked:(id)sender {
    if(![self isTextFieldValide]){
        return;
    }
    
    NSManagedObjectContext *context = [[DataManager sharedManager] managedObjectContext];
    
    Team *newTeam = nil;
    
    if (![[self.detailItem valueForKeyPath:@"team.name"] isEqualToString: self.teamTextField.text]) {
        newTeam = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:context];
        newTeam.name = [self.teamTextField.text capitalizedString];
    } else {
        newTeam = (Team *)self.detailItem.team;
    }
    
    if (self.detailItem) {
        self.detailItem.lastName = self.lastNameTextField.text;
        self.detailItem.goals = [NSNumber numberWithInteger:[self.goalsTextField.text integerValue]];
        self.detailItem.number = [NSNumber numberWithInteger:[self.numberTextField.text integerValue]];
        self.detailItem.team = newTeam;
    } else {
        Player *newPlayer = [NSEntityDescription insertNewObjectForEntityForName:@"Player" inManagedObjectContext:context];
        
        newPlayer.lastName = [self.lastNameTextField.text capitalizedString];
        newPlayer.number = @([self.numberTextField.text integerValue]);
        newPlayer.goals = @([self.goalsTextField.text integerValue]);
        newPlayer.team = newTeam;
    }
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
