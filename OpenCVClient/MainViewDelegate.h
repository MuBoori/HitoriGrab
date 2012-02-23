//
//  MainViewDelegate.h
//  OpenCVClient
//
//  Created by Mujtaba Alboori on 16/02/2012.
//  Copyright (c) 2012 Aptogo Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "AppDelegateProtocol.h"
#import "DataAppDataObject.h"

@interface MainViewDelegate : UIResponder <UIApplicationDelegate,AppDataObjectProtocol>
{

    DataAppDataObject* theAppDataObject;

}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) DataAppDataObject* theAppDataObject;


@end