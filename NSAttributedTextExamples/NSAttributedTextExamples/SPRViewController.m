//
//  SPRViewController.m
//  NSAttributedTextExamples
//
//  Created by Scott Robertson on 5/19/13.
//  Copyright (c) 2013 Scott Robertson. All rights reserved.
//

#import "SPRViewController.h"

#import "SPRConfigurationManager.h"

@interface SPRViewController () <ConfigurationManagerDelegate>

@property (nonatomic,strong) NSString *theBody;

@end

@implementation SPRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    SPRConfigurationManager *config = [SPRConfigurationManager defaultManager];
    config.delegate = self;
    
    self.theBody = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent tristique, arcu a tristique cursus, neque nisi pellentesque urna, a facilisis mauris augue vitae purus. Ut mollis dignissim rutrum. Phasellus eu enim sed mi facilisis fermentum eget et tortor. Morbi eros lacus, tempor id rutrum vitae, congue in nisl. Etiam consequat pellentesque sem, sed pellentesque mauris iaculis ut. Donec eu orci a sapien mollis commodo pulvinar sed sapien. Vivamus pharetra, tortor id suscipit hendrerit, lorem turpis consectetur metus, id varius tellus lectus eu tellus. Etiam commodo libero quis eros iaculis vel elementum mi feugiat. Sed luctus massa odio, et tempus lacus. Praesent nec nisi at erat lacinia aliquet eget at sapien.\nPraesent in leo ipsum. Pellentesque porttitor enim sed orci rutrum aliquet. Donec dapibus magna quis risus congue sollicitudin auctor dui hendrerit. Nunc convallis pharetra mollis. Maecenas rhoncus justo non enim volutpat sodales. Nam mollis, metus vel auctor ullamcorper, mi orci eleifend neque, a bibendum nisl quam vel velit. Suspendisse quis ullamcorper massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aliquam in lectus nisi. Suspendisse adipiscing cursus volutpat. Sed et suscipit risus. Nullam et nibh non sem auctor consectetur.\nPhasellus ut neque quam, ac sodales magna. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Sed hendrerit pellentesque suscipit. Integer lacinia arcu in est suscipit non aliquet est dapibus. Nulla nec odio magna, pulvinar varius tellus. Quisque id congue erat. In lectus lorem, convallis eget sollicitudin a, pulvinar ut sem. Maecenas id massa est, vel pretium justo. In hac habitasse platea dictumst. Etiam aliquet bibendum iaculis.\nVestibulum iaculis tempor ante eu accumsan. Nulla imperdiet blandit tempus. Curabitur eu sodales tellus. Maecenas id dictum arcu. Duis felis risus, cursus sed scelerisque sed, tincidunt eu dui. Duis ut rhoncus eros. Mauris fermentum sapien vel justo pellentesque eget dictum justo sagittis. Quisque feugiat ante dignissim justo tincidunt nec dictum mauris porta. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Mauris mattis adipiscing diam non aliquet. Cras gravida ipsum vel lorem tempus id pharetra neque faucibus. Nullam pharetra elementum quam.\nFusce pharetra sem non nibh consectetur sed viverra lectus viverra. Proin neque ante, posuere non scelerisque eget, pulvinar nec eros. Proin interdum urna at dolor consectetur eu vehicula massa euismod. Duis sodales dictum rutrum. Etiam quis purus tellus. Proin ullamcorper euismod faucibus. Mauris vitae nulla velit. Integer interdum sollicitudin dolor, ut ultricies quam dictum non. Suspendisse eget ornare sem. Maecenas feugiat mauris id sem aliquam sit amet ultricies lectus tempus. Donec at risus velit, eget convallis libero. Sed lacus quam, fringilla sit amet consequat at, lacinia non sem. Quisque sed ipsum vel est eleifend tincidunt. Phasellus mauris sem, lacinia ullamcorper viverra nec, ultrices et nulla.\nNulla auctor cursus dui quis porta. Aenean nec justo non felis interdum tincidunt et quis sem. Pellentesque pulvinar odio ut nunc sollicitudin pretium. Pellentesque vitae sapien augue, id scelerisque nunc. Curabitur eleifend ullamcorper arcu in lacinia. Ut fermentum, risus id euismod ultrices, felis odio laoreet metus, ac egestas neque tellus vitae dolor. Donec tristique neque eget mauris dignissim egestas. Donec aliquam ultrices sem, at tristique tellus dapibus eu. Phasellus ut lectus et purus convallis auctor. Donec erat dolor, sodales sit amet dapibus a, dapibus nec turpis. Ut ut est lorem.\n\nSed viverra mollis erat. Proin rutrum dictum lacus, nec volutpat ante fermentum quis. Donec dictum vestibulum nisl ac tincidunt. Integer volutpat metus sit amet mauris adipiscing consequat. Pellentesque quis ante ante, nec fringilla ligula. Aliquam gravida purus ut ipsum tempor non accumsan urna gravida. Mauris convallis justo vel mauris pharetra eget semper leo lobortis. Etiam cursus bibendum elit, ut euismod risus molestie eu. Donec convallis aliquet est, quis rutrum turpis dictum vel. In eleifend scelerisque neque in tincidunt. In ultricies auctor diam, id dignissim urna interdum eget. Cras varius hendrerit quam varius placerat. Nullam imperdiet felis quis quam tempus vulputate. Nullam laoreet luctus hendrerit. Sed sit amet tellus elit. In leo eros, pellentesque lobortis vehicula et, varius at ante.";
    
    NSAttributedString *attributedBody = [[NSAttributedString alloc] initWithString:self.theBody attributes:[config settingsAsAttributes]];
    
    self.oneLineLabel.attributedText = attributedBody;
    self.twoLineLabel.attributedText = attributedBody;
    self.manyLinesLabel.attributedText = attributedBody;
    self.manyLinesTextView.attributedText = attributedBody;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configurationDidFinishUpdating:(SPRConfigurationManager *)configurationManager {
    NSAttributedString *attributedBody = [[NSAttributedString alloc] initWithString:self.theBody attributes:[configurationManager settingsAsAttributes]];
    self.oneLineLabel.attributedText = attributedBody;
    self.twoLineLabel.attributedText = attributedBody;
    self.manyLinesLabel.attributedText = attributedBody;
    self.manyLinesTextView.attributedText = attributedBody;
    [self.view setNeedsDisplay];
}

@end
