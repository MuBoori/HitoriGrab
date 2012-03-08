//
//  BoardExtractor.h
//  OpenCVClient
//
//  Created by Mujtaba Alboori on 16/02/2012.
//  Copyright (c) 2012 Aptogo Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
//#include <vector>//;
#include "baseapi.h"
#import "HitoriGrid.h"

#include "environ.h"
#import "pix.h"
namespace tesseract {
    class TessBaseAPI;
};
using namespace cv;

@interface BoardExtractor : NSObject{

    cv::Mat imageFromMat;
    cv::Mat gridLines;
    cv::Mat gridImage;
    UIImage* rawImage;
    char* rawResult;
    NSString *resultInString;
    NSMutableArray *rows;
    NSString *resultInMatrix[8][8];
    NSMutableArray *resultInArray;
    
    int colums;
    //int rows;
    //vector<vector<int> > matrix;
    tesseract::TessBaseAPI *tesseract;
}
-(UIImage*) set : (UIImage*) image;

-(void) setMat : (Mat) matImage;
-(void) processImage;
-(void) makeProspective;
-(void) readDigit;


@property Mat gridImage, imageFromMat;
@property UIImage* rawImage;
@property NSString *resultInString;
@property NSMutableArray *resultInArray;
@property NSMutableArray *rows;

void getMatrix (int metx[8][8]);
void drawLine1 (cv::Vec2f line, cv::Mat &img, cv::Scalar rgb);
void mergeRelatedLines1(cv::vector<cv::Vec2f> *lines, cv::Mat &img);

@end
