//
//  SearchView.m
//  CoreDataTest
//
//  Created by Christopher Cohen on 5/7/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "SearchView.h"
#import "StyleKit.h"

@implementation SearchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)setIsValidInput:(BOOL)isValidInput {
    _isValidInput = isValidInput;
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (_isValidInput) {
        [StyleKit drawCanvas2];
    } else {
        [StyleKit drawCanvas1];
    }
}


@end
