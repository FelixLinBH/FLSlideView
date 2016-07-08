//
//  SlideView.h
//  FLSlideView
//
//  Created by felix.lin on 07/08/2016.
//  Copyright (c) 2016 felix.lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideView : UIView
@property (nonatomic) UIView *slideSubView;
- (instancetype)initWithRootView:(UIViewController *)rootViewController ViewController:(UIViewController *)viewController;
- (instancetype)initWithRootView:(UIViewController *)rootViewController ViewController:(UIViewController *)viewController subView:(UIView *)subView;
- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer;
- (void)dismiss;

@end
