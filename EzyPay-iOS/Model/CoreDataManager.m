//
//  CoreDataManager.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/9/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "CoreDataManager.h"
NSString const *KEYPERSINTENTSTORE = @"ManagedContextKey";

static CoreDataManager *sharedInstance;

@implementation CoreDataManager

@synthesize managedObjectModel, managedObjectContext, persistentStoreCoordinator;

+ (CoreDataManager *) sharedInstance {
    @synchronized (self) {
        if(!sharedInstance) {
            sharedInstance = [[CoreDataManager alloc] init];
        }
    }
    return sharedInstance;
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = [[[NSThread currentThread] threadDictionary] objectForKey:KEYPERSINTENTSTORE];
    if (context != nil) {
        return context;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if(coordinator != nil && [[NSThread currentThread] isEqual:[NSThread mainThread]]) {
        context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [context setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        [context setPersistentStoreCoordinator:coordinator];
        [context setUndoManager:[[NSUndoManager alloc] init]];
        [[[NSThread currentThread] threadDictionary] setObject:context forKey:KEYPERSINTENTSTORE];
    } else if(coordinator != nil) {
         context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [context setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        [context setParentContext:managedObjectContext];
        [[[NSThread currentThread] threadDictionary] setObject:context forKey:KEYPERSINTENTSTORE];
    }
    
    if([[NSThread currentThread]  isEqual:[NSThread mainThread]]) {
        managedObjectContext = context;
    }
    return managedObjectContext;
}

- (NSManagedObjectModel *) managedObjectModel {
    if(managedObjectModel != nil){
        return managedObjectModel;
    }
    
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"EzyPay" withExtension:@".momd"]];
    
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
    if(persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    NSError *error = nil;
    NSURL *persintentURL = [[self applicationDirectory] URLByAppendingPathComponent:@"EzyPay"];
    NSDictionary *persintentOptions = @{NSMigratePersistentStoresAutomaticallyOption : @YES, NSInferMappingModelAutomaticallyOption : @YES};
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:persintentURL options:persintentOptions error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return persistentStoreCoordinator;
}

+ (__kindof NSManagedObject *)createEntityWithName:(NSString *)name {
    NSManagedObjectContext *context = [[CoreDataManager sharedInstance] managedObjectContext];
    NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:context];
    return entity;
}

+ (void) saveContext {
    NSError *error = nil;
    NSManagedObjectContext *context = [[CoreDataManager sharedInstance] managedObjectContext];
    
    if(context != nil) {
        if ([context hasChanges] && ![context save:&error]) {
            NSLog(@"Error saving info error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

+ (void)saveContextParent {
    NSError *error = nil;
    NSManagedObjectContext *context = [[CoreDataManager sharedInstance] managedObjectContext];
    
    if(context != nil) {
        if ([context hasChanges] && ![context save:&error]) {
            NSLog(@"Error saving info error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    if(context.parentContext) {
        [context.parentContext performBlock:^{
            [CoreDataManager saveContext];
        }];
    }
}

+ (void) deleteDataFromCoredata {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Car"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    NSPersistentStoreCoordinator *persintentStrore = [[CoreDataManager sharedInstance] persistentStoreCoordinator];
    NSManagedObjectContext *context = [[CoreDataManager sharedInstance] managedObjectContext];
    [persintentStrore executeRequest:delete withContext:context error:&deleteError];
}

- (NSURL *)applicationDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



@end
