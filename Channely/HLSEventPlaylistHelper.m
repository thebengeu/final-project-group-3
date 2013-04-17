//
//  HLSEventPlaylistHelper.m
//  CameraTest
//
//  Created by Camillus Gerard Cai on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "HLSEventPlaylistHelper.h"

// Note: #EXT-X-TARGETDURATION must be an (unsigned) integral value, whereas the actual length of a clip in #EXTINF may be a decimal value.
static NSString *const cPlaylistHeaderFormat = @"#EXTM3U\n#EXT-X-VERSION:3\n#EXT-X-PLAYLIST-TYPE:EVENT\n#EXT-X-TARGETDURATION:%d\n#EXT-X-MEDIA-SEQUENCE:%d\n";
static NSString *const cPlaylistMediaItemFormat = @"#EXTINF:%lf,%@\n%@\n";
static NSString *const cPlaylistTrailerFormat = @"#EXT-X-ENDLIST";
static NSUInteger const cDefaultSequenceNumber = 0;
static NSString *const cHash = @"#";

@interface HLSEventPlaylistHelper ()
// Internal.
@property (strong) NSURL * _fileName;
@property (atomic) NSUInteger _targetInterval;
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
- (void) beginPlaylistWithTargetInterval:(NSUInteger)period {
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
    
    NSData *data = [_buffer dataUsingEncoding:NSUTF8StringEncoding];
    [data writeToURL:_fileName atomically:YES];
}

#pragma mark Static Methods
+ (BOOL) playlistIsComplete:(NSString *)path {
    NSError *error = nil;
    NSString *plContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        return NO;
    }
    
    plContents = [plContents stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [plContents hasSuffix:cPlaylistTrailerFormat];
}

+ (NSUInteger) playlistChunkCount:(NSString *)path {
    NSError *error = nil;
    NSString *plContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        return NO;
    }
    
    plContents = [plContents stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray *lines = [plContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSUInteger count = 0;
    for (NSString *line in lines) {
        if (![line hasPrefix:cHash]) {
            count++;
        }
    }
    
    return count;
}

@end
