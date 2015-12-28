//
//  BNMAlbumTableViewCell.m
//  BrandNewMusicApp
//
//

#import "BNMAlbumTableViewCell.h"

@implementation BNMAlbumTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAlbumData:(BNMAlbum *)currentAlbum{
    
    if(_myAlbum == currentAlbum){
        return;
    }
    
    _myAlbum = currentAlbum;
    [_myAlbum setDelegate:nil];
    
    
    self.albumNameLabel.text = [NSString stringWithFormat:@"Album : %@",_myAlbum.albumName];
    if (!_myAlbum.albumDate || [_myAlbum.albumDate isEqual:[NSNull null]]) {
    }
    else{
        self.albumDateLabel.text = [NSString stringWithFormat:@"Date : %@",_myAlbum.albumDate];

    }
    
    if ([_myAlbum albumImage]) {
        //[self.albumImageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.albumImageView setImage:[_myAlbum albumImage]];
        
    }
    else {
        [_myAlbum setDelegate:self];
        [_myAlbum performSelectorInBackground:@selector(loadAlbumImageData) withObject:nil];
    }
    
}


// ----------------------------------------------------------------------------
#pragma mark -
#pragma mark LNFriendDelegate methods
// ----------------------------------------------------------------------------

- (void)albumImageDataLoaded{
    [self performSelectorOnMainThread:@selector(BNM_updateImageView) withObject:nil waitUntilDone:NO];
    
}
- (void)failedToLoadAlbumImageData{
    [self performSelectorOnMainThread:@selector(BNM_setDefaultImage) withObject:nil waitUntilDone:NO];
    
}

#pragma mark
#pragma Artist Delegate

- (void)BNM_updateImageView{
    [_myAlbum setDelegate:nil];
    [self.albumImageView setImage:[_myAlbum albumImage]];
}
- (void)BNM_setDefaultImage{
    [_myAlbum setDelegate:nil];
    UIImage *image = [UIImage imageNamed:@"stub_event_img.png"];
    [self.albumImageView setImage:image];
}


@end
