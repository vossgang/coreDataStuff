//
//  MVAppDelegate+CoreDataContext.m
//  CoreDataTest
//
//  Created by Matthew Voss on 5/7/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "MVAppDelegate+CoreDataContext.h"

@implementation MVAppDelegate (CoreDataContext)

-(void)createManagedObjectContextWithCompletion:(void(^)(NSManagedObjectContext *conxtext))completion
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
    
    url = [url URLByAppendingPathComponent:@"LabelDocument"];

    self.managedDocument = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [self.managedDocument saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            self.objectContext = self.managedDocument.managedObjectContext;
            completion(self.objectContext);
        }];
    } else if (self.managedDocument.documentState == UIDocumentStateClosed){
        [self.managedDocument openWithCompletionHandler:^(BOOL success) {
            self.objectContext = self.managedDocument.managedObjectContext;
            completion(self.objectContext);
        }];
    } else {
        self.objectContext = self.managedDocument.managedObjectContext;
        completion(self.objectContext);
    }
}

@end
