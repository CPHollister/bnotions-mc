//
//  ShellViewController.m
//  BNotions-MC
//
//  Created by Kyle Brooks on 2013-07-15.
//  Copyright (c) 2013 Kyle Brooks Inc. All rights reserved.
//

#import "ShellViewController.h"

#import "Constants.h"
#import "FHSTwitterEngine.h"
#import "Shell.h"

@interface ShellViewController ()

@end

@implementation ShellViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];    
}

#pragma mark - Twitter Login
-(void) promptTwitterLogin
{
    if( ![[FHSTwitterEngine sharedEngine]isAuthorized] ) {
        
        [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:OAUTH_TWITTER_ACCESS_KEY andSecret:OAUTH_TWITTER_SECRET];
        
        [[FHSTwitterEngine sharedEngine]showOAuthLoginControllerFromViewController:self withCompletion:^(BOOL success) {
            if (success) {
                [self performSelector:@selector(onTwitterLoginSuccess) withObject:self.view afterDelay:2.0];
            } else {
                 [self performSelector:@selector(onLoginFail) withObject:self.view afterDelay:2.0];
            }
        }];
    }
}

- (void) onLoginFail
{
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"ERROR" message:@"You Must Login with Twitter to use this App." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    [alertView show];
}

- (void) onTwitterLoginSuccess
{
    [(Shell *)self.view onTwitterLoginSuccess];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation == UIInterfaceOrientationPortrait)
        return YES;
    
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
