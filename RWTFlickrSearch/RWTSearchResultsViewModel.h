//
//  RWTSearchResultsViewModel.h
//  RWTFlickrSearch
//
//  Created by morris on 14-7-7.
//  Copyright (c) 2014年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWTViewModelServices.h"
#import "RWTFlickrSearchResults.h"

@interface RWTSearchResultsViewModel : NSObject

- (instancetype)initWithSearchResults:(RWTFlickrSearchResults *)results services:(id<RWTViewModelServices>)services;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *searchResults;

@end
