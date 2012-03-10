//
//  HitoriCell.h
//  HitioriGrab
//
//  Created by Mujtaba Alboori on 06/03/2012.
//  Copyright (c) 2012 Aptogo Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HitoriPoint.h"
enum HitoriCellStatus {CELL_HIDDEN,CELL_VISABLE,CELL_NO_MULTIPLE,CELL_MULTIPLE_PER_RAW, CELL_MULTIPLE_PER_COLUMN, CELL_MULTIPLE_PER_RAW_AND_COLUMN,CELL_NOT_PAINTABLE_PAINTED};
enum HitoriMarkStatus {MARK_HIDDEN,MARK_NOT_MULTIPLE,MARK_MULTIPLE_PER_RAW, MARK_MULTIPLE_PER_COLUMN, MARK_MULTIPLE_PER_RAW_AND_COLUMN,MARK_NOT_PAINTABLE_PAINTED};

@interface HitoriCell : NSObject
{
    int number;
    BOOL Hidden;
    enum HitoriCellStatus Status;
    enum HitoriMarkStatus Mark;
    int confidence;
    NSString *NumberAsString;
    int x;
    int y;
    HitoriPoint *location;
}

@property int number;
@property int confidence;
@property BOOL Hidden;
@property enum HitoriCellStatus Status;
@property NSString *NumberAsString;
@property enum HitoriMarkStatus Mark;
@property HitoriPoint *location;
@end
