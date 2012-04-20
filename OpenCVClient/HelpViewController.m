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
    NSString *html = @"<body style=\"background-color: transparent;\"><h1>How the app works ?</h1><p>Click on Capture or select to load an image of a Hitori board then click on \"Recognise\" to process the image. After the processing is finished, the app will show you the recognised number. You will be able to modifiy the numbers that the app is not confidence of. You can click on play once you made sure that the numbers are correct. </p><h1>Hitori Rules</h1><p>Hitori is played with a grid of squares or cells, and each cell contains a number. The objective is to eliminate numbers by filling in the squares such that remaining cells do not contain numbers that appear more than once in either a given row or column.</p></body>";
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
