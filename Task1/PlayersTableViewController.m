//
//  PlayersTableViewController.m
//  Task1
//
//  Created by Vladislav Posashkov on 07.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import "PlayersTableViewController.h"
#import "PlayerDetailTableViewController.h"
#import "DataManager.h"
#import "PlayerTableViewCell.h"
#import "StatisticsViewController.h"
#import "Player.h"
#import "Team.h"

@interface PlayersTableViewController ()

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation PlayersTableViewController

static NSString *headerIdentifier = @"Header";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"PlayersHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:headerIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Player *player = [self.fetchedResultsController objectAtIndexPath:indexPath];
    PlayerTableViewCell *playerCell = (PlayerTableViewCell *)cell;
    playerCell.numberLabel.text = [NSString stringWithFormat:@"%@", player.number];
    playerCell.lastNameLabel.text = player.lastName;
    playerCell.goalLabel.text = [NSString stringWithFormat:@"%@", player.goals];
}

- (NSManagedObjectContext *)managedObjectContext{
    if(!_managedObjectContext){
        _managedObjectContext = [[DataManager sharedManager] managedObjectContext];
    }
    return _managedObjectContext;
}

#pragma mark - IBAction

- (IBAction)showStatistics:(id)sender{
    UIButton *button = (UIButton *)sender;
    [self performSegueWithIdentifier:@"ShowStatisticsSegue" sender:[NSNumber numberWithInteger:button.tag]];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"EditePlayerSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Player *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
    } else if ([[segue identifier] isEqualToString:@"ShowStatisticsSegue"]){
        NSInteger section = [sender integerValue];
        id <NSFetchedResultsSectionInfo> info = [self.fetchedResultsController sections][section];
        [[segue destinationViewController] setPlayersWithArray:[info objects]];
        
    }
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    id <NSFetchedResultsSectionInfo> info = [self.fetchedResultsController sections][section];
    
    [header setValue:[NSNumber numberWithInteger:section] forKeyPath:@"statisticsButton.tag"];
    [header setValue:[info name] forKeyPath:@"teamNameLabel.text"];
    
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    return header.frame.size.height;
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Player" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *teamDescriptor = [[NSSortDescriptor alloc] initWithKey:@"team.name" ascending:YES];
    NSSortDescriptor *numbeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];    
    NSArray *sortDescriptors = @[teamDescriptor, numbeDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                             initWithFetchRequest:fetchRequest
                                                             managedObjectContext:self.managedObjectContext
                                                             sectionNameKeyPath:@"team.name"
                                                             cacheName:@"Master"];
    
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}
@end
