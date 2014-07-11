//
//  RWTFlickrPhotoMetadata.m
//  RWTFlickrSearch
//
//  Created by morris on 14-7-10.
//  Copyright (c) 2014年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrPhotoMetadata.h"

@implementation RWTFlickrPhotoMetadata

- (NSString *)description
{
    return [NSString stringWithFormat:@"metadata: comments=%lU, faves=%lU",
            (unsigned long)self.comments, (unsigned long)self.favorites];
}

@end
