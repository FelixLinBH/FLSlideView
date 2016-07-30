# FLSlideView

[![Version](https://img.shields.io/cocoapods/v/FLSlideView.svg?style=flat)](http://cocoapods.org/pods/FLSlideView)
[![License](https://img.shields.io/cocoapods/l/FLSlideView.svg?style=flat)](http://cocoapods.org/pods/FLSlideView)
[![Platform](https://img.shields.io/cocoapods/p/FLSlideView.svg?style=flat)](http://cocoapods.org/pods/FLSlideView)

It provides a silde view with viewcontroller.

## How To Use

### Import header
```
#import "SlideView.h"

```

### Create silde view with viewController

#### Use this method

```
- (instancetype)initWithRootView:(UIViewController *)rootViewController viewController:(UIViewController *)viewController slideSubView:(UIView *)slideSubView
```
#### Provide direction property

```
@property (nonatomic, assign) SlideViewControllerDirection direction;
```
### It provide delegate:

```
- (void)slideViewDidSlide:(SlideView *)silderView;
- (void)slideViewDidRollback:(SlideView *)silderView;
- (void)rootViewController:(UIViewController *)rootViewController didShowSlideViewController:(UIViewController *)slideViewController;
- (void)rootViewController:(UIViewController *)rootViewController didDismissSlideViewController:(UIViewController *)slideViewController;
```

## Screen shot

![Editor preferences pane](https://github.com/FelixLinBH/FLSlideView/blob/master/1.gif?raw=true)

## Installation

FLSlideView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "FLSlideView"
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

##Dependency

* [**Masonry**](https://github.com/SnapKit/Masonry)


## Author

[Felix.lin](mailto:fly_81211@hotmail.com)

## License

FLSlideView is available under the MIT license. See the LICENSE file for more info.
