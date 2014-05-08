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
#import "SearchView.h"
#import "StyleKit.h"

@interface MVViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) NSManagedObjectContext *objectContext;
@property (nonatomic, strong) NSArray *labels;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//search functionality
@property (nonatomic, strong) SearchView *searchView;
@property (nonatomic, strong) UITextField *searchField;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) UIView *backgroundGradient;

@end

@implementation MVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //search view setup
    _searchView = [[SearchView alloc] initWithFrame:CGRectMake(0, 65, 318, 100)];
    _searchView.alpha = 0;
    _searchView.backgroundColor = [UIColor clearColor];
    _searchField = [[UITextField alloc] initWithFrame:CGRectMake(40, 27, _searchView.frame.size.width * .65, _searchView.frame.size.height * .5)];
    
    [_searchView addSubview:_searchField];
    [self.view addSubview:_searchView];
    _searchView.transform = CGAffineTransformMakeScale(1.4, 1.4);

    //establish searchbar behavior
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchDataBase) name:UITextFieldTextDidChangeNotification object:nil];
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    MVAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    [appDelegate createManagedObjectContextWithCompletion:^(NSManagedObjectContext *conxtext) {
        self.objectContext = conxtext;
        
        [self fetchResults:self];
    }];
    
    self.title = @"Labels";
    
    self.tableView.delegate = self;
    self.tableView.dataSource  = self;
}

-(void)searchDataBase {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Label"];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(name CONTAINS[cd] %@)", _searchField.text];
    
    NSError *error;
    
    _labels = [self.objectContext executeFetchRequest:fetchRequest error:&error];
    
    if (_labels.count) {
        _searchView.isValidInput = YES;
    } else {
        _searchView.isValidInput = NO;
    }
    
    [_tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [UIView animateWithDuration:.75 animations:^{
        _searchView.alpha = 1;
        _searchView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
    
    [UIView animateWithDuration:1 animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
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
    
    NSSortDescriptor *sortdesc = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    
    [fetchRequest setSortDescriptors:@[sortdesc]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.objectContext sectionNameKeyPath:nil cacheName:nil];
    
    self.fetchedResultsController.delegate = self;
    
    NSError *error;
    
    [self.fetchedResultsController performFetch:&error];
    
//    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name = %@",  @"Lolipopcorn"];
//    NSError *error;
//    self.labels = [self.objectContext executeFetchRequest:fetchRequest error:&error];
    NSLog(@"number of labels: %ld", (unsigned long)self.labels.count);
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"labelCell"];
    
//    cell.backgroundColor = [UIColor clearColor];
//    Label *label = self.labels[indexPath.row];
//    cell.textLabel.text = label.name;
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
    
}

//dismiss keyboard when anything is touched
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIControl *control in self.view.subviews) {
        if ([control isKindOfClass:[UITextField class]] || [control isKindOfClass:[UITextView class]] ) {
            [control endEditing:YES];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goToArtist"]) {
        ArtistsViewController *dectVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        dectVC.selectedLabel = self.labels[indexPath.row];
    }
}

- (IBAction)addLabel:(id)sender
{
    Label *label = [NSEntityDescription insertNewObjectForEntityForName:@"Label" inManagedObjectContext:self.objectContext];
    label.name = @"Awesome";
}

/*
 Assume self has a property 'tableView' -- as is the case for an instance of a UITableViewController
 subclass -- and a method configureCell:atIndexPath: which updates the contents of a given cell
 with information from a managed object at the given index path in the fetched results controller.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [object valueForKey:@"name"];
}

@end
