//
//  BNMGenreTableViewCell.h
//  BrandNewMusicApp
//
//

#import <UIKit/UIKit.h>
#import "BNMGenre.h"

@interface BNMGenreTableViewCell : UITableViewCell<GenreDelegate>

@property (strong, nonatomic) BNMGenre *myGenre;
@property (strong, nonatomic) IBOutlet UIImageView *genreImageView;

@property (weak, nonatomic) IBOutlet UIButton *genreArrowButton;
@property (weak, nonatomic) IBOutlet UILabel *genreNameLabel;

-(void)setGenreData:(BNMGenre *)currentGenre;

@end
