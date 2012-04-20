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
//@synthesize ResultLabel;
@synthesize ConvertButton;
@synthesize SelectButton;
@synthesize PlayButton;
@synthesize maskViewImage;
@synthesize captureButton;
@synthesize PreviewView;
@synthesize PreviewViewController;
@synthesize image = _image;
@synthesize newImage = _newImage;
@synthesize point1Button;
@synthesize point2Buttion;
@synthesize point3Button;
@synthesize point4Button;


@synthesize imgPicker = _imagePicker;
@synthesize CapturedImage = _CapturedImage;

const int smallImageWidth = 640;
const int smallImageHight = 960;

const int largeImageW = 1536;
const int largeImageH = 2008;


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
    PlayButton.enabled = NO;
    ConvertButton.enabled = NO;
    point1Button.hidden = YES;
    point2Buttion.hidden = YES;
    point3Button.hidden = YES;
    point4Button.hidden = YES;
    [point1Button addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventAllEvents];
    [point2Buttion addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventAllEvents];
    [point3Button addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventAllEvents];
    [point4Button addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventAllEvents];


    maskViewImage.hidden =YES;
    //[ self doTransform];
    
}
/*
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{

    UITouch *touch = [[event allTouches] anyObject];

    
    point3Button.center = [touch locationInView:self.view];
    point2Buttion.center = [touch locationInView:self.view];
    point1Button.center = [touch locationInView:self.view];
    point4Button.center = [touch locationInView:self.view];
}
 */
- (IBAction) imageMoved:(UIButton*) sender withEvent:(UIEvent *) event
{
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    UIControl *control = sender;
    control.center = point;
    [self doTransform];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
    NSLog(@"Got it");
    _image = img;
    [picker dismissModalViewControllerAnimated:NO];

    _CapturedImage.image = _image;
    //[self processRawImage];
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    
    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(processRawImage) onTarget:self withObject:nil animated:YES];
    //[[picker parentViewController] dismissModalViewControllerAnimated:NO];

    
    
}

-(void) doTransform
{
   
    cv::Mat matImage = [maskViewImage.image CVMat];
    
    Point2f src[4];
    src[0] = Point2f(point1Button.center.x,point1Button.center.y);
    src[1] = Point2f(point2Buttion.center.x,point2Buttion.center.y);
    src[2] = Point2f(point3Button.center.x,point3Button.center.y);
    src[3] = Point2f(point4Button.center.x,point4Button.center.y);
    Point2f dst[4];
    dst[0] = Point2f(matImage.rows/2,matImage.cols/2);
    dst[1] = Point2f(matImage.rows/2,matImage.cols/2);
    dst[2] = Point2f(matImage.rows/2,matImage.cols/2);
    dst[2] = Point2f(matImage.rows/2,matImage.cols/2);
     cv::warpPerspective(matImage, matImage, cv::getPerspectiveTransform(dst, src), cv::Size(matImage.rows, matImage.cols));
    maskViewImage.image = [[UIImage alloc] initWithCVMat:matImage];
    
}
- (IBAction)convertImage:(id)sender {
    
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    
    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(transform) onTarget:self withObject:nil animated:YES];
    NSLog(@"StartProccessing");
    

    //[self processRawImage];
    NSLog(@"Finished");

}

-(void) viewDidAppear:(BOOL)animated
{

    
    
    _CapturedImage.image = _newImage;
    
}

/**
 Once the image has been loaded located the four corners in the board
 @param void it use global variables
 @returns void 
 @exception nothing
 */
-(void) processRawImage
{

    be = [[BoardExtractor alloc] init];
    


    
    largeImage = [self imageWithImage:_image scaledToSize:CGSizeMake(largeImageW,largeImageH)].copy;
    _image = [self imageWithImage:_image scaledToSize:CGSizeMake(smallImageWidth,smallImageHight)];
    smallImage = _image.copy;
    cv::Mat matImage = [_image CVMat];
    [be setMat:matImage];
    NSMutableArray *points  =[be makeProspective];
        
    point1Button.hidden = NO;
    point2Buttion.hidden = NO;
    point3Button.hidden = NO;
    point4Button.hidden = NO;
    
   

 

    NSValue *val1 = [points objectAtIndex:0];
    NSValue *val2 = [points objectAtIndex:1];
    NSValue *val3 = [points objectAtIndex:2];
    NSValue *val4 = [points objectAtIndex:3];
    
    CGPoint poin1 = val1.CGPointValue;
    CGPoint poin2 = val2.CGPointValue;
    CGPoint poin3 = val3.CGPointValue;
    CGPoint poin4 = val4.CGPointValue;
    
   
    


    NSLog(@"Thie butttom on %f and %f",[_CapturedImage frame].size.height, [_CapturedImage frame].size.width);
    NSLog(@"imageSize H%f and w%f", _newImage.size.height,_newImage.size.width);
    
    float x1 = poin1.x * [_CapturedImage frame].size.width/smallImageWidth;
    float x2 = poin2.x * [_CapturedImage frame].size.width/smallImageWidth;
    float x3 = poin3.x * [_CapturedImage frame].size.width/smallImageWidth;
    float x4 = poin4.x * [_CapturedImage frame].size.width/smallImageWidth;
    
    float y1 = poin1.y * [_CapturedImage frame].size.height/smallImageHight;
    float y2 = poin2.y * [_CapturedImage frame].size.height/smallImageHight;
    float y3 = poin3.y * [_CapturedImage frame].size.height/smallImageHight;
    float y4 = poin4.y * [_CapturedImage frame].size.height/smallImageHight;

    if (x1 <= smallImageWidth && y1 <= smallImageHight && x1 >= 0 && y1 >=0)
    point1Button.center = CGPointMake(x1, y1);
    if (x2 <= smallImageWidth && y2 <= smallImageHight && x2 >= 0 && y2 >=0)
    point2Buttion.center = CGPointMake(x2, y2);
    if (x3 <= smallImageWidth && y3 <= smallImageHight && x3 >= 0 && y3 >=0)
    point3Button.center = CGPointMake(x3, y3);
    if (x4 <= smallImageWidth && y4 <= smallImageHight && x4 >= 0 && y4 >=0)
    point4Button.center = CGPointMake(x4, y4);

   
    

    NSLog(@"Floats are %f,%f %f,%f %f,%f %f,%f",x1,y1,x2,y2,x3,y3,x4,y4);
     NSLog(@"Acually are %f,%f %f,%f %f,%f %f,%f",poin1.x,poin1.y ,poin2.x,poin2.y,poin3.x,poin3.y,poin4.x,poin4.y);
}

/**
 This must be called after processRawImage to countunue
 @param void
 @returns void
 @exception no
 */
-(void) transform
{
    
    //[be readDigit];
 
    point1Button.hidden = YES;
    point2Buttion.hidden = YES;
    point3Button.hidden = YES;
    point4Button.hidden = YES;

    float x1 = point1Button.center.x * (largeImage.size.height/[_CapturedImage frame].size.width);
    float x2 = point2Buttion.center.x * (largeImage.size.width/[_CapturedImage frame].size.width);
    float x3 = point3Button.center.x * (largeImage.size.width/[_CapturedImage frame].size.width);
    float x4 = point4Button.center.x * (largeImage.size.width/[_CapturedImage frame].size.width);
    
    float y1 = point1Button.center.y * (largeImage.size.height/[_CapturedImage frame].size.height);
    float y2 = point2Buttion.center.y * (largeImage.size.height/[_CapturedImage frame].size.height);
    float y3 = point3Button.center.y * (largeImage.size.height/[_CapturedImage frame].size.height);
    float y4 = point4Button.center.y * (largeImage.size.height/[_CapturedImage frame].size.height);
    NSLog(@"Floats are %f,%f %f,%f %f,%f %f,%f",x1,y1,x2,y2,x3,y3,x4,y4);

    Point2f p[4];
    p[0] = Point2f(x1,y1);
    p[1] = Point2f(x2,y2);
    p[2] = Point2f(x3,y3);
    p[3] = Point2f(x4,y4);
    
    
   
    
    //[be readDigit];
    
    
    //[be readDigit];
    
    Mat croppedImage = [be transformMat:p andMat:[largeImage CVMat]];
    //Mat grids = [be largestBlob:[be transformMat:p andMat:[largeImage CVMat]]];
    Mat grids = [be largestBlob:croppedImage];
    [be readDigit:croppedImage andGrid:grids];
    _newImage = [[UIImage alloc] initWithCVMat:be.imageFromMat];


    //hitoriInArray = be.resultInArray;
    //_newImage = [[UIImage alloc] initWithCVMat: be.imageFromMat];
    
    //[ResultLabel setText:[be resultInString]];
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
            if (tempCell.confidence < 88) {
                [label setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                label.selected = YES;
                label.highlighted = YES;
                ///// setup colour
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
                
                [label setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
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
    ConvertButton.enabled = NO;
    SelectButton.enabled = NO;
    captureButton.enabled = NO;
    PlayButton.enabled = YES;


}
- (IBAction)DoStuff:(id)sender {
    NSLog(@"Cool shit");
    self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imgPicker.showsCameraControls = YES;
    //self.imgPicker.cameraViewTransform = YES;
    self.imgPicker.showsCameraControls = YES;
    [self presentModalViewController:self.imgPicker animated:YES];
    ConvertButton.enabled = YES;

}
- (IBAction)SelectAPicture:(id)sender {
    
    self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:self.imgPicker animated:YES];
    ConvertButton.enabled = YES;
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
    //[self setResultLabel:nil];
    [self setSelectButton:nil];
    [self setPlayButton:nil];
    [self setPoint1Button:nil];
    [self setPoint2Buttion:nil];
    [self setPoint3Button:nil];
    [self setPoint4Button:nil];
    [maskViewImage release];
    maskViewImage = nil;
    [self setMaskViewImage:nil];
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
            HitoriCell *tempCell = [[be.resultInArray objectAtIndex:i] objectAtIndex:j];
            tempCell.number=[sender.title intValue];
            tempCell.NumberAsString = sender.title;
            [[be.resultInArray objectAtIndex:i]setObject:tempCell atIndex:j];
            tempButton.highlighted = true;
            NSLog(@"Number has changer ");
        
        }     
        }
    }
    DataAppDataObject* theDataObject = [self theAppDataObject];
    theDataObject.HitoriMatrix = be.resultInArray;

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
    //[ResultLabel release];
    [SelectButton release];

    [PlayButton release];
    [point1Button release];
    [point2Buttion release];
    [point3Button release];
    [point4Button release];
    [maskViewImage release];
    [maskViewImage release];
    [super dealloc];
}
@end
