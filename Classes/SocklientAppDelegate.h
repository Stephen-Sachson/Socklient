//
//  SocklientAppDelegate.h
//  Socklient
//
//  Created by Stephen on 9/20/12.
//  Copyright silicon valley 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SocklientViewController;

@interface SocklientAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SocklientViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SocklientViewController *viewController;

@end

