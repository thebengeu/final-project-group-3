//
//  ChanAPIEndpoints.h
//  Channely
//
//  Created by Beng on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#ifndef Channely_ChanAPIEndpoints_h
#define Channely_ChanAPIEndpoints_h

// Twitter
static NSString *const TWITTER_BEARER_TOKEN = @"AAAAAAAAAAAAAAAAAAAAAPb8PwAAAAAAFYE6kyCqLkP3cFPLIF5yv0mH3pE%3D5uqvmdF7pxOthWs2zY25tehPnBEOboL9hU3YQBccc";

// Client ID / Secret
static NSString *const CLIENT_ID = @"515d95a2d529fbbb18000001";
static NSString *const CLIENT_SECRET = @"bRst9AEPfEst6UN7UGZdGzuiemzcl7";

// Channel Endpoints
static NSString *const PATH_CHANNEL = @"/channels";
static NSString *const PATH_CHANNEL_UPDATE = @"/channels/:channelID";
static NSString *const PATH_CHANNEL_UPDATE_FORMAT = @"/channels/%@";
static NSString *const PATH_CHANNEL_SEARCH = @"/channels/search";

// Event Endpoints
static NSString *const PATH_EVENTS_POST = @"/events";
static NSString *const PATH_EVENTS_SEARCH = @"/events/search";

// Post Endpoints
static NSString *const PATH_POST_TEXT = @"/channels/:channelID/posts/text";
static NSString *const PATH_POST_TEXT_FORMAT = @"/channels/%@/posts/text";
static NSString *const PATH_POST_IMAGE = @"/channels/:channelID/posts/image";
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

// User Endpoints
static NSString *const PATH_USER = @"/users";
static NSString *const PATH_USER_UPDATE = @"/users/:userID";
static NSString *const PATH_USER_UPDATE_FORMAT = @"/users/%@";
static NSString *const PATH_OWNED_CHANNELS = @"/users/:userID/channels";
static NSString *const PATH_OWNED_CHANNELS_FORMAT = @"/users/%@/channels";

// Auth Endpoints
static NSString *const PATH_GET_ACCESS_TOKEN = @"/oauth/token";

#endif
