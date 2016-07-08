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
#import "UIViewController+Slide.h"
@interface FLViewController ()
@property (nonatomic) SlideView *slideDemo;
@end

@implementation FLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Demo";
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"Demo";
    [titleView addSubview:titleLabel];
    
    [self.navigationItem setTitleView:titleView];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView);
        make.centerX.equalTo(titleView);
        make.height.and.width.mas_equalTo(100);
    }];

    
    UIViewController *demoViewController = [[UIViewController alloc]init];
    demoViewController.view.backgroundColor = [UIColor yellowColor];
    demoViewController.title = @"Demo - 1";
    
    UINavigationController *demoNav = [[UINavigationController alloc]initWithRootViewController:demoViewController];
    demoNav.view.frame = demoViewController.view.frame;
    
    UILabel *demoLabel = [[UILabel alloc]init];
    demoLabel.text = @"Demo Slide Label";
    demoLabel.textAlignment = NSTextAlignmentCenter;
    
    _slideDemo = [[SlideView alloc]initWithRootView:self viewController:demoNav slideSubView:demoLabel];
    _slideDemo.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_slideDemo];
    
    [_slideDemo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.height.mas_equalTo(100);
    }];
    
    demoViewController.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self   action:@selector(method1)];

}

- (void)method1{
    
    [_slideDemo dismiss];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
