//
//  PreviewViewController.h
//  OpenCVClient
//
//  Created by Mujtaba Alboori on 16/02/2012.
//  Copyright (c) 2012 Aptogo Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BoardExtractor.h"
#import "BoardExtractor.h"
#import "UIImage+OpenCV.h"
#import "MBProgressHUD.h"
@protocol UIImagePickerControllerDelegate;
@interface PreviewViewController : UIViewController<UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIPopoverControllerDelegate, MBProgressHUDDelegate>{

    UIImagePickerController *imgPicker;
    UIImage *image;
    UIImage * newImage;

    NSMutableArray *hitoriInArray;
    NSMutableArray *trackButton;
    MBProgressHUD *HUD;
    BoardExtractor *be;
    UIImage *largeImage;
    UIImage *smallImage;
    IBOutlet UIImageView *maskViewImage;
    
    
}
//@property (retain, nonatomic) IBOutlet UILabel *ResultLabel;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *ConvertButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *SelectButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *PlayButton;
@property (retain, nonatomic) IBOutlet UIImageView *maskViewImage;

@property (retain, nonatomic) IBOutlet UIBarButtonItem *captureButton;
@property (retain, nonatomic) IBOutlet UIView *PreviewView;
@property (retain, nonatomic) IBOutlet NSObject *PreviewViewController;

@property (nonatomic, retain) UIImagePickerController *imgPicker;
@property (retain, nonatomic) IBOutlet UIImageView *CapturedImage;
@property (retain, nonatomic) UIImage *image;
@property (retain, nonatomic) UIImage *newImage;
@property (retain, nonatomic) IBOutlet UIButton *point1Button;
@property (retain, nonatomic) IBOutlet UIButton *point2Buttion;
@property (retain, nonatomic) IBOutlet UIButton *point3Button;
@property (retain, nonatomic) IBOutlet UIButton *point4Button;

- (IBAction)changeNo:(id)sender;

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

-(void) processRawImage;


@end
