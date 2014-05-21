//
//  SPRCustomViewController.m
//  StateRestorationExamples
//
//  Created by Scott Robertson on 5/20/14.
//  Copyright (c) 2014 Scott Robertson. All rights reserved.
//

#import "SPRCustomViewController.h"

#import "SPRCollectionViewController.h"

@interface SPRCustomViewController () <UIViewControllerRestoration>

@property (nonatomic,readwrite,strong) SPRCollectionViewController *cvc;

@end

@implementation SPRCustomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.restorationClass = [self class];
        self.restorationIdentifier = NSStringFromClass([self class]);
    }
    return self;
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder {

    UIViewController *vc = [[self alloc] init];
    vc.restorationClass = self;
    vc.restorationIdentifier = [identifierComponents lastObject];
    return vc;
}

static NSString *kRestorationCVCKey = @"CVC";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];

    [coder encodeObject:self.cvc forKey:kRestorationCVCKey];
}

// Child view controllers do not come back for free just because you encode
// them. Encoding them will trigger all the state restoration machinery,
// but it will not replace the programatically created versions for you.
//
// Instead you need to swap out the child view controllers that you wish to
// restore. 
- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];

    SPRCollectionViewController *newCVC = [coder decodeObjectForKey:kRestorationCVCKey];

    CGRect frame = self.cvc.view.frame;

    [self.cvc.view removeFromSuperview];
    [self.cvc removeFromParentViewController];

    [self addChildViewController:newCVC];
    [newCVC didMoveToParentViewController:self];
    newCVC.view.frame = frame;
    [self.view addSubview:newCVC.view];

    self.cvc = newCVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.cvc = [[SPRCollectionViewController alloc] init];
    [self addChildViewController:self.cvc];
    [self.cvc didMoveToParentViewController:self];

    CGRect bottomHalf, topHalf;
    CGRectDivide(self.view.bounds, &topHalf, &bottomHalf, CGRectGetHeight(self.view.bounds)/2, CGRectMinYEdge);

    self.cvc.view.frame = bottomHalf;

    [self.view addSubview:self.cvc.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
