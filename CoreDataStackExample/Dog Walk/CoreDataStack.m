//
//  CoreDataStack.m
//  Dog Walk
//
//  Created by GaoYuan on 16/3/1.
//  Copyright © 2016年 Razeware. All rights reserved.
//

#import "CoreDataStack.h"

@interface CoreDataStack()
@property (nonatomic,strong,readwrite) NSString *modelName;
@property (nonatomic,strong,readwrite) NSURL *applcationDocumentsDirectory;
@property (nonatomic,strong,readwrite) NSManagedObjectModel *managedObjectModel;
@property (nonatomic,strong,readwrite) NSPersistentStoreCoordinator *psc;
@property (nonatomic,strong,readwrite) NSManagedObjectContext *managedObjectContext;
@end

@implementation CoreDataStack

-(instancetype)initCoreDataStackWithModelName:(nonnull NSString *)modelName
{
    self = [self init];
    if (self) {
        _modelName = modelName;
        _managedObjectModel = [self _createManagedObjectModelWithModelName:modelName];
        _psc = [self _createPSCWithMOM:_managedObjectModel andModelName:modelName];
        _managedObjectContext = [self _createManagedObjectContextWithPSC:_psc];
    }
    
    return self;
}


-(void) saveContext
{
    if (self.managedObjectContext.hasChanges) {
        NSError *error;
        [self.managedObjectContext save:&error];
        
        if (error) {
            NSLog(@"Save context error: %@", error.localizedDescription);
        }
    }
}


-(NSURL *) applcationDocumentsDirectory
{
    if (!_applcationDocumentsDirectory) {
        NSArray <NSURL *> *urls = [[NSFileManager defaultManager]
                                   URLsForDirectory:NSDocumentDirectory
                                   inDomains:NSUserDomainMask];
        _applcationDocumentsDirectory = [urls objectAtIndex:(urls.count-1)];
    }
    
    return _applcationDocumentsDirectory;
}

-(NSManagedObjectModel *) _createManagedObjectModelWithModelName:(nonnull NSString *)modelName
{

    if (!_managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:modelName
                                                  withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return _managedObjectModel;
}

-(NSPersistentStoreCoordinator *) _createPSCWithMOM:(nonnull NSManagedObjectModel *)mom andModelName:(nonnull NSString *)modelName
{
    if (!_psc) {
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
        NSURL *url = [self.applcationDocumentsDirectory URLByAppendingPathComponent:modelName];
        
        NSError *error;
        NSDictionary *option = @{NSMigratePersistentStoresAutomaticallyOption : @YES};
        [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:option error:&error];
        _psc = coordinator;
    }
    return _psc;
}

-(NSManagedObjectContext *) _createManagedObjectContextWithPSC:(nonnull NSPersistentStoreCoordinator*)psc
{
    if (!_managedObjectContext) {
        NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        managedObjectContext.persistentStoreCoordinator = psc;
        _managedObjectContext = managedObjectContext;
    }
    
    return _managedObjectContext;
}


@end
