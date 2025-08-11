//
//  PersistenceService.m
//  PixabayImageApp
//
//  Created by vijayesha on 31.07.25.
//

#import "PersistenceService.h"

static NSString *const kImageEntityName = @"PixabayImageEntity";


@implementation PersistenceService

+ (instancetype)sharedInstance {
    static PersistenceService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupCoreData];
    }
    return self;
}

- (void)setupCoreData {
    self.persistentContainer = [[NSPersistentContainer alloc] initWithName:@"PixabayImageApp"]; // Your model name!
    [self.persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *desc, NSError *error) {
        if (error) {
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        } else {
            NSLog(@"Core Data store loaded at %@", desc.URL);
        }
    }];

    // Use the context like this:
    self.managedObjectContext = self.persistentContainer.viewContext;
    self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)saveContext {
    NSError *error = nil;
    if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)saveImages:(NSArray<PixabayImageModel *> *)images forQuery:(NSString *)query {
    for (PixabayImageModel *image in images) {
        NSManagedObject *imageEntity = [NSEntityDescription insertNewObjectForEntityForName:kImageEntityName
                                            inManagedObjectContext:self.managedObjectContext];
        
        [imageEntity setValue:image.imageId forKey:@"imageId"];
        [imageEntity setValue:image.previewURL forKey:@"previewURL"];
        [imageEntity setValue:image.largeImageURL forKey:@"largeImageURL"];
        [imageEntity setValue:image.user forKey:@"user"];
        [imageEntity setValue:[image.tags componentsJoinedByString:@", "] forKey:@"tags"];
        [imageEntity setValue:@(image.likes) forKey:@"likes"];
        [imageEntity setValue:@(image.favorites) forKey:@"favorites"];
        [imageEntity setValue:@(image.comments) forKey:@"comments"];
        [imageEntity setValue:query forKey:@"searchQuery"];
    }
    
    [self saveContext];
}

- (NSArray<PixabayImageModel *> *)getImagesForQuery:(NSString *)query {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kImageEntityName];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"searchQuery == %@", query];
    
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Error fetching images: %@", error);
        return @[];
    }
    
    NSMutableArray<PixabayImageModel *> *images = [NSMutableArray array];
    for (NSManagedObject *entity in results) {
        PixabayImageModel *image = [[PixabayImageModel alloc] init];
        image.imageId = [entity valueForKey:@"imageId"];
        image.previewURL = [entity valueForKey:@"previewURL"];
        image.largeImageURL = [entity valueForKey:@"largeImageURL"];
        image.user = [entity valueForKey:@"user"];
        image.likes = [[entity valueForKey:@"likes"] integerValue];
        image.favorites = [[entity valueForKey:@"favorites"] integerValue];
        image.comments = [[entity valueForKey:@"comments"] integerValue];
        image.searchQuery = [entity valueForKey:@"searchQuery"];
        
        NSString *tagsString = [entity valueForKey:@"tags"];
        if (tagsString && ![tagsString isEqualToString:@""]) {
            image.tags = [tagsString componentsSeparatedByString:@", "];
        } else {
            image.tags = @[];
        }
        
        [images addObject:image];
    }
    
    return [images copy];
}

- (NSArray<PixabayImageModel *> *)getAllImages {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kImageEntityName];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"searchDate" ascending:NO]];
    
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Error fetching all images: %@", error);
        return @[];
    }
    
    NSMutableArray<PixabayImageModel *> *images = [NSMutableArray array];
    for (NSManagedObject *entity in results) {
        PixabayImageModel *image = [[PixabayImageModel alloc] init];
        image.imageId = [entity valueForKey:@"imageId"];
        image.previewURL = [entity valueForKey:@"previewURL"];
        image.largeImageURL = [entity valueForKey:@"largeImageURL"];
        image.user = [entity valueForKey:@"user"];
        image.likes = [[entity valueForKey:@"likes"] integerValue];
        image.favorites = [[entity valueForKey:@"favorites"] integerValue];
        image.comments = [[entity valueForKey:@"comments"] integerValue];
        image.searchQuery = [entity valueForKey:@"searchQuery"];
        
        NSString *tagsString = [entity valueForKey:@"tags"];
        if (tagsString && ![tagsString isEqualToString:@""]) {
            image.tags = [tagsString componentsSeparatedByString:@", "];
        } else {
            image.tags = @[];
        }
        
        [images addObject:image];
    }
    
    return [images copy];
}

- (void)deleteAllImages {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kImageEntityName];
    NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    
    NSError *error = nil;
    [self.managedObjectContext executeRequest:deleteRequest error:&error];
    
    if (error) {
        NSLog(@"Error deleting all images: %@", error);
    } else {
        [self saveContext];
    }
}

@end
