//
//  SocklientViewController.h
//  Socklient
//
//  Created by Stephen on 9/20/12.
//  Copyright silicon valley 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AsyncSocket;

@interface SocklientViewController : UIViewController <UITextFieldDelegate>{
	AsyncSocket *crtSock;
	BOOL subviewAdded;
	IBOutlet UITextField *addrField, *prtField, *msgField;
    IBOutlet UIView *cmmtView;
	IBOutlet UITextView *textView, *wrnView;
	
@private
	NSMutableString *msg;
	float upAmount;
}
@property (nonatomic, retain)UITextField *addrField, *prtField, *msgField;
@property (nonatomic, retain)UIView *cmmtView;
@property (nonatomic, retain)UITextView *textView, *wrnView;

- (IBAction)connect;
- (IBAction)sendTapped;
- (IBAction)disconnect;

@end

