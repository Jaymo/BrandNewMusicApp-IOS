//
//  BNMSignInViewController.h
//  BrandNewMusicApp
//
//

#import <UIKit/UIKit.h>
#import "BNMBasicViewController.h"


@interface BNMSignInViewController : BNMBasicViewController<UIGestureRecognizerDelegate>{
    UITapGestureRecognizer *tapRecognizer_;
    UITapGestureRecognizer *forgotPasswordTapGesture;

}

@end
