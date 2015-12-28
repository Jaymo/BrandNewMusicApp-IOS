//
//  BNMTrackTableViewCell.m
//  BrandNewMusicApp
//
//

#import "BNMTrackTableViewCell.h"

@implementation BNMTrackTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setTrackData:(BNMTrack *)currentTrack{
    
    if(_myTrack == currentTrack){
        return;
    }
    
    _myTrack = currentTrack;
    [_myTrack setDelegate:nil];
    
    
    self.trackArtistNameLabel.text = _myTrack.trackArtistName;
    self.trackNameLabel.text = _myTrack.tracknName; //[NSString stringWithFormat:@"Track: %@",_myTrack.tracknName];
    
    if ([_myTrack albumTrackImage]) {
        //[self.trackImageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.trackImageView setImage:[_myTrack albumTrackImage]];
    }
    else {
        [_myTrack setDelegate:self];
        [_myTrack performSelectorInBackground:@selector(loadAlbumTrackImageData) withObject:nil];
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
    [self.trackImageView setImage:[_myTrack albumTrackImage]];
}
- (void)BNM_setDefaultImage{
    [_myTrack setDelegate:nil];
    UIImage *image = [UIImage imageNamed:@"stub_event_img.png"];
    [self.trackImageView setImage:image];
}

@end
