//
//  JMMusicViewController.m
//  MusicPicker
//
//  Created by Joffrey Mann on 7/23/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import "JMMusicViewController.h"
#import "ViewController.h"
#import "ProfileViewController.h"
#import "FitnessMapViewController.h"
#import "AddGoalViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Music.h"

@interface JMMusicViewController ()

@property (strong, nonatomic) NSMutableArray *tracksList;
@property (strong, nonatomic) MPMusicPlayerController *musicPlayer;
@property (strong, nonatomic) NSTimer *currentTimer;

@end

@implementation JMMusicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //Use an MPMusicPlayerController object, or music player, to play media items from the device iPod library. There are two types of music player:
    _musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    
    // If the music player's playback state is that it's currently playing, set the play/pause button as selected to denote that it's currently playing.
    if ([_musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        [self.changePlayPause setSelected:YES];
    }
    
    // Registers notifications regarding playback state changes, volume, etc.
    [self registerMediaPlayerNotifications];
    
    // Plays and pauses the track according to the pressing of the play button.
    [self handle_NowPlayingItemChanged];
    //[self play];
    //[_libraryButton setBackgroundColor:[UIColor blueColor]];
    
    // Creates a gradient for the libraryButton with a multi-dimensional array of RGB values to add a nicely formed gradient to our button.
    CAGradientLayer *btnGradient = [CAGradientLayer layer];
    btnGradient.frame = _libraryButton.bounds;
    btnGradient.colors = [NSArray arrayWithObjects:
                          (id)[[UIColor colorWithRed:12.0f / 255.0f green:62.0f / 255.0f blue:222.0f / 255.0f alpha:1.0f] CGColor],
                          (id)[[UIColor colorWithRed:11.0f / 255.0f green:51.0f / 255.0f blue:101.0f / 255.0f alpha:1.0f] CGColor],
                          nil];
    [_libraryButton.layer insertSublayer:btnGradient atIndex:0];
    
    // Allows us to round the corners of our button, clips the sublayers to it's bounds and set the border width and color.
    CALayer *btnLayer = [_libraryButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    // Programmatically changes the navigation bar's title text attributes like font name, size.
    [self.navBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Zapfino" size:17],
      NSFontAttributeName, nil]];
    
    [self.navBar setBackgroundImage:[UIImage imageNamed:@"ChampionNavBar.png"] forBarMetrics:UIBarMetricsDefault];
    
    // Sets the slider's value according to the music player's current playback time
    _volumeChanger.value = self.musicPlayer.currentPlaybackTime;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                                  object: _musicPlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                                  object: _musicPlayer];
    
//    [[NSNotificationCenter defaultCenter] removeObserver: self
//                                                    name: MPMusicPlayerControllerVolumeDidChangeNotification
//                                                  object: _musicPlayer];
    
    [_musicPlayer endGeneratingPlaybackNotifications];
}

// Method that takes gets the current playback time in hours, minutes, and seconds. Sets the slider's value to the currentPlaybackTime.
- (void)onTimer {
    long currentPlaybackTime = self.musicPlayer.currentPlaybackTime;
    int currentHours = (currentPlaybackTime / 3600);
    int currentMinutes = ((currentPlaybackTime / 60) - currentHours*60);
    int currentSeconds = (currentPlaybackTime % 60);
    self.timeLabel.text = [NSString stringWithFormat:@"%2d:%02d", currentMinutes, currentSeconds];
    _volumeChanger.value = currentPlaybackTime;
}

// Method that handles changes in the track that is currently playing. Changes the total playback time according to the value for the property of playbackDuration while calling for the nowPlayingItem. Sets the max value of the time slider to the total playback time.
- (void) handle_NowPlayingItemChanged
{
    MPMediaItem *currentItem = [_musicPlayer nowPlayingItem];
    
    MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
    
    _currentTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    // The total duration of the track...
    long totalPlaybackTime = [[[_musicPlayer nowPlayingItem] valueForProperty: @"playbackDuration"] longValue];
    int tHours = (totalPlaybackTime / 3600);
    int tMins = ((totalPlaybackTime/60) - tHours*60);
    int tSecs = (totalPlaybackTime % 60 );
    self.durationLabel.text = [NSString stringWithFormat:@"%2d:%02d", tMins, tSecs ];
    [_volumeChanger setMaximumValue:totalPlaybackTime];
    
    // If the timeLabel's value is equal to the durationLabel's value, the musicPlayer should skip to the next item in the queue.
    if([self.timeLabel.text isEqualToString:self.durationLabel.text]){
        [_musicPlayer skipToNextItem];
    }
    // The slider's value should be set to the music player's current playback time divided by the total playback time
    _volumeChanger.value = [self.musicPlayer currentPlaybackTime]/totalPlaybackTime;
    
    // If there's a title display it, if not display no title.
    NSString *titleString = [currentItem valueForProperty:MPMediaItemPropertyTitle];
    if (titleString) {
        _trackLabel.text = [NSString stringWithFormat:@"Title: %@",titleString];
    } else {
        _trackLabel.text = @"Title: No Title";
    }
    
    // If there's an artist display it, otherwise display Artist: Please Select a track.
    NSString *artistString = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    if (artistString) {
        _artistLabel.text = [NSString stringWithFormat:@"Artist: %@",artistString];
    } else {
        _artistLabel.text = @"Artist: Please select a track";
    }
    
    // If there's an album display it, otherwise display Album: Please Select a track.
    NSString *albumString = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    if (albumString) {
        _albumLabel.text = [NSString stringWithFormat:@"Album: %@",albumString];
    } else {
        _albumLabel.text = @"Album: Please select a track";
    }
    
    // Display album artwork. self.artworkImageView is a UIImageView.
    CGSize artworkImageViewSize = self.artworkImageView.bounds.size;
    if (artwork != nil) {
        self.artworkImageView.image = [artwork imageWithSize:artworkImageViewSize];
    }
    else {
        self.artworkImageView.image = [UIImage imageNamed:@"music.png"];
    }
}

// Changes the background image of the play button according the playback state.
- (void) handle_PlaybackStateChanged: (id) notification
{
    MPMusicPlaybackState playbackState = [_musicPlayer playbackState];
    
    if (playbackState == MPMusicPlaybackStatePaused) {
        _changePlayPause.imageView.image = [UIImage imageNamed:@"play_button.png"];
    } else if (playbackState == MPMusicPlaybackStatePlaying) {
        _changePlayPause.imageView.image = [UIImage imageNamed:@"pause_button.png"];
    } else if (playbackState == MPMusicPlaybackStateStopped) {
        _changePlayPause.imageView.image = [UIImage imageNamed:@"play_button.png"];
        [_musicPlayer stop];
    }
    
}

// Registers notifications for events such as changes in the song playing, the playback state, etc.
- (void) registerMediaPlayerNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_NowPlayingItemChanged)
                               name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object: _musicPlayer];
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_PlaybackStateChanged:)
                               name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                             object: _musicPlayer];
    
    [_musicPlayer beginGeneratingPlaybackNotifications];
}

// Manually change the current playback time with the slider
- (IBAction)timeChanger:(id)sender
{
    [_musicPlayer setCurrentPlaybackTime: [_volumeChanger value]];
}

-(void)play
{
    if ([_musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        [_musicPlayer pause];
        [self.changePlayPause setSelected:NO];
        
    } else {
        [_musicPlayer play];
        [self.changePlayPause setSelected:YES];
    }
}

// If a new nowPlayingItem is accessible, play automatically.
- (IBAction)playTrack:(id)sender
{
    if([_musicPlayer nowPlayingItem]){
    [self play];
    }
}

// Skips to the previous item in the queue.
- (IBAction)previousTrack:(id)sender
{
    [_musicPlayer skipToPreviousItem];
}

// Skips to the next item in the queue.
- (IBAction)nextTrack:(id)sender
{
    [_musicPlayer skipToNextItem];
}

// Displays media picker controller that allows you to create your own custom playlist
- (IBAction)displayMediaPicker:(id)sender
{
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAny];
    
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = YES;
    mediaPicker.prompt = @"Select songs to play";
    
    [self presentViewController:mediaPicker animated:YES completion:nil];
}

// Once you select your media, set the queue with your item collection, play the first song in the queue. Also, calls the play method which changes the background image of the play button to pause.
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection
{
    if (mediaItemCollection) {
        
        [_musicPlayer setQueueWithItemCollection: mediaItemCollection];
        [_musicPlayer play];
        [self play];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)back:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
