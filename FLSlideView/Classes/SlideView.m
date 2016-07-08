//
//  SlideView.m
//  FLSlideView
//
//  Created by felix.lin on 07/08/2016.
//  Copyright (c) 2016 felix.lin. All rights reserved.
//

#import "SlideView.h"
#import "Masonry/Masonry.h"
#import "SlideViewSharedInstance.h"
@interface SlideView ()
@property (assign, readwrite, nonatomic) CGPoint originPoint;
@property (assign, readwrite, nonatomic) CGPoint originViewControllerPoint;
@property (assign, readwrite, nonatomic) CGPoint originRootViewControllerTitleViewPoint;

@property (assign, nonatomic) UIViewController *viewController;
@property (assign, nonatomic) UIViewController *rootViewController;

@property (assign, nonatomic) UIView *rootTitleView;
@property (assign, nonatomic) UIView *rootTitleLabel;
@property (nonatomic) UILabel *viewControllerTitleLabel;

@end


@implementation SlideView

- (instancetype)initWithRootView:(UIViewController *)rootViewController ViewController:(UIViewController *)viewController{
    self = [super init];
    if (self) {
        _rootViewController = rootViewController;
        _viewController = viewController;
        _rootTitleView = rootViewController.navigationItem.titleView;

        _rootTitleLabel = [rootViewController.navigationItem.titleView subviews][0];
        _viewControllerTitleLabel = [[UILabel alloc]initWithFrame:_rootTitleView.bounds];
        _viewControllerTitleLabel.alpha = 0;
        _viewControllerTitleLabel.text = viewController.title;
        _viewControllerTitleLabel.textAlignment = NSTextAlignmentCenter;
        
        [_rootTitleView addSubview:_viewControllerTitleLabel];

        CGRect frame = _viewController.view.frame;
        frame.origin.x -= [[UIScreen mainScreen]bounds].size.width;
        _viewController.view.frame = frame;
        [_viewController willMoveToParentViewController:_rootViewController];
        [_rootViewController addChildViewController:_viewController];
        [_rootViewController.view addSubview:_viewController.view];
        [_viewController didMoveToParentViewController:_rootViewController];
        
        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)]];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect frame = _viewController.view.frame;
    frame.origin.x = (-[[UIScreen mainScreen]bounds].size.width);
    _viewController.view.frame = frame;
}

-(void)setSlideSubView:(UIView *)slideSubView{
    _slideSubView = slideSubView;
    [self addSubview:_slideSubView];
    [_slideSubView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self);
    }];
    
}

- (void)tapGestureRecognized:(UITapGestureRecognizer *)recognizer
{
    
    if ([SlideViewSharedInstance sharedInstance].isSlided) {
        return;
    }
    [SlideViewSharedInstance sharedInstance].isSlided = YES;
    
    [_rootViewController.view bringSubviewToFront:_viewController.view];
    
    _originRootViewControllerTitleViewPoint = _rootTitleLabel.frame.origin;
    
    CGRect frame = _slideSubView.frame;
    CGRect frameViewControll = _viewController.view.frame;
    CGRect titleView = _rootTitleLabel.frame;
    CGRect newTitleView = _viewControllerTitleLabel.frame;
    newTitleView.origin.x = - newTitleView.size.width;
    _viewControllerTitleLabel.frame = newTitleView;
    CGFloat titleViewAlpha = 1.0;
    BOOL isNextNav = NO;
    titleView.origin.x = [[UIScreen mainScreen]bounds].size.width;
    frame.origin.x = [[UIScreen mainScreen]bounds].size.width;
    frameViewControll.origin.x = 0;
    titleViewAlpha = 0;
    
    newTitleView.origin.x = _rootTitleView.center.x - (newTitleView.size.width / 2) - _rootTitleView.frame.origin.x;
    isNextNav = YES;

    [UIView animateWithDuration:0.35 animations:^{
            
        _viewController.view.frame = frameViewControll;
        _viewControllerTitleLabel.frame = newTitleView;
        _rootTitleLabel.frame = titleView;
        _rootTitleLabel.alpha = titleViewAlpha;
        _viewControllerTitleLabel.alpha = 1 - titleViewAlpha;
        [_slideSubView setFrame:frame];
        
        
    } completion:^(BOOL finished) {
            
        [_rootViewController.navigationController setNavigationBarHidden:isNextNav];
        
    }];
    
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer
{
    if ([SlideViewSharedInstance sharedInstance].isSlided) {
        return;
    }
    
    [_rootViewController.view bringSubviewToFront:_viewController.view];
    
    CGPoint point = [recognizer translationInView:self];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _originPoint = self.frame.origin;
        _originViewControllerPoint = _viewController.view.frame.origin;

        if (_rootTitleView != nil) {
            [_rootTitleView addSubview:_viewControllerTitleLabel];
            _originRootViewControllerTitleViewPoint = _rootTitleLabel.frame.origin;
        }
       
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (point.x > 0) {
            CGRect frame = self.frame;
            frame.origin.x = _originPoint.x + point.x;
            self.frame = frame;
            
            CGRect frameViewControll = _viewController.view.frame;
            frameViewControll.origin.x = _originViewControllerPoint.x + point.x;
             _viewController.view.frame = frameViewControll;
            
            CGRect titleView = _rootTitleLabel.frame;
            titleView.origin.x = _originRootViewControllerTitleViewPoint.x + point.x;
            _rootTitleLabel.frame = titleView;
            _rootTitleLabel.alpha = 1 - ((_originRootViewControllerTitleViewPoint.x + point.x) * 1.5 ) / ([[UIScreen mainScreen]bounds].size.width);
            
            CGPoint newTitleViewCenter = _viewControllerTitleLabel.center;
            newTitleViewCenter.x = point.x / 2 - _rootTitleView.frame.origin.x;
            _viewControllerTitleLabel.center = newTitleViewCenter;

            _viewControllerTitleLabel.alpha = 1 - _rootTitleLabel.alpha;

        }
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGRect frame = self.frame;
        CGRect frameViewControll = _viewController.view.frame;
        CGRect titleView = _rootTitleLabel.frame;
        CGPoint newTitleViewCenter = _viewControllerTitleLabel.center;
        
        CGFloat titleViewAlpha = 1.0;
        BOOL isNextNav = NO;
        
        if ([recognizer velocityInView:self].x < 0) {
            frame.origin.x = 0;
            titleView.origin.x = _originRootViewControllerTitleViewPoint.x;

            frameViewControll.origin.x = (-[[UIScreen mainScreen]bounds].size.width);
            newTitleViewCenter.x = - _viewControllerTitleLabel.frame.size.width;
        }else{
            titleView.origin.x = [[UIScreen mainScreen]bounds].size.width;
            frame.origin.x = [[UIScreen mainScreen]bounds].size.width;
            frameViewControll.origin.x = 0;
            titleViewAlpha = 0;
            newTitleViewCenter.x = _rootTitleView.center.x - _rootTitleView.frame.origin.x ;
            isNextNav = YES;
        }
        [SlideViewSharedInstance sharedInstance].isSlided = isNextNav;
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.35 animations:^{
            weakSelf.frame = frame;
            _viewController.view.frame = frameViewControll;
            _viewControllerTitleLabel.center = newTitleViewCenter;
            _rootTitleLabel.frame = titleView;
            _rootTitleLabel.alpha = titleViewAlpha;
            _viewControllerTitleLabel.alpha = 1 - titleViewAlpha;
            
        } completion:^(BOOL finished) {
            [_rootViewController.navigationController setNavigationBarHidden:isNextNav];
        }];
        
        
    }

    
}

- (void)dismiss{
    [SlideViewSharedInstance sharedInstance].isSlided = NO;
//    _isSlide = NO;
    [_viewController.view sendSubviewToBack:_rootViewController.view];
    
    [_rootViewController.navigationController setNavigationBarHidden:NO];
    //
    CGRect frame = self.frame;
    frame.origin.x = [[UIScreen mainScreen]bounds].size.width;
    self.frame = frame;
    //
    //
    CGRect tmpTitleFrame = _slideSubView.frame;
    tmpTitleFrame.origin.x = 0;
    
    //
    CGRect frameViewControll = _viewController.view.frame;
    CGRect titleView = _rootTitleLabel.frame;
    //
    CGRect newTitleView = _viewControllerTitleLabel.frame;
    newTitleView.origin.x = _rootTitleView.center.x - (newTitleView.size.width / 2) - _rootTitleView.frame.origin.x;
    _viewControllerTitleLabel.frame = newTitleView;
    CGFloat titleViewAlpha = 1.0;
    //
    
    frame.origin.x = 0;
    titleView.origin.x = _originRootViewControllerTitleViewPoint.x;
    frameViewControll.origin.x = (-[[UIScreen mainScreen]bounds].size.width);
    newTitleView.origin.x = - newTitleView.size.width;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.35 animations:^{
        
        weakSelf.frame = frame;
        _slideSubView.frame = tmpTitleFrame;
        _viewController.view.frame = frameViewControll;
        _viewControllerTitleLabel.frame = newTitleView;
        _rootTitleLabel.frame = titleView;
        _rootTitleLabel.alpha = titleViewAlpha;
        _viewControllerTitleLabel.alpha = 1 - titleViewAlpha;
        
    } completion:^(BOOL finished) {
        
    }];

}

@end
