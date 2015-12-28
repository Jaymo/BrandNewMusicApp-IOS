//
//  BNMTrack.h
//  BrandNewMusicApp
//
//

#import <Foundation/Foundation.h>

@protocol TrackDelegate;

@interface BNMTrack : NSObject<NSCoding>{
    id<TrackDelegate> delegate_;
    
    
}

@property(strong, nonatomic) id<TrackDelegate>delegate;
@property(strong, nonatomic) NSString *trackId;
@property(nonatomic, strong) NSString *tracknName;
@property(nonatomic, strong) NSString *trackArtistName;
@property(nonatomic, strong) NSString *trackUrl;
@property(nonatomic, strong) NSString *trackListnersCount;
@property(nonatomic, strong) NSString *trackItunesLink;
@property(nonatomic, strong) NSString *trackDownloadLink;
@property(nonatomic, strong) NSString *trackArtistImageUrl;
@property(nonatomic, strong) NSString *trackAlbumArtworkUrlLarge;

-(id)initWithDictionary:(NSDictionary*)dict;

- (UIImage *)trackImage;
- (void)loadTrackImageData;

- (UIImage *)albumTrackImage;
- (void)loadAlbumTrackImageData;

@end


@protocol TrackDelegate <NSObject>

- (void)trackImageDataLoaded;
- (void)failedToLoadTrackImageData;
@end
