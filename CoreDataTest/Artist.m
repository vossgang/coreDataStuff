//
//  Artist.m
//  CoreDataTest
//
//  Created by Matthew Voss on 5/7/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "Artist.h"
#import "Label.h"


@implementation Artist

@dynamic firstName;
@dynamic genre;
@dynamic lastName;
@dynamic label;
@dynamic albums;


-(NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

@end
