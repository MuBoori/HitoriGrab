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
#import <QuartzCore/QuartzCore.h>
@implementation PuzzleViewController
@synthesize ToolBar;
@synthesize itemButton;


@synthesize PuzzleAreaView;

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
- (IBAction)answerToPuzzle:(id)sender {
    for (int i =0; buttonTracker.count > i; i++) {
        
        for (int j = 0; buttonTracker.count > j; j++) {
            HitoriCell *tempCell = (HitoriCell*)[[hitoriInArray objectAtIndex:i] objectAtIndex:j];
            if (((UIButton*)[[buttonTracker objectAtIndex:i] objectAtIndex:j]).isHighlighted) {
                tempCell.Hidden = false;
                NSLog(@"Cell hidden at %d and %d", i, j);
            }else{
            
                tempCell.Hidden = true;
            }
            
        }
   
    }
     NSLog(@"button Clicked");
    HitoriRules * tempRules = [[HitoriRules alloc] init];
    tempRules.hitoriInArray = hitoriInArray;
}


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
    // grid view sits on top of the background image
    _gridView = [[AQGridView alloc] initWithFrame: self.view.bounds];
    _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _gridView.backgroundColor = [UIColor clearColor];
    _gridView.opaque = NO;
    _gridView.dataSource = self;
    _gridView.delegate = self;
    _gridView.scrollEnabled = NO;
    [self.view addSubview: _gridView];
    /////
  
    NSLog(@"YESSSS");
    DataAppDataObject* theDataObject = [self theAppDataObject];
    NSMutableArray *myArray = theDataObject.HitoriMatrix;

    hitoriInArray = myArray;
    buttonTracker = [[NSMutableArray alloc] init];
    for (int i =0; 8 > i; i++) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (int j = 0 ; 8 > j; j++) {
            //NSLog([[myArray objectAtIndex:i] objectAtIndex:j]);
            UIButton *label = [[UIButton alloc] initWithFrame:CGRectMake(40*j, 40*i, 35, 35)];
            HitoriCell *cellForGrid = (HitoriCell*)[[myArray objectAtIndex:i] objectAtIndex:j];
            NSString *tempTitle = [NSString stringWithFormat:@"%d",cellForGrid.number];
            NSLog(@"THis the number %d",myArray.count);
            [label setTitle:tempTitle forState:UIControlStateNormal] ;
            [label setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            label.backgroundColor = [UIColor whiteColor];
            
            ////
            CGRect rect = CGRectMake(0, 0, 1, 1);
            UIGraphicsBeginImageContext(rect.size);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(context,
                                           [[UIColor redColor] CGColor]);
            //  [[UIColor colorWithRed:222./255 green:227./255 blue: 229./255 alpha:1] CGColor]) ;
            CGContextFillRect(context, rect);
            UIImage *colorImg = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            ///
            [label setBackgroundImage:colorImg forState:UIControlStateSelected];
            label.layer.borderColor =  [UIColor blackColor].CGColor;

            label.selected = YES;
            label.highlighted = YES;
            //[label setHighlighted:true];
            //[label setText: [[myArray objectAtIndex:i] objectAtIndex:j]];
            label.tintColor = [UIColor redColor];
            [label addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            //[self.view addSubview:label];
            [PuzzleAreaView addSubview:label];
            [tempArray addObject:label];
            
            
            
        }
        [buttonTracker addObject:tempArray];
       

    }
    [self.view addSubview:PuzzleAreaView];
    [self.view addSubview:ToolBar];
    [super viewDidLoad];
}

- (DataAppDataObject*) theAppDataObject;
{
    
	id<AppDataObjectProtocol> theDelegate = (id<AppDataObjectProtocol>) [UIApplication sharedApplication].delegate;
	DataAppDataObject* theDataObject;
	theDataObject = (DataAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}
- (IBAction)ButtonClicked:(UIButton*)sender 
{
    [sender setHighlighted:!sender.isHighlighted];
    [sender setSelected:!sender.isSelected];
    
    //[sender setHighlighted:!sender.isHighlighted];
    /*
    if (sender.isHighlighted) {
        sender.highlighted = false;
        sender.selected = false;
    }else{
    
        sender.highlighted = true;
        sender.selected = true;
    }
     */
    
    NSLog(@"I was clicked");
    
    //[sender setSelected:!sender.isSelected];
    //[sender setHighlighted:!sender.isHighlighted];
    
}
- (void)viewDidUnload
{

    
    [self setPuzzleAreaView:nil];
    [self setAnswerButton:nil];
    [self setAnswerButton:nil];
    [self setItemButton:nil];
    [self setToolBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [PuzzleAreaView release];

    [itemButton release];
    [ToolBar release];
    [super dealloc];
}


- (IBAction)IsThatCorrect:(id)sender {
    for (int i =0; buttonTracker.count > i; i++) {
        NSLog(@"button Clicked");
        for (int j = 0; buttonTracker.count > j; j++) {
            HitoriCell *tempCell = (HitoriCell*)[[hitoriInArray objectAtIndex:i] objectAtIndex:j];
            if (!((UIButton*)[[buttonTracker objectAtIndex:i] objectAtIndex:j]).isHighlighted) {
                tempCell.Hidden = true;
                NSLog(@"Cell hidden at %d and %d", i, j);
            }else{
                
                tempCell.Hidden = false;
            }
            
        }
        
    }
    NSLog(@"button Clicked");
    HitoriRules * tempRules = [[HitoriRules alloc] init];
    tempRules.hitoriInArray = hitoriInArray;
    //tempRules.firstRule;
    //tempRules.secondRule;

    if (tempRules.secondRule && tempRules.thirdRule && tempRules.firstRule) {
        // todo
        NSLog(@"You Win");
        
        NSLog(@"You did not Win");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You Won" 
                                                        message:@"congratulation" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else {

        NSLog(@"You did not Win");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Solution is Wrong" 
                                                        message:@"Please check agian" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (IBAction)pleaseClick:(id)sender {
    
    NSLog(@"Please I clicked");
}
@end
