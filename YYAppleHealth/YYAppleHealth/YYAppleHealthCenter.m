//
//  YYAppleHealthCenter.m
//  YYAppleHealth
//
//  Created by yy.Fu on 2020/12/28.
//

#import "YYAppleHealthCenter.h"
#import <HealthKit/HealthKit.h>

@interface QuantityModel: NSObject
@property (assign, nonatomic) double value;
@property (strong, nonatomic) NSDate* startDate;
@property (strong, nonatomic) NSDate* endDate;
@end

@implementation QuantityModel
@end



@interface YYAppleHealthCenter()

@property (nonatomic, strong)HKHealthStore *healthStore;

@end

@implementation YYAppleHealthCenter



#pragma mark- ********* Permission. *********
-(void)requestAuthorization
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        self.healthStore = [[HKHealthStore alloc] init];
        if (![HKHealthStore isHealthDataAvailable]) {
            NSLog(@"HealthKit data is not available");
            return;
        }
        
        
        [self.healthStore requestAuthorizationToShareTypes:[self types:nil] readTypes:nil completion:^(BOOL success, NSError *error) {
            if (!success) {
                NSString *errMsg = [NSString stringWithFormat:@"Error with HealthKit authorization: %@", error];
                NSLog(@"=========== : %@", errMsg);
                return;
            } else {
                NSLog(@"=========== success ");
            }
        }];
    });
}


- (void)getStatus
{
    NSSet *set = [self types:nil];
    for (HKObjectType *typeModel in set) {
        HKAuthorizationStatus state = [self.healthStore authorizationStatusForType:typeModel];
        NSLog(@"===========typeModel: %@========state: %ld====", typeModel.identifier, (long)state);
    }
}


- (NSSet*)types:(NSString *)type
{
    if (type) {
        
        HKObjectType *objType = nil;
        if ([type isEqualToString:HKCategoryTypeIdentifierSleepAnalysis]) {
            objType = [HKObjectType categoryTypeForIdentifier:type];
        }else{
            objType = [HKObjectType quantityTypeForIdentifier:type];
        }
        return [NSSet setWithObjects:objType, nil];
    }
    NSSet* writeSet = [NSSet setWithObjects:
                       [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
                       [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning],
                       [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned],
                       [HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis],
                       [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate],
                       [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex],
                       [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyFatPercentage],
                       [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],
                       nil];
    return writeSet;
}

#pragma mark- ********* Post data. *********

- (void)postData
{
    
    /**
     STEPS
     */
    //    HKObjectType *type = [[self types:HKQuantityTypeIdentifierStepCount] allObjects][0];
    //    if ([self.healthStore authorizationStatusForType:type] != HKAuthorizationStatusSharingAuthorized) {
    //        NSLog(@"========Not Authorized==========");
    //        return;
    //    }
    //
    //    //steps.
    //    QuantityModel *model = [[QuantityModel alloc] init];
    //    model.value = 2000;
    //    model.startDate =[NSDate dateWithTimeIntervalSince1970: [[NSDate date] timeIntervalSince1970] - 3600 * 5];
    //    model.endDate =[NSDate dateWithTimeIntervalSince1970: [[NSDate date] timeIntervalSince1970] - 3600 * 4.5];
    //
    //    NSArray *records = @[model];
    //    NSArray *values = [self toHKQuantityModelArray:[HKUnit countUnit] type:HKQuantityTypeIdentifierStepCount data:records];
    
    
    /**
     SLEEP
     */
    //    HKObjectType *type = [[self types:HKCategoryTypeIdentifierSleepAnalysis] allObjects][0];
    //    if ([self.healthStore authorizationStatusForType:type] != HKAuthorizationStatusSharingAuthorized) {
    //        NSLog(@"========Not Authorized==========");
    //        return;
    //    }
    //    QuantityModel *model = [[QuantityModel alloc] init];
    //    model.value = 1;   // 0 or 1 ,  0 - light sleep. 1: deep sleep.
    //    model.startDate =[NSDate dateWithTimeIntervalSince1970: [[NSDate date] timeIntervalSince1970] - (48 +13) * 3600];
    //    model.endDate =[NSDate dateWithTimeIntervalSince1970: [[NSDate date] timeIntervalSince1970] - (48 +3) * 3600];
    //    NSArray *records = @[model];
    //    NSArray *values = [self toHKCategorySampleArray:HKCategoryTypeIdentifierSleepAnalysis data:records];
    
    
    /**
     Heart Rate.
     */
//    HKObjectType *type = [[self types:HKQuantityTypeIdentifierHeartRate] allObjects][0];
//    if ([self.healthStore authorizationStatusForType:type] != HKAuthorizationStatusSharingAuthorized) {
//        NSLog(@"========Not Authorized==========");
//        return;
//    }
//    QuantityModel *model = [[QuantityModel alloc] init];
//    model.value = 80;
//    model.startDate =[NSDate dateWithTimeIntervalSince1970: [[NSDate date] timeIntervalSince1970]];
//    model.endDate =[NSDate dateWithTimeIntervalSince1970: [[NSDate date] timeIntervalSince1970]];
//    NSArray *records = @[model];
//    HKUnit *unit = [[HKUnit countUnit] unitDividedByUnit:[HKUnit minuteUnit]];
//    NSArray *values = [self toHKQuantityModelArray:unit type:HKQuantityTypeIdentifierHeartRate data:records];
    
    /**
     BMI
     */
//    HKObjectType *type = [[self types:HKQuantityTypeIdentifierBodyMassIndex] allObjects][0];
//    if ([self.healthStore authorizationStatusForType:type] != HKAuthorizationStatusSharingAuthorized) {
//        NSLog(@"========Not Authorized==========");
//        return;
//    }
//    QuantityModel *model = [[QuantityModel alloc] init];
//    model.value = 20;
//    model.startDate =[NSDate dateWithTimeIntervalSince1970: [[NSDate date] timeIntervalSince1970] - 3600];
//    model.endDate =[NSDate dateWithTimeIntervalSince1970: [[NSDate date] timeIntervalSince1970] - 3600];
//    NSArray *records = @[model];
////    HKUnit *unit = [[HKUnit gramUnit] unitDividedByUnit:[HKUnit ]];
//    HKUnit *unit = [HKUnit countUnit];
//    NSArray *values = [self toHKQuantityModelArray:unit type:HKQuantityTypeIdentifierBodyMassIndex data:records];
//
    
    /**
     Weight
     */
//    HKObjectType *type = [[self types:HKQuantityTypeIdentifierBodyMass] allObjects][0];
//    if ([self.healthStore authorizationStatusForType:type] != HKAuthorizationStatusSharingAuthorized) {
//        NSLog(@"========Not Authorized==========");
//        return;
//    }
//    QuantityModel *model = [[QuantityModel alloc] init];
//    model.value = 61;
//    model.startDate =[NSDate dateWithTimeIntervalSince1970: [[NSDate date] timeIntervalSince1970] - 3600];
//    model.endDate =[NSDate dateWithTimeIntervalSince1970: [[NSDate date] timeIntervalSince1970] - 3600];
//    NSArray *records = @[model];
//    HKUnit *unit = [HKUnit unitFromString:@"kg"];
//    NSArray *values = [self toHKQuantityModelArray:unit type:HKQuantityTypeIdentifierBodyMass data:records];

    /**
     BodyFatPercentage
     */
    @try {
        
        HKObjectType *type = [[self types:HKQuantityTypeIdentifierBodyFatPercentage] allObjects][0];
        if ([self.healthStore authorizationStatusForType:type] != HKAuthorizationStatusSharingAuthorized) {
            NSLog(@"========Not Authorized==========");
            return;
        }
        QuantityModel *model = [[QuantityModel alloc] init];
        model.value = 0.17;
        // 1609228914.7585201;// [[NSDate date] timeIntervalSince1970] - 3600; 使用相同的时间戳， Apple health 会同样上传成功，health 显示也正常， 知识 APPs 里面有多次上传的记录。；
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] - 3600;
        model.startDate =[NSDate dateWithTimeIntervalSince1970: interval];//
        model.endDate =[NSDate dateWithTimeIntervalSince1970: interval];
        NSArray *records = @[model];
        HKUnit *unit = [HKUnit percentUnit];
        NSArray *values = [self toHKQuantityModelArray:unit type:HKQuantityTypeIdentifierBodyFatPercentage data:records];
        
        [self.healthStore saveObjects:values withCompletion:^(BOOL success, NSError * _Nullable error) {
            NSLog(@"===========success : %d, ======= error: %@",success,  error);
        }];
    } @catch (NSException *exception) {
        NSLog(@"================== error: %@",  exception);
    }
}

- (NSArray*) toHKQuantityModelArray:(HKUnit*) unit
                               type:(HKQuantityTypeIdentifier) type
                               data:(NSArray<QuantityModel*>*) samples {
    HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier:type];
    NSMutableArray* array = [NSMutableArray new];
    for (QuantityModel* sample in samples) {
        HKQuantity *quantity = [HKQuantity quantityWithUnit:unit doubleValue:sample.value];
        HKQuantitySample *data = [HKQuantitySample quantitySampleWithType:quantityType quantity:quantity startDate:sample.startDate endDate:sample.endDate];
        [array addObject:data];
    }
    return array;
}


- (NSArray*) toHKCategorySampleArray:(HKCategoryTypeIdentifier) type
                                data:(NSArray<QuantityModel*>*) samples {
    HKCategoryType *categoryType = [HKCategoryType categoryTypeForIdentifier: type];
    NSMutableArray* array = [NSMutableArray new];
    for (QuantityModel* sample in samples) {
        HKCategorySample *data = [HKCategorySample categorySampleWithType:categoryType value:sample.value startDate:sample.startDate endDate:sample.endDate];
        [array addObject:data];
    }
    return array;
}


@end
