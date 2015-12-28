//
//  BNMMyArtist.m
//  BrandNewMusicApp
//
//

#import "BNMMyArtist.h"

@implementation BNMMyArtist

@synthesize artistId;
@synthesize artistName;
@synthesize artistImageUrl;
@synthesize artistTrackCount;
@synthesize artistStatus;
@synthesize artistLatestTracks;
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
        
        if([dict valueForKey:@"artist_image_url"] && ![[dict valueForKey:@"artist_image_url"]isEqual:[NSNull null]])
        {
            self.artistImageUrl = [dict valueForKey:@"artist_image_url"];
        }
        if([dict valueForKey:@"artist_track_count"] && ![[dict valueForKey:@"artist_track_count"]isEqual:[NSNull null]])
        {
            self.artistTrackCount = [dict valueForKey:@"artist_track_count"];
        }
        if([dict valueForKey:@"artist_status"] && ![[dict valueForKey:@"artist_status"]isEqual:[NSNull null]])
        {
            self.artistStatus = [dict valueForKey:@"artist_status"];
        }
        if([dict valueForKey:@"artist_latest_track"] && ![[dict valueForKey:@"artist_latest_track"]isEqual:[NSNull null]])
        {
            self.artistLatestTracks = [[NSMutableArray alloc] initWithArray:[dict valueForKey:@"artist_latest_track"]];
        }
       

    }
    return self;
    

}
- (UIImage *)artistImage{
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* imageFile = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@ArtsitImage.png",self.artistId]];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:imageFile]){
        return [UIImage imageWithContentsOfFile:imageFile];
    }
    return nil;

}
- (void)loadArtistImageData{
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString* imageFile = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@ArtsitImage.png",self.artistId]];
    
    NSString *imageString = [NSString stringWithFormat:@"%@",self.artistImageUrl];
    
    NSString *finalImageString = [imageString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if ([finalImageString isKindOfClass:[NSString class]]) {
        NSData *data = [NSData dataWithContentsOfURL:[[NSURL alloc] initWithString: finalImageString]];
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                [data writeToFile:imageFile atomically:YES];
                if ([delegate_ respondsToSelector:@selector(artistImageDataLoaded)]) {
                    [delegate_ artistImageDataLoaded];
                }
            }
            else {
                if ([delegate_ respondsToSelector:@selector(failedToLoadArtistImageData)]) {
                    [delegate_ failedToLoadArtistImageData];
                }
                
            }
        }
        else {
            if ([delegate_ respondsToSelector:@selector(failedToLoadArtistImageData)]) {
                [delegate_ failedToLoadArtistImageData];
            }
        }
    }
    else {
        //        if ([self.delegate respondsToSelector:@selector(eventFailedToLoadImageData)]) {
        //            [self.delegate eventFailedToLoadImageData];
        //        }
    }

}


//-----------------------------------------------------------------------------
#pragma mark NSCoding protocol
//-----------------------------------------------------------------------------
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.artistId forKey:@"artist_id"];
    [aCoder encodeObject:self.artistName forKey:@"artist_name"];
    [aCoder encodeObject:self.artistImageUrl forKey:@"artist_image_url"];
    [aCoder encodeObject:self.artistTrackCount forKey:@"artist_track_count"];
    [aCoder encodeObject:self.artistStatus forKey:@"artist_status"];
    [aCoder encodeObject:self.artistLatestTracks forKey:@"artist_latest_track"];
    
    return;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        
        self.artistId = [[aDecoder decodeObjectForKey:@"artist_id"] copy];
        self.artistName = [[aDecoder decodeObjectForKey:@"artist_name"] copy];
        self.artistImageUrl = [[aDecoder decodeObjectForKey:@"artist_image_url"] copy];
        self.artistTrackCount = [[aDecoder decodeObjectForKey:@"artist_track_count"] copy];
        self.artistStatus = [[aDecoder decodeObjectForKey:@"artist_status"] copy];
        self.artistLatestTracks = [[aDecoder decodeObjectForKey:@"artist_latest_track"] copy];
        
    }
    return self;
}

/*
 artist_id
 artist_name
 artist_image_url
 artist_track_count
 artist_status
 artist_latest_track
 */


@end
