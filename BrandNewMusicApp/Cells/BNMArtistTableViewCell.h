//
//  BNMArtistTableViewCell.h
//  BrandNewMusicApp
//
//

#import <UIKit/UIKit.h>
#import "BNMArtist.h"

@interface BNMArtistTableViewCell : UITableViewCell<ArtistNewDelegate>

@property (strong, nonatomic) BNMArtist *myArtist;
@property (strong, nonatomic) IBOutlet UIImageView *artistImageView;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *artistFollowStatusButton;

-(void)setArtistData:(BNMArtist *)currentArtist;

@end
