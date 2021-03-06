//
//  StyleKitName.h
//  ProjectName
//
//  Created by AuthorName on 5/7/14.
//  Copyright (c) 2014 CompanyName. All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//

#import <Foundation/Foundation.h>


@class PCGradient;

@interface StyleKit : NSObject

// Colors
+ (UIColor*)gradientColor;
+ (UIColor*)gradientColor2;

// Gradients
+ (PCGradient*)gradient;
+ (PCGradient*)gradient2;
+ (PCGradient*)gradient6;

// Drawing Methods
+ (void)drawCanvas1;
+ (void)drawCanvas2;

@end



@interface PCGradient : NSObject
@property(nonatomic, readonly) CGGradientRef CGGradient;
- (CGGradientRef)CGGradient NS_RETURNS_INNER_POINTER;

+ (instancetype)gradientWithColors: (NSArray*)colors locations: (const CGFloat*)locations;
+ (instancetype)gradientWithStartingColor: (UIColor*)startingColor endingColor: (UIColor*)endingColor;

@end
