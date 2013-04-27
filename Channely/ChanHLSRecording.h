#import "_ChanHLSRecording.h"

/**
 `ChanHLSRecording` wraps API and persistence operations for HLS recordings.
 */
@interface ChanHLSRecording : _ChanHLSRecording {}

/**
 Creates and returns new HLS Recording.
 
 @param startDate The date/time when the HLS recording was started.
 @param channelId The ID of the channel which the HLS recording should belong to.
 @param block A block object to be executed when the request operation finishes. This block has no return value and takes two arguments: the created HLS recording and the `NSError` object describing the network or parsing error that occurred or nil if there are no errors.
 */
+ (void)createRecordingWithStartDate:(NSDate *)startDate
                           channelId:(NSString *)channelId
                      withCompletion:(void (^)(ChanHLSRecording *hlsRecording, NSError *error))block;

/**
 Stops HLS Recording.
 
 @param endDate The date/time when the HLS recording was stopped.
 @param endSeqNo The sequence number which the HLS recording ended with.
 @param block A block object to be executed when the request operation finishes. This block has no return value and takes two arguments: the updated HLS recording and the `NSError` object describing the network or parsing error that occurred or nil if there are no errors.
 */
- (void)stopRecordingWithEndDate:(NSDate *)endDate
                        endSeqNo:(NSUInteger)endSeqNo
                  withCompletion:(void (^)(ChanHLSRecording *hlsRecording, NSError *error))block;

/**
 Adds new chunk to HLS Recording.
 
 @param data The byte buffer of the chunk to be added.
 @param duration The duration of chunk in seconds.
 @param seqNo The sequence number of the chunk.
 @param block A block object to be executed when the request operation finishes. This block has no return value and takes two arguments: the added HLS chunk and the `NSError` object describing the network or parsing error that occurred or nil if there are no errors.
 */
- (void)addChunkWithData:(NSData *)data
                duration:(double)duration
                   seqNo:(NSUInteger)seqNo
          withCompletion:(void (^)(ChanHLSChunk *hlsChunk, NSError *error))block;

@end
