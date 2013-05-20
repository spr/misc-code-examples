//
//  SPRTextSettingsViewController.m
//  NSAttributedTextExamples
//
//  Created by Scott Robertson on 5/19/13.
//  Copyright (c) 2013 Scott Robertson. All rights reserved.
//

#import "SPRTextSettingsViewController.h"

#import "SPRConfigurationManager.h"

#define FLOAT_STRING(_val_) [NSString stringWithFormat:@"%.1f", _val_]

@interface SPRTextSettingsViewController ()

@end

@implementation SPRTextSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    SPRConfigurationManager *config = [SPRConfigurationManager defaultManager];
    self.fontSizeStepper.value = config.fontSize;
    self.fontSizeDisplay.text = [NSString stringWithFormat:@"%d", config.fontSize];
    self.lineSpacingSlider.value = config.lineSpacing;
    self.lineSpacingDisplay.text = FLOAT_STRING(config.lineSpacing);
    self.minLineHeightSlider.value = config.minLineHeight;
    self.minLineHeightDisplay.text = FLOAT_STRING(config.minLineHeight);
    self.maxLineHeightSlider.value = config.maxLineHeight;
    self.maxLineHeightDisplay.text = FLOAT_STRING(config.maxLineHeight);
    self.paragraphSpacingSlider.value = config.paragraphSpacing;
    self.paragraphSpacingDisplay.text = FLOAT_STRING(config.paragraphSpacing);
    self.lineHeightMultipleSlider.value = config.lineHeightMultiple;
    self.lineHeightMultipleDisplay.text = FLOAT_STRING(config.lineHeightMultiple);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    SPRConfigurationManager *config = [SPRConfigurationManager defaultManager];
    [config changesComplete];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resetToDefaults:(id)sender {
    SPRConfigurationManager *config = [SPRConfigurationManager defaultManager];
    [config resetToDefaults];
    self.fontSizeStepper.value = config.fontSize;
    self.fontSizeDisplay.text = [NSString stringWithFormat:@"%d", config.fontSize];
    self.lineSpacingSlider.value = config.lineSpacing;
    self.lineSpacingDisplay.text = FLOAT_STRING(config.lineSpacing);
    self.minLineHeightSlider.value = config.minLineHeight;
    self.minLineHeightDisplay.text = FLOAT_STRING(config.minLineHeight);
    self.maxLineHeightSlider.value = config.maxLineHeight;
    self.maxLineHeightDisplay.text = FLOAT_STRING(config.maxLineHeight);
    self.paragraphSpacingSlider.value = config.paragraphSpacing;
    self.paragraphSpacingDisplay.text = FLOAT_STRING(config.paragraphSpacing);
    self.lineHeightMultipleSlider.value = config.lineHeightMultiple;
    self.lineHeightMultipleDisplay.text = FLOAT_STRING(config.lineHeightMultiple);
}

- (IBAction)fontSizeChanged:(UIStepper *)sender {
    [SPRConfigurationManager defaultManager].fontSize = sender.value;
    self.fontSizeDisplay.text = [NSString stringWithFormat:@"%d", (NSUInteger)sender.value];
}

- (IBAction)lineSpacingChanged:(UISlider *)sender {
    [SPRConfigurationManager defaultManager].lineSpacing = sender.value;
    self.lineSpacingDisplay.text = FLOAT_STRING(sender.value);
}

- (IBAction)minLineHeightChanged:(UISlider *)sender {
    [SPRConfigurationManager defaultManager].minLineHeight = sender.value;
    self.minLineHeightDisplay.text = FLOAT_STRING(sender.value);
}

- (IBAction)maxLineHeightChanged:(UISlider *)sender {
    [SPRConfigurationManager defaultManager].maxLineHeight = sender.value;
    self.maxLineHeightDisplay.text = FLOAT_STRING(sender.value);
}

- (IBAction)paragraphSpacingChanged:(UISlider *)sender {
    [SPRConfigurationManager defaultManager].paragraphSpacing = sender.value;
    self.paragraphSpacingDisplay.text = FLOAT_STRING(sender.value);
}

- (IBAction)lineHeightMultipleChanged:(UISlider *)sender {
    [SPRConfigurationManager defaultManager].lineHeightMultiple = sender.value;
    self.lineHeightMultipleDisplay.text = FLOAT_STRING(sender.value);
}

@end
