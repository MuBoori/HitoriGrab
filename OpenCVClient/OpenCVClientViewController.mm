//
//  OpenCVClientViewController.m
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

// UIImage extensions for converting between UIImage and cv::Mat
#import "UIImage+OpenCV.h"

#import "OpenCVClientViewController.h"
#import "digitrecognizer.h"

#import "cvblob.h"

#include "baseapi.h"

#include "environ.h"
#import "pix.h"

#import "allheaders.h"






// Aperture value to use for the Canny edge detection
const int kCannyAperture = 7;

@interface OpenCVClientViewController ()
- (void)processFrame;
@end

@implementation OpenCVClientViewController

@synthesize imageView = _imageView;
@synthesize elapsedTimeLabel = _elapsedTimeLabel;
@synthesize highSlider = _highSlider;
@synthesize lowSlider= _lowSlider;
@synthesize highLabel = _highLabel;
@synthesize lowLabel = _lowLabel;


int w_matrix[8][8];
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
    // Initialise video capture - only supported on iOS device NOT simulator
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"Video capture is not supported in the simulator");
#else
    _videoCapture = new cv::VideoCapture;
    if (!_videoCapture->open(CV_CAP_AVFOUNDATION))
    {
        NSLog(@"Failed to open video camera");
    }
#endif
     */
    
    // Load a test image and demonstrate conversion between UIImage and cv::Mat

    UIImage *testImage = [UIImage imageNamed:@"hitori6.png"];
    
    double t;
    int times = 10;
    
    
    //--------------------------------
    // Convert from UIImage to cv::Mat
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    //t = (double)cv::getTickCount();
    
   // for (int i = 0; i < times; i++)
    //{
        //cv::Mat tempMat = [testImage CVMat];
   // }
        
    //t = 1000 * ((double)cv::getTickCount() - t) / cv::getTickFrequency() / times;
    
  //  [pool release];
    
 //   NSLog(@"UIImage to cv::Mat: %gms", t);
    
    //------------------------------------------
    // Convert from UIImage to grayscale cv::Mat
    pool = [[NSAutoreleasePool alloc] init];
    
    //t = (double)cv::getTickCount();
    /*
    for (int i = 0; i < times; i++)
    {
     */
        cv::Mat tempMat = [testImage CVMat];
        //cv::Mat tempMat = [testImage CVGrayscaleMat];
        //cv::GaussianBlur(tempMat, tempMat, cv::Size(11,11), 0);

    /*
    }
     */
    
    //t = 1000 * ((double)cv::getTickCount() - t) / cv::getTickFrequency() / times;
    
    [pool release];
    
    NSLog(@"UIImage to grayscale cv::Mat: %gms", t);
    
    //--------------------------------
    // Convert from cv::Mat to UIImage
    cv::Mat testMat = [testImage CVMat];

   // t = (double)cv::getTickCount();
        
  //  for (int i = 0; i < times; i++)
  //  {
        UIImage *tempImage = [[UIImage alloc] initWithCVMat:testMat];
        [tempImage release];
   // }
    
    //t = 1000 * ((double)cv::getTickCount() - t) / cv::getTickFrequency() / times;
    
    NSLog(@"cv::Mat to UIImage: %gms", t);
    
    // Process test image and force update of UI 
    _lastFrame = testMat;
    [self sliderChanged:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.imageView = nil;
    self.elapsedTimeLabel = nil;
    self.highLabel = nil;
    self.lowLabel = nil;
    self.highSlider = nil;
    self.lowSlider = nil;

    delete _videoCapture;
    _videoCapture = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Called when the user taps the Capture button. Grab a frame and process it
- (IBAction)capture:(id)sender
{
    if (_videoCapture && _videoCapture->grab())
    {
        (*_videoCapture) >> _lastFrame;
        [self processFrame];
    }
    else
    {
        NSLog(@"Failed to grab frame");        
    }
}

// Perform image processing on the last captured frame and display the results
- (void)processFrame
{
    
    double t = (double)cv::getTickCount();
    
    cv::Mat grayFrame, output;
    Mat test1;
  
    // Convert captured frame to grayscale
    cv::cvtColor(_lastFrame, grayFrame, cv::COLOR_RGB2GRAY);
    //grayFrame = _lastFrame;
    //cv::GaussianBlur(grayFrame, grayFrame, cv::Size(1,1), 0);

    _lastFrame.release();
    _lastFrame.deallocate();
    //cv::cvtColor(grayFrame, grayFrame, cv::COLOR_RGB2GRAY);
    
    cv::Mat outerBox = cv::Mat(grayFrame.size(), CV_8UC1);
    
    //cv::GaussianBlur(grayFrame, outerBox, cv::Size(11,11), 0);
    //cv::medianBlur(grayFrame, outerBox, 7);
    cv::GaussianBlur(grayFrame, outerBox, cv::Size(11,11), 0);
    
    //cv::GaussianBlur(outerBox, outerBox, cv::Size(11,11), 0);
    
    
    cv::adaptiveThreshold( outerBox, outerBox, 255, cv::ADAPTIVE_THRESH_MEAN_C, cv::THRESH_BINARY, 101, 2);
    cv::adaptiveThreshold( outerBox, test1, 255, cv::ADAPTIVE_THRESH_MEAN_C, cv::THRESH_BINARY, 5, 2);
    
    bitwise_not( outerBox,  outerBox);
    
    //cv::Mat kernel = (cv::Mat_<uchar>(3,3) << 0,1,0,1,1,1,0,1,0);
    
    //cv::dilate( outerBox,  outerBox, kernel);
    //cv::threshold(outerBox, outerBox, 5, 255, cv::ADAPTIVE_THRESH_GAUSSIAN_C);
    
    int count=0;
    int max=-1;
    cv::Point maxPt;
    
   
    for(int y=0;y<outerBox.size().height;y++)
    {
        uchar *row = outerBox.ptr(y);
        for(int x=0;x<outerBox.size().width;x++)
        {
            if(row[x]>=128)
            {
                int area = floodFill(outerBox, cv::Point(x,y), CV_RGB(0,0,64));
                
                if(area>max)
                {
                    maxPt = cv::Point(x,y);
                    max = area;
                }
            }
        }
    }
    
    cv::floodFill(outerBox, maxPt, CV_RGB(255,255,255));
   
   
    
    int counter1 = 0; 
    int xx =0 ;
    int x;
    Boolean line_test;
    Boolean prev_test;
    for(int y=0;y<outerBox.size().height;y++)
    {
        uchar *row = outerBox.ptr(y);

        for( x=0;x<outerBox.size().width;x++)
        {
           
            if(row[x]==64 && x!=maxPt.x && y!=maxPt.y)
            {
                
                int area = floodFill(outerBox, cv::Point(x,y), CV_RGB(0,0,0));
                 
            }
           
        }
    }
    Mat newHu = outerBox.clone();

    //counter1 = counter1 +1;
    //printf("Numbers is %i",counter1);
    //NSLog(@"NSInteger value :%@", counter1);
    
    NSLog(@"Finished");
    //cv::erode(outerBox, test1, kernel);
    printf("size of %zu \n",test1.size().width);
    printf("size of %zu \n",test1.size().height);
    printf("size of %zu \n",maxPt.y);
    printf("size of %zu \n",maxPt.x);
   
    //Mat newHu;
        
    //cv::erode(outerBox, newHu, kernel);
    //cv::erode(outerBox, outerBox, kernel);

    //cv::imshow("thresholded", test1);
    cv::imshow("thresholded", outerBox);

    cv::vector<cv::Vec2f> lines;
    cv::HoughLines(outerBox, lines,1, CV_PI/180, 550);
    //cv::HoughLinesP(outerBox, lines, 1, CV_PI/180, 80);

    
    std::vector<cv::Vec2f>::const_iterator itx= lines.begin();
    for(int i=0;i<lines.size();i++)
    {
        
        float rho= (lines[i])[0];   // first element is distance rho
        float theta= (lines[i])[1]; // second element is angle theta
        /*
        if (theta>CV_PI*80/180 && theta<CV_PI*100/180){
        drawLine(lines[i], outerBox, CV_RGB(0,0,128));
        }
        */
        //if(theta < CV_PI/4|| theta > 3*CV_PI/4){
        double degree = theta*180/CV_PI;
        
        if(((degree<=180 && degree>165) || (degree>=0 && degree<18)) && rho > 100){
        printf("lines V angle are %f \n", theta*180/CV_PI);
            printf("rho are %f \n", rho);
        drawLine(lines[i], outerBox, CV_RGB(0,0,128));
        //drawLine(lines[i], newHu, CV_RGB(0,0,128));
        }
        
        if(degree>=78 && degree<118){
            printf("lines H angle are %f \n", theta*180/CV_PI);
            printf("rho are %f \n", rho);
            drawLine(lines[i], outerBox, CV_RGB(0,0,128));
            //drawLine(lines[i], newHu, CV_RGB(0,0,128));
        }

         
         
        //drawLine(lines[i], outerBox, CV_RGB(0,0,128));

        //drawLine(lines[i], newHu, CV_RGB(0,0,128));

            
             //printf("Theta of %zu \n",theta);
            
        //}
         
        
        
    }

    //test1 = Mat(outerBox);

    //HoughLines(outerBox, lines, 1, CV_PI/180, 200);
    
    mergeRelatedLines(&lines, grayFrame); // Add this line
    
     //mergeRelatedLines(&lines, newHu); // Add this line

     
    
    // Find extreamLine 
    // Now detect the lines on extremes
    cv::Vec2f topEdge = cv::Vec2f(1000,1000);    double topYIntercept=100000, topXIntercept=0;
    cv::Vec2f bottomEdge = cv::Vec2f(-1000,-1000);        double bottomYIntercept=0, bottomXIntercept=0;
    cv::Vec2f leftEdge = cv::Vec2f(1000,1000);    double leftXIntercept=100000, leftYIntercept=0;
    cv::Vec2f rightEdge = cv::Vec2f(-1000,-1000);        double rightXIntercept=0, rightYIntercept=0;
    
    for(int i=0;i<lines.size();i++)
    {
        Vec2f current = lines[i];
        
        float p=current[0];
        float theta=current[1];
        
        if(p==0 && theta==-100)
            continue;
        double xIntercept, yIntercept;
        xIntercept = p/cos(theta);
        yIntercept = p/(cos(theta)*sin(theta));
        
        if(theta>CV_PI*80/180 && theta<CV_PI*100/180)
        {
            if(p<topEdge[0])
                topEdge = current;
            
            if(p>bottomEdge[0])
                bottomEdge = current;
        }
        
        else if(theta<CV_PI*10/180 || theta>CV_PI*170/180)
        {
            if(xIntercept>rightXIntercept)
            {
                rightEdge = current;
                rightXIntercept = xIntercept;
            }
            else if(xIntercept<=leftXIntercept)
            {
                leftEdge = current;
                leftXIntercept = xIntercept;
            }
        }
    }
    
    drawLine(topEdge, grayFrame, CV_RGB(0,0,0));
    drawLine(bottomEdge, grayFrame, CV_RGB(0,0,0));
    drawLine(leftEdge, grayFrame, CV_RGB(0,0,0));
    drawLine(rightEdge, grayFrame, CV_RGB(0,0,0));
    
    cv::Point left1, left2, right1, right2, bottom1, bottom2, top1, top2;
    
    int height=outerBox.size().height;
    int width=outerBox.size().width;
    
    if(leftEdge[1]!=0)
    {
        left1.x=0;        left1.y=leftEdge[0]/sin(leftEdge[1]);
        left2.x=width;    left2.y=-left2.x/tan(leftEdge[1]) + left1.y;
    }
    else
    {
        left1.y=0;        left1.x=leftEdge[0]/cos(leftEdge[1]);
        left2.y=height;    left2.x=left1.x - height*tan(leftEdge[1]);
    }
    
    if(rightEdge[1]!=0)
    {
        right1.x=0;        right1.y=rightEdge[0]/sin(rightEdge[1]);
        right2.x=width;    right2.y=-right2.x/tan(rightEdge[1]) + right1.y;
    }
    else
    {
        right1.y=0;        right1.x=rightEdge[0]/cos(rightEdge[1]);
        right2.y=height;    right2.x=right1.x - height*tan(rightEdge[1]);
    }
    
    bottom1.x=0;    bottom1.y=bottomEdge[0]/sin(bottomEdge[1]);
    bottom2.x=width;bottom2.y=-bottom2.x/tan(bottomEdge[1]) + bottom1.y;
    
    top1.x=0;        top1.y=topEdge[0]/sin(topEdge[1]);
    top2.x=width;    top2.y=-top2.x/tan(topEdge[1]) + top1.y;
    
    // Next, we find the intersection of  these four lines
    double leftA = left2.y-left1.y;
    double leftB = left1.x-left2.x;
    double leftC = leftA*left1.x + leftB*left1.y;
    
    double rightA = right2.y-right1.y;
    double rightB = right1.x-right2.x;
    double rightC = rightA*right1.x + rightB*right1.y;
    
    double topA = top2.y-top1.y;
    double topB = top1.x-top2.x;
    double topC = topA*top1.x + topB*top1.y;
    
    double bottomA = bottom2.y-bottom1.y;
    double bottomB = bottom1.x-bottom2.x;
    double bottomC = bottomA*bottom1.x + bottomB*bottom1.y;  
    
    // Intersection of left and top
    double detTopLeft = leftA*topB - leftB*topA;
    CvPoint ptTopLeft = cvPoint((topB*leftC - leftB*topC)/detTopLeft, (leftA*topC - topA*leftC)/detTopLeft);
    
    // Intersection of top and right
    double detTopRight = rightA*topB - rightB*topA;
    CvPoint ptTopRight = cvPoint((topB*rightC-rightB*topC)/detTopRight, (rightA*topC-topA*rightC)/detTopRight);
    
    // Intersection of right and bottom
    double detBottomRight = rightA*bottomB - rightB*bottomA;
    CvPoint ptBottomRight = cvPoint((bottomB*rightC-rightB*bottomC)/detBottomRight, (rightA*bottomC-bottomA*rightC)/detBottomRight);// Intersection of bottom and left
    double detBottomLeft = leftA*bottomB-leftB*bottomA;
    CvPoint ptBottomLeft = cvPoint((bottomB*leftC-leftB*bottomC)/detBottomLeft, (leftA*bottomC-bottomA*leftC)/detBottomLeft);
    
    int maxLength = (ptBottomLeft.x-ptBottomRight.x)*(ptBottomLeft.x-ptBottomRight.x) + (ptBottomLeft.y-ptBottomRight.y)*(ptBottomLeft.y-ptBottomRight.y);
    int temp = (ptTopRight.x-ptBottomRight.x)*(ptTopRight.x-ptBottomRight.x) + (ptTopRight.y-ptBottomRight.y)*(ptTopRight.y-ptBottomRight.y);
    if(temp>maxLength) maxLength = temp;
    
    temp = (ptTopRight.x-ptTopLeft.x)*(ptTopRight.x-ptTopLeft.x) + (ptTopRight.y-ptTopLeft.y)*(ptTopRight.y-ptTopLeft.y);
    if(temp>maxLength) maxLength = temp;
    
    temp = (ptBottomLeft.x-ptTopLeft.x)*(ptBottomLeft.x-ptTopLeft.x) + (ptBottomLeft.y-ptTopLeft.y)*(ptBottomLeft.y-ptTopLeft.y);
    if(temp>maxLength) maxLength = temp;
    
    maxLength = sqrt((double)maxLength);
    
    Point2f src[4], dst[4];
    src[0] = ptTopLeft;            dst[0] = Point2f(0,0);
    src[1] = ptTopRight;        dst[1] = Point2f(maxLength-1, 0);
    src[2] = ptBottomRight;        dst[2] = Point2f(maxLength-1, maxLength-1);
    src[3] = ptBottomLeft;        dst[3] = Point2f(0, maxLength-1);
    
    cv::Mat undistorted = Mat(cv::Size(maxLength, maxLength), CV_8UC1);
    //cv::Mat test1un = Mat(cv::Size(maxLength, maxLength), CV_8UC1);
    //cv::warpPerspective(test1, test1un, cv::getPerspectiveTransform(src, dst), cv::Size(maxLength, maxLength));
    cv::warpPerspective(grayFrame, undistorted, cv::getPerspectiveTransform(src, dst), cv::Size(maxLength, maxLength));
     cv::warpPerspective(newHu, newHu, cv::getPerspectiveTransform(src, dst), cv::Size(maxLength, maxLength));

   
    printf("lines are %zu \n", lines.size());
    const double PI = 3.141592;
 
    //cv::Canny(undistorted,contours,125,350);
    
    cv::Mat contours = cv::Mat(undistorted.size(), CV_8UC1);
    cv::medianBlur(undistorted, contours, 5);
    cv::GaussianBlur(contours, contours, cv::Size(3,3), 0);
    //cv::Mat kernel1 = (cv::Mat_<uchar>(3,3) << -1,0,1,-2,0,2,-1,0,1);
    cv::Mat kernel1 = (cv::Mat_<uchar>(3,3) << -1,-2,-1,0,0,0,1,2,1);

    cv::dilate( contours,  contours, kernel1);
   
        
    cv::adaptiveThreshold( contours, contours, 255, cv::ADAPTIVE_THRESH_MEAN_C, cv::THRESH_BINARY, 301, 1);
    bitwise_not( contours,  contours);

    
   // cv::Sobel(contours, contours, 3, 1, 1);
    std::vector<cv::Vec2f> lines1;
    
    cv::HoughLines(contours,lines1,1,PI/180,  // step size
                   80);
    
    std::vector<cv::Vec2f>::const_iterator it= lines1.begin();
    int nOfLineV = 0;
    int nOfLineH = 0;
    printf("lines are %zu \n", lines1.size());
    while (it!=lines1.end()) {
        float rho= (*it)[0];   // first element is distance rho
        float theta= (*it)[1]; // second element is angle theta
      //  if (theta < PI/4.
        //    || theta > 3.*PI/4.) { // ~vertical line
            //printf("lines V angle are %zu and %zu \n", rho , theta);
                
              //  ++nOfLineV;
            
            printf("lines V angle are %f \n", theta*180/CV_PI);
            // ++nOfLineV;
            
     //   } else { // ~horizontal line
          //  ++nOfLineH;
       // }
        ++it; 
    }
    printf("lines V are %zu \n", nOfLineV);
    printf("lines H are %zu \n", nOfLineH);
    NSLog(@"END");
    //outerBox = grayFrame;

   
    //TS setup
    
    // Set up the tessdata path. This is included in the application bundle
    // but is copied to the Documents directory on the first run.
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = ([documentPaths count] > 0) ? [documentPaths objectAtIndex:0] : nil;
    
    NSString *dataPath = [documentPath stringByAppendingPathComponent:@"tessdata"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:dataPath]) {
        // get the path to the app bundle (with the tessdata dir)
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        NSString *tessdataPath = [bundlePath stringByAppendingPathComponent:@"tessdata"];
        if (tessdataPath) {
            [fileManager copyItemAtPath:tessdataPath toPath:dataPath error:NULL];
        }
    }
    
    setenv("TESSDATA_PREFIX", [[documentPath stringByAppendingString:@"/"] UTF8String], 1);
    
    // init the tesseract engine.
    tesseract = new tesseract::TessBaseAPI();
    

   // tesseract->Init([dataPath cStringUsingEncoding:NSUTF8StringEncoding], "eng");
    
    tesseract->Init([dataPath cStringUsingEncoding:NSUTF8StringEncoding], "eng", tesseract::OEM_DEFAULT,NULL, 0, NULL, NULL, false);

    

       
    tesseract->SetVariable("tessedit_char_whitelist", "123456789");
    //tesseract->SetVariable("tessedit_accuracyvspeed", "100");

    //grayFrame.release();
    //grayFrame.deallocate();
    // Perform Canny edge detection using slide values for thresholds
    /*
    cv::Canny(grayFrame, output,
              _lowSlider.value * kCannyAperture * kCannyAperture,
              _highSlider.value * kCannyAperture * kCannyAperture,
              kCannyAperture);
    
    //t = 1000 * ((double)cv::getTickCount() - t) / cv::getTickFrequency();
    */

    //cv::adaptiveThreshold( undistorted, undistorted, 255, cv::ADAPTIVE_THRESH_MEAN_C, cv::THRESH_BINARY, 5, 2);
    
    //bitwise_not( undistorted,  undistorted);
    //cv::dilate( undistorted,  undistorted, kernel);

   
    cv::warpPerspective(grayFrame, undistorted, cv::getPerspectiveTransform(src, dst), cv::Size(maxLength, maxLength));
    Mat undistortedThreshed = undistorted.clone();
    
    /*   
    cv::GaussianBlur(undistorted, undistortedThreshed, cv::Size(7,7), 0);
    //cv::medianBlur(undistortedThreshed, undistortedThreshed, 7);
    cv::dilate( undistortedThreshed,  undistortedThreshed, kernel1);
    //cv::dilate( undistortedThreshed,  undistortedThreshed, kernel);
    adaptiveThreshold(undistortedThreshed, undistortedThreshed, 255, ADAPTIVE_THRESH_GAUSSIAN_C, CV_THRESH_BINARY_INV, 895, 1);

    */
     //cv::dilate( grayFrame,  grayFrame, kernel);
    //cv::Mat greyFramecopy = grayFrame.clone();
    cv::GaussianBlur(undistortedThreshed, undistortedThreshed, cv::Size(11,11), 0);
    
    adaptiveThreshold(undistortedThreshed, undistortedThreshed, 255, ADAPTIVE_THRESH_GAUSSIAN_C, CV_THRESH_BINARY_INV, 555, 1);
    //cv::equalizeHist(grayFrame, grayFrame);
    //cv::threshold(undistortedThreshed, undistortedThreshed, 128, 255, CV_THRESH_BINARY);

   // bitwise_or(greyFramecopy, grayFrame, grayFrame);
    //bitwise_not(greyFramecopy, greyFramecopy);
    //bitwise_and(greyFramecopy, grayFrame, grayFrame);

    //cv::medianBlur(undistortedThreshed, undistortedThreshed, 1);
    //cv::threshold(grayFrame, grayFrame, 200, 255, CV_THRESH_BINARY);
    //bitwise_not(grayFrame, grayFrame);
    //cv::equalizeHist(grayFrame, grayFrame);
 
    //Mat essPic = undistortedThreshed.clone();
    bitwise_not(newHu, newHu);
    //bitwise_and(undistortedThreshed, newHu, newHu);
    
    bitwise_and(undistortedThreshed, newHu, undistortedThreshed);


    bitwise_not(undistortedThreshed, undistortedThreshed);
    
       
    
    Mat newReco;
    cv::resize(undistortedThreshed, newReco, cv::Size(undistortedThreshed.size().width/1,undistortedThreshed.size().height/1));
       
    tesseract->SetImage((uchar*)newReco.data, newReco.size().width, newReco.size().height, newReco.channels(), newReco.step1());
    tesseract->Recognize(0);



    const char* outer =tesseract->GetUTF8Text();
    std::cout << "characters are " << outer << std::endl;
    
    
    std::cout << "Size is " << strlen(outer);
    int extraChar = 0;
    int sizeofOuter = (int)strlen(outer);
    int colSize = 1;
    int rawSize = -1;
    for (int i = 0 ; sizeofOuter > i ; ++i) {
        if(outer[i] == *"\n"){
            std::cout << "new Line \n" ;
            extraChar++ ;
            rawSize++;
        }else{
            colSize++;
        }
        
    }
    
    int hitoriMatrix[8][8];

    char * endSt;

        
    int nSt = 0 ;
    //nSt = (int)std::strtol(outer, &endSt, 10) ;

    //nSt = (int)std::strtol(&outer[1], &endSt, 10) ;

    int i = 0;
        for (int ii = 0 ; ii< 8; ii++) {
            for (int j =0; j<8; j++) {
                if(outer[i] == *"\n"){
                    
                   // ii++; 
                    i++;
                    j = j - 1 ;
                }else{
                    
                    std::cout << outer[i] << std::endl;
                    
                    
                    char oneSt = outer[i];
                    nSt = (int)std::strtol(&oneSt, &endSt, 10) ;
                    w_matrix[ii][j] = nSt;
                    //std::cout << "Row "<< ii << " col " << j << " Result "<<outer[i] << " Mat " << hitoriMatrix[ii][j] << std::endl;

                    i++;

                    
                }
            }
            
        }

       
    
   /* 
    
    for (int i =0 ; i < 8; i++) {
        for (int j = 0; j < 8 ; j++) {
            std::cout << "Row " << i << " col " << j << " = " << hitoriMatrix[i][j] << std::endl;
        }
    }
*/

    //std::cout <<  tesseract->AllWordConfidences() << std::endl;
/*
    const char* outer =tesseract->GetUTF8Text();
    std::cout << "character is " << outer << std::endl;
    */
    for (int i = 0; i<8; i++) {
        for (int j = 0; j<8; j++) {
            
            tesseract->SetRectangle((undistortedThreshed.size().width/8)*j, (undistortedThreshed.size().height/8)*i, (undistortedThreshed.size().width/8), (undistortedThreshed.size().height/8));
            tesseract->Recognize(0);

            
            
  
            
            const char* outer =tesseract->GetUTF8Text();
            
            nSt = (int)std::strtol(outer, &endSt, 10) ;
            w_matrix[i][j] = nSt;
            std::cout << "character is " << outer << std::endl;
            
            //cvb::CvBlobs blobs;
            
            
            //IplImage ipl_map=undistortedThreshed;
            //unsigned char* imageData = undistortedThreshed.data;

            
            
            //IplImage *labelImg=cvCreateImage(cvSize(ipl_map.width,ipl_map.height), IPL_DEPTH_LABEL, 1);
            
            //unsigned int resultsss = cvb::cvLabel(&ipl_map,labelImg,blobs);
            
            //undistortedThreshed = labelImg;
        }
    }
    
    
     int l_idx_row = 0;
     int l_idx_col = 0;
     int l_substitutions = 0;
     
     //PrintMatrix();
     
     // Algorithm A: NOT the optimal solution
     
     while(false == IsAValidHitori(&l_idx_row, &l_idx_col))
     {
     assert(
     l_idx_row >= 0 &&
     l_idx_row < 8 &&
     l_idx_col >= 0 &&
     l_idx_col < 8
     );
     w_matrix[l_idx_row][l_idx_col] = -1;
     l_substitutions++;
     }
     
     
     printf("\n");
     
    int xl_idx_row = 0;
	int xl_idx_col = 0;
    
	for(xl_idx_row = 0; xl_idx_row < 8; xl_idx_row++)
	{
		for(xl_idx_col = 0; xl_idx_col < 8; xl_idx_col++)
		{
			if(-1 != w_matrix[xl_idx_row][xl_idx_col])
			{
				printf("%2d ", w_matrix[xl_idx_row][xl_idx_col]);
			}
			else
			{
				printf("   ");
			}
		}
		printf("\n");
	}
    
    
    
    //tesseract::TessBaseAPI:: its = tesseract-> GetIterator();


    
        //tesseract->GetConnectedComponents(pix);
    
    

    
    //cv::threshold(undistortedThreshed, undistortedThreshed, 200, 255, CV_THRESH_BINARY);
    //cv::resize(undistortedThreshed, undistortedThreshed, cv::Size(200,200));
    //DigitRecognizer *dr = new DigitRecognizer();
    //bool b = dr->train("/train-images.idx3-ubyte", "/train-labels.idx1-ubyte");


    //int dist = ceil((double)maxLength/10);

    int distx = ceil((double)undistortedThreshed.rows/14);
    int disty = ceil((double)undistortedThreshed.cols/14);
    Mat currentCell = Mat(distx, disty, CV_8UC1);
    //Mat numberTwo = imread("222.png",0);
    //Mat numberTwoT = Mat(numberTwo.size(),CV_8UC1);

   // adaptiveThreshold(numberTwo, numberTwoT, 255, CV_ADAPTIVE_THRESH_GAUSSIAN_C, CV_THRESH_BINARY_INV, 101, 1);
    //int number = dr->classify(numberTwoT);
    //printf("%d ", number);
    bitwise_not(undistortedThreshed, undistortedThreshed);
    
    printf("I was here");
    for(int j=0;j<14;j++)
    {
        
        for(int i=0;i<14;i++)
        {
            
            for(int y=0;y<disty && j*disty+y<undistortedThreshed.cols;y++)
            {
                uchar* ptr = currentCell.ptr(y);
                
                for(int x=0;x<distx && i*distx+x<undistortedThreshed.rows;x++)
                {
                    ptr[x] = undistortedThreshed.at<uchar>(j*disty+y, i*distx+x);
                }
            }
            Moments m = cv::moments(currentCell, true);
            int area = m.m00;
            if(area > currentCell.rows*currentCell.cols/5)
            {


                /*
                cvb::CvBlobs blobs;
                


                	
                

                //grayFrame.release();
                //outerBox.release();
                //test1.release();
                IplImage ipl_map=currentCell;
                unsigned char* imageData = currentCell.data;

                
                String result = tesseract->TesseractRect((const unsigned char*)imageData, 1,currentCell.step1(), 0, 0, currentCell.rows, currentCell.cols);
                
                
                IplImage *labelImg=cvCreateImage(cvSize(ipl_map.width,ipl_map.height), IPL_DEPTH_LABEL, 1);

                unsigned int resultsss = cvb::cvLabel(&ipl_map,labelImg,blobs);
            
                int blobNumber = 0;
                
                
               
                for (cvb::CvBlobs::const_iterator it=blobs.begin(); it!=blobs.end(); ++it)
                {
                    
                    blobNumber++;
                    
                }
                //printf("Result of blob %zu \n", blobNumber);

                //printf("Result of blob %s \n", result);
                std::cout << "THis result " << result << std::endl;
                //cvb::CBlobResult blobs;
                
                //bitwise_not(currentCell, currentCell);
                //UIImageWriteToSavedPhotosAlbum([UIImage imageWithCVMat:currentCell], nil,nil,nil);
                 */
                
            }
            else
            {
                //UIImageWriteToSavedPhotosAlbum([UIImage imageWithCVMat:currentCell], nil,nil,nil);
                printf("  ");
            }
        }
        printf("\n");
    }
     
    // output = essPic ;
    //output = newHu;
    output = undistortedThreshed;
    //output = contours;
    grayFrame.release();
    test1.release();
    /*
    for (int y =0; test1un.size().height; y++) {
        for(int x = 0; test1un.size().height;x++){
        int centreW = round(test1un.size().width/2);
        int centreH = round(test1un.size().height/2);
        //int colourValue = ;
        //printf("color value at %zu \n",test1un.at<uchar>(centreW,centreH));
        }
    }
     */
    

    
    
    //output = undistorted;
    //UIImageWriteToSavedPhotosAlbum([UIImage imageWithCVMat:test1un], nil,nil,nil);
    //output = outerBox;
    
    // Display result 
    self.imageView.image = [UIImage imageWithCVMat:output];
    self.elapsedTimeLabel.text = [NSString stringWithFormat:@"%.1fms", t];
     
}

// Called when the user changes either of the threshold sliders
- (IBAction)sliderChanged:(id)sender
{
    self.highLabel.text = [NSString stringWithFormat:@"%.0f", self.highSlider.value];
    self.lowLabel.text = [NSString stringWithFormat:@"%.0f", self.lowSlider.value];
    
    [self processFrame];
}
void drawLine(cv::Vec2f line, cv::Mat &img, cv::Scalar rgb = CV_RGB(0,0,255))
{
    if(line[1]!=0)
    {
        float m = -1/tan(line[1]);
        float c = line[0]/sin(line[1]);
        
        cv::line(img, cv::Point(0, c), cv::Point(img.size().width, m*img.size().width+c), rgb);
    }
    else
    {
        cv::line(img, cv::Point(line[0], 0), cv::Point(line[0], img.size().height), rgb);
    }
}

// Merge Line

void mergeRelatedLines(cv::vector<cv::Vec2f> *lines, cv::Mat &img)
{
    vector<Vec2f>::iterator current;
    for(current=lines->begin();current!=lines->end();current++)
    {
        if((*current)[0]==0 && (*current)[1]==-100) continue;
        float p1 = (*current)[0];
        float theta1 = (*current)[1];
        cv::Point pt1current, pt2current;
        if(theta1>CV_PI*45/180 && theta1<CV_PI*135/180)
        {
            pt1current.x=0;
            pt1current.y = p1/sin(theta1);
            
            pt2current.x=img.size().width;
            pt2current.y=-pt2current.x/tan(theta1) + p1/sin(theta1);
        }
        else
        {
            pt1current.y=0;
            pt1current.x=p1/cos(theta1);
            
            pt2current.y=img.size().height;
            pt2current.x=-pt2current.y/tan(theta1) + p1/cos(theta1);
        }
        vector<Vec2f>::iterator    pos;
        for(pos=lines->begin();pos!=lines->end();pos++)
        {
            if(*current==*pos) continue;
            if(fabs((*pos)[0]-(*current)[0])<20 && fabs((*pos)[1]-(*current)[1])<CV_PI*10/180)
            {
                float p = (*pos)[0];
                float theta = (*pos)[1];
                cv::Point pt1, pt2;
                if((*pos)[1]>CV_PI*45/180 && (*pos)[1]<CV_PI*135/180)
                {
                    pt1.x=0;
                    pt1.y = p/sin(theta);
                    pt2.x=img.size().width;
                    pt2.y=-pt2.x/tan(theta) + p/sin(theta);
                }
                else
                {
                    pt1.y=0;
                    pt1.x=p/cos(theta);
                    pt2.y=img.size().height;
                    pt2.x=-pt2.y/tan(theta) + p/cos(theta);
                }
                
                if(((double)(pt1.x-pt1current.x)*(pt1.x-pt1current.x) + (pt1.y-pt1current.y)*(pt1.y-pt1current.y)<64*64) &&
                   ((double)(pt2.x-pt2current.x)*(pt2.x-pt2current.x) + (pt2.y-pt2current.y)*(pt2.y-pt2current.y)<64*64))
                {
                    // Merge the two
                    (*current)[0] = ((*current)[0]+(*pos)[0])/2;
                    (*current)[1] = ((*current)[1]+(*pos)[1])/2;
                    
                    (*pos)[0]=0;
                    (*pos)[1]=-100;
                }
            }
        }
    }

}

#define MROW 8
#define MCOL 8
#define NOVAL -1

// =====================================================================================
// Check if the matrix is valid, otherwise save in the given parameters the indexes of
// the duplicated element.
// =====================================================================================
static bool IsAValidHitori(int *p_idx_row, int *p_idx_col)
{
	int l_idx_main_row = 0;
	int l_idx_main_col = 0;
	int l_idx_slave_row = 0;
	int l_idx_slave_col = 0;
	int l_current_val = NOVAL;
    
	assert(NULL != p_idx_row);
	assert(NULL != p_idx_col);
    
	for(l_idx_main_row = 0; l_idx_main_row < MROW; l_idx_main_row++)
	{
		for(l_idx_main_col = 0; l_idx_main_col < MCOL; l_idx_main_col++)
		{
			l_current_val = w_matrix[l_idx_main_row][l_idx_main_col];
			// Check only if currenta value is not a NON-VALUE
			if(NOVAL != l_current_val)
			{
				// Loop over the entire column: is there current value?
				for(l_idx_slave_row = l_idx_main_row+1; l_idx_slave_row < MROW; l_idx_slave_row++)
				{
					if(l_current_val == w_matrix[l_idx_slave_row][l_idx_main_col])
					{
						printf("%d == %d - matrix not valid", l_current_val, w_matrix[l_idx_slave_row][l_idx_main_col]);
						*p_idx_row = l_idx_slave_row;
						*p_idx_col = l_idx_main_col;
                        
						return false;
					}
				}
				// Loop over the entire row: is there current value?
				for(l_idx_slave_col = l_idx_main_col+1; l_idx_slave_col < MCOL; l_idx_slave_col++)
				{
					if(l_current_val == w_matrix[l_idx_main_row][l_idx_slave_col])
					{
						printf("%d == %d - matrix not valid", l_current_val, w_matrix[l_idx_main_row][l_idx_slave_col]);
						*p_idx_row = l_idx_main_row;
						*p_idx_col = l_idx_slave_col;
                        
						return false;
					}
				}
			}
		}
	}
    
	printf("Scan complete - Matrix is valid");
    
	return true;
}
@end
