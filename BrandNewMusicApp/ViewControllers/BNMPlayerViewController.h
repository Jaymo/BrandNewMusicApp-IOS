//
//  BNMPlayerViewController.h
//  BrandNewMusicApp
//
//

#import <UIKit/UIKit.h>
#import "BNMBasicViewController.h"


@interface BNMPlayerViewController : BNMBasicViewController
@property(nonatomic,strong)NSMutableArray *playerList;
@property(nonatomic,assign)int currentIndex;

-(IBAction)mp3PlayerOptions:(id)sender;

@end
