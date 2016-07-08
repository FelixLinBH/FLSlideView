//
//  SlideViewSharedInstance.m
//  FLSlideView
//
//  Created by felix.lin on 07/08/2016.
//  Copyright (c) 2016 felix.lin. All rights reserved.
//

#import "SlideViewSharedInstance.h"

@implementation SlideViewSharedInstance

+ (SlideViewSharedInstance *)sharedInstance
{
    static SlideViewSharedInstance *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SlideViewSharedInstance alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _isSlided = NO;
    }
    return self;
}

@end
