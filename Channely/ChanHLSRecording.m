#import "ChanHLSRecording.h"
#import "ChanHLSChunk.h"
#import "ChanAPIEndpoints.h"

@interface ChanHLSRecording ()

// Private interface goes here.

@end


@implementation ChanHLSRecording

+ (void)createRecordingWithStartDate:(NSDate *)startDate
                      withCompletion:(void (^)(ChanHLSRecording *hlsRecording, NSError *error))block
{
    ChanHLSRecording *hlsRecording = [NSEntityDescription insertNewObjectForEntityForName:@"HLSRecording" inManagedObjectContext:[[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext]];
    hlsRecording.startDate = startDate;
    
    [[RKObjectManager sharedManager] postObject:hlsRecording path:PATH_CREATE_RECORDING parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        block(hlsRecording, nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

- (void)stopRecordingWithEndDate:(NSDate *)endDate
                        endSeqNo:(NSUInteger)endSeqNo
                  withCompletion:(void (^)(ChanHLSRecording *hlsRecording, NSError *error))block
{
    self.endDate = endDate;
    self.endSeqNoValue = endSeqNo;
    
    [[RKObjectManager sharedManager] postObject:self path:[NSString stringWithFormat:PATH_STOP_RECORDING_FORMAT, self.id] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        block(self, nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

- (void)addChunkWithData:(NSData *)data
                duration:(double)duration
                   seqNo:(NSUInteger)seqNo
          withCompletion:(void (^)(ChanHLSChunk *hlsChunk, NSError *error))block
{
    ChanHLSChunk *hlsChunk = [NSEntityDescription insertNewObjectForEntityForName:@"HLSChunk" inManagedObjectContext:[[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext]];
    hlsChunk.durationValue = duration;
    hlsChunk.seqNoValue = seqNo;
    [self addChunksObject:hlsChunk];
    
    NSMutableURLRequest *request = [[RKObjectManager sharedManager] multipartFormRequestWithObject:hlsChunk method:RKRequestMethodPOST path:[NSString stringWithFormat:PATH_ADD_CHUNK_FORMAT, self.id] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data
                                    name:@"chunk"
                                fileName:@"chunk.ts"
                                mimeType:@"video/MP2T"];
    }];
    
    RKObjectRequestOperation *operation = [[RKObjectManager sharedManager] objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        block(hlsChunk, nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
    [[RKObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}

@end
