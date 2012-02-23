//
//  PuzzleViewController.m
//  OpenCVClient
//
//  Created by Mujtaba Alboori on 18/02/2012.
//  Copyright (c) 2012 Aptogo Limited. All rights reserved.
//

#import "PuzzleViewController.h"
#import "DataAppDataObject.h"
#import "AppDelegateProtocol.h"
@implementation PuzzleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    /*
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 200, 100)];
    label.text = @"Hello";
    [self.view addSubview:label];
    [self.view addSubview:label];
    [self.view addSubview:label];
    [self.view addSubview:label];
    [self.view addSubview:label];
    [self.view addSubview:label];
    for (int i = 0 ; i< 10 ; i++) {
        UITextField *label = [[UITextField alloc] initWithFrame:CGRectMake(20*i, 20*i, 100, 100)];
        [label setText: @"Hello" ];
        [self.view addSubview:label];
    }
    
    */
  
    NSLog(@"YESSSS");
    DataAppDataObject* theDataObject = [self theAppDataObject];
    NSMutableArray *myArray = theDataObject.HitoriMatrix;
    
    for (int i =0; 8 > i; i++) {
        for (int j = 0 ; 8 > j; j++) {
            NSLog([[myArray objectAtIndex:i] objectAtIndex:j]);
            UITextField *label = [[UITextField alloc] initWithFrame:CGRectMake(40*j, 60*i, 30, 30)];
            [label setText: [[myArray objectAtIndex:i] objectAtIndex:j]];
            label.textColor = [UIColor redColor];
            [self.view addSubview:label];
        }
    }
    [super viewDidLoad];
}

- (DataAppDataObject*) theAppDataObject;
{
    
	id<AppDataObjectProtocol> theDelegate = (id<AppDataObjectProtocol>) [UIApplication sharedApplication].delegate;
	DataAppDataObject* theDataObject;
	theDataObject = (DataAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
