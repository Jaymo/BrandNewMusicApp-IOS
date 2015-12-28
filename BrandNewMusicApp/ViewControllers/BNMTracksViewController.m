//
//  BNMTracksViewController.m
//  BrandNewMusicApp
//
//

#import "BNMTracksViewController.h"
#import "BNMTrack.h"
#import "BNMTrackTableViewCell.h"

#import "BNMClientApi.h"

#import "BNMPlayerViewController.h"
#import "BNMSettingsViewController.h"



#define CELLLABELCOLOR [UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:1.0]
#import "EGORefreshTableHeaderView.h"


@interface BNMTracksViewController ()<EGORefreshTableHeaderDelegate>{
    __weak IBOutlet UITableView *tracksTableView;
    
    MBProgressHUD *progressHud;
    NSMutableArray *tracks;
    
    // Pull To Refresh
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;


}

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;


@end

@implementation BNMTracksViewController

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
    
    tracks = [[NSMutableArray alloc] init];
    
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

    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - tracksTableView.bounds.size.height, self.view.frame.size.width, tracksTableView.bounds.size.height)];
		view.delegate = self;
        view.backgroundColor = [UIColor clearColor];
		[tracksTableView addSubview:view];
		_refreshHeaderView = view;
	}
    //
    // update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];

    
    [self fetchAlbumList];
    
    
//    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [menuButton setFrame:CGRectMake(290, 0, 40, 40)];
//    menuButton.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 25.0);
//    [menuButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
//    [menuButton addTarget:self action:@selector(menuOption:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:menuButton];

    
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

-(void)fetchAlbumList{
    // Fetch Album List
    
    
    NSString *webPath;
    if (self.isGenre) {
        webPath = [NSString stringWithFormat:@"?do=genre_tracks&genre_id=%@",self.currentAlbumId];

    }
    else{
        webPath = [NSString stringWithFormat:@"?do=tracks&album_id=%@",self.currentAlbumId];

    }
    
    
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
        
        NSArray *tempArtists = [dict valueForKey:@"PAYLOAD"];
        
        
        NSDictionary *errorDict = (NSDictionary *)[tempArtists objectAtIndex:0];
        
        if ([[errorDict valueForKey:@"status"] isEqualToString:@"Error"]) {
            
            NSString *message ;
            if (self.isGenre) {
                message = @"No Tracks could be found from this Genre";
            }
            else{
                message = @"No Tracks could be found from this Album";

            }
            UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Track", nil) message:message delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
            tempAlert.tag = 320;
            [tempAlert show];
            
            return;
            
        }

        
        [tracks removeAllObjects];
        for (NSDictionary *albumDict in tempArtists) {
            if ([albumDict valueForKey:@"status"] || [albumDict valueForKey:@"message"]) {
                
            }
            else{
                BNMTrack *track = [[BNMTrack alloc] initWithDictionary:albumDict];
                [tracks addObject:track];

            }
        }
        
        [tracksTableView reloadData];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self performSelectorOnMainThread:@selector(stopAnimator) withObject:nil waitUntilDone:NO];
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Sorry! there is some network problem.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
        [tempAlert show];
    }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 320) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    
    _reloading = YES;
    [self fetchAlbumList];
    
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
   	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:tracksTableView];
	
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
    
    return [tracks count];
}
// custom view for header. will be adjusted to default or specified header height

// Customize the appearance of table view cells...

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *albumTableIdentifier = @"MusicsAlbumCellIdentifier";
    
    
    BNMTrackTableViewCell *cell = (BNMTrackTableViewCell *)[tableView dequeueReusableCellWithIdentifier:albumTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BNMTrackTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.trackArtistNameLabel.textColor = CELLLABELCOLOR;
        [cell.trackArtistNameLabel setFont:[UIFont fontWithName:@"Swiss721BT-Bold" size:18.0]];
        
        [cell.trackNameLabel setFont:[UIFont fontWithName:@"Swis721 BT" size:16.0]];
        cell.trackNameLabel.textColor = CELLLABELCOLOR;
        cell.userInteractionEnabled = YES;
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"listbg.png"]];
    }
    
    if (indexPath.row == 0 && self.isGenre) {
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"listbg-h.png"]];
    }
    if (indexPath.row == 1 && self.isGenre) {
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"listbg2.png"]];
    }
    if (indexPath.row == 2 && self.isGenre) {
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"listbg3.png"]];
    }
    BNMTrack *currentTrack = (BNMTrack *)[tracks objectAtIndex:indexPath.row];
    [cell setTrackData:currentTrack];
    
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BNMPlayerViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"BNMPlayerViewController"];
    [controller setCurrentIndex:indexPath.row];
    [controller setPlayerList:tracks];
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
