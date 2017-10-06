//
//  ResultTableViewCell.h
//  giphy-ios-test
//
//  Created by andy on 02.10.17.
//  Copyright © 2017 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CellPresenter;

@interface ResultTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *previewImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, weak) CellPresenter *presenter;

- (void)setPreview:(UIImage *)preview;

@end
