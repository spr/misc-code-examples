//
//  SPRConfigurationManager.h
//  NSAttributedTextExamples
//
//  Created by Scott Robertson on 5/19/13.
//  Copyright (c) 2013 Scott Robertson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPRConfigurationManager;

@protocol ConfigurationManagerDelegate <NSObject>

- (void)configurationDidFinishUpdating:(SPRConfigurationManager *)configurationManager;

@optional

- (void)configurationDidUpdate:(SPRConfigurationManager *)configurationManager;

@end

@interface SPRConfigurationManager : NSObject

+ (SPRConfigurationManager *)defaultManager;

@property (nonatomic) CGFloat lineSpacing;
@property (nonatomic) CGFloat minLineHeight;
@property (nonatomic) CGFloat maxLineHeight;
@property (nonatomic) CGFloat paragraphSpacing;
@property (nonatomic) NSUInteger fontSize;
@property (nonatomic,strong) NSString *fontName;
@property (nonatomic) CGFloat lineHeightMultiple;

@property (nonatomic,weak) id<ConfigurationManagerDelegate> delegate;

- (NSDictionary *)settingsAsAttributes;
- (void)resetToDefaults;

- (void)changesComplete;

@end
