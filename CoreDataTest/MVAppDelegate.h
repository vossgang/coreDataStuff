//
//  MVAppDelegate.h
//  CoreDataTest
//
//  Created by Matthew Voss on 5/7/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MVAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIManagedDocument *managedDocument;
@property (nonatomic, strong) NSManagedObjectContext   *objectContext;

@end
