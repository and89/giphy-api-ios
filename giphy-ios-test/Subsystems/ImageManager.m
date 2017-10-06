//
//  ImageManager.m
//  giphy-ios-test
//
//  Created by andy on 02.10.17.
//  Copyright © 2017 andy. All rights reserved.
//

#import "ImageManager.h"
#import "NetworkManager.h"
#import "GiphyItem.h"

@interface ImageManager ()

@property (atomic, strong) NSCache *imageCache;

- (void)didReceiveMemoryWarning;

@end

@implementation ImageManager

+ (instancetype)sharedInstance {
	static ImageManager *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[ImageManager alloc] init];
	});
	return instance;
}

- (instancetype)init {
	if (self = [super init]) {
		_imageCache = [[NSCache alloc] init];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
	}
	return self;
}

- (UIImage *)imageForId:(NSString *)identifier {
	return [self.imageCache objectForKey:identifier];
}

- (UIImage *)imageForId:(const GiphyItem *)item withCompletionBlock:(fetchImageT)block {
	UIImage *cached = [self.imageCache objectForKey:item.ident];
	if (cached) {
		return cached;
	} else {
		__weak typeof(self) welf = self;
		[[NetworkManager sharedInstance] requestImageWithUrl:item.urlPreview withBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
			if (error || !data) {
				return;
			}
			
			UIImage *img = [UIImage imageWithData:data];
			[welf.imageCache setObject:img forKey:item.ident];
			
			if (block) {
				block(img);
			}
		}];
		return nil;
	}
}

- (void)cleanUp {
	[self.imageCache removeAllObjects];
}

- (void)didReceiveMemoryWarning {
	[self cleanUp];
}

@end
