//
//  SPRViewController.h
//  NSAttributedTextExamples
//
//  Created by Scott Robertson on 5/19/13.
//  Copyright (c) 2013 Scott Robertson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPRViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *oneLineLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLineLabel;
@property (weak, nonatomic) IBOutlet UILabel *manyLinesLabel;
@property (weak, nonatomic) IBOutlet UITextView *manyLinesTextView;

@end
