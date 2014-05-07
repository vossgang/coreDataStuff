//
//  AlbumViewController.m
//  CoreDataTest
//
//  Created by Matthew Voss on 5/7/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "AlbumViewController.h"
#import "SongViewController.h"

@interface AlbumViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *albumNameField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *albums;


@end

@implementation AlbumViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _albumNameField.delegate    = self;
    _tableView.delegate         = self;
    _tableView.dataSource       = self;
    
    self.title = [_selectedArtist fullName];
    self.albums = [self.selectedArtist.albums allObjects];

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addAlbum:(id)sender
{

    Album  *newAlbum = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:self.selectedArtist.managedObjectContext];
    
    newAlbum.name = self.albumNameField.text;
    newAlbum.artist = self.selectedArtist;
    
    NSError *error;
    [self.selectedArtist.managedObjectContext  save:&error];
    
    self.albums = [self.selectedArtist.albums allObjects];
    [self.tableView reloadData];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _albums.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"albumCell"];
    
    Album *album = _albums[indexPath.row];

    cell.textLabel.text = album.name;
    
    return cell;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goToSong"]) {
        SongViewController *dectVC  = segue.destinationViewController;
        NSIndexPath *indexPath      = [self.tableView indexPathForSelectedRow];
        dectVC.selectedAlbum        = self.albums[indexPath.row];
    }

}

@end
