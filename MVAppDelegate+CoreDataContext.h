//
//  MVAppDelegate+CoreDataContext.h
//  CoreDataTest
//
//  Created by Matthew Voss on 5/7/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "MVAppDelegate.h"

@interface MVAppDelegate (CoreDataContext)

-(void)createManagedObjectContextWithCompletion:(void(^)(NSManagedObjectContext *conxtext))completion;

@end
