//
//  FLViewController.m
//  FLSlideView
//
//  Created by felix.lin on 07/08/2016.
//  Copyright (c) 2016 felix.lin. All rights reserved.
//

#import "FLViewController.h"
#import "SlideView.h"
#import "Masonry/Masonry.h"
@interface FLViewController ()<SlideViewDelegate>
@property (nonatomic) SlideView *slideRight;
@property (nonatomic) SlideView *slideLeft;
@property (nonatomic) SlideView *slideTop;
@property (nonatomic) SlideView *slideBottom;
@property (nonatomic ,assign) SlideView *usedSlideView;
@property (nonatomic, assign) UINavigationController *tmp;
@end

@implementation FLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
	// Do any additional setup after loading the view, typically from a nib.
    
    // RootViewController setting
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"Home";
    [titleView addSubview:titleLabel];
    
    [self.navigationItem setTitleView:titleView];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView);
        make.centerX.equalTo(titleView);
        make.height.and.width.mas_equalTo(100);
    }];
    
    // TopViewController
    _slideTop = [[SlideView alloc]initWithRootView:self viewController:[self createViewControllerWithTitle:@"Top View Controller"] slideSubView:[self createSlideLabelWithTitle:@"Top"]];
    
    _slideTop.delegate = self;
    _slideTop.direction = SlideViewControllerDirectionTop;
    _slideTop.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_slideTop];
    
    [_slideTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(66);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.height.mas_equalTo(50);
    }];
    
    // RightViewController
    _slideRight = [[SlideView alloc]initWithRootView:self viewController:[self createViewControllerWithTitle:@"Right View Controller"] slideSubView:[self createSlideLabelWithTitle:@"Right"]];
    
    _slideRight.direction = SlideViewControllerDirectionRight;
    _slideRight.delegate = self;
    _slideRight.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_slideRight];
    
    [_slideRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.slideTop.mas_bottom).with.offset(10);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.height.mas_equalTo(50);
    }];
    
    // LeftViewController
    _slideLeft = [[SlideView alloc]initWithRootView:self viewController:[self createViewControllerWithTitle:@"Left View Controller"] slideSubView:[self createSlideLabelWithTitle:@"Left"]];
    
    _slideLeft.direction = SlideViewControllerDirectionLeft;
    _slideLeft.delegate = self;
    _slideLeft.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_slideLeft];
    
    [_slideLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.slideRight.mas_bottom).with.offset(10);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.height.mas_equalTo(50);
    }];
    
    // BottomViewController
    _slideBottom = [[SlideView alloc]initWithRootView:self viewController:[self createViewControllerWithTitle:@"Bottom View Controller"] slideSubView:[self createSlideLabelWithTitle:@"Bottom"]];
    _slideBottom.delegate = self;
    
    _slideBottom.direction = SlideViewControllerDirectionBottom;
    _slideBottom.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_slideBottom];
    
    [_slideBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.height.mas_equalTo(50);
    }];

    

}

- (UILabel *)createSlideLabelWithTitle:(NSString *)title{
    UILabel *demoLabel = [[UILabel alloc]init];
    demoLabel.text = title;
    demoLabel.textAlignment = NSTextAlignmentCenter;
    return demoLabel;
}

- (UINavigationController *)createViewControllerWithTitle:(NSString *)title{
    UIViewController *demoViewController = [[UIViewController alloc]init];
    demoViewController.view.backgroundColor = [UIColor yellowColor];
    demoViewController.title = title;
    
    UINavigationController *demoNav = [[UINavigationController alloc]initWithRootViewController:demoViewController];
    demoNav.view.frame = demoViewController.view.frame;
    
    demoViewController.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self   action:@selector(usedSlideViewDismiss)];
    
    demoViewController.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithTitle:@"PushVC" style:UIBarButtonItemStylePlain target:self   action:@selector(push)];
    
    return demoNav;

}

- (void)push{
    UIViewController *demoViewController = [[UIViewController alloc]init];
    demoViewController.view.backgroundColor = [UIColor redColor];
    demoViewController.title = @"Test";
    
    demoViewController.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithTitle:@"POP UP" style:UIBarButtonItemStylePlain target:self   action:@selector(popup)];
    [_tmp pushViewController:demoViewController animated:YES];
}

-(void)popup{
    [_tmp popViewControllerAnimated:YES];
}

- (void)usedSlideViewDismiss{
    
    [_usedSlideView dismiss];
}


#pragma mark - SlideViewDelegate
- (void)rootViewController:(UIViewController *)rootViewController didShowSlideViewController:(UIViewController *)slideViewController{
    NSLog(@"didShowSlideViewController");
    _tmp = (UINavigationController *)slideViewController;
}

- (void)rootViewController:(UIViewController *)rootViewController didDismissSlideViewController:(UIViewController *)slideViewController{
    NSLog(@"didDismissSlideViewController");
}

- (void)slideViewDidSlide:(SlideView *)silderView{
    NSLog(@"slideViewWillSlide");
    _usedSlideView = silderView;
}

- (void)slideViewDidRollback:(SlideView *)silderView{
    NSLog(@"slideViewWillRollback");
    _usedSlideView = nil;
}
@end
