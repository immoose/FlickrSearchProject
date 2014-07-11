//
//  RWTSearchResultsViewModel.m
//  RWTFlickrSearch
//
//  Created by morris on 14-7-7.
//  Copyright (c) 2014年 Colin Eberhardt. All rights reserved.
//

#import "RWTSearchResultsViewModel.h"
#import "RWTFlickrPhoto.h"
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RWTSearchResultsItemViewModel.h"

@implementation RWTSearchResultsViewModel

- (instancetype)initWithSearchResults:(RWTFlickrSearchResults *)results services:(id<RWTViewModelServices>)services
{
    if (self = [super init]) {
        _title = results.searchString;
        _searchResults = [results.photos linq_select:^id(RWTFlickrPhoto *photo) {
            return [[RWTSearchResultsItemViewModel alloc] initWithPhoto:photo services:services];
        }];
    }
    return self;
}

@end
