//
//  SPRVCSelectionViewController.m
//  StateRestorationExamples
//
//  Created by Scott Robertson on 1/19/14.
//  Copyright (c) 2014 Scott Robertson. All rights reserved.
//

#import "SPRVCSelectionViewController.h"

#import "SPRBasicViewController.h"
#import "SPRTableViewController.h"
#import "SPRCollectionViewController.h"

@interface SPRVCSelectionViewController () <UIViewControllerRestoration>

@end

@implementation SPRVCSelectionViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
    }
    return self;
}

- (id)init {
    return [self initWithStyle:UITableViewStylePlain];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"Pick A VC";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder {
    UIViewController *vc = [[self alloc] init];
    vc.restorationClass = self;
    vc.restorationIdentifier = [identifierComponents lastObject];
    return vc;
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
    return 3;
}

- (NSString *)titleForRow:(NSInteger)row {
    NSString *title = nil;
    switch (row) {
        case 0:
            title = @"Basic";
            break;
        case 1:
            title = @"Table View Controller";
            break;
        case 2:
            title = @"Collection View Controller";
            break;
        default:
            title = @"Unknown";
            break;
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = [self titleForRow:indexPath.row];
    
    return cell;
}

- (UIViewController *)viewControllerForRow:(NSInteger)row {
    UIViewController *vc = nil;
    switch (row) {
        case 0:
            vc = [[SPRBasicViewController alloc] init];
            break;
        case 1:
            vc = [[SPRTableViewController alloc] initWithStyle:UITableViewStylePlain];
            break;
        case 2:
            vc = [[SPRCollectionViewController alloc] init];
            break;
        default:
            NSLog(@"ERROR: NEED TO SET A VC");
            break;
    }
    return vc;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc = [self viewControllerForRow:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
