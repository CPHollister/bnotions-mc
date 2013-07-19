//
//  AppDelegate.h
//  BNotions-MC
//
//  Created by Kyle Brooks on 2013-07-15.
//  Copyright (c) 2013 Kyle Brooks Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShellViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) ShellViewController *rootViewController;


@end
