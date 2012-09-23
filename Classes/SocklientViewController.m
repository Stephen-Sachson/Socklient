//
//  SocklientViewController.m
//  Socklient
//
//  Created by Stephen on 9/20/12.
//  Copyright silicon valley 2012. All rights reserved.
//
#import <CFNetwork/CFNetwork.h>
#import "SocklientViewController.h"
#import "AsyncSocket.h"


@implementation SocklientViewController

@synthesize addrField, prtField, msgField;
@synthesize cmmtView;
@synthesize textView, wrnView;



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	crtSock=[[AsyncSocket alloc] initWithDelegate:self];
	
	addrField.delegate=self;
	prtField.delegate=self;
	msgField.delegate=self;
	
	subviewAdded=NO;
}

- (void)viewWillAppear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowUp:)
												 name:UIKeyboardWillShowNotification 
											   object:self.view.window];
	[super viewWillAppear:animated];
}

//Move up the view so that the text field could be visible as keyboard shows up.
- (void)keyboardWillShowUp:(NSNotification *)notif {
	if(subviewAdded) {
		NSDictionary *info=[notif userInfo];
        NSValue *value=[info objectForKey:UIKeyboardBoundsUserInfoKey];
		
		CGRect rect=[value CGRectValue];
		
		float o=self.view.frame.size.height;
		float y=msgField.frame.origin.y;
		float h=msgField.frame.size.height;
		
		upAmount=rect.size.height-o+y+h+10.0f; //Calculate the amount to move up by.
		
		[UIView beginAnimations:@"up" context:nil];
		[UIView setAnimationDuration:0.3];
		
		CGRect viewFrame=self.view.frame;
		viewFrame.origin.y-=upAmount;
		self.view.frame=viewFrame;
		
		[UIView commitAnimations];
	}
	return;
}

- (void)switchView:(BOOL)foward {
	[UIView beginAnimations:@"swipe" context:nil];
	[UIView setAnimationDuration:0.5f];
	
	CGRect rect=self.view.frame;
	if(foward) {
		rect.origin.x-=320.0f;
		rect.size.width=rect.size.width*2;
	}
	else {
		rect.origin.x+=320.0f;
		rect.size.width=rect.size.width/2;
	}
	
	self.view.frame=rect;
	
	if (foward)
	    [self.view addSubview:cmmtView];
	else
		[cmmtView removeFromSuperview];
	
	[UIView commitAnimations];
}

- (void)scrollToBottom {
	CGPoint bottomOffset = CGPointMake(0, textView.contentSize.height - self.textView.bounds.size.height);
	
	if (bottomOffset.y>0) [textView setContentOffset:bottomOffset animated:YES];
}	

- (IBAction)connect {
	if (![addrField.text isEqualToString:@""]) {
		
		NSInteger port=[prtField.text intValue];
		NSError *error=nil;
		
		[crtSock connectToHost:addrField.text onPort:port error:&error];
	}
	else {
		wrnView.text=@"Waring: Host is required!";
		return;
	}
}

- (IBAction)sendTapped {
	NSString *message=[NSString stringWithFormat:@"%@\r\n",msgField.text];
	NSData *msgData=[message dataUsingEncoding:NSUTF8StringEncoding];
	
	[crtSock writeData:msgData withTimeout:-1 tag:1];
}

- (IBAction)disconnect {
	[crtSock disconnect];
	
	[self switchView:NO];
	
	wrnView.text=@"";
	subviewAdded=NO;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewWillDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification
												  object:nil];
	[super viewWillDisappear:animated];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[addrField release];
	[prtField release];
	[msgField release];
	[cmmtView release];
	[textView release];
	[wrnView release];
	[crtSock release];
	[msg release];
	
    [super dealloc];
}
#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if([textField isEqual:msgField]) {
		[self sendTapped];
		
		[UIView beginAnimations:@"up" context:nil];
		[UIView setAnimationDuration:0.3];
		
		CGRect viewFrame=self.view.frame;
		viewFrame.origin.y+=upAmount;
		self.view.frame=viewFrame;
		
		[UIView commitAnimations]; 
	}
	return [textField resignFirstResponder];
}
#pragma mark -
#pragma mark Socket Delegate
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
	cmmtView.frame=CGRectMake(320.0f, 0.0f, 320.0f, 480.0f);
	
	[self switchView:YES];
	
	subviewAdded=YES;
	
	textView.text=@"";
	textView.editable=NO;
	
	msg=[[NSMutableString alloc] initWithFormat:@""];
	
	[crtSock readDataWithTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
	
	NSString *incomeMsg=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	[msg appendFormat:@"%@",incomeMsg];
    
	textView.text=msg;
	
	[self scrollToBottom];
	
	[incomeMsg release];
    
	[crtSock readDataWithTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
	
	msgField.text=@"";
	
	[crtSock readDataWithTimeout:-1 tag:0];
}


@end
