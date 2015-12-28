//
//  BNMTrack.m
//  BrandNewMusicApp
//
//

#import "BNMTrack.h"


@implementation BNMTrack


@synthesize delegate =delegate_;


-(id)initWithDictionary:(NSDictionary*)dict{
    
    
    if (self = [super init]) {
        
        if([dict valueForKey:@"track_id"] && ![[dict valueForKey:@"track_id"]isEqual:[NSNull null]])
        {
            self.trackId = [dict valueForKey:@"track_id"];
        }

        if([dict valueForKey:@"track_name"] && ![[dict valueForKey:@"track_name"]isEqual:[NSNull null]])
        {
            self.tracknName = [dict valueForKey:@"track_name"];
        }
        if([dict valueForKey:@"artist_name"] && ![[dict valueForKey:@"artist_name"]isEqual:[NSNull null]])
        {
            self.trackArtistName = [dict valueForKey:@"artist_name"];
        }
        
        if([dict valueForKey:@"track_url"] && ![[dict valueForKey:@"track_url"]isEqual:[NSNull null]])
        {
            self.trackUrl = [dict valueForKey:@"track_url"];
        }
        if([dict valueForKey:@"track_count"] && ![[dict valueForKey:@"track_count"]isEqual:[NSNull null]])
        {
            self.trackListnersCount = [dict valueForKey:@"track_count"];
        }
        if([dict valueForKey:@"track_itunes_link"] && ![[dict valueForKey:@"track_itunes_link"]isEqual:[NSNull null]])
        {
            self.trackItunesLink = [dict valueForKey:@"track_itunes_link"];
        }
        if([dict valueForKey:@"download_link"] && ![[dict valueForKey:@"download_link"]isEqual:[NSNull null]])
        {
            self.trackDownloadLink = [dict valueForKey:@"download_link"];
        }
        
        if([dict valueForKey:@"track_itunes_link"] && ![[dict valueForKey:@"track_itunes_link"]isEqual:[NSNull null]])
        {
            self.trackItunesLink = [dict valueForKey:@"track_itunes_link"];
        }
        if([dict valueForKey:@"artist_image_url"] && ![[dict valueForKey:@"artist_image_url"]isEqual:[NSNull null]])
        {
            self.trackArtistImageUrl = [dict valueForKey:@"artist_image_url"];
        }
        if([dict valueForKey:@"album_artwork_url_large"] && ![[dict valueForKey:@"album_artwork_url_large"]isEqual:[NSNull null]])
        {
            self.trackAlbumArtworkUrlLarge = [dict valueForKey:@"album_artwork_url_large"];
        }

    }
    return self;

}

- (UIImage *)trackImage{
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* imageFile = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@Image.png",self.tracknName]];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:imageFile]){
        return [UIImage imageWithContentsOfFile:imageFile];
    }
    return nil;

}

- (UIImage *)albumTrackImage{
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* imageFile = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@AlbumImage.png",self.tracknName]];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:imageFile]){
        return [UIImage imageWithContentsOfFile:imageFile];
    }
    return nil;

}
- (void)loadAlbumTrackImageData{
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString* imageFile = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@AlbumImage.png",self.tracknName]];
    
    NSString *imageString = [NSString stringWithFormat:@"%@",self.trackAlbumArtworkUrlLarge];
    
    NSString *finalImageString = [imageString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if ([finalImageString isKindOfClass:[NSString class]]) {
        NSData *data = [NSData dataWithContentsOfURL:[[NSURL alloc] initWithString: finalImageString]];
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                [data writeToFile:imageFile atomically:YES];
                if ([delegate_ respondsToSelector:@selector(trackImageDataLoaded)]) {
                    [delegate_ trackImageDataLoaded];
                }
            }
            else {
                if ([delegate_ respondsToSelector:@selector(failedToLoadTrackImageData)]) {
                    [delegate_ failedToLoadTrackImageData];
                }
                
            }
        }
        else {
            if ([delegate_ respondsToSelector:@selector(failedToLoadTrackImageData)]) {
                [delegate_ failedToLoadTrackImageData];
            }
        }
    }
    else {
        //        if ([self.delegate respondsToSelector:@selector(eventFailedToLoadImageData)]) {
        //            [self.delegate eventFailedToLoadImageData];
        //        }
    }

}

- (void)loadTrackImageData{
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString* imageFile = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@Image.png",self.tracknName]];
    
    NSString *imageString = [NSString stringWithFormat:@"%@",self.trackArtistImageUrl];
    
    NSString *finalImageString = [imageString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if ([finalImageString isKindOfClass:[NSString class]]) {
        NSData *data = [NSData dataWithContentsOfURL:[[NSURL alloc] initWithString: finalImageString]];
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                [data writeToFile:imageFile atomically:YES];
                if ([delegate_ respondsToSelector:@selector(trackImageDataLoaded)]) {
                    [delegate_ trackImageDataLoaded];
                }
            }
            else {
                if ([delegate_ respondsToSelector:@selector(failedToLoadTrackImageData)]) {
                    [delegate_ failedToLoadTrackImageData];
                }
                
            }
        }
        else {
            if ([delegate_ respondsToSelector:@selector(failedToLoadTrackImageData)]) {
                [delegate_ failedToLoadTrackImageData];
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
 track_name
 artist_name
 track_url
 track_count
 track_itunes_link
 download_link
 artist_image_url
 album_artwork_url_large
 */

//-----------------------------------------------------------------------------
#pragma mark NSCoding protocol
//-----------------------------------------------------------------------------
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.tracknName forKey:@"track_name"];
    [aCoder encodeObject:self.trackArtistName forKey:@"artist_name"];
    [aCoder encodeObject:self.trackUrl forKey:@"track_url"];
    [aCoder encodeObject:self.trackListnersCount forKey:@"track_count"];
    [aCoder encodeObject:self.trackItunesLink forKey:@"track_itunes_link"];
    [aCoder encodeObject:self.trackDownloadLink forKey:@"download_link"];
    [aCoder encodeObject:self.trackArtistImageUrl forKey:@"artist_image_url"];
    [aCoder encodeObject:self.trackAlbumArtworkUrlLarge forKey:@"album_artwork_url_large"];

    
    return;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if ((self = [super init])) {
        
        self.tracknName = [[aDecoder decodeObjectForKey:@"track_name"] copy];
        self.trackArtistName = [[aDecoder decodeObjectForKey:@"artist_name"] copy];
        self.trackUrl = [[aDecoder decodeObjectForKey:@"track_url"] copy];
        self.trackListnersCount = [[aDecoder decodeObjectForKey:@"track_count"] copy];
        self.trackItunesLink = [[aDecoder decodeObjectForKey:@"track_itunes_link"] copy];
        self.trackDownloadLink = [[aDecoder decodeObjectForKey:@"download_link"] copy];
        self.trackArtistImageUrl = [[aDecoder decodeObjectForKey:@"artist_image_url"] copy];
        self.trackAlbumArtworkUrlLarge = [[aDecoder decodeObjectForKey:@"album_artwork_url_large"] copy];

        
    }
    return self;
}


@end
