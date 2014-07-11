//
//  RWTFlickrSearchImpl.m
//  RWTFlickrSearch
//
//  Created by morris on 14-7-4.
//  Copyright (c) 2014年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchImpl.h"
#import "RWTFlickrSearchResults.h"
#import "RWTFlickrPhoto.h"
#import <objectiveflickr/ObjectiveFlickr.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RWTFlickrPhotoMetadata.h"
#import <ReactiveCocoa/RACEXTScope.h>

@interface RWTFlickrSearchImpl () <OFFlickrAPIRequestDelegate>

@property (strong, nonatomic) NSMutableSet *requests;
@property (strong, nonatomic) OFFlickrAPIContext *flickrContext;

@end

@implementation RWTFlickrSearchImpl

- (id)init
{
    if (self = [super init]) {
        NSString *OFSampleAppAPIKey = @"2ab4deb354c2a8e26e76c08487fc0101";
        NSString *OFSampleAppAPISharedSecret = @"38b23513909db56f";
        _flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:OFSampleAppAPIKey
                                                       sharedSecret:OFSampleAppAPISharedSecret];
        _requests = [NSMutableSet new];
    }
    return self;
}

- (RACSignal *)signalFromAPIMethod:(NSString *)method arguments:(NSDictionary *)args transform:(id (^)(NSDictionary *response))block
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        OFFlickrAPIRequest *flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:self.flickrContext];
        flickrRequest.delegate = self;
        [self.requests addObject:flickrRequest];
        RACSignal *errorSignal = [self rac_signalForSelector:@selector(flickrAPIRequest:didFailWithError:) fromProtocol:@protocol(OFFlickrAPIRequestDelegate)];
        [errorSignal subscribeNext:^(RACTuple *tuple) {
            [subscriber sendError:tuple.second];
        }];
        RACSignal *successSignal = [self rac_signalForSelector:@selector(flickrAPIRequest:didCompleteWithResponse:) fromProtocol:@protocol(OFFlickrAPIRequestDelegate)];
        @weakify(flickrRequest)
        [[[[successSignal filter:^BOOL(RACTuple *tuple) {
            @strongify(flickrRequest)
            return tuple.first == flickrRequest;
        }] map:^id(RACTuple *tuple) {
            return tuple.second;
        }] map:block] subscribeNext:^(id x) {
            [subscriber sendNext:x];
            [subscriber sendCompleted];
        }];
        [flickrRequest callAPIMethodWithGET:method arguments:args];
        return [RACDisposable disposableWithBlock:^{
            [self.requests removeObject:flickrRequest];
        }];
    }];
}

- (RACSignal *)flickrSearchSignal:(NSString *)searchString
{
    return [self signalFromAPIMethod:@"flickr.photos.search"
                           arguments:@{@"text": searchString,
                                       @"sort": @"interestingness-desc"}
                           transform:^id(NSDictionary *response) {
                               RWTFlickrSearchResults *results = [RWTFlickrSearchResults new];
                               results.searchString = searchString;
                               results.totalResults = [[response valueForKeyPath:@"photos.total"] integerValue];
                               NSArray *photos = [response valueForKeyPath:@"photos.photo"];
                               results.photos = [photos linq_select:^id(NSDictionary *jsonPhoto) {
                                   RWTFlickrPhoto *photo = [RWTFlickrPhoto new];
                                   photo.title = [jsonPhoto objectForKey:@"title"];
                                   photo.identifier = [jsonPhoto objectForKey:@"id"];
                                   photo.url = [self.flickrContext photoSourceURLFromDictionary:jsonPhoto size:OFFlickrSmallSize];
                                   return photo;
                               }];
                               return results;
                           }];
}

- (RACSignal *)flickrImageMetadata:(NSString *)photoId
{
    RACSignal *favorites = [self signalFromAPIMethod:@"flickr.photos.getFavorites" arguments:@{@"photo_id": photoId} transform:^id(NSDictionary *response) {
        NSString *total = [response valueForKeyPath:@"photo.total"];
        return total;
    }];
    RACSignal *comments = [self signalFromAPIMethod:@"flickr.photos.getInfo" arguments:@{@"photo_id": photoId} transform:^id(NSDictionary *response) {
        NSString *total = [response valueForKeyPath:@"photo.comments._text"];
        return total;
    }];
    return [RACSignal combineLatest:@[favorites, comments]
            reduce:^id(NSString *favs, NSString *coms) {
                RWTFlickrPhotoMetadata *meta = [RWTFlickrPhotoMetadata new];
                meta.comments = [coms integerValue];
                meta.favorites = [favs integerValue];
                return meta;
            }];
}

@end
