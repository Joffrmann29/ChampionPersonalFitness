//
//  Music.h
//  FitnessTracker
//
//  Created by Joffrey Mann on 11/12/14.
//  Copyright (c) 2014 Joffrey Mann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface Music : NSObject

- (void) registerMediaPlayerNotifications;
- (void)onTimer;

@end
