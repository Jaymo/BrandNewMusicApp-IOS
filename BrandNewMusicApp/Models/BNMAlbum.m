//
//  BNMAlbum.m
//  BrandNewMusicApp
//
//

#import "BNMAlbum.h"

@implementation BNMAlbum

@synthesize delegate = delegate_;

-(id)initWithDictionary:(NSDictionary*)dict{
    
    
    if (self = [super init]) {
        
        if([dict valueForKey:@"album_id"] && ![[dict valueForKey:@"album_id"]isEqual:[NSNull null]])
        {
            self.albumId = [dict valueForKey:@"album_id"];
        }
        if([dict valueForKey:@"album_name"] && ![[dict valueForKey:@"album_name"]isEqual:[NSNull null]])
        {
            self.albumName = [dict valueForKey:@"album_name"];
        }
        
        if([dict valueForKey:@"album_artwork_url"] && ![[dict valueForKey:@"album_artwork_url"]isEqual:[NSNull null]])
        {
            self.albumImageUrl = [dict valueForKey:@"album_artwork_url"];
        }
        
        if([dict valueForKey:@"album_date"] && ![[dict valueForKey:@"album_date"]isEqual:[NSNull null]])
        {
            self.albumDate = [dict valueForKey:@"album_date"];
        }
        
    }
    return self;
    
}
- (UIImage *)albumImage{
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* imageFile = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@AlbumImage.png",self.albumId]];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:imageFile]){
        return [UIImage imageWithContentsOfFile:imageFile];
    }
    return nil;
}
- (void)loadAlbumImageData{
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString* imageFile = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@AlbumImage.png",self.albumId]];
    
    NSString *imageString = [NSString stringWithFormat:@"%@",self.albumImageUrl];
    
    NSString *finalImageString = [imageString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if ([finalImageString isKindOfClass:[NSString class]]) {
        NSData *data = [NSData dataWithContentsOfURL:[[NSURL alloc] initWithString: finalImageString]];
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                [data writeToFile:imageFile atomically:YES];
                if ([delegate_ respondsToSelector:@selector(albumImageDataLoaded)]) {
                    [delegate_ albumImageDataLoaded];
                }
            }
            else {
                if ([delegate_ respondsToSelector:@selector(failedToLoadAlbumImageData)]) {
                    [delegate_ failedToLoadAlbumImageData];
                }
                
            }
        }
        else {
            if ([delegate_ respondsToSelector:@selector(failedToLoadAlbumImageData)]) {
                [delegate_ failedToLoadAlbumImageData];
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
 album_name
 album_id
 album_artwork_url
 album_date
 */
//-----------------------------------------------------------------------------
#pragma mark NSCoding protocol
//-----------------------------------------------------------------------------
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.albumId forKey:@"album_id"];
    [aCoder encodeObject:self.albumName forKey:@"album_name"];
    [aCoder encodeObject:self.albumImageUrl forKey:@"album_artwork_url"];
    [aCoder encodeObject:self.albumDate forKey:@"album_date"];
    return;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if ((self = [super init])) {
        self.albumId = [[aDecoder decodeObjectForKey:@"album_id"] copy];
        self.albumName = [[aDecoder decodeObjectForKey:@"album_name"] copy];
        self.albumImageUrl = [aDecoder decodeObjectForKey:@"album_artwork_url"];
        self.albumDate = [[aDecoder decodeObjectForKey:@"album_date"] copy];
        
    }
    return self;
}


@end
