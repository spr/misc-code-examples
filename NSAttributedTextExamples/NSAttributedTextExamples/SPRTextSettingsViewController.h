//
//  SPRTextSettingsViewController.h
//  NSAttributedTextExamples
//
//  Created by Scott Robertson on 5/19/13.
//  Copyright (c) 2013 Scott Robertson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPRTextSettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIStepper *fontSizeStepper;
@property (weak, nonatomic) IBOutlet UILabel *fontSizeDisplay;
@property (weak, nonatomic) IBOutlet UISlider *lineSpacingSlider;
@property (weak, nonatomic) IBOutlet UILabel *lineSpacingDisplay;
@property (weak, nonatomic) IBOutlet UISlider *minLineHeightSlider;
@property (weak, nonatomic) IBOutlet UILabel *minLineHeightDisplay;
@property (weak, nonatomic) IBOutlet UISlider *maxLineHeightSlider;
@property (weak, nonatomic) IBOutlet UILabel *maxLineHeightDisplay;
@property (weak, nonatomic) IBOutlet UISlider *paragraphSpacingSlider;
@property (weak, nonatomic) IBOutlet UILabel *paragraphSpacingDisplay;
@property (weak, nonatomic) IBOutlet UILabel *lineHeightMultipleDisplay;
@property (weak, nonatomic) IBOutlet UISlider *lineHeightMultipleSlider;

- (IBAction)resetToDefaults:(id)sender;
- (IBAction)fontSizeChanged:(id)sender;
- (IBAction)lineSpacingChanged:(id)sender;
- (IBAction)minLineHeightChanged:(id)sender;
- (IBAction)maxLineHeightChanged:(id)sender;
- (IBAction)paragraphSpacingChanged:(id)sender;
- (IBAction)lineHeightMultipleChanged:(id)sender;

@end
