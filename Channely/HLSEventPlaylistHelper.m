//
//  HLSEventPlaylistHelper.m
//  CameraTest
//
//  Created by Camillus Gerard Cai on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "HLSEventPlaylistHelper.h"

static NSString *const cPlaylistHeaderFormat = @"#EXTM3U\n#EXT-X-VERSION:3\n#EXT-X-PLAYLIST-TYPE:EVENT\n#EXT-X-TARGETDURATION:%.4lf\n#EXT-X-MEDIA-SEQUENCE:%d\n";
static NSString *const cPlaylistMediaItemFormat = @"#EXTINF:%.4lf,%@\n%@\n";
static NSString *const cPlaylistTrailerFormat = @"#EXT-X-ENDLIST";
static NSUInteger const cDefaultSequenceNumber = 0;

@interface HLSEventPlaylistHelper ()
// Internal.
@property (strong) NSURL * _fileName;
@property (atomic) CGFloat _targetInterval;
@property (strong) NSMutableString *_buffer;

- (void) writeBufferToFile;

@end

@implementation HLSEventPlaylistHelper
// Internal.
@synthesize _fileName;
@synthesize _targetInterval;
@synthesize _buffer;

#pragma mark Constructors
- (id) initWithFileURL:(NSURL *)url {
    if (self = [super init]) {
        _fileName = url;
        _buffer = nil;
    }
    return self;
}

#pragma mark Playlist Manipulation
- (void) beginPlaylistWithTargetInterval:(CGFloat)period {
    _targetInterval = period;
    _buffer = [[NSMutableString alloc] init];
    
    [_buffer appendFormat:cPlaylistHeaderFormat, _targetInterval, cDefaultSequenceNumber];
}

- (void) appendItem:(NSString *)path withDuration:(CGFloat)duration {
    [self appendItem:path withDuration:duration withTitle:@""];
}

- (void) appendItem:(NSString *)path withDuration:(CGFloat)duration withTitle:(NSString *)title {
    if (!_buffer) {
        return;
    }
    
    [_buffer appendFormat:cPlaylistMediaItemFormat, duration, title, path];
    [self writeBufferToFile];
}

- (void) endPlaylist {
    if (!_buffer) {
        return;
    }
    
    [_buffer appendString:cPlaylistTrailerFormat];
    [self writeBufferToFile];
}

#pragma mark Serialization
// If the file exists, it is truncated and overwritten.
- (void) writeBufferToFile {
    if (!_buffer) {
        return;
    }
    
    // NSLog(@"%@", _buffer); // Debug.
    
    NSData *data = [_buffer dataUsingEncoding:NSUTF8StringEncoding];
    [data writeToURL:_fileName atomically:YES];
}

@end
