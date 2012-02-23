//
//  DataAppDataObject.h
//  OpenCVClient
//
//  Created by Mujtaba Alboori on 20/02/2012.
//  Copyright (c) 2012 Aptogo Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDataObject.h"
@interface DataAppDataObject : AppDataObject 
{
    NSMutableArray *HitoriMatrix;
}

@property (nonatomic, retain) NSMutableArray *HitoriMatrix;


@end
