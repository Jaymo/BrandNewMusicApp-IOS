//
//  BNMAlbumsViewController.h
//  BrandNewMusicApp
//
//

#import <UIKit/UIKit.h>
#import "BNMBasicViewController.h"

@interface BNMAlbumsViewController : BNMBasicViewController
@property(nonatomic,strong) NSString *currentArtistId;
@property(nonatomic,assign) BOOL isGenre;

-(IBAction)menuOption:(id)sender;


@end
