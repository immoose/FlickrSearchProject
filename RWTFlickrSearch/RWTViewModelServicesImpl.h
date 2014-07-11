//
//  RWTViewModelServicesImpl.h
//  RWTFlickrSearch
//
//  Created by morris on 14-7-4.
//  Copyright (c) 2014年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWTViewModelServices.h"
#import "RWTSearchResultsViewController.h"

@interface RWTViewModelServicesImpl : NSObject <RWTViewModelServices>

@property (weak, nonatomic) UINavigationController *navigationController;

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

@end
