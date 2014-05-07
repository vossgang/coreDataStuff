//
//  SongViewController.h
//  CoreDataTest
//
//  Created by Matthew Voss on 5/7/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#import "Album.h"
#import "Label.h"
#import "Artist.h"


@interface SongViewController : UIViewController

@property (nonatomic, weak) Album *selectedAlbum;

@end
