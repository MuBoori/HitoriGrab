//
//  BoardExtractor.m
//  OpenCVClient
//
//  Created by Mujtaba Alboori on 16/02/2012.
//  Copyright (c) 2012 Aptogo Limited. All rights reserved.
//

#import "BoardExtractor.h"
@implementation BoardExtractor

@synthesize gridImage, rawImage;
@synthesize imageFromMat;
@synthesize resultInString = _resultInString;
@synthesize resultInArray;
@synthesize rows;
@synthesize ListOfPoint = _ListOfPoint;
@synthesize pointes4;
int matrix[8][8];
-(void) setMat : (Mat) matImage{

    gridImage = matImage;

}
-(NSMutableArray*) makeProspective
{

    NSLog(@"Start working on Prospactive");
    cv::Mat grayFrame, output;
    
    grayFrame = gridImage.clone();
    
    // Convert captured frame to grayscale
    cv::cvtColor(grayFrame, grayFrame, cv::COLOR_RGB2GRAY);
    
    cv::Mat outerBox = cv::Mat(grayFrame.size(), CV_8UC1);
    
     
    cv::GaussianBlur(grayFrame, grayFrame, cv::Size(11,11), 0);
    
        
    cv::adaptiveThreshold( grayFrame, outerBox, 255, cv::ADAPTIVE_THRESH_MEAN_C, cv::THRESH_BINARY, 45, 1);
    
    bitwise_not( outerBox,  outerBox);

    // Largest Blob
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
    
    // secound Pass
    
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
    
    //gridLines = outerBox.clone();

    //UIImageWriteToSavedPhotosAlbum([[UIImage alloc] initWithCVMat:outerBox], self, 
    //                               @selector(image:didFinishSavingWithError:contextInfo:), nil);
    cv::imshow("thresholded", outerBox);
    
    
    // Finding the line
    
    cv::vector<cv::Vec2f> lines;
    cv::HoughLines(outerBox, lines,1, CV_PI/180, 243);
    
    
    std::vector<cv::Vec2f>::const_iterator itx= lines.begin();
    for(int i=0;i<lines.size();i++)
    {
        
        float rho= (lines[i])[0];   // first element is distance rho
        float theta= (lines[i])[1]; // second element is angle theta

        double degree = theta*180/CV_PI;
        
        drawLine1(lines[i], outerBox, CV_RGB(0,0,128));
        /*
        if(((degree<=180 && degree>165) || (degree>=0 && degree<18)) && rho > 100){
            //printf("lines V angle are %f \n", theta*180/CV_PI);
            //printf("rho are %f \n", rho);
            drawLine1(lines[i], outerBox, CV_RGB(0,0,128));
            //drawLine(lines[i], newHu, CV_RGB(0,0,128));

        }
        
        if(degree>=78 && degree<118){
           // printf("lines H angle are %f \n", theta*180/CV_PI);
            //printf("rho are %f \n", rho);
            drawLine1(lines[i], outerBox, CV_RGB(0,0,128));

            //drawLine(lines[i], newHu, CV_RGB(0,0,128));
        }
         */
        
    }
    
        
    mergeRelatedLines1(&lines, grayFrame); // Add this line
    
    //UIImageWriteToSavedPhotosAlbum([[UIImage alloc] initWithCVMat:outerBox], self, 
    //                               @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
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
    
    drawLine1(topEdge, grayFrame, CV_RGB(0,0,0));
    drawLine1(bottomEdge, grayFrame, CV_RGB(0,0,0));
    drawLine1(leftEdge, grayFrame, CV_RGB(0,0,0));
    drawLine1(rightEdge, grayFrame, CV_RGB(0,0,0));
    
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
    ListOfPoint = [[NSMutableArray alloc ] init];
    [ListOfPoint addObject:[NSValue valueWithCGPoint:CGPointMake(src[0].x, src[0].y)]];
    [ListOfPoint addObject:[NSValue valueWithCGPoint:CGPointMake(src[1].x, src[1].y)]];
    [ListOfPoint addObject:[NSValue valueWithCGPoint:CGPointMake(src[2].x, src[2].y)]];
    [ListOfPoint addObject:[NSValue valueWithCGPoint:CGPointMake(src[3].x, src[3].y)]];
    
    printf("COool %f", src[1].x);
    cv::Mat undistorted = Mat(cv::Size(maxLength, maxLength), CV_8UC1);
    cv::warpPerspective(grayFrame, undistorted, cv::getPerspectiveTransform(src, dst), cv::Size(maxLength, maxLength));
    
    //cv::warpPerspective(gridLines, gridLines, cv::getPerspectiveTransform(src, dst), cv::Size(maxLength, maxLength));
    
    //imageFromMat = undistorted;
    

    return ListOfPoint;
    
}

-(Mat) transformMat:(Point2f[4]) points andMat:(Mat) imageInMat
{
        


    CvPoint ptBottomLeft = points[3];
    CvPoint ptTopRight = points[1];
    CvPoint ptTopLeft = points[0];
    CvPoint ptBottomRight = points[2];
    
    int maxLength = (ptBottomLeft.x-ptBottomRight.x)*(ptBottomLeft.x-ptBottomRight.x) + (ptBottomLeft.y-ptBottomRight.y)*(ptBottomLeft.y-ptBottomRight.y);
    int temp = (ptTopRight.x-ptBottomRight.x)*(ptTopRight.x-ptBottomRight.x) + (ptTopRight.y-ptBottomRight.y)*(ptTopRight.y-ptBottomRight.y);
    if(temp>maxLength) maxLength = temp;
    
    temp = (ptTopRight.x-ptTopLeft.x)*(ptTopRight.x-ptTopLeft.x) + (ptTopRight.y-ptTopLeft.y)*(ptTopRight.y-ptTopLeft.y);
    if(temp>maxLength) maxLength = temp;
    
    temp = (ptBottomLeft.x-ptTopLeft.x)*(ptBottomLeft.x-ptTopLeft.x) + (ptBottomLeft.y-ptTopLeft.y)*(ptBottomLeft.y-ptTopLeft.y);
    if(temp>maxLength) maxLength = temp;
    
    maxLength = sqrt((double)maxLength);
    
    Point2f dst[4];
    dst[0] = Point2f(0,0);
    dst[1] = Point2f(imageInMat.rows-1, 0);
    dst[2] = Point2f(imageInMat.rows-1, imageInMat.cols-1);
    dst[3] = Point2f(0, imageInMat.cols-1);
    cv::Mat undistorted = Mat(cv::Size(maxLength, maxLength), CV_8UC1);
    cv::warpPerspective(imageInMat, undistorted, cv::getPerspectiveTransform(points, dst), cv::Size(imageInMat.rows, imageInMat.cols));
    
    //cv::warpPerspective(gridLines, gridLines, cv::getPerspectiveTransform(points, dst), cv::Size(imageInMat.rows, imageInMat.rows));
    
    imageFromMat = undistorted.clone();
    //gridLines = [self largestBlob:imageFromMat.clone()];

    return imageFromMat;
    
}

-(void) readDigit: (Mat) image andGrid:(cv::Mat)grid
{

    
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
    tesseract->SetVariable("tessedit_char_whitelist", "123456789");
    tesseract->Init([dataPath cStringUsingEncoding:NSUTF8StringEncoding], "eng", tesseract::OEM_TESSERACT_ONLY, NULL, 0, NULL, NULL, false);


    tesseract->SetVariable("tessedit_char_whitelist", "123456789");
    
    
    
    //cv::medianBlur(imageFromMat, imageFromMat, 11);
    //cv::GaussianBlur(imageFromMat, imageFromMat, cv::Size(11,11), 0);

    //cv::medianBlur(imageFromMat, imageFromMat, 13);


    cv::cvtColor(image, image, cv::COLOR_RGB2GRAY);
    
    //cv::Mat tempfor = cv::Mat(image.size(), CV_8UC1);

    //GaussianBlur(image, tempfor, cv::Size(3,3), 0);
    gridLines = grid.clone();
    imageFromMat = image.clone();
    printf("grid w%d h%d img w%d h%d \n",gridLines.rows,gridLines.cols,imageFromMat.rows,imageFromMat.cols);
    GaussianBlur(imageFromMat, imageFromMat, cv::Size(11,11), 0);
    medianBlur(imageFromMat, imageFromMat, 5);
    adaptiveThreshold(imageFromMat, imageFromMat, 255, ADAPTIVE_THRESH_GAUSSIAN_C, CV_THRESH_BINARY_INV, 389, 1);
    bitwise_not(gridLines, gridLines);
    
    //bitwise_and(undistortedThreshed, newHu, newHu);
    
    bitwise_and(imageFromMat, gridLines, imageFromMat);
        
    bitwise_not(imageFromMat, imageFromMat);
    tesseract->SetPageSegMode(tesseract::PSM_SINGLE_CHAR);
    

    int EdgeCuttingW = imageFromMat.size().width /100;
    
    int EdgeCuttingH = imageFromMat.size().height /100;
    printf("w%d h%d",EdgeCuttingW,EdgeCuttingH);
    //cv::Rect roi= cv::Rect(EdgeCuttingW, EdgeCuttingW, imageFromMat.size().width - EdgeCuttingW, imageFromMat.size().height -EdgeCuttingH);
    //cv::Mat cropped_Image = imageFromMat(roi);
    //imageFromMat.release();

    //imageFromMat = cropped_Image.clone();
    
    tesseract->SetImage((uchar*)imageFromMat.data, imageFromMat.size().width, imageFromMat.size().height, imageFromMat.channels(), imageFromMat.step1());


    
    //_resultInString = [ NSString stringWithUTF8String:tesseract->GetUTF8Text() ] ;
    char * endSt;
    resultInArray = [[NSMutableArray alloc] initWithCapacity:8];
    HitoriCell *tempCell;
    //[resultInArray addObject:@"Hello"];


    for (int i = 0; i<8; i++) {
        rows = [[NSMutableArray alloc] initWithCapacity:8];
                for (int j = 0; j<8; j++) {

            tesseract->SetRectangle((imageFromMat.size().width/8)*j, (imageFromMat.size().height/8)*i, (imageFromMat.size().width/8), (imageFromMat.size().height/8));
            tesseract->Recognize(0);
                    
            
                    
                    int *conf =  tesseract->AllWordConfidences();
                    NSLog(@"Confidence is %d", conf[0]);
            const char* outer =tesseract->GetUTF8Text();
            int nSt = (int)std::strtol(outer, &endSt, 10) ;
           
                    
            matrix[i][j] = nSt;
            tempCell = [[HitoriCell alloc] init];
                    tempCell.number = nSt;
                    tempCell.NumberAsString = [NSString stringWithUTF8String:&(tesseract->GetUTF8Text()[0])];
                    tempCell.confidence = conf[0];
                    tempCell.Status = CELL_VISABLE;
                    tempCell.Hidden = false;

                    HitoriPoint *point = [[HitoriPoint alloc]init];
                    point.x = i;
                    point.y =j;
                    tempCell.location = point;
                    
            [rows addObject:tempCell];
           // std::cout << "character is " << outer << std::endl;

        }
        [resultInArray addObject:rows];
        //[rows removeAllObjects];
    }
}

void getMatrix (int metx[8][8])
{

    metx = matrix;
}
// Draw Line
void drawLine1(cv::Vec2f line, cv::Mat &img, cv::Scalar rgb = CV_RGB(0,0,255))
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

void mergeRelatedLines1(cv::vector<cv::Vec2f> *lines, cv::Mat &img)
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


-(Mat) largestBlob: (Mat) matImage
{

    // Convert captured frame to grayscale
    cv::cvtColor(matImage, matImage, cv::COLOR_RGB2GRAY);
    
    cv::Mat outerBox = cv::Mat(matImage.size(), CV_8UC1);
    
    
    cv::GaussianBlur(matImage, outerBox, cv::Size(11,11), 0);
    
    
    cv::adaptiveThreshold( outerBox, outerBox, 255, cv::ADAPTIVE_THRESH_MEAN_C, cv::THRESH_BINARY, 83, 1);
    
    bitwise_not( outerBox,  outerBox);
    
    // Largest Blob
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
    
    // secound Pass
    
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
    
    return outerBox;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error 
  contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        // Show error message...
        
    }
    else  // No errors
    {
        // Show message image successfully saved
    }
}




@end
