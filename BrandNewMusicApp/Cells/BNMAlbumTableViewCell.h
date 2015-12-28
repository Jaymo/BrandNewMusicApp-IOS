//
//  BNMAlbumTableViewCell.h
//  BrandNewMusicApp
//
//

#import <UIKit/UIKit.h>
#import "BNMAlbum.h"

@interface BNMAlbumTableViewCell : UITableViewCell<AlbumDelegate>

@property (strong, nonatomic) BNMAlbum *myAlbum;
@property (strong, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UILabel *albumNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumDateLabel;

-(void)setAlbumData:(BNMAlbum *)currentAlbum;

@end
