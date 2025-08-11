//
//  PixabayImageRepository.m
//  PixabayImageApp
//
//  Created by vijayesha on 31.07.25.
//

#import "PixabayImageRepository.h"
#import "PixabayAPIService.h"
#import "PersistenceService.h"
#import "PixabayImageModel.h"

@interface PixabayImageRepository ()
@property (nonatomic, strong) PixabayAPIService *apiService;
@property (nonatomic, strong) PersistenceService *persistenceService;
@end

@implementation PixabayImageRepository

- (instancetype)initWithAPIService:(PixabayAPIService *)apiService
                 persistenceService:(PersistenceService *)persistenceService {
    if (self = [super init]) {
        _apiService = apiService;
        _persistenceService = persistenceService;
    }
    return self;
}

- (void)searchImagesWithQuery:(NSString *)query
                        page:(NSInteger)page
                  completion:(PixabayRepositoryCompletion)completion
{
    if (page == 1) {
        // Optionally, return cached images for page 1
        NSArray<PixabayImageModel *> *cachedImages = [self.persistenceService getImagesForQuery:query];
        if (cachedImages.count > 0) {
            completion(cachedImages, nil);
        }
    }

    [self.apiService searchImagesWithQuery:query page:page completion:^(NSArray<PixabayImageModel *> * _Nullable images, NSError * _Nullable error) {
        if (error) {
            completion(nil, error);
            return;
        }
        if (images.count > 0) {
            // Save new images to Core Data
            [self.persistenceService saveImages:images forQuery:query];
            completion(images, nil);
        } else {
            completion(@[], nil);
        }
    }];
}


@end
