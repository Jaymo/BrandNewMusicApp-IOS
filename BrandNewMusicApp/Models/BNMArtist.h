//
//  BNMArtist.h
//  BrandNewMusicApp
//
//

#import <Foundation/Foundation.h>


@protocol ArtistNewDelegate;

@interface BNMArtist : NSObject<NSCoding>{
    id<ArtistNewDelegate> delegate_;
    
    
}
@property (strong, nonatomic) id<ArtistNewDelegate>delegate;
@property(nonatomic, strong) NSString *artistId;
@property(nonatomic, strong) NSString *artistName;
@property(nonatomic) int artistFollowStatus;
@property(nonatomic, strong) NSString *artistImageUrl;

-(id)initWithDictionary:(NSDictionary*)dict;

- (UIImage *)artistNewImage;
- (void)loadArtistNewImageData;
@end


@protocol ArtistNewDelegate <NSObject>

- (void)artistNewImageDataLoaded;
- (void)failedToLoadArtistNewImageData;

@end

