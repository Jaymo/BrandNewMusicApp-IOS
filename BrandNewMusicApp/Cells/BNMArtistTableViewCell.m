//
//  BNMArtistTableViewCell.m
//  BrandNewMusicApp
//
//

#import "BNMArtistTableViewCell.h"

@implementation BNMArtistTableViewCell

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

-(void)setArtistData:(BNMArtist *)currentArtist{

    if(_myArtist == currentArtist){
        return;
    }
    
    _myArtist = currentArtist;
    [_myArtist setDelegate:nil];
    
    
    self.artistNameLabel.text = _myArtist.artistName;
    if (_myArtist.artistFollowStatus == 0) {
        //self.artistFollowStatusButton.backgroundColor = [UIColor colorWithRed:24.0/255.0 green:168.0/255.0 blue:64.0/255.0 alpha:1.0];
        
        //[self.artistFollowStatusButton setTitle:NSLocalizedString(@"Follow", nil) forState:UIControlStateNormal];
        
        [self.artistFollowStatusButton setBackgroundImage:[UIImage imageNamed:@"follow70.png"] forState:UIControlStateNormal];

    }else{
        //self.artistFollowStatusButton.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:12.0/255.0 blue:33.0/255.0 alpha:1.0];
        //[self.artistFollowStatusButton setTitle:NSLocalizedString(@"Following", nil) forState:UIControlStateNormal];
        [self.artistFollowStatusButton setBackgroundImage:[UIImage imageNamed:@"following70.png"] forState:UIControlStateNormal];

    }
    //
    if ([_myArtist artistNewImage]) {
        //[self.artistImageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.artistImageView setImage:[_myArtist artistNewImage]];
        
    }
    else {
        [_myArtist setDelegate:self];
        [_myArtist performSelectorInBackground:@selector(loadArtistNewImageData) withObject:nil];
    }
    
}


// ----------------------------------------------------------------------------
#pragma mark -
#pragma mark LNFriendDelegate methods
// ----------------------------------------------------------------------------

- (void)artistNewImageDataLoaded{
    [self performSelectorOnMainThread:@selector(BNM_updateImageView) withObject:nil waitUntilDone:NO];
    
}
- (void)failedToLoadArtistNewImageData{
    [self performSelectorOnMainThread:@selector(BNM_setDefaultImage) withObject:nil waitUntilDone:NO];
    
}

#pragma mark
#pragma Artist Delegate

- (void)BNM_updateImageView{
    [_myArtist setDelegate:nil];
    [self.artistImageView setImage:[_myArtist artistNewImage]];
}
- (void)BNM_setDefaultImage{
    [_myArtist setDelegate:nil];
    UIImage *image = [UIImage imageNamed:@"img_placeholder_male.png"];
    [self.artistImageView setImage:image];
}

@end
