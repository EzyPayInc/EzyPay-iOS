//
//  CoreDataManager.h
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/9/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (CoreDataManager *) sharedInstance;
+ (__kindof NSManagedObject *) createEntityWithName:(NSString *)name;
+ (void)saveContext;
+ (void)saveContextParent;
@end
