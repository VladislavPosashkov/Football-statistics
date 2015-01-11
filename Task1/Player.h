//
//  Player.h
//  Task1
//
//  Created by Vladislav Posashkov on 07.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Player : NSManagedObject

@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * goals;
@property (nonatomic, retain) NSManagedObject *team;

@end
