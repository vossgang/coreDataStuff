//
//  MVViewController.m
//  CoreDataTest
//
//  Created by Matthew Voss on 5/7/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "MVViewController.h"
#import "MVAppDelegate+CoreDataContext.h"
#import "Label.h"
#import "ArtistsViewController.h"

@interface MVViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) NSManagedObjectContext *objectContext;
@property (nonatomic, strong) NSArray *labels;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MVAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    [appDelegate createManagedObjectContextWithCompletion:^(NSManagedObjectContext *conxtext) {
        self.objectContext = conxtext;
        
        [self fetchResults:self];
    }];
    
    self.title = @"Lables";
    
    self.tableView.delegate = self;
    self.tableView.dataSource  = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)seedData:(id)sender
{
    Label *rapLabel = [NSEntityDescription insertNewObjectForEntityForName:@"Label" inManagedObjectContext:self.objectContext];
    rapLabel.name = @"Bros 4 Lyfe";
    
    Label *countryLabel = [NSEntityDescription insertNewObjectForEntityForName:@"Label" inManagedObjectContext:self.objectContext];
    countryLabel.name = @"Country Label";
    
    Label *popLabel = [NSEntityDescription insertNewObjectForEntityForName:@"Label" inManagedObjectContext:self.objectContext];
    popLabel.name = @"Lolipopcorn";

    NSError *error;
    [self.objectContext save:&error];
    if (error) { NSLog(@"Error: %@", error.localizedDescription); }
}

- (IBAction)fetchResults:(id)sender
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Label"];
//    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name = %@",  @"Lolipopcorn"];
    NSError *error;
    self.labels = [self.objectContext executeFetchRequest:fetchRequest error:&error];
    NSLog(@"number of labels: %ld", self.labels.count);
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.labels.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"labelCell"];
    
    Label *label = self.labels[indexPath.row];
    cell.textLabel.text = label.name;
    
    return cell;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goToArtist"]) {
        ArtistsViewController *dectVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        dectVC.selectedLabel = self.labels[indexPath.row];
    }
}

@end
