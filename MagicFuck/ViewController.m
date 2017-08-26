//
//  ViewController.m
//  MagicFuck
//
//  Created by MAC-MiNi on 2017/8/26.
//  Copyright © 2017年 MAC-MiNi. All rights reserved.
//

@import WebRTC;
#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) RTCPeerConnectionFactory *peerFactory;
@property (nonatomic, strong) RTCMediaStream *mediaStream;
@property (nonatomic, strong) RTCEAGLVideoView *videoView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createLocalStream];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(300, 300, 100, 100);
    [btn addTarget:self action:@selector(playOrUnPlay) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
}

- (void)playOrUnPlay {
    static int flag = 0;
    static int times = 0;
    if (flag % 2 == 0) {
        [self play];
        ++times;
        NSLog(@"play times: %d", times);
    } else {
        [self unplay];
    }
    ++flag;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createLocalStream {
    self.peerFactory = [[RTCPeerConnectionFactory alloc] init];
    self.mediaStream = [self.peerFactory mediaStreamWithStreamId:@"Fuck"];
    
    // 创建video track
    RTCAVFoundationVideoSource *source = [self.peerFactory avFoundationVideoSourceWithConstraints:nil];
    RTCVideoTrack *videoTrack = [self.peerFactory videoTrackWithSource:source trackId:@"FuckVideo"];
    
    // 将video track添加到stream中
    if (videoTrack) {
        [self.mediaStream addVideoTrack:videoTrack];
    }
    
}

- (void)play {
    self.videoView = [[RTCEAGLVideoView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [self.view addSubview:self.videoView];
    
    if (self.mediaStream.videoTracks.count > 0) {
        RTCVideoTrack *videoTrack = self.mediaStream.videoTracks.firstObject;
        [videoTrack addRenderer:self.videoView];
    }
}

- (void)unplay {
    if (self.mediaStream.videoTracks.count > 0) {
        RTCVideoTrack *videoTrack = self.mediaStream.videoTracks.firstObject;
        [videoTrack removeRenderer:self.videoView];
    }
    [self.videoView removeFromSuperview];
}



@end
