//
//  BNMTopTenTableViewCell.m
//  BrandNewMusicApp
//
//

#import "BNMTopTenTableViewCell.h"

@implementation BNMTopTenTableViewCell

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

-(void)setTrackData:(BNMTrack *)currentTrack{
    
    if(_myTrack == currentTrack){
        return;
    }
    
     _myTrack = currentTrack;
    [_myTrack setDelegate:nil];
    
    self.trackArtistNameLabel.text = _myTrack.trackArtistName;
    
    self.trackNameLabel.text = [NSString stringWithFormat:@"Track: %@",_myTrack.tracknName];
    if ([_myTrack.trackListnersCount intValue]>1) {
        self.trackCountLabel.text = [NSString stringWithFormat:@"%@ Listens",_myTrack.trackListnersCount];
    }
    else{
        self.trackCountLabel.text = [NSString stringWithFormat:@"%@ Listen",_myTrack.trackListnersCount];
        
    }
    
    if ([_myTrack trackImage]) {
        //[self.trackImageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.trackImageView setImage:[_myTrack trackImage]];
        
    }
    else {
        [_myTrack setDelegate:self];
        [_myTrack performSelectorInBackground:@selector(loadTrackImageData) withObject:nil];
    }
    
}


// ----------------------------------------------------------------------------
#pragma mark -
#pragma mark LNFriendDelegate methods
// ----------------------------------------------------------------------------

- (void)trackImageDataLoaded{
    [self performSelectorOnMainThread:@selector(BNM_updateImageView) withObject:nil waitUntilDone:NO];
    
}
- (void)failedToLoadTrackImageData{
    [self performSelectorOnMainThread:@selector(BNM_setDefaultImage) withObject:nil waitUntilDone:NO];
    
}

#pragma mark
#pragma Artist Delegate

- (void)BNM_updateImageView{
    [_myTrack setDelegate:nil];
    [self.trackImageView setImage:[_myTrack trackImage]];
}
- (void)BNM_setDefaultImage{
    [_myTrack setDelegate:nil];
    UIImage *image = [UIImage imageNamed:@"img_placeholder_male.png"];
    [self.trackImageView setImage:image];
}


@end
