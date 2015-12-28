//
//  BNMAppGuidelinesViewController.m
//  BrandNewMusicApp
//
//

#import "BNMAppGuidelinesViewController.h"
#import "BNMHomeViewController.h"

@interface BNMAppGuidelinesViewController (){
    __weak IBOutlet UIScrollView *scrollView;
}

@end

@implementation BNMAppGuidelinesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AppTourDone"] == YES) {
//        [self performSegueWithIdentifier:@"GuidelineToHome" sender:self];
//        
//    }


    scrollView.pagingEnabled = YES;


    [self addIntroPages];

    
//    BNMHomeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BNMHomeViewController"];
//    [self.navigationController pushViewController:vc animated:NO];

    // Do any additional setup after loading the view.
}
-(void)addIntroPages{
    
    NSLog(@"SELF WIDTH %f",self.view.frame.size.width);
    for (UIView *tempView in scrollView.subviews) {
        if ([tempView isKindOfClass:[UIView class]]) {
            [tempView removeFromSuperview];
        }
    }

    for (int i=0;i<6;i++) {
        
         UIView *introBaseView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*i, 0, self.view.frame.size.width, self.view.frame.size.height)];
        if (i == 0) {
            if (!IS_IPHONE_5) {
                
                introBaseView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginPage-1.png"]];

            }
            else{
                introBaseView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginPage.png"]];

            }

        }
        if (i == 1) {
            if (!IS_IPHONE_5) {
                
                introBaseView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HomePage-1.png"]];
                
            }
            else{
                introBaseView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HomePage.png"]];
                
            }
            
        }
        if (i == 2) {
            if (!IS_IPHONE_5) {
                
                introBaseView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"GenrePage-1.png"]];
                
            }
            else{
                introBaseView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"GenrePage.png"]];
                
            }
            
        }
        if (i == 3) {
            if (!IS_IPHONE_5) {
                
                introBaseView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ArtistPage-1.jpg"]];
                
            }
            else{
                introBaseView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ArtistPage.png"]];
                
            }
            
        }
        if (i == 4) {
            if (!IS_IPHONE_5) {
                
                introBaseView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"MusicPlayerPage-1.png"]];
                
            }
            else{
                introBaseView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"MusicPlayerPage.png"]];
                
            }
            
        }
        if (i == 5) {
            if (!IS_IPHONE_5) {
                
                introBaseView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"NotificationsPage-1.png"]];
                
            }
            else{
                introBaseView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"NotificationsPage.png"]];
                
            }
            
        }

        [introBaseView setAutoresizingMask:UIViewAutoresizingNone];

        [scrollView addSubview:introBaseView];

        

        
        // Center vertically


    }
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width*6, 0)];

    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView1{
    
    NSLog(@"Scroll View Content offset %@",NSStringFromCGPoint(scrollView.contentOffset));
    if (scrollView.contentOffset.x >= 1610.0) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AppTourDone"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self performSegueWithIdentifier:@"APPGUIDETOTAB" sender:self];
    }
    //
}// any offset changes

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
   
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{

    //UIInterfaceOrientation currentOrientation = self.interfaceOrientation;

//    [self addIntroPages];
//
//    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width*6, 0)];
//    scrollView.pagingEnabled = YES;
//    [scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
    

}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
