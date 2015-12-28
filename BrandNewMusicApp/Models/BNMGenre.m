//
//  BNMGenre.m
//  BrandNewMusicApp
//
//

#import "BNMGenre.h"

@implementation BNMGenre

@synthesize delegate =delegate_;


-(id)initWithDictionary:(NSDictionary*)dict{
    
    
    if (self = [super init]) {
        
        if([dict valueForKey:@"genre_id"] && ![[dict valueForKey:@"genre_id"]isEqual:[NSNull null]])
        {
            self.genreId = [dict valueForKey:@"genre_id"];
        }
        if([dict valueForKey:@"genre_name"] && ![[dict valueForKey:@"genre_name"]isEqual:[NSNull null]])
        {
            self.genreName = [dict valueForKey:@"genre_name"];
        }
        
        if([dict valueForKey:@"genre_image_url"] && ![[dict valueForKey:@"genre_image_url"]isEqual:[NSNull null]])
        {
            self.genreImageUrl = [dict valueForKey:@"genre_image_url"];
        }

        
    }
    return self;
    
}

- (UIImage *)genreImage{
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* imageFile = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@GenreImage.png",self.genreId]];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:imageFile]){
        return [UIImage imageWithContentsOfFile:imageFile];
    }
    return nil;
    
}
- (void)loadGenreImageData{
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString* imageFile = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@GenreImage.png",self.genreId]];
    
    NSString *imageString = [NSString stringWithFormat:@"%@",self.genreImageUrl];
    
    NSString *finalImageString = [imageString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if ([finalImageString isKindOfClass:[NSString class]]) {
        NSData *data = [NSData dataWithContentsOfURL:[[NSURL alloc] initWithString: finalImageString]];
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                [data writeToFile:imageFile atomically:YES];
                if ([delegate_ respondsToSelector:@selector(genreImageDataLoaded)]) {
                    [delegate_ genreImageDataLoaded];
                }
            }
            else {
                if ([delegate_ respondsToSelector:@selector(failedToLoadGenreImageData)]) {
                    [delegate_ failedToLoadGenreImageData];
                }
                
            }
        }
        else {
            if ([delegate_ respondsToSelector:@selector(failedToLoadGenreImageData)]) {
                [delegate_ failedToLoadGenreImageData];
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
 genre_id
 genre_name
 genre_image_url
 */
//-----------------------------------------------------------------------------
#pragma mark NSCoding protocol
//-----------------------------------------------------------------------------
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.genreId forKey:@"genre_id"];
    [aCoder encodeObject:self.genreName forKey:@"genre_name"];
    [aCoder encodeObject:self.genreImageUrl forKey:@"genre_image_url"];
    return;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if ((self = [super init])) {
        self.genreId = [[aDecoder decodeObjectForKey:@"genre_id"] copy];
        self.genreName = [[aDecoder decodeObjectForKey:@"genre_name"] copy];
        self.genreImageUrl = [[aDecoder decodeObjectForKey:@"genre_image_url"] copy];
        
    }
    return self;
}
@end
