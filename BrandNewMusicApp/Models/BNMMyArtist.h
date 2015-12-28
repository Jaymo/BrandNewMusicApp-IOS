//
//  BNMMyArtist.h
//  BrandNewMusicApp
//
//

#import <Foundation/Foundation.h>

@protocol ArtistDelegate;

@interface BNMMyArtist : NSObject<NSCoding>{
    id<ArtistDelegate> delegate_;

    
}
@property (strong, nonatomic) id<ArtistDelegate>delegate;
@property(nonatomic, strong) NSString *artistId;
@property(nonatomic, strong) NSString *artistName;
@property(nonatomic, strong) NSString *artistImageUrl;
@property(nonatomic, strong) NSString *artistTrackCount;
@property(nonatomic, strong) NSString *artistStatus;
@property(nonatomic, strong) NSMutableArray *artistLatestTracks;

-(id)initWithDictionary:(NSDictionary*)dict;

- (UIImage *)artistImage;
- (void)loadArtistImageData;
@end


@protocol ArtistDelegate <NSObject>

- (void)artistImageDataLoaded;
- (void)failedToLoadArtistImageData;

@end
