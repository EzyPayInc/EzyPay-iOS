//
//  UserManager.m
//  EzyPay-iOS
//
//  Created by Gustavo Quesada Sanchez on 11/29/16.
//  Copyright © 2016 EzyPay Inc. All rights reserved.
//

#import "UserManager.h"
#import "CoreDataManager.h"
#import "GeneralServiceClient.h"
#import "UserServiceClient.h"

@implementation UserManager

#pragma mark - Core Data
+ (User *)userFromDictionary:(NSDictionary *)userDictionary {
    User *user = [CoreDataManager createEntityWithName:@"User"];
    user.name = [userDictionary objectForKey:@"name"];
    user.email = [userDictionary objectForKey:@"email"];
    user.lastName = [userDictionary objectForKey:@"lastName"];
    user.phoneNumber = [userDictionary objectForKey:@"phoneNumber"];
    user.userType = [[userDictionary objectForKey:@"userType"] integerValue];
    //user.boss = [[userDictionary objectForKey:@"boss"] integerValue];
    return user;
}

+ (User *)getUser {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"token.length > 0"];
    NSError *error;
    NSArray *array = [[[[CoreDataManager sharedInstance] managedObjectContext] executeFetchRequest:request error:&error] filteredArrayUsingPredicate:predicate];
    if(!error && [array count] > 0){
        return [array firstObject];
    }
    return nil;
}

+ (NSArray *)usersFromArray:(NSArray *)usersArray {
    NSMutableArray *users = [NSMutableArray array];
    for (NSDictionary *userDictionary in usersArray) {
        CoreDataManager *manager = [[CoreDataManager alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:manager.managedObjectContext];
        User *user = (User *)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
        user.id = [[userDictionary objectForKey:@"id"] integerValue];
        user.name = [userDictionary objectForKey:@"name"];
        user.email = [userDictionary objectForKey:@"email"];
        user.lastName = [userDictionary objectForKey:@"lastName"];
        user.phoneNumber = [userDictionary objectForKey:@"phoneNumber"];
        user.userType = [[userDictionary objectForKey:@"userType"] integerValue];
        [users addObject:user];
    }
    return users;
}

+ (void)deleteUser
{
    [CoreDataManager deleteDataFromEntity:@"User"];
}

+ (NSArray *)employeesFromArray:(NSArray *)employeesArray {
    NSMutableArray *employees = [NSMutableArray array];
    for (NSDictionary *employeeDictionary in employeesArray) {
        CoreDataManager *manager = [[CoreDataManager alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:manager.managedObjectContext];
        User *user = (User *)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
        user.id = [[employeeDictionary objectForKey:@"id"] integerValue];
        user.name = [employeeDictionary objectForKey:@"name"];
        user.lastName = [employeeDictionary objectForKey:@"lastName"];
        user.email = [employeeDictionary objectForKey:@"email"];
        [employees addObject:user];
    }
    return employees;
}

#pragma mark - Web Services
- (void)login:(NSString *) email password:(NSString *)password successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler {
    GeneralServiceClient *service = [[GeneralServiceClient alloc] init];
    [service login:email password:password successHandler:successHandler failureHandler:failureHandler];
}

- (void)registerUser:(User *) user successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler {
    UserServiceClient *service = [[UserServiceClient alloc] init];
    [service registerUser:user successHandler:successHandler failureHandler:failureHandler];
}

- (void)getUserFromServer:(int64_t)userId token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler:(ConnectionErrorHandler) failureHandler {
    UserServiceClient *service = [[UserServiceClient alloc] init];
    [service getUserFromServer:userId token:token successHandler:successHandler failureHandler:failureHandler];
}

- (void)updateUser:(User *) user successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler {
    UserServiceClient *service = [[UserServiceClient alloc] init];
    [service updateUser:user successHandler:successHandler failureHandler:failureHandler];
}

- (void)validatePhoneNumbers:(NSArray *)phoneNumbers token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler {
     UserServiceClient *service = [[UserServiceClient alloc] init];
    [service validatePhoneNumbers:phoneNumbers token:token successHandler:successHandler failureHandler:failureHandler];
}

- (void)uploadUserImage:(UIImage *)image User:(User *)user successHandler:(ConnectionSuccessHandler) successHandler failureHandler: (ConnectionErrorHandler) failureHandler {
    UserServiceClient *service = [[UserServiceClient alloc] init];
    [service uploadUserImage:image User:user successHandler:successHandler failureHandler:failureHandler];
}

- (void)downloadImage:(int64_t)idUser toImageView:(UIImageView *)imageView defaultImage:(NSString *)defaultImage {
    UserServiceClient *service = [[UserServiceClient alloc] init];
    [service downloadImage:idUser toImageView:imageView defaultImage:defaultImage];
}

- (void)getEmployees:(int64_t)boss token:(NSString *)token successHandler:(ConnectionSuccessHandler) successHandler failureHandler:(ConnectionErrorHandler) failureHandler {
    UserServiceClient *service = [[UserServiceClient alloc] init];
    [service getEmployees:boss token:token successHandler:successHandler failureHandler:failureHandler];
}


@end
