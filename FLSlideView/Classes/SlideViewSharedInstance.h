//
//  SlideViewSharedInstance.h
//  FLSlideView
//
//  Created by felix.lin on 07/08/2016.
//  Copyright (c) 2016 felix.lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SlideViewSharedInstance : NSObject
@property (nonatomic, assign) BOOL isSlided;
+ (SlideViewSharedInstance *)sharedInstance;
@end
