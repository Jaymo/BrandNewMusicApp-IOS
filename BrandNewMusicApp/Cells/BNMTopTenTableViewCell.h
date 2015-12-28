//
//  BNMTopTenTableViewCell.h
//  BrandNewMusicApp
//
//

#import <UIKit/UIKit.h>
#import "BNMTrack.h"

@interface BNMTopTenTableViewCell : UITableViewCell<TrackDelegate>


@property (strong, nonatomic) BNMTrack *myTrack;
@property (strong, nonatomic) IBOutlet UIImageView *trackImageView;

@property (weak, nonatomic) IBOutlet UIButton *trackArrowButton;
@property (weak, nonatomic) IBOutlet UILabel *trackArtistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackCountLabel;

-(void)setTrackData:(BNMTrack *)currentTrack;

@end
