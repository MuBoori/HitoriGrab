//
//  HitoriCell.h
//  HitioriGrab
//
//  Created by Mujtaba Alboori on 06/03/2012.
//  Copyright (c) 2012 Aptogo Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
enum HitoriCellStatus {CELL_HIDDEN,CELL_VISABLE,NOT_MULTIPLE,CELL_MULTIPLE_PER_RAW, CELL_MULTIPLE_PER_COLUMN, CELL_MULTIPLE_PER_RAW_AND_COLUMN,CELL_NOT_PAINTABLE_PAINTED};
@interface HitoriCell : NSObject
{
    int number;
    BOOL Hidden;
    enum HitoriCellStatus Status;
    int confidence;
    NSString *NumberAsString;
}

@property int number;
@property int confidence;
@property BOOL Hidden;
@property enum HitoriCellStatus Status;
@property NSString *NumberAsString;
@end
