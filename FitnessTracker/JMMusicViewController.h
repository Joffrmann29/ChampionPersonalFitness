//
//  JMMusicViewController.h
//  MusicPicker
//
//  Created by Joffrey Mann on 7/23/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface JMMusicViewController : UIViewController<MPMediaPickerControllerDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIButton *changePlayPause;
@property (strong, nonatomic) IBOutlet UIButton *libraryButton;
@property (strong, nonatomic) IBOutlet UILabel *trackLabel;
@property (strong, nonatomic) IBOutlet UISlider *volumeChanger;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *durationLabel;
@property (strong, nonatomic) IBOutlet UILabel *artistLabel;
@property (strong, nonatomic) IBOutlet UILabel *albumLabel;
@property (strong, nonatomic) IBOutlet UIImageView *artworkImageView;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;


- (IBAction)displayMediaPicker:(id)sender;
- (IBAction)playTrack:(id)sender;
- (IBAction)back:(UIBarButtonItem *)sender;
- (IBAction)previousTrack:(id)sender;
- (IBAction)nextTrack:(id)sender;
- (IBAction)timeChanger:(id)sender;

@end
