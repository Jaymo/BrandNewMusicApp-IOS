//
//  BNMClientApi.m
//  BrandNewMusicApp
//
//

#import "BNMClientApi.h"

#define HOST_URL @"http://bnmapp.com/ws/bootstrap.php"

@implementation BNMClientApi

+(BNMClientApi *)sharedInsatance{
    
    static BNMClientApi *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance  = [[self alloc] initWithBaseURL:[NSURL URLWithString:HOST_URL]];
    });    return instance;

}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    //[self setDefaultHeader:APIKEY value:APIVALUE];
    
    return self;
}


@end
