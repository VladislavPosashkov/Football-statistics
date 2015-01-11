//
//  AddPlayerTableViewController.h
//  Task1
//
//  Created by Vladislav Posashkov on 07.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Player;

@interface PlayerDetailTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *teamTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *goalsTextField;

@property (strong, nonatomic) Player *detailItem;

- (BOOL)isTextFieldValide;
- (void)showAlertWithMessage:(NSString *)message;


@end
