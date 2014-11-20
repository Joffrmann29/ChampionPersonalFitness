//
//  JMMusicViewController.h
//  MusicPicker
//
//  Created by Joffrey Mann on 7/23/14.
//  Copyright (c) 2014 JoffreyMann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMMusicViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIButton *changePlayPause;
@property (strong, nonatomic) IBOutlet UILabel *trackLabel;
@property (strong, nonatomic) IBOutlet UISlider *volumeChanger;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)playPause:(UIButton *)sender;

@end
