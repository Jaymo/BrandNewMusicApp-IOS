//
//  BNMHomeTableViewCell.h
//  BrandNewMusicApp
//
//

#import <UIKit/UIKit.h>
#import "BNMMyArtist.h"

@interface BNMHomeTableViewCell : UITableViewCell<ArtistDelegate>{
    
}

@property (strong, nonatomic) BNMMyArtist *currentArtist_;
@property (strong, nonatomic) IBOutlet UIImageView *artistImageView;

@property (weak, nonatomic) IBOutlet UIButton *artistArrowButton;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLatestLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistCountLabel;

-(void)setArtistData:(BNMMyArtist *)currentArtist;

@end
