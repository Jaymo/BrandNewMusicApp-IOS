//
//  BNMGenreTableViewCell.m
//  BrandNewMusicApp
//
//

#import "BNMGenreTableViewCell.h"

@implementation BNMGenreTableViewCell

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

-(void)setGenreData:(BNMGenre *)currentGenre{
    
    if(_myGenre == currentGenre){
        return;
    }
    
    _myGenre = currentGenre;
    [_myGenre setDelegate:nil];
    
    
    self.genreNameLabel.text = _myGenre.genreName;
   
    if ([_myGenre genreImage]) {
        //[self.genreImageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.genreImageView setImage:[_myGenre genreImage]];
        
    }
    else {
        [_myGenre setDelegate:self];
        [_myGenre performSelectorInBackground:@selector(loadGenreImageData) withObject:nil];
    }
    
}


// ----------------------------------------------------------------------------
#pragma mark -
#pragma mark LNFriendDelegate methods
// ----------------------------------------------------------------------------

- (void)genreImageDataLoaded{
    [self performSelectorOnMainThread:@selector(BNM_updateImageView) withObject:nil waitUntilDone:NO];
    
}
- (void)failedToLoadGenreImageData{
    [self performSelectorOnMainThread:@selector(BNM_setDefaultImage) withObject:nil waitUntilDone:NO];
    
}

#pragma mark
#pragma Artist Delegate

- (void)BNM_updateImageView{
    [_myGenre setDelegate:nil];
    [self.genreImageView setImage:[_myGenre genreImage]];
}
- (void)BNM_setDefaultImage{
    [_myGenre setDelegate:nil];
    UIImage *image = [UIImage imageNamed:@"stub_event_img.png"];
    [self.genreImageView setImage:image];
}


@end
