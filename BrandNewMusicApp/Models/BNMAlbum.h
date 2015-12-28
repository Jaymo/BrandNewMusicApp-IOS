//
//  BNMAlbum.h
//  BrandNewMusicApp
//
//

#import <Foundation/Foundation.h>

@protocol AlbumDelegate;

@interface BNMAlbum : NSObject{
    id<AlbumDelegate> delegate_;

}
@property (strong, nonatomic) id<AlbumDelegate>delegate;
@property(nonatomic, strong) NSString *albumId;
@property(nonatomic, strong) NSString *albumName;
@property(nonatomic, strong) NSString *albumImageUrl;
@property(nonatomic, strong) NSString *albumDate;

-(id)initWithDictionary:(NSDictionary*)dict;

- (UIImage *)albumImage;
- (void)loadAlbumImageData;
@end


@protocol AlbumDelegate <NSObject>

- (void)albumImageDataLoaded;
- (void)failedToLoadAlbumImageData;

@end
