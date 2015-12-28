//
//  BNMArtist.m
//  BrandNewMusicApp
//
//

#import "BNMArtist.h"

@implementation BNMArtist

@synthesize delegate = delegate_;

-(id)initWithDictionary:(NSDictionary*)dict{
    
    
    if (self = [super init]) {
        
        if([dict valueForKey:@"artist_id"] && ![[dict valueForKey:@"artist_id"]isEqual:[NSNull null]])
        {
            self.artistId = [dict valueForKey:@"artist_id"];
        }
        if([dict valueForKey:@"artist_name"] && ![[dict valueForKey:@"artist_name"]isEqual:[NSNull null]])
        {
            self.artistName = [dict valueForKey:@"artist_name"];
        }
        
        if([dict valueForKey:@"artist_follow_status"] && ![[dict valueForKey:@"artist_follow_status"]isEqual:[NSNull null]])
        {
            self.artistFollowStatus = [[dict valueForKey:@"artist_follow_status"] intValue];
        }
        
        if([dict valueForKey:@"artist_image_url"] && ![[dict valueForKey:@"artist_image_url"]isEqual:[NSNull null]])
        {
            self.artistImageUrl = [dict valueForKey:@"artist_image_url"];
        }
        
    }
    return self;
    
}

- (UIImage *)artistNewImage{
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* imageFile = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@NewArtistImage.png",self.artistId]];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:imageFile]){
        return [UIImage imageWithContentsOfFile:imageFile];
    }
    return nil;
    
}
- (void)loadArtistNewImageData{
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString* imageFile = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@NewArtistImage.png",self.artistId]];
    
    NSString *imageString = [NSString stringWithFormat:@"%@",self.artistImageUrl];
    
    NSString *finalImageString = [imageString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if ([finalImageString isKindOfClass:[NSString class]]) {
        NSData *data = [NSData dataWithContentsOfURL:[[NSURL alloc] initWithString: finalImageString]];
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                [data writeToFile:imageFile atomically:YES];
                if ([delegate_ respondsToSelector:@selector(artistNewImageDataLoaded)]) {
                    [delegate_ artistNewImageDataLoaded];
                }
            }
            else {
                if ([delegate_ respondsToSelector:@selector(failedToLoadArtistNewImageData)]) {
                    [delegate_ failedToLoadArtistNewImageData];
                }
                
            }
        }
        else {
            if ([delegate_ respondsToSelector:@selector(failedToLoadArtistNewImageData)]) {
                [delegate_ failedToLoadArtistNewImageData];
            }
        }
    }
    else {
        //        if ([self.delegate respondsToSelector:@selector(eventFailedToLoadImageData)]) {
        //            [self.delegate eventFailedToLoadImageData];
        //        }
    }
    
}
/*
 artist_name,
 artist_id,
 artist_follow_status,
 artist_image_url
 */
//-----------------------------------------------------------------------------
#pragma mark NSCoding protocol
//-----------------------------------------------------------------------------
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.artistId forKey:@"artist_id"];
    [aCoder encodeObject:self.artistName forKey:@"artist_name"];
    [aCoder encodeInt:self.artistFollowStatus forKey:@"artist_follow_status"];
    [aCoder encodeObject:self.artistImageUrl forKey:@"artist_image_url"];
    return;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if ((self = [super init])) {
        self.artistId = [[aDecoder decodeObjectForKey:@"artist_id"] copy];
        self.artistName = [[aDecoder decodeObjectForKey:@"artist_name"] copy];
        self.artistFollowStatus = [aDecoder decodeIntForKey:@"artist_follow_status"];
        self.artistImageUrl = [[aDecoder decodeObjectForKey:@"artist_image_url"] copy];
        
    }
    return self;
}


@end
