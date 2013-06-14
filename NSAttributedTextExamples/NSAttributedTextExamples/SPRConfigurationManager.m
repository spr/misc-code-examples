//
//  SPRConfigurationManager.m
//  NSAttributedTextExamples
//
//  Created by Scott Robertson on 5/19/13.
//  Copyright (c) 2013 Scott Robertson. All rights reserved.
//

#import "SPRConfigurationManager.h"

@implementation SPRConfigurationManager

+ (SPRConfigurationManager *)defaultManager {
    static SPRConfigurationManager *defaultManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultManager = [[SPRConfigurationManager alloc] init];
    });
    return defaultManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSParagraphStyle *defaultStyle = [NSParagraphStyle defaultParagraphStyle];
        
        _lineSpacing = defaultStyle.lineSpacing;
        _minLineHeight = defaultStyle.minimumLineHeight;
        _maxLineHeight = defaultStyle.maximumLineHeight;
        _paragraphSpacing = defaultStyle.paragraphSpacing;
        _lineHeightMultiple = defaultStyle.lineHeightMultiple;
        _fontSize = 14.0f;
        _fontName = @"HelveticaNeue";
    }
    return self;
}

- (NSDictionary *)settingsAsAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineSpacing = self.lineSpacing;
    paragraphStyle.minimumLineHeight = self.minLineHeight;
    paragraphStyle.maximumLineHeight = self.maxLineHeight;
    paragraphStyle.paragraphSpacing = self.paragraphSpacing;
    paragraphStyle.lineHeightMultiple = self.lineHeightMultiple;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    return @{NSFontAttributeName: [UIFont fontWithName:self.fontName size:self.fontSize], NSParagraphStyleAttributeName: paragraphStyle};
}

- (void)resetToDefaults {
    NSParagraphStyle *defaultStyle = [NSParagraphStyle defaultParagraphStyle];
    self.lineSpacing = defaultStyle.lineSpacing;
    self.minLineHeight = defaultStyle.minimumLineHeight;
    self.maxLineHeight = defaultStyle.maximumLineHeight;
    self.paragraphSpacing = defaultStyle.paragraphSpacing;
    self.lineHeightMultiple = defaultStyle.lineHeightMultiple;
    self.fontSize = 14.0f;
    self.fontName = @"HelveticaNeue";
}

- (void)changesComplete {
    [self.delegate configurationDidFinishUpdating:self];
}

@end
