//
//  PreviewViewController.h
//  giphy-ios-test
//
//  Created by andy on 02.10.17.
//  Copyright © 2017 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GiphyItem;

@interface PreviewViewController : UIViewController

@property (nonatomic, strong) GiphyItem *selectedItem;

@end
