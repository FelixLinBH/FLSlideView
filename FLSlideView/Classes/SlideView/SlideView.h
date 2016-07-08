//
//  SlideView.h
//  FLSlideView
//
//  Created by felix.lin on 07/08/2016.
//  Copyright (c) 2016 felix.lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideView : UIView

- (instancetype)initWithRootView:(UIViewController *)rootViewController viewController:(UIViewController *)viewController slideSubView:(UIView *)slideSubView;
- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer;
- (void)dismiss;

@end
