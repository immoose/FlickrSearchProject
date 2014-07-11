//
//  RWTFlickrSearch.h
//  RWTFlickrSearch
//
//  Created by morris on 14-7-4.
//  Copyright (c) 2014年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@protocol RWTFlickrSearch <NSObject>

- (RACSignal *)flickrSearchSignal:(NSString *)searchString;

- (RACSignal *)flickrImageMetadata:(NSString *)photoId;

@end
