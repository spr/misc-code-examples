//
//  SPRTableViewController.m
//  StateRestorationExamples
//
//  Created by Scott Robertson on 1/13/14.
//  Copyright (c) 2014 Scott Robertson. All rights reserved.
//

#import "SPRTableViewController.h"

@interface SPRTableViewController () <UIViewControllerRestoration,UIDataSourceModelAssociation>

@property (nonatomic,readwrite,strong) NSArray *dataSource;

@end

#define kCellId @"Cell"

@implementation SPRTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _dataSource = @[@"First",
                        @"Second",
                        @"Third",
                        @"Fourth",
                        @"Fifth",
                        @"Sixth",
                        @"Seventh",
                        @"Eighth",
                        @"Nineth",
                        @"Tenth",
                        @"Eleventh",
                        @"Twelveth",
                        @"Thirteenth",
                        @"Fourteenth",
                        @"Fifteenth",
                        @"Sixteenth"];
        self.restorationClass = [self class];
        self.restorationIdentifier = NSStringFromClass([self class]);
        
        self.title = @"Table View";
    }
    return self;
}

#define kRestorationTableViewStyle @"TableViewStyle"

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder {
    // We need to know the style in advance before restoring
    NSInteger style = [coder decodeIntegerForKey:kRestorationTableViewStyle];
    UIViewController *vc = [[self alloc] initWithStyle:style];
    vc.restorationIdentifier = [identifierComponents lastObject];
    vc.restorationClass = self;
    return vc;
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    [coder encodeInteger:self.tableView.style forKey:kRestorationTableViewStyle];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    NSLog(@"%@: restoring state", self);
}

// These two functions are used to determine where in the table something is.
// Typically you'd grab a reference you could use to pull the object back out of
// Core Data and produce the row (even if elements have changed since).
- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx inView:(UIView *)view {
    NSLog(@"%@: Getting model id for %d", [self class], idx.row);
    return [NSString stringWithFormat:@"%d", idx.row];
}

- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view {
    NSInteger row = [identifier integerValue];
    NSLog(@"%@: Generating index for '%@'", [self class], identifier);
    return [NSIndexPath indexPathForRow:row inSection:1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // We have to add this line, otherwise the tableview won't try to preserve
    // its position and selected item.
    self.tableView.restorationIdentifier = NSStringFromClass([self.tableView class]);
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    return cell;
}

@end
