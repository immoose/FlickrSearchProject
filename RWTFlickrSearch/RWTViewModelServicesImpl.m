//
//  RWTViewModelServicesImpl.m
//  RWTFlickrSearch
//
//  Created by morris on 14-7-4.
//  Copyright (c) 2014年 Colin Eberhardt. All rights reserved.
//

#import "RWTViewModelServicesImpl.h"
#import "RWTFlickrSearchImpl.h"
#import "RWTSearchResultsViewModel.h"

@interface RWTViewModelServicesImpl ()
@property (strong, nonatomic) RWTFlickrSearchImpl *searchService;
@end

@implementation RWTViewModelServicesImpl

- (id<RWTFlickrSearch>)getFlickrSearchService
{
    return self.searchService;
}

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
{
    if (self = [super init]) {
        _searchService = [RWTFlickrSearchImpl new];
        _navigationController = navigationController;
    }
    return self;
}

- (void)pushViewModel:(id)viewModel
{
    id viewController;
    if ([viewModel isKindOfClass:[RWTSearchResultsViewModel class]]) {
        viewController = [[RWTSearchResultsViewController alloc] initWithViewModel:viewModel];
    } else {
        NSLog(@"an Unknown ViewModel was pushed");
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
