//
//  BNMHomeTableViewCell.m
//  BrandNewMusicApp
//
//

#import "BNMHomeTableViewCell.h"

@implementation BNMHomeTableViewCell
@synthesize currentArtist_;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

//    UIImage *selectionBackground = [UIImage imageNamed:@"listbg-h.png"];
//    UIImageView *iview=[[UIImageView alloc] initWithImage:selectionBackground];
//    self.selectedBackgroundView=iview;

    // Configure the view for the selected state
}


-(void)setArtistData:(BNMMyArtist *)currentArtist{

    
    if(currentArtist_ == currentArtist){
        return;
    }
    
    currentArtist_ = currentArtist;
    [currentArtist_ setDelegate:nil];
    
    self.artistNameLabel.text = currentArtist_.artistName;
    self.artistStatusLabel.text = [NSString stringWithFormat:@"Status: %@",currentArtist_.artistStatus];
    if ([currentArtist_.artistTrackCount intValue]>1) {
        self.artistCountLabel.text = [NSString stringWithFormat:@"%@ Tracks",currentArtist_.artistTrackCount];
    }
    else{
        self.artistCountLabel.text = [NSString stringWithFormat:@"%@ Track",currentArtist_.artistTrackCount];

    }
    if ([currentArtist_.artistLatestTracks count] != 0) {
        self.artistLatestLabel.text = [NSString stringWithFormat:@"Latest: %@",[[currentArtist_.artistLatestTracks objectAtIndex:0] objectForKey:@"track_name"]];

    }
    
    if ([currentArtist_ artistImage]) {
        //[self.artistImageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.artistImageView setImage:[currentArtist_ artistImage]];
        
    }
    else {
        [currentArtist_ setDelegate:self];
        [currentArtist_ performSelectorInBackground:@selector(loadArtistImageData) withObject:nil];
    }
    
}


// ----------------------------------------------------------------------------
#pragma mark -
#pragma mark LNFriendDelegate methods
// ----------------------------------------------------------------------------

- (void)artistImageDataLoaded{
    [self performSelectorOnMainThread:@selector(BNM_updateImageView) withObject:nil waitUntilDone:NO];

}
- (void)failedToLoadArtistImageData{
    [self performSelectorOnMainThread:@selector(BNM_setDefaultImage) withObject:nil waitUntilDone:NO];

}

#pragma mark
#pragma Artist Delegate

- (void)BNM_updateImageView{
    [currentArtist_ setDelegate:nil];
    [self.artistImageView setImage:[currentArtist_ artistImage]];
}
- (void)BNM_setDefaultImage{
    [currentArtist_ setDelegate:nil];
    UIImage *image = [UIImage imageNamed:@"img_placeholder_male.png"];
    [self.artistImageView setImage:image];
}

@end
