//
//  HelpViewController.m
//  HitioriGrab
//
//  Created by Mujtaba Alboori on 10/03/2012.
//  Copyright (c) 2012 Aptogo Limited. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController
@synthesize HelpWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    HelpWebView.opaque = NO;
    HelpWebView.backgroundColor = [UIColor clearColor];
    NSString *html = @"<body style=\"background-color: transparent;\"><h1>Hitori Rules</h1><p>Hitori is played with a grid of squares or cells, and each cell contains a number. The objective is to eliminate numbers by filling in the squares such that remaining cells do not contain numbers that appear more than once in either a given row or column.</p></body>";
    [HelpWebView loadHTMLString:html baseURL:[NSURL URLWithString:@"http://localhost"]];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setHelpWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [HelpWebView release];
    [super dealloc];
}
@end
