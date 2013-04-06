#import "_ChanHLSRecording.h"

@interface ChanHLSRecording : _ChanHLSRecording {}

+ (void)createRecordingWithStartDate:(NSDate *)startDate
                           channelId:(NSString *)channelId
                      withCompletion:(void (^)(ChanHLSRecording *hlsRecording, NSError *error))block;
- (void)stopRecordingWithEndDate:(NSDate *)endDate
                        endSeqNo:(NSUInteger)endSeqNo
                  withCompletion:(void (^)(ChanHLSRecording *hlsRecording, NSError *error))block;
- (void)addChunkWithData:(NSData *)data
                duration:(double)duration
                   seqNo:(NSUInteger)seqNo
          withCompletion:(void (^)(ChanHLSChunk *hlsChunk, NSError *error))block;

@end
