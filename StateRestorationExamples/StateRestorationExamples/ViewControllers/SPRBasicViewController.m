//
//  SPRBasicViewController.m
//  StateRestorationExamples
//
//  Created by Scott Robertson on 1/13/14.
//  Copyright (c) 2014 Scott Robertson. All rights reserved.
//

#import "SPRBasicViewController.h"

@interface SPRBasicViewController () <UIViewControllerRestoration>

@property (nonatomic,readwrite) NSUInteger tapCounter;

@end

/** A fully custom view controller that participates in state restoration
 */
@implementation SPRBasicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.restorationClass = [self class];
        self.restorationIdentifier = NSStringFromClass([self class]);
        _tapCounter = 0;
        
        self.title = @"Tapper";
    }
    return self;
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder {

    UIViewController *vc = nil;
    vc = [[self alloc] init];
    vc.restorationClass = self;
    vc.restorationIdentifier = [identifierComponents lastObject];
    
    return vc;
}

static NSString *kRestorationTapCounter = @"tapCounter";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    [coder encodeInteger:self.tapCounter forKey:kRestorationTapCounter];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    
    NSLog(@"%@: restoring state", self);
    self.tapCounter = [coder decodeIntegerForKey:kRestorationTapCounter];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Draw a big blue box
    UIView *box = [[UIView alloc] initWithFrame:CGRectInset(self.view.bounds, 40.f, 40.f)];
    box.backgroundColor = [UIColor blueColor];
    [self.view addSubview:box];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCounterAction:)];
    [box addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapCounterAction:(UITapGestureRecognizer *)tap {
    self.tapCounter += 1;
    NSLog(@"Tap counter is now: %lu", (unsigned long)self.tapCounter);
}

@end
