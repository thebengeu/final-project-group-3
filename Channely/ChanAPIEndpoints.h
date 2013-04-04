//
//  ChanAPIEndpoints.h
//  Channely
//
//  Created by Beng on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#ifndef Channely_ChanAPIEndpoints_h
#define Channely_ChanAPIEndpoints_h

// Channel Endpoints
static NSString *const PATH_CHANNEL = @"/channels";

// Event Endpoints
static NSString *const PATH_EVENTS_SEARCH = @"/events/search";

// Post Endpoints
static NSString *const PATH_POST_TEXT_FORMAT = @"/channels/%@/posts/text";
static NSString *const PATH_POST_IMAGE_FORMAT = @"/channels/%@/posts/image";
static NSString *const PATH_DELETE_TEXT_FORMAT = @"/posts/text/%@";
static NSString *const PATH_DELETE_IMAGE_FORMAT = @"/posts/text/%@";
static NSString *const PATH_POSTS_UNIFIED_GET = @"/channels/:channelID/posts";
static NSString *const PATH_POSTS_UNIFIED_GET_FORMAT = @"/channels/%@/posts";

// HLS Endpoints
static NSString *const PATH_CREATE_RECORDING = @"/hls/recordings";
static NSString *const PATH_STOP_RECORDING = @"/hls/recordings/:recordingID/stop";
static NSString *const PATH_STOP_RECORDING_FORMAT = @"/hls/recordings/%@/stop";
static NSString *const PATH_ADD_CHUNK = @"/hls/recordings/:recordingID/chunks";
static NSString *const PATH_ADD_CHUNK_FORMAT = @"/hls/recordings/%@/chunks";

#endif
