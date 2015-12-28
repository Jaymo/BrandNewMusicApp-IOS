//
//  BNMPlayerViewController.m
//  BrandNewMusicApp
//
//

#import "BNMPlayerViewController.h"
#import "BNMTrack.h"
#import "AudioStreamer.h"
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>
#import "BNMClientApi.h"
#import "MarqueeLabel.h"

@interface BNMPlayerViewController ()<TrackDelegate>{

    __weak IBOutlet UIImageView *trackImageView;
    __weak IBOutlet MarqueeLabel *trackNameLabel;
    __weak IBOutlet UILabel *trackRunningTimeLabel;
    __weak IBOutlet UILabel *trackTotalTimeLabel;

    __weak IBOutlet UIProgressView *trackProgressView;
    //__weak IBOutlet UISlider *volumeSlider;
    __weak IBOutlet UIButton *playPauseButton;
    
    __weak IBOutlet UIScrollView *scrollView;
    
    BNMTrack *runningTrack;
    AudioStreamer *streamer;
    NSTimer *progressUpdateTimer;
    NSTimer *customTimer;
    MarqueeLabel *trackName;
}

@end

@implementation BNMPlayerViewController

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

    
    
    [trackProgressView setTrackTintColor:[UIColor colorWithRed:97.0/255.0 green:97.0/255.0 blue:102.0/255.0 alpha:1.0]];
//    UIImage *tempNewImage = [self getImageFromColor:[UIColor colorWithRed:255.0/255.0 green:37.0/255.0 blue:0.0/255.0 alpha:1.0]];
////    [volumeSlider setMinimumTrackImage:tempNewImage forState:UIControlStateNormal];
//    [volumeSlider setMinimumTrackTintColor:[UIColor colorWithRed:255.0/255.0 green:37.0/255.0 blue:0.0/255.0 alpha:1.0]];
//    [volumeSlider setMaximumTrackTintColor:[UIColor colorWithRed:97.0/255.0 green:97.0/255.0 blue:102.0/255.0 alpha:1.0]];
//    [trackName setFont:[UIFont fontWithName:@"Swis721 BT" size:16.0]];
//    [volumeSlider addTarget:self action:@selector(volumeSliderChanged:) forControlEvents:UIControlEventValueChanged];
//    [volumeSlider setThumbImage:[UIImage imageNamed:@"vol_cont_bttn"] forState:UIControlStateNormal];
    
    
    trackName = [[MarqueeLabel alloc] initWithFrame:CGRectMake(20, 349 ,self.view.frame.size.width-40, 25)];
    trackName.rate = 200.0f;
    trackName.fadeLength = 10.0f;
    trackName.tag = 102;
    
    trackName.numberOfLines = 1;
    trackName.opaque = NO;
    trackName.enabled = YES;
    trackName.textAlignment = NSTextAlignmentLeft;
    trackName.textColor = [UIColor colorWithRed:246.0/255.0 green:12.0/255.0 blue:33.0/255.0 alpha:1.0];
    trackName.backgroundColor = [UIColor clearColor];
    trackName.text = [runningTrack tracknName];
    // For Autoresizing test
    trackName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [scrollView addSubview:trackName];
    
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:trackName
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:trackName
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    // Center vertically
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:trackName
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:trackName
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0.0]];

    
    
//    UIImage *tempImage = [self getImageFromColor:[UIColor colorWithRed:97.0/255.0 green:97.0/255.0 blue:102.0/255.0 alpha:1.0]];
//    [volumeSlider setMaximumTrackImage:tempImage forState:UIControlStateNormal];
//    



    runningTrack  = (BNMTrack *)[self.playerList objectAtIndex:self.currentIndex];
    [playPauseButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [self updatePlayerView];

    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    trackName.text = [runningTrack tracknName];

    if ([runningTrack tracknName].length >25) {
        customTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(changeTheLabel) userInfo:nil repeats:YES];
    }


}

- (void)changeTheLabel {
    // Generate even or odd
    int i = arc4random() % 2;
    if (i == 0) {
        [(MarqueeLabel *)[self.view viewWithTag:102] setText:[runningTrack tracknName]];
    } else {
        [(MarqueeLabel *)[self.view viewWithTag:102] setText:[runningTrack tracknName]];
    }
}


- (UIImage *)getImageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [img stretchableImageWithLeftCapWidth:0 topCapHeight:0];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self destroyStreamer];
	if (progressUpdateTimer)
	{
		[progressUpdateTimer invalidate];
		progressUpdateTimer = nil;
	}
    if (customTimer) {
        [customTimer invalidate];
		customTimer = nil;

    }

}
- (void)updateProgress:(NSTimer *)updatedTimer {
	if (streamer.bitRate != 0.0) {
		double progress = streamer.progress;
        double duration = streamer.duration;
        
        [trackProgressView setProgress:progress / duration];

		NSNumberFormatter *minutesFormatter = [[NSNumberFormatter alloc] init];
		[minutesFormatter setMaximumFractionDigits:0];
		[minutesFormatter setRoundingMode: NSNumberFormatterRoundDown];
		NSNumber *minutes = [NSNumber numberWithDouble:progress/60.0];
		
		NSNumberFormatter *secondsFormatter = [[NSNumberFormatter alloc] init];
		[secondsFormatter setMaximumFractionDigits:0];
		[secondsFormatter setRoundingMode: NSNumberFormatterRoundDown];
		[secondsFormatter setMinimumIntegerDigits:2];
		NSNumber *seconds = [NSNumber numberWithDouble:(progress - ([minutes intValue] * 60.0f))];
		
		trackRunningTimeLabel.text = [NSString stringWithFormat:@"%@:%@", [minutesFormatter stringFromNumber:minutes], [secondsFormatter stringFromNumber:seconds]];
       	} else {
		trackRunningTimeLabel.text = @"0:00";
	}
}


//- (void)volumeSliderChanged:(id)sender {
//	UISlider *slider = (UISlider *)sender;
//	[streamer setVolume:slider.value];
//	// Here you may want to write the volume value to somewhere to persist to the file system so that
//	// it is known the next time the user uses your app.
//}

- (void)trackImageDataLoaded{
    [runningTrack setDelegate:nil];
    if ([runningTrack albumTrackImage]) {
        [trackImageView setImage:[runningTrack albumTrackImage]];

    }

}
- (void)failedToLoadTrackImageData{
    [runningTrack setDelegate:nil];
}


-(void)updatePlayerView{
    
    NSLog(@"runningTrack.trackAlbumArtworkUrlLarge %@",[runningTrack albumTrackImage]);
    if (![runningTrack albumTrackImage]) {
        [runningTrack setDelegate:self];
        [runningTrack loadAlbumTrackImageData];
    }else {
        [trackImageView setImage:[runningTrack albumTrackImage]];

    }
    [trackName setText:[runningTrack tracknName]];
    
    NSString *webPath = [NSString stringWithFormat:@"?do=topten&email=%@&track_id=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserEmailID"],[runningTrack trackId]];
    
    
    
    if ([[BNMClientApi sharedInsatance] networkReachabilityStatus] == 0 ) {
        
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Sorry! No Internet Connection", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
        [tempAlert show];
        
        return;
    }
    
    
    [[BNMClientApi sharedInsatance] getPath:webPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        if ([str isEqualToString:@"0"]) {
            [self createStreamer];
            [streamer start];

        }
        if ([str isEqualToString:@"1"]) {
            
            UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Notification", nil) message:NSLocalizedString(@"You have already Played this track, Please Consider Downloading", nil) delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Cancel", nil)    otherButtonTitles:NSLocalizedString(@"Download", nil),nil];
            tempAlert.tag = 50;
            [tempAlert show];

        }
        NSLog(@"Top-Ten song played %@",str);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Sorry! there is some network problem.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)    otherButtonTitles:nil];
        [tempAlert show];
    }];




}


-(IBAction)backToPreviousView:(id)sender{
    // Back To Previous View
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)mp3PlayerOptions:(id)sender {
    
    
    NSLog(@"self.current Index %d",self.currentIndex);
    UIButton *tempButton = (UIButton *)sender;
    if (tempButton.tag == 10) {
        // Previous
        

        if (self.currentIndex >= 1) {
            [self destroyStreamer];
            self.currentIndex = self.currentIndex -1;
            runningTrack  = (BNMTrack *)[self.playerList objectAtIndex:self.currentIndex];
            [self updatePlayerView];

        }
        else{
        
            NSLog(@"No Song as Prevous");
        }

    }
    if (tempButton.tag == 20) {
        if ([streamer isPlaying]) {
            
            [playPauseButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];

        }
        else{
            [playPauseButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];

        }
        [streamer pause];

        // Play/Pause

    }
    if (tempButton.tag == 30) {
        // Next

        if (self.currentIndex < [self.playerList count]-1) {
            [self destroyStreamer];
            self.currentIndex = self.currentIndex+1;
            runningTrack  = (BNMTrack *)[self.playerList objectAtIndex:self.currentIndex];
            [self updatePlayerView];
            
        }
        else{
            
            NSLog(@"No Song as Next");

        }


    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Create Streamer

- (void)createStreamer
{
    

    if (!runningTrack.trackUrl || [runningTrack.trackUrl isEqual:[NSNull null]]) {
        return;
    }
	if (streamer)
	{
		return;
	}
    
	[self destroyStreamer];
	
	NSString *escapedValue =  (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                         nil,
                                                         (CFStringRef)runningTrack.trackUrl,
                                                         NULL,
                                                         NULL,
                                                         kCFStringEncodingUTF8));
    
	NSURL *url = [NSURL URLWithString:escapedValue];
	streamer = [[AudioStreamer alloc] initWithURL:url];
	
	progressUpdateTimer =
    [NSTimer
     scheduledTimerWithTimeInterval:0.5
     target:self
     selector:@selector(updateProgress:)
     userInfo:nil
     repeats:YES];
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playbackStateChanged:)
     name:ASStatusChangedNotification
     object:streamer];

    
}


- (void)destroyStreamer
{
	if (streamer)
	{
		[[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:streamer];
		[progressUpdateTimer invalidate];
		progressUpdateTimer = nil;
		
		[streamer stop];
		streamer = nil;
	}
}
- (void)playbackStateChanged:(NSNotification *)aNotification
{
	if ([streamer isWaiting])
	{
		
        NSLog(@"Waiting");
        //[self setButtonImageNamed:@"loadingbutton.png"];
	}
	else if ([streamer isPlaying])
	{
        NSLog(@"Playing");
        
        [playPauseButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];

        
        float duration = streamer.duration;
        
        NSNumberFormatter *minutesFormatter = [[NSNumberFormatter alloc] init];
		[minutesFormatter setMaximumFractionDigits:0];
		[minutesFormatter setRoundingMode: NSNumberFormatterRoundDown];
		NSNumber *minutes = [NSNumber numberWithDouble:duration/60.0];
		
		NSNumberFormatter *secondsFormatter = [[NSNumberFormatter alloc] init];
		[secondsFormatter setMaximumFractionDigits:0];
		[secondsFormatter setRoundingMode: NSNumberFormatterRoundDown];
		[secondsFormatter setMinimumIntegerDigits:2];
		NSNumber *seconds = [NSNumber numberWithDouble:(duration - ([minutes intValue] * 60.0f))];

        
        trackTotalTimeLabel.text = [NSString stringWithFormat:@"%@:%@", [minutesFormatter stringFromNumber:minutes], [secondsFormatter stringFromNumber:seconds]];


		//[self setButtonImageNamed:@"stopbutton.png"];
	}
    else if ([streamer isFinished]){
        NSLog(@"Track Played ");
        [self destroyStreamer];

        
        
        UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Track Played", nil) message:@"Track Playback Complete, Please Consider Downloading or skip to the next track." delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Next", nil)    otherButtonTitles:NSLocalizedString(@"Download", nil),nil];
        tempAlert.tag = 55;
        [tempAlert show];

    }

	else if ([streamer isIdle])
	{
        NSLog(@"Idle");
        
        
        

		[self destroyStreamer];
		//[self setButtonImageNamed:@"playbutton.png"];
	}
    }


#pragma mark
#pragma AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  
    if (alertView.tag == 50) {
        
        if (buttonIndex == 1) {
            
            NSArray *tempStringArray = [[runningTrack trackDownloadLink] componentsSeparatedByString:@".com"];
            
            NSString *lastIndexString = [tempStringArray objectAtIndex:1];
            
            lastIndexString =  [ lastIndexString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSString* urlText = [NSString stringWithFormat:@"https://itunes.apple.com/%@", lastIndexString];
            
            NSLog(@"[runningTrack trackDownloadLink] %@",urlText);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
        }

    }
    
    if (alertView.tag == 55) {
        
        if (buttonIndex == 1) {
            
            NSArray *tempStringArray = [[runningTrack trackDownloadLink] componentsSeparatedByString:@".com"];
            
            NSString *lastIndexString = [tempStringArray objectAtIndex:1];
            
            lastIndexString =  [ lastIndexString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSString* urlText = [NSString stringWithFormat:@"https://itunes.apple.com/%@", lastIndexString];
            
            NSLog(@"[runningTrack trackDownloadLink] %@",urlText);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
        }
        else{
            
            if (self.currentIndex == [self.playerList count]-1) {
                
                self.currentIndex = 0;
                
                // Next Song Exist
            }
            else{
                
                self.currentIndex = self.currentIndex +1;
                
            }
            runningTrack  = (BNMTrack *)[self.playerList objectAtIndex:self.currentIndex];
            [self updatePlayerView];

        }
    }
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
