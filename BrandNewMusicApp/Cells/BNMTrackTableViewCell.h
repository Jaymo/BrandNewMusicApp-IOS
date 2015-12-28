//
//  BNMTrackTableViewCell.h
//  BrandNewMusicApp
//
//

#import <UIKit/UIKit.h>
#import "BNMTrack.h"


@interface BNMTrackTableViewCell : UITableViewCell<TrackDelegate>
@property (strong, nonatomic) BNMTrack *myTrack;
@property (strong, nonatomic) IBOutlet UIImageView *trackImageView;

@property (weak, nonatomic) IBOutlet UIButton *trackArrowButton;
@property (weak, nonatomic) IBOutlet UILabel *trackArtistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackNameLabel;

-(void)setTrackData:(BNMTrack *)currentTrack;

@end
