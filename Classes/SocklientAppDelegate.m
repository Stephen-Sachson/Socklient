//
//  SocklientAppDelegate.m
//  Socklient
//
//  Created by Stephen on 9/20/12.
//  Copyright silicon valley 2012. All rights reserved.
//

#import "SocklientAppDelegate.h"
#import "SocklientViewController.h"

@implementation SocklientAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
