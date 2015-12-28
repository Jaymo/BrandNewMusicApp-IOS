//
//  BNMTracksViewController.h
//  BrandNewMusicApp
//
//

#import <UIKit/UIKit.h>
#import "BNMBasicViewController.h"

@interface BNMTracksViewController : BNMBasicViewController
@property (nonatomic,strong)NSString *currentAlbumId;
@property(nonatomic,assign) BOOL isGenre;

-(IBAction)menuOption:(id)sender;

@end
