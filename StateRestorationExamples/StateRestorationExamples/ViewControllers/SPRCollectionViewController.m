//
//  SPRCollectionViewController.m
//  StateRestorationExamples
//
//  Created by Scott Robertson on 1/19/14.
//  Copyright (c) 2014 Scott Robertson. All rights reserved.
//

#import "SPRCollectionViewController.h"

@interface SPRCollectionViewController () <UIViewControllerRestoration>

@property (nonatomic,readwrite,strong) NSArray *colors;

@end

@implementation SPRCollectionViewController

- (id)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(90.f, 90.f);
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        _colors = @[[UIColor redColor],
                    [UIColor orangeColor],
                    [UIColor yellowColor],
                    [UIColor greenColor],
                    [UIColor cyanColor],
                    [UIColor blueColor],
                    [UIColor magentaColor],
                    [UIColor purpleColor]];

        // This is the only thing you need to set beyond the class's
        // restorationIdentifier.
        //
        // If you leave this out, you will have to do all the state
        // restoration manually.
        self.collectionView.restorationIdentifier = NSStringFromClass([self.collectionView class]);
    }
    return self;
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    return [self init];
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder {
    
    UIViewController *vc = [[self alloc] init];
    vc.restorationClass = self;
    vc.restorationIdentifier = [identifierComponents lastObject];

    NSLog(@"Created %@", vc);

    return vc;
}

// UICollectionViewControllers don't need an explict implementation of these
// by default. However, if you have custom data that needs to be stored
// between launches, you'll need to add them.

//- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
//    [super encodeRestorableStateWithCoder:coder];
//
//    // Your code here
//}
//
//- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
//    [super decodeRestorableStateWithCoder:coder];
//
//    // Your code here
//}

// The UICollectionViewController has a default implementation of these that
// will properly encode the current indexPath's as needed.
// However, if you data model can change between launches of the app
// You'll need a custom implementation.
//
// Don't forget to add the UIDataSourceModelAssociation protocol as well.

//- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx inView:(UIView *)view {
//    return nil;
//}
//
//- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view {
//    return nil;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = self.colors[indexPath.row % self.colors.count];

    UIView *selection = [[UIView alloc] initWithFrame:CGRectInset(cell.bounds, -5, -5)];
    selection.backgroundColor = [UIColor whiteColor];

    cell.selectedBackgroundView = selection;
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

@end
