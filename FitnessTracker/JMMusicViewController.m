//
//  JMMusicViewController.m
//  MusicPicker
//
//  Created by Joffrey Mann on 7/23/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import "JMMusicViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface JMMusicViewController ()

@property (strong, nonatomic) NSMutableArray *tracksList;
@property (strong, nonatomic) AVPlayer *audioPlayer;

@end

@implementation JMMusicViewController

- (void)viewDidLoad
{
    //1
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    //2
    self.audioPlayer = [[AVPlayer alloc] init];
    MPMediaQuery *allSongs = [MPMediaQuery songsQuery];
    NSArray *musicQueryItems = [allSongs items];
    self.tracksList = [NSMutableArray arrayWithArray:musicQueryItems];
    //3
    [self.tableView reloadData];
    //4
    MPMediaItem *song = [self.tracksList objectAtIndex:0];
    AVPlayerItem * currentItem = [AVPlayerItem playerItemWithURL:[song valueForProperty:MPMediaItemPropertyAssetURL]];
    [self.audioPlayer replaceCurrentItemWithPlayerItem:currentItem];
    //[self.audioPlayer play];
    //5
    NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
    self.trackLabel.text = songTitle;
    [self.volumeChanger setMaximumValue:self.audioPlayer.currentItem.duration.value/self.audioPlayer.currentItem.duration.timescale];
    //6
    [super viewDidLoad];
}

-(void) configurePlayer {
    //7
    __block JMMusicViewController * weakSelf = self;
    //8
    [self.audioPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, 1)
        queue:NULL
        usingBlock:^(CMTime time) {
            if(!time.value) {
                return;
                }
                                                  
                int currentTime = (int)((weakSelf.audioPlayer.currentTime.value)/weakSelf.audioPlayer.currentTime.timescale);
                int currentMins = (int)(currentTime/60);
                int currentSec  = (int)(currentTime%60);
                                                  
                NSString * durationLabel = [NSString stringWithFormat:@"%02d:%02d",currentMins,currentSec];
                                                  weakSelf.timeLabel.text = durationLabel;
                                                  weakSelf.volumeChanger.value = currentTime;
                                              }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _tracksList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TrackCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    MPMediaItem *song = [self.tracksList objectAtIndex:indexPath.row];
    NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
    NSString *durationLabel = [song valueForProperty: MPMediaItemPropertyGenre];
    cell.textLabel.text = songTitle;
    cell.detailTextLabel.text = durationLabel;
    
    return cell;
}

#pragma mark - TableView Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.audioPlayer pause];
    MPMediaItem *song = [self.tracksList objectAtIndex:indexPath.row];
    AVPlayerItem * currentItem = [AVPlayerItem playerItemWithURL:[song valueForProperty:MPMediaItemPropertyAssetURL]];
    
    [self.audioPlayer replaceCurrentItemWithPlayerItem:currentItem];
    [self.audioPlayer play];
    [self.changePlayPause setSelected:YES];
    MPMediaItem *currentSong = [self.tracksList objectAtIndex:indexPath.row];
    NSString *songTitle = [currentSong valueForProperty: MPMediaItemPropertyTitle];
    self.trackLabel.text = songTitle;
    [self.volumeChanger setMaximumValue:self.audioPlayer.currentItem.duration.value/self.audioPlayer.currentItem.duration.timescale];
    
}

- (IBAction)playPause:(UIButton *)sender {
    if(self.changePlayPause.selected) {
        [self.audioPlayer pause];
        [self.changePlayPause setSelected:NO];
    } else {
        [self.audioPlayer play];
        [self.changePlayPause setSelected:YES];
    }
}

@end
