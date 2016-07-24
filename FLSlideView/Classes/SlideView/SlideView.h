//
//  SlideView.h
//  FLSlideView
//
//  Created by felix.lin on 07/08/2016.
//  Copyright (c) 2016 felix.lin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SlideViewControllerDirection) {
    SlideViewControllerDirectionLeft,
    SlideViewControllerDirectionRight,
    SlideViewControllerDirectionTop,
    SlideViewControllerDirectionBottom
};

@class SlideView;
@protocol SlideViewDelegate <NSObject>
@optional
- (void)slideViewDidSlide:(SlideView *)silderView;
- (void)slideViewDidRollback:(SlideView *)silderView;
- (void)rootViewController:(UIViewController *)rootViewController didShowSlideViewController:(UIViewController *)slideViewController;
- (void)rootViewController:(UIViewController *)rootViewController didDismissSlideViewController:(UIViewController *)slideViewController;
@end

@interface SlideView : UIView
@property (nonatomic, weak) id<SlideViewDelegate> delegate;
@property (nonatomic, assign) SlideViewControllerDirection direction;

- (instancetype)initWithRootView:(UIViewController *)rootViewController viewController:(UIViewController *)viewController slideSubView:(UIView *)slideSubView;
- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer;
- (void)dismiss;

@end
