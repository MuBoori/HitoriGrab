//
//  PreviewViewController.m
//  OpenCVClient
//
//  Created by Mujtaba Alboori on 16/02/2012.
//  Copyright (c) 2012 Aptogo Limited. All rights reserved.
//

#import "PreviewViewController.h"
#import "AppDelegateProtocol.h"
#import "DataAppDataObject.h"

@implementation PreviewViewController
@synthesize ResultLabel;
@synthesize ConvertButton;
@synthesize SelectButton;
@synthesize captureButton;
@synthesize PreviewView;
@synthesize PreviewViewController;
@synthesize image = _image;
@synthesize newImage = _newImage;


@synthesize imgPicker = _imagePicker;
@synthesize CapturedImage = _CapturedImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    self.imgPicker = [[UIImagePickerController alloc] init];
    self.imgPicker.allowsEditing = FALSE;
    self.imgPicker.delegate = self; 
    //[[[imgPicker self] setDelegate: self];


    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
    NSLog(@"Got it");
    _image = img;
    [picker dismissModalViewControllerAnimated:NO];


    _CapturedImage.image = _image;
    //[[picker parentViewController] dismissModalViewControllerAnimated:NO];

    
    
}
- (IBAction)convertImage:(id)sender {
    
    NSLog(@"StartProccessing");
    [self processRawImage];
    NSLog(@"Finished");

}

-(void) viewDidAppear:(BOOL)animated
{

    
    
    _CapturedImage.image = _newImage;
    
}

-(void) processRawImage
{

    BoardExtractor *be = [[BoardExtractor alloc] init];
    


    _image = [self imageWithImage:_image scaledToSize:CGSizeMake(1152,1536)];
    cv::Mat matImage = [_image CVMat];
    [be setMat:matImage];
    [be makeProspective];
    [be readDigit];
   
    hitoriInArray = be.resultInArray;
    _newImage = [[UIImage alloc] initWithCVMat:be.imageFromMat];

    
    [ResultLabel setText:[be resultInString]];
    //NSMutableArray *myArray = [be.resultInArray objectAtIndex:0];

    //NSString *oneResult = [myArray objectAtIndex:0];
    
    //NSLog(oneResult);
        
    NSLog(@"Size of the array is %d",[be.resultInArray count]);
    NSMutableArray *myArray = [be.resultInArray objectAtIndex:1];
    NSLog(@"Size of the array is %d",[myArray count]);
    //NSLog([[be.resultInArray objectAtIndex:1] objectAtIndex:0]);

    trackButton = [[NSMutableArray alloc] init];
    
    for (int i =0; 8 > i; i++) {

        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (int j = 0 ; 8 > j; j++) {
            UIButton *label = [[UIButton alloc] initWithFrame:CGRectMake(40*j, 50*i, 30, 30)];
            HitoriCell *tempCell = ((HitoriCell*)[[be.resultInArray objectAtIndex:i] objectAtIndex:j]);
            NSString *tempTitle = tempCell.NumberAsString;
            [label setTitle: tempTitle forState:UIControlStateNormal];
            if (tempCell.confidence < 75) {
                [label setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                label.selected = YES;
                label.highlighted = YES;
                /////
                CGRect rect = CGRectMake(0, 0, 1, 1);
                UIGraphicsBeginImageContext(rect.size);
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextSetFillColorWithColor(context,
                                               [[UIColor blueColor] CGColor]);
                //  [[UIColor colorWithRed:222./255 green:227./255 blue: 229./255 alpha:1] CGColor]) ;
                CGContextFillRect(context, rect);
                UIImage *colorImg = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //
                [label setBackgroundImage:colorImg forState:UIControlStateHighlighted];
                [label setBackgroundImage:colorImg forState:UIControlStateSelected];
                [label addTarget:self action:@selector(ButtonHighlited:) forControlEvents:UIControlStateHighlighted];
            }else{
           
                [label setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }

            [self.view addSubview:label];
            [tempArray addObject:label];

        }
        [trackButton addObject:tempArray];
        
          } 
    
     	
    DataAppDataObject* theDataObject = [self theAppDataObject];
    theDataObject.HitoriMatrix = be.resultInArray;
    //[be release];
     _CapturedImage.image = _newImage;
    
}
- (IBAction)DoStuff:(id)sender {
    NSLog(@"Cool shit");
    self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imgPicker.showsCameraControls = YES;
    //self.imgPicker.cameraViewTransform = YES;
    self.imgPicker.showsCameraControls = YES;
    [self presentModalViewController:self.imgPicker animated:YES];


}
- (IBAction)SelectAPicture:(id)sender {
    
    self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:self.imgPicker animated:YES];
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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    NSLog(@"Yahoo I did load ");
    [self setCaptureButton:nil];
    [self setPreviewView:nil];
    [self setPreviewViewController:nil];
    [self setCapturedImage:nil];
    [self setConvertButton:nil];
    [self setResultLabel:nil];
    [self setSelectButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)changeNo:(UIBarButtonItem*)sender {
 
    NSLog(@"I'm clicked %@", sender.title);

    for (int i = 0; trackButton.count > i; i++) {
        for (int j = 0; trackButton.count > j; j++) {
        UIButton *tempButton = (UIButton*)[[trackButton objectAtIndex:i] objectAtIndex:j];
        if(!tempButton.highlighted){
            [tempButton setTitle:sender.title forState:UIControlStateNormal];
            HitoriCell *tempCell = [[hitoriInArray objectAtIndex:i] objectAtIndex:j];
            tempCell.number=[sender.title intValue];
            tempCell.NumberAsString = sender.title;
            [[hitoriInArray objectAtIndex:i]setObject:tempCell atIndex:j];
            tempButton.highlighted = true;
        
        }     
        }
    }

}

- (IBAction)ButtonHighlited:(UIButton*)sender 
{
    
    for (int i = 0; trackButton.count > i; i++) {
        for (int j = 0; trackButton.count > j; j++) {
            
            UIButton *tempButton = (UIButton*)[[trackButton objectAtIndex:i] objectAtIndex:j];
            tempButton.highlighted = true;
        }

       
    }
     sender.highlighted = false;

}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}

- (DataAppDataObject*) theAppDataObject;
{
    
	id<AppDataObjectProtocol> theDelegate = (id<AppDataObjectProtocol>) [UIApplication sharedApplication].delegate;
	DataAppDataObject* theDataObject;
	theDataObject = (DataAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}

- (void)dealloc {
    [captureButton release];
    [PreviewView release];
    [PreviewViewController release];
    [_CapturedImage release];
    [ConvertButton release];
    [ResultLabel release];
    [SelectButton release];

    [super dealloc];
}
@end
