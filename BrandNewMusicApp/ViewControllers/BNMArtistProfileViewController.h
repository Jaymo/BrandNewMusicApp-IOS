//
//  BNMArtistProfileViewController.h
//  BrandNewMusicApp
//
//

#import <UIKit/UIKit.h>
#import "BNMBasicViewController.h"
#import "BNMArtist.h"

@interface BNMArtistProfileViewController : BNMBasicViewController

@property(nonatomic, strong)BNMArtist *currentArtist;
-(IBAction)artistFollowAndUnfollowOption:(id)sender;

@end
