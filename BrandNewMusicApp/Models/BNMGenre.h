//
//  BNMGenre.h
//  BrandNewMusicApp
//
//

#import <Foundation/Foundation.h>

@protocol GenreDelegate;

@interface BNMGenre : NSObject<NSCoding>{
    id<GenreDelegate> delegate_;
    
    
}

@property (strong, nonatomic) id<GenreDelegate>delegate;
@property(nonatomic, strong) NSString *genreId;
@property(nonatomic, strong) NSString *genreName;
@property(nonatomic, strong) NSString *genreImageUrl;

-(id)initWithDictionary:(NSDictionary*)dict;

- (UIImage *)genreImage;
- (void)loadGenreImageData;
@end


@protocol GenreDelegate <NSObject>

- (void)genreImageDataLoaded;
- (void)failedToLoadGenreImageData;

@end
