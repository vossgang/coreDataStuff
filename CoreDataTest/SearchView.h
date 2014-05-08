//
//  SearchView.h
//  CoreDataTest
//
//  Created by Christopher Cohen on 5/7/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchView : UIView
@property (nonatomic, readwrite) BOOL isValidInput;

-(void)setIsValidInput:(BOOL)isValidInput;

@end
