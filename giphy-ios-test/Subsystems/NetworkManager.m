//
//  NetworkManager.m
//  giphy-ios-test
//
//  Created by andy on 02.10.17.
//  Copyright © 2017 andy. All rights reserved.
//

#import "Common.h"
#import "NetworkManager.h"

@interface NetworkManager ()

@property (atomic, strong) NSOperationQueue *networkQueue;
@property (atomic, strong) NSMutableSet<NSString *> *requestedUrls;

@end

@implementation NetworkManager

+ (instancetype)sharedInstance {
	static NetworkManager *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[NetworkManager alloc] init];
	});
	return instance;
}

- (instancetype)init {
	if (self = [super init]) {
		_networkQueue = [[NSOperationQueue alloc] init];
		_networkQueue.maxConcurrentOperationCount = 5;
		_requestedUrls = [[NSMutableSet alloc] initWithCapacity:1024];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanUp) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
	}
	return self;
}

- (void)requestWithUrlString:(NSString *)urlString withBlock:(responseT)block {
	[self.networkQueue addOperationWithBlock:^{
		NSURL *url = [NSURL URLWithString:urlString];
		[[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
			if (block) {
				block(data, response, error);
			}
		}] resume];
	}];
}

- (void)requestImageWithUrl:(NSString *)url withBlock:(responseT)block {
	[self.networkQueue addOperationWithBlock:^{
		[[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
			if (block) {
				block(data, response, error);
			}
		}] resume];
	}];
}

- (void)requestPreview:(NSString *)url withBlock:(responseT)block {
	if ([self.requestedUrls containsObject:url]) {
		return;
	}
	[self.requestedUrls addObject:url];
	__weak typeof(self) welf = self;
	[self requestImageWithUrl:url withBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
		if (!data || error) {
			[welf.requestedUrls removeObject:url];
		}
		if (block) {
			block(data, response, error);
		}
	}];
}

- (void)cleanUp {
	[self.requestedUrls removeAllObjects];
}

@end
