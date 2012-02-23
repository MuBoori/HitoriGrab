//
//  OpenCVClientViewController.h
//  OpenCVClient
//
//  Created by Robin Summerhill on 02/09/2011.
//  Copyright 2011 Aptogo Limited. All rights reserved.
//
//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import <UIKit/UIKit.h>
using namespace cv;

namespace tesseract {
    class TessBaseAPI;
};
@interface OpenCVClientViewController : UIViewController
{
    cv::VideoCapture *_videoCapture;
    cv::Mat _lastFrame;
    tesseract::TessBaseAPI *tesseract;
    uint32_t *pixels;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UILabel *elapsedTimeLabel;
@property (nonatomic, retain) IBOutlet UISlider *highSlider;
@property (nonatomic, retain) IBOutlet UISlider *lowSlider;
@property (nonatomic, retain) IBOutlet UILabel *highLabel;
@property (nonatomic, retain) IBOutlet UILabel *lowLabel;

void drawLine (cv::Vec2f line, cv::Mat &img, cv::Scalar rgb);
void mergeRelatedLines(cv::vector<cv::Vec2f> *lines, cv::Mat &img);
void PrintMatrix();
static bool IsAValidHitori(int *p_idx_row, int *p_idx_col);
- (IBAction)capture:(id)sender;
- (IBAction)sliderChanged:(id)sender;



@end
