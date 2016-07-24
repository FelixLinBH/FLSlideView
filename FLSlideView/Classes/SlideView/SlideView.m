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
@property (assign, nonatomic) UIView *slideSubView;
@property (nonatomic) UILabel *viewControllerTitleLabel;

@end


@implementation SlideView
- (void)updateConstraints{
    
    [_slideSubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [super updateConstraints];
}

- (instancetype)initWithRootView:(UIViewController *)rootViewController viewController:(UIViewController *)viewController slideSubView:(UIView *)slideSubView{
    self = [super init];
    if (self) {
        _direction = SlideViewControllerDirectionRight;
        
        _rootViewController = rootViewController;
        _viewController = viewController;
        
        _slideSubView = slideSubView;
        
        _rootTitleView = rootViewController.navigationItem.titleView;
        _rootTitleLabel = [rootViewController.navigationItem.titleView subviews][0];
        _viewControllerTitleLabel = [[UILabel alloc]initWithFrame:_rootTitleView.bounds];
        _viewControllerTitleLabel.alpha = 0;
        _viewControllerTitleLabel.text = viewController.title;
        _viewControllerTitleLabel.textAlignment = NSTextAlignmentCenter;
        
        [_rootTitleView addSubview:_viewControllerTitleLabel];

        [_viewController willMoveToParentViewController:_rootViewController];
        [_rootViewController addChildViewController:_viewController];
        [_rootViewController.view addSubview:_viewController.view];
        [_viewController didMoveToParentViewController:_rootViewController];
        
        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)]];
        [self addSubview:_slideSubView];
        [self needsUpdateConstraints];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = _viewController.view.frame;
    switch (_direction) {
        case SlideViewControllerDirectionLeft:
            frame.origin.x = (-[[UIScreen mainScreen]bounds].size.width);
            break;
        case SlideViewControllerDirectionRight:
            frame.origin.x = ([[UIScreen mainScreen]bounds].size.width);
            break;
        case SlideViewControllerDirectionTop:
            frame.origin.y = (-[[UIScreen mainScreen]bounds].size.height);
            break;
        case SlideViewControllerDirectionBottom:
            frame.origin.y = ([[UIScreen mainScreen]bounds].size.height);
            break;
    }
    
    _viewController.view.frame = frame;
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
    CGFloat titleViewAlpha = 0;
    
    CGRect slideView = self.frame;
    BOOL isNextNav = YES;
    
    if (_direction == SlideViewControllerDirectionLeft) {
        newTitleView.origin.x = - newTitleView.size.width;
        _viewControllerTitleLabel.frame = newTitleView;
        titleView.origin.x = [[UIScreen mainScreen]bounds].size.width;
        frame.origin.x = [[UIScreen mainScreen]bounds].size.width;
        newTitleView.origin.x = _rootTitleView.center.x - (newTitleView.size.width / 2) - _rootTitleView.frame.origin.x;
    }else if (_direction == SlideViewControllerDirectionRight) {
        newTitleView.origin.x = newTitleView.size.width;
        _viewControllerTitleLabel.frame = newTitleView;
        titleView.origin.x = -[[UIScreen mainScreen]bounds].size.width;
        frame.origin.x = -[[UIScreen mainScreen]bounds].size.width;
        newTitleView.origin.x = _rootTitleView.center.x - (newTitleView.size.width / 2) - _rootTitleView.frame.origin.x;
    }else if (_direction == SlideViewControllerDirectionTop){
        slideView.origin.y = [[UIScreen mainScreen]bounds].size.height;

    }else if( _direction == SlideViewControllerDirectionBottom){
        slideView.origin.y = -frame.size.height;
    }
    frameViewControll.origin.y = 0;
    frameViewControll.origin.x = 0;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.35 animations:^{

        _viewController.view.frame = frameViewControll;
        _viewControllerTitleLabel.frame = newTitleView;
        _rootTitleLabel.frame = titleView;
        _rootTitleLabel.alpha = titleViewAlpha;
        _viewControllerTitleLabel.alpha = 1 - titleViewAlpha;
        [_slideSubView setFrame:frame];
        [weakSelf setFrame:slideView];
        
    } completion:^(BOOL finished) {
        
        [_rootViewController.navigationController setNavigationBarHidden:isNextNav];

        if (isNextNav && self.delegate && [self.delegate respondsToSelector:@selector(rootViewController:didShowSlideViewController:)]) {
            [self.delegate rootViewController:_rootViewController didShowSlideViewController:_viewController];
        }
        
        if (isNextNav && self.delegate && [self.delegate respondsToSelector:@selector(slideViewDidSlide:)]) {
            [self.delegate slideViewDidSlide:self];
        }
        
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
        
        if (_direction == SlideViewControllerDirectionTop) {
            _originViewControllerPoint.y += self.frame.origin.y;
        }
       
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (point.y > 0 && _direction == SlideViewControllerDirectionTop || point.y < 0 && _direction == SlideViewControllerDirectionBottom) {
            
            CGRect frame = self.frame;
            frame.origin.y = _originPoint.y + point.y;
            self.frame = frame;
            CGRect frameViewControll = _viewController.view.frame;
            frameViewControll.origin.y = _originViewControllerPoint.y + point.y;
            
            _viewController.view.frame = frameViewControll;
            
        }
        
        if ((point.x > 0 && _direction == SlideViewControllerDirectionLeft )|| (point.x < 0 && _direction == SlideViewControllerDirectionRight)) {
            CGRect frame = self.frame;
            frame.origin.x = _originPoint.x + point.x;
            self.frame = frame;
            
            CGRect frameViewControll = _viewController.view.frame;
            frameViewControll.origin.x = _originViewControllerPoint.x + point.x;
           
            _viewController.view.frame = frameViewControll;
            
            CGRect titleView = _rootTitleLabel.frame;
            titleView.origin.x = _originRootViewControllerTitleViewPoint.x + point.x;
            _rootTitleLabel.frame = titleView;
            
           
            
            CGPoint newTitleViewCenter = _viewControllerTitleLabel.center;
            if (_direction == SlideViewControllerDirectionLeft) {
                newTitleViewCenter.x = point.x / 2 - _rootTitleView.frame.origin.x;
                 _rootTitleLabel.alpha = 1 - ((_originRootViewControllerTitleViewPoint.x + point.x) * 1.5 ) / ([[UIScreen mainScreen]bounds].size.width);
            }else{
                newTitleViewCenter.x = point.x / 2 + [[UIScreen mainScreen]bounds].size.width;
                 _rootTitleLabel.alpha = 0.5 - ([[UIScreen mainScreen]bounds].size.width - newTitleViewCenter.x) / ([[UIScreen mainScreen]bounds].size.width / 2);
            }
            
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
        
        if (([recognizer velocityInView:self].x < 0 && _direction == SlideViewControllerDirectionLeft )|| ([recognizer velocityInView:self].x > 0 && _direction == SlideViewControllerDirectionRight )||([recognizer velocityInView:self].y < 0 && _direction == SlideViewControllerDirectionTop) ||([recognizer velocityInView:self].y > 0 && _direction == SlideViewControllerDirectionBottom)) {
            frame.origin.x = 0;
            frame.origin.y = _originPoint.y;
            titleView.origin.x = _originRootViewControllerTitleViewPoint.x;
            if (_direction == SlideViewControllerDirectionRight) {
                frameViewControll.origin.x = ([[UIScreen mainScreen]bounds].size.width);
                newTitleViewCenter.x = _viewControllerTitleLabel.frame.size.width;
            }else if (_direction == SlideViewControllerDirectionLeft){
                frameViewControll.origin.x = (-[[UIScreen mainScreen]bounds].size.width);
                newTitleViewCenter.x = - _viewControllerTitleLabel.frame.size.width;
            }else if(_direction == SlideViewControllerDirectionTop){
                frameViewControll.origin.y = (-[[UIScreen mainScreen]bounds].size.height);
            }else if(_direction == SlideViewControllerDirectionBottom){
                frameViewControll.origin.y = ([[UIScreen mainScreen]bounds].size.height);
            }
            
        }else{
            
            if (_direction == SlideViewControllerDirectionRight) {
                frame.origin.x = -[[UIScreen mainScreen]bounds].size.width;
                titleView.origin.x = -[[UIScreen mainScreen]bounds].size.width;
                frameViewControll.origin.x = 0;
            }else if(_direction == SlideViewControllerDirectionLeft) {
                frame.origin.x = [[UIScreen mainScreen]bounds].size.width;
                titleView.origin.x = [[UIScreen mainScreen]bounds].size.width;
                frameViewControll.origin.x = 0;
            }else if (_direction == SlideViewControllerDirectionTop){
                frame.origin.y = [[UIScreen mainScreen]bounds].size.height;
                frameViewControll.origin.y = 0;
            }else if( _direction == SlideViewControllerDirectionBottom){
                frame.origin.y = -frame.size.height;
                frameViewControll.origin.y = 0;
            }
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
            
            if (isNextNav && self.delegate && [self.delegate respondsToSelector:@selector(rootViewController:didShowSlideViewController:)]) {
                [self.delegate rootViewController:_rootViewController didShowSlideViewController:_viewController];
            }
            
            if (isNextNav && self.delegate && [self.delegate respondsToSelector:@selector(slideViewDidSlide:)]) {
                [self.delegate slideViewDidSlide:self];
            }
            
        }];
        
        
    }

    
}

- (void)dismiss{
    
    
    
    
    [_viewController.view sendSubviewToBack:_rootViewController.view];
    
    [_rootViewController.navigationController setNavigationBarHidden:NO];
    //
    CGRect frame = self.frame;
    if (_direction == SlideViewControllerDirectionLeft) {
        frame.origin.x = [[UIScreen mainScreen]bounds].size.width;
    }else if (_direction == SlideViewControllerDirectionRight) {
        frame.origin.x = -[[UIScreen mainScreen]bounds].size.width;
    }
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
    if (_direction == SlideViewControllerDirectionLeft) {
        frameViewControll.origin.x = (-[[UIScreen mainScreen]bounds].size.width);
        newTitleView.origin.x = - newTitleView.size.width;
    }else if (_direction == SlideViewControllerDirectionRight) {
        frameViewControll.origin.x = ([[UIScreen mainScreen]bounds].size.width);
        newTitleView.origin.x = newTitleView.size.width;
    }else if (_direction == SlideViewControllerDirectionTop) {
     
    
        frameViewControll.origin.y = -[[UIScreen mainScreen]bounds].size.height;
    }else if (_direction == SlideViewControllerDirectionBottom){
        frameViewControll.origin.y += [[UIScreen mainScreen]bounds].size.height;
    }
    
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
        [SlideViewSharedInstance sharedInstance].isSlided = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(rootViewController:didDismissSlideViewController:)]) {
            [self.delegate rootViewController:_rootViewController didDismissSlideViewController:_viewController];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(slideViewDidRollback:)]) {
            [self.delegate slideViewDidRollback:self];
        }
        
    }];

}

@end
