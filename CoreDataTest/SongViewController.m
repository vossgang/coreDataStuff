//
//  SongViewController.m
//  CoreDataTest
//
//  Created by Matthew Voss on 5/7/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "SongViewController.h"

@interface SongViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *songField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *songs;

@end

@implementation SongViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _songField.delegate     = self;
    _tableView.delegate     = self;
    _tableView.dataSource   = self;
    
    self.title = _selectedAlbum.name;
    
    self.songs = [self.selectedAlbum.songs allObjects];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addSong:(id)sender
{
    
    Song  *newSong = [NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:self.selectedAlbum.managedObjectContext];
    
    newSong.name = self.songField.text;
    newSong.album = self.selectedAlbum;
    
    NSError *error;
    [self.selectedAlbum.managedObjectContext  save:&error];
    
    self.songs = [self.selectedAlbum.songs allObjects];
    [self.tableView reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _songs.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songCell"];
    
    Song *song = _songs[indexPath.row];
    
    cell.textLabel.text = song.name;
    
    return cell;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
