//
//  BNMArtistProfileViewController.m
//  BrandNewMusicApp
//
//

#import "BNMArtistProfileViewController.h"
#import "BNMClientApi.h"
#import "BNMAlbum.h"
#import "BNMAlbumTableViewCell.h"
#import "BNMTracksViewController.h"
#import "BNMSettingsViewController.h"

#define CELLLABELCOLOR [UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:1.0]

#import "EGORefreshTableHeaderView.h"


@interface BNMArtistProfileViewController ()<EGORefreshTableHeaderDelegate>{
    
    __weak IBOutlet UIImageView *artistImageView;
    __weak IBOutlet UILabel *artistNameLabel;
    __weak IBOutlet UILabel *artistStatusLabel;
    __weak IBOutlet UIButton *followUnfollowButton;
    __weak IBOutlet UILabel *artistFollowingLabel;

    __weak IBOutlet UITableView *artistAlbumTable;
    
    MBProgressHUD *progressHud;
    NSMutableArray *albums;
    
    // Pull To Refresh
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    

}
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;


@end

@implementation BNMArtistProfileViewController

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

    
    albums = [[NSMutableArray alloc] init];
    [self.customTitleLabel setText:NSLocalizedString(@"BRAND NEW MUSIC", nil)];
    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 5, 30, 30)];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 7.5, 1.0, 7.5);
    [backButton setShowsTouchWhenHighlighted:YES];
    [backButton setImage:[UIImage imageNamed:@"back_bttn.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToPreviousView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setFrame:CGRectMake(30, 5, 150, 30)];
    [titleButton addTarget:self action:@selector(backToPreviousView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:titleButton];

    
    [artistNameLabel setFont:[UIFont fontWithName:@"Swis721 BT" size:14.0]];
    [artistStatusLabel setFont:[UIFont fontWithName:@"Swis721 BT" size:14.0]];

    [artistImageView setImage:[self.currentArtist artistNewImage]];
    [artistNameLabel setText:self.currentArtist.artistName];
    if (self.currentArtist.artistFollowStatus == 0) {
        
        [followUnfollowButton setBackgroundImage:[UIImage imageNamed:@"follow100.png"] forState:UIControlStateNormal];
        //[followUnfollowButton setTitle:@"FOLLOW" forState:UIControlStateNormal];
    }
    else {
        //[followUnfollowButton setTitle:@"UNFOLLOW" forState:UIControlStateNormal];
        [followUnfollowButton setBackgroundImage:[UIImage imageNamed:@"unfollow.png"] forState:UIControlStateNormal];


    }
    
    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - artistAlbumTable.bounds.size.height, self.view.frame.size.width, artistAlbumTable.bounds.size.height)];
		view.delegate = self;
        view.backgroundColor = [UIColor clearColor];
		[artistAlbumTable addSubview:view];
		_refreshHeaderView = view;
	}
    //
    // update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];

    [self fetchArtistInformation];
    
    [artistFollowingLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"following100.png"]]];
    [artistFollowingLabel setTextColor:[UIColor colorWithRed:237.0/255.0 green:28.0/255.0 blue:36.0/255.0 alpha:1.0]];
    
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setFrame:CGRectMake(290, 0, 40, 40)];
    menuButton.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 25.0);
    [menuButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(menuOption:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuButton];

    
    
    // Do any additional setup after loading the view.
}

-(IBAction)menuOption:(id)sender{
    // menu option clicked
    BNMSettingsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"BNMSettingsViewController"];
    [self.navigationController pushViewController:controller animated:YES];
    
    
}

-(IBAction)backToPreviousView:(id)sender{
    // Back To Previous View
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)fetchArtistInformation {
    // Fetch Artist Information
    
    
    NSString *webPath = [NSString stringWithFormat:@"?do=profile&email=%@&artist_id=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserEmailID"],self.currentArtist.artistId];
    
    
    
    if ([[BNMClientApi sharedInsatance] networkReachabilityStatus] == 0 ) {
        
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Sorry! No Internet Connection", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
        [tempAlert show];
        
        return;
    }
    
    [self performSelectorOnMainThread:@selector(startAnimator) withObject:nil waitUntilDone:NO];

    [[BNMClientApi sharedInsatance] getPath:webPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self performSelectorOnMainThread:@selector(stopAnimator) withObject:nil waitUntilDone:NO];
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        NSDictionary *dict= [str objectFromJSONString];
        NSLog(@"dict %@",dict);
        
        if (![dict valueForKey:@"PAYLOAD"]||[[dict valueForKey:@"PAYLOAD"] isEqual:[NSNull null]]) {
            return ;
        }
        
        NSArray *tempArtistArray = [dict valueForKey:@"PAYLOAD"];
        if ([tempArtistArray count]>0) {
            NSDictionary *tempDict = [tempArtistArray objectAtIndex:0];
            
            if([tempDict valueForKey:@"artist_name"] && ![[tempDict valueForKey:@"artist_name"]isEqual:[NSNull null]]){
                [artistNameLabel setText:[tempDict valueForKey:@"artist_name"]];
            }
            if([tempDict valueForKey:@"artist_status_update"] && ![[tempDict valueForKey:@"artist_status_update"]isEqual:[NSNull null]]){
                [artistStatusLabel setText:[tempDict valueForKey:@"artist_status_update"]];
            }


            
            if([tempDict valueForKey:@"artist_follow_status"] && ![[tempDict valueForKey:@"artist_follow_status"]isEqual:[NSNull null]])
            {
                int  followStatus = [[tempDict valueForKey:@"artist_follow_status"] intValue];
                NSLog(@"followStatus %d",followStatus);
                self.currentArtist.artistFollowStatus = followStatus;
                if (followStatus == 0) {

                    [followUnfollowButton setBackgroundImage:[UIImage imageNamed:@"follow100.png"] forState:UIControlStateNormal];

//                        [followUnfollowButton setTitle:@"FOLLOW" forState:UIControlStateNormal];
//                        followUnfollowButton.backgroundColor = [UIColor colorWithRed:24.0/255.0 green:168.0/255.0 blue:64.0/255.0 alpha:1.0];

                    }
                    else {
                        [followUnfollowButton setBackgroundImage:[UIImage imageNamed:@"unfollow.png"] forState:UIControlStateNormal];

//                        [followUnfollowButton setTitle:@"UNFOLLOW" forState:UIControlStateNormal];
//                        followUnfollowButton.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:12.0/255.0 blue:33.0/255.0 alpha:1.0];

                        
                    }
                
            }
            
            if([tempDict valueForKey:@"artist_followers_count"] && ![[tempDict valueForKey:@"artist_followers_count"]isEqual:[NSNull null]]){
                
                [artistFollowingLabel setText:[NSString stringWithFormat:@"%@ FOLLOWING",[tempDict valueForKey:@"artist_followers_count"]]];
            }
    

            if([tempDict valueForKey:@"artist_image_url"] && ![[tempDict valueForKey:@"artist_image_url"]isEqual:[NSNull null]])
            {
                
                
                dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                //this will start the image loading in bg
                dispatch_async(concurrentQueue, ^{
                    NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[tempDict valueForKey:@"artist_image_url"]]];
                    
                    //this will set the image when loading is finished
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UIImage *cellImage = [UIImage imageWithData:image];
                        if (cellImage) {
                            [artistImageView setImage:cellImage];
                        }
                    });
                });

            }

            
            NSArray *tempAlbums = [tempDict objectForKey:@"artist_albums"];
            
            [albums removeAllObjects];
            for (NSDictionary *albumDict in tempAlbums) {
                BNMAlbum *album = [[BNMAlbum alloc] initWithDictionary:albumDict];
                [albums addObject:album];
            }
            

        }
        
        
        [artistAlbumTable reloadData];
    }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self performSelectorOnMainThread:@selector(stopAnimator) withObject:nil waitUntilDone:NO];
            UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Sorry! there is some network problem.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
            [tempAlert show];
        }];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)artistFollowAndUnfollowOption:(id)sender{
    // Artist Follow/Unfollow
    
    
    
    NSString *webPath = [NSString stringWithFormat:@"?do=follow&email=%@&artist_id=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserEmailID"],self.currentArtist.artistId];
    

    
    
    if ([[BNMClientApi sharedInsatance] networkReachabilityStatus] == 0 ) {
        
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Sorry! No Internet Connection", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
        [tempAlert show];
        
        return;
    }
    
    [self performSelectorOnMainThread:@selector(startAnimator) withObject:nil waitUntilDone:NO];

    [[BNMClientApi sharedInsatance] getPath:webPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self performSelectorOnMainThread:@selector(stopAnimator) withObject:nil waitUntilDone:NO];
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        if ([str isEqualToString:@"1"]) {
            [self.currentArtist setArtistFollowStatus:1];
            [followUnfollowButton setBackgroundImage:[UIImage imageNamed:@"unfollow.png"] forState:UIControlStateNormal];

//            followUnfollowButton.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:12.0/255.0 blue:33.0/255.0 alpha:1.0];
//            [followUnfollowButton setTitle:NSLocalizedString(@"UNFOLLOW", nil) forState:UIControlStateNormal];
            
        }
        else{
            [self.currentArtist setArtistFollowStatus:0];
            [followUnfollowButton setBackgroundImage:[UIImage imageNamed:@"follow100.png"] forState:UIControlStateNormal];

//            followUnfollowButton.backgroundColor = [UIColor colorWithRed:24.0/255.0 green:168.0/255.0 blue:64.0/255.0 alpha:1.0];
//            [followUnfollowButton setTitle:NSLocalizedString(@"FOLLOW", nil) forState:UIControlStateNormal];
            
        }
        
        
        
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        [self performSelectorOnMainThread:@selector(stopAnimator) withObject:nil waitUntilDone:NO];
                                        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Sorry! there is some network problem.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
                                        [tempAlert show];
                                    }];

}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    
    _reloading = YES;
    [self fetchArtistInformation];
    
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
   	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:artistAlbumTable];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // The user did scroll to the bottom of the scroll view
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

// ----------------------------------------------------------------------------
#pragma mark-
#pragma mark- MBProgressHud Methods
// ----------------------------------------------------------------------------

- (void) startAnimator {
    progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHud.labelText = NSLocalizedString(@"Please wait...", @"Title of activity indicator, to wait some time.");
}
- (void) stopAnimator {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    progressHud = nil;
}


// ----------------------------------------------------------------------------
#pragma mark -
#pragma mark - TableView Data Source methods
// ----------------------------------------------------------------------------

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [albums count];
}
// custom view for header. will be adjusted to default or specified header height

// Customize the appearance of table view cells...

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *albumTableIdentifier = @"MusicsAlbumCellIdentifier";
    
    
    BNMAlbumTableViewCell *cell = (BNMAlbumTableViewCell *)[tableView dequeueReusableCellWithIdentifier:albumTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BNMAlbumTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.albumNameLabel.textColor = CELLLABELCOLOR;
        [cell.albumNameLabel setFont:[UIFont fontWithName:@"Swiss721BT-Bold" size:18.0]];
        
        [cell.albumDateLabel setFont:[UIFont fontWithName:@"Swis721 BT" size:16.0]];
        cell.albumDateLabel.textColor = CELLLABELCOLOR;
        cell.userInteractionEnabled = YES;
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"listbg.png"]];
    }
    
    BNMAlbum *currentAlbum = (BNMAlbum *)[albums objectAtIndex:indexPath.row];
    [cell setAlbumData:currentAlbum];
    
    return cell;
    
}

// ----------------------------------------------------------------------------
#pragma mark -
#pragma mark - TableView Delegate methods
// ----------------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BNMAlbum *currentAlbum = (BNMAlbum *)[albums objectAtIndex:indexPath.row];
    BNMTracksViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"BNMTracksViewController"];
    [controller setCurrentAlbumId:currentAlbum.albumId];
    [controller setIsGenre:NO];
    [self.navigationController pushViewController:controller animated:YES];
    
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
