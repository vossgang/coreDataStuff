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

@interface MVViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, weak) NSManagedObjectContext *objectContext;
@property (nonatomic, strong) NSArray *labels;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//search functionality
@property (nonatomic, strong) SearchView *searchView;
@property (nonatomic, strong) UITextField *searchField;

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
//    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name = %@",  @"Lolipopcorn"];
    NSError *error;
    self.labels = [self.objectContext executeFetchRequest:fetchRequest error:&error];
    NSLog(@"number of labels: %ld", (unsigned long)self.labels.count);
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.labels.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"labelCell"];
    
    cell.backgroundColor = [UIColor clearColor];
    Label *label = self.labels[indexPath.row];
    cell.textLabel.text = label.name;
    
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


@end
