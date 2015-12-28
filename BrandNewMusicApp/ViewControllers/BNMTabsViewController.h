//
//  BNMTabsViewController.h
//  BrandNewMusicApp
//
//

#import <UIKit/UIKit.h>
#import "BNMBasicViewController.h"

typedef enum{
    MusicListTypeHome =0,
    MusicListTypeTopTen,
    MusicListTypeGenre,
    MusicListTypeArtist
}MusicListType;


@interface BNMTabsViewController :BNMBasicViewController<UIGestureRecognizerDelegate>{
    MusicListType currentMusicListType;
    UITapGestureRecognizer *tapRecognizer_;
    

}
-(IBAction)searchOption:(id)sender;
-(IBAction)menuOption:(id)sender;
-(IBAction)crossOption:(id)sender;
-(IBAction)tabOptions:(id)sender;
@end
