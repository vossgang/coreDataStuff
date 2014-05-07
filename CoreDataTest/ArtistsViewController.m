//
//  ArtistsViewController.m
//  CoreDataTest
//
//  Created by Matthew Voss on 5/7/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "ArtistsViewController.h"
#import "Artist.h"
#import "AlbumViewController.h"

@interface ArtistsViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *genreField;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *artists;
@end

@implementation ArtistsViewController

- (IBAction)saveBUtton:(id)sender
{
    Artist  *newArtist = [NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:self.selectedLabel.managedObjectContext];
    
    newArtist.firstName = self.firstNameField.text;
    newArtist.lastName = self.lastNameField.text;
    newArtist.genre = self.genreField.text;
    newArtist.label = self.selectedLabel;
    NSError *error;
    [self.selectedLabel.managedObjectContext  save:&error];
    
    self.artists = [self.selectedLabel.artists allObjects];
    [self.tableView reloadData];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.firstNameField.delegate = self;
    self.lastNameField.delegate = self;
    self.genreField.delegate = self;
    
    
    self.artists = [self.selectedLabel.artists allObjects];
    
    self.title = _selectedLabel.name;
    
    
    // Do any additional setup after loading the view.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"artistCell"];
    
    Artist *artist = self.artists[indexPath.row];
    
    cell.textLabel.text = [artist fullName];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.artists.count;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goToAlbum"]) {
        AlbumViewController *dectVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        dectVC.selectedArtist= self.artists[indexPath.row];
    }
}

@end
