//
//  CoreDataStack.h
//  Dog Walk
//
//  Created by GaoYuan on 16/3/1.
//  Copyright © 2016年 Razeware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#pragma clang diagnostic ignored "-Wnullability-completeness"

@interface CoreDataStack : NSObject
@property (nonatomic,strong,readonly) NSString *modelName;
@property (nonatomic,strong,readonly) NSURL *applcationDocumentsDirectory;
@property (nonatomic,strong,readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic,strong,readonly) NSPersistentStoreCoordinator *psc;
@property (nonatomic,strong,readonly) NSManagedObjectContext *managedObjectContext;

-(instancetype) initCoreDataStackWithModelName:(nonnull NSString *)modelName;
-(void) saveContext;
@end
