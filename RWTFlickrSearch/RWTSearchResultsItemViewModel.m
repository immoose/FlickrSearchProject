//
//  RWTSearchResultsItemViewModel.m
//  RWTFlickrSearch
//
//  Created by morris on 14-7-10.
//  Copyright (c) 2014年 Colin Eberhardt. All rights reserved.
//

#import "RWTSearchResultsItemViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "RWTFlickrPhotoMetadata.h"

@interface RWTSearchResultsItemViewModel ()

@property (weak, nonatomic) id<RWTViewModelServices> services;
@property (strong, nonatomic) RWTFlickrPhoto *photo;

@end

@implementation RWTSearchResultsItemViewModel

- (instancetype)initWithPhoto:(RWTFlickrPhoto *)photo services:(id<RWTViewModelServices>)services
{
    self = [super init];
    if (self) {
        _title = photo.title;
        _url = photo.url;
        _services = services;
        _photo = photo;
        [self initialize];
    }
    return  self;
}

- (void)initialize
{
    RACSignal *visibleStateChanged = [RACObserve(self, isVisible) skip:1];
    RACSignal *visibleSignal = [visibleStateChanged filter:^BOOL(NSNumber *value) {
        return value.boolValue;
    }];
    RACSignal *hiddenSignal = [visibleStateChanged filter:^BOOL(NSNumber *value) {
        return ![value boolValue];
    }];
    RACSignal *fetchMetaData = [[visibleSignal delay:1.0] takeUntil:hiddenSignal];
    @weakify(self)
    [fetchMetaData subscribeNext:^(id x) {
        @strongify(self)
        [[[self.services getFlickrSearchService]
          flickrImageMetadata:self.photo.identifier]
         subscribeNext:^(RWTFlickrPhotoMetadata *x) {
             self.favorites = @(x.favorites);
             self.comments = @(x.comments);
         }];
    }];
}

@end
