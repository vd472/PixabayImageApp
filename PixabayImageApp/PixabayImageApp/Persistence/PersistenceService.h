//
//  PersistenceService.h
//  PixabayImageApp
//
//  Created by vijayesha on 31.07.25.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PixabayImageModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * PersistenceService
 *
 * A singleton responsible for managing Core Data operations in the app.
 * Handles setup of the Core Data stack, saving and fetching of `PixabayImageModel` objects,
 * and local caching of images and their metadata for offline support and fast access.
 */
@interface PersistenceService : NSObject

@property (strong, nonatomic) NSPersistentContainer *persistentContainer;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype)sharedInstance;
- (void)saveContext;
- (void)saveImages:(NSArray<PixabayImageModel *> *)images forQuery:(NSString *)query;
- (NSArray<PixabayImageModel *> *)getImagesForQuery:(NSString *)query;
- (NSArray<PixabayImageModel *> *)getAllImages;
- (void)deleteAllImages;

@end

NS_ASSUME_NONNULL_END
