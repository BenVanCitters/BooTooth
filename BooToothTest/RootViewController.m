//
//  RootViewController.m
//  BooToothTest
//
//  Created by Ben Van Citters on 3/25/15.
//  Copyright (c) 2015 Ben Van Citters. All rights reserved.
//

#import "RootViewController.h"


@interface RootViewController ()

@end

@implementation RootViewController



- (void)viewDidLoad {
    [super viewDidLoad];


    //BLUETOOTH
    
    //managers
//    NSMutableDictionary* myCentralOptions = [[NSMutableDictionary alloc] init];
//    CBCentralManager* myCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:myCentralOptions];
    
    self.statusLabel.text = @"";
    
    NSMutableDictionary* myPeripheralOptions = [[NSMutableDictionary alloc] init];
    self.myPeripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:myPeripheralOptions];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark
#pragma mark CBPeripheralManagerDelegate

/*!
 *  @method peripheralManagerDidUpdateState:
 *
 *  @param peripheral   The peripheral manager whose state has changed.
 *
 *  @discussion         Invoked whenever the peripheral manager's state has been updated. Commands should only be issued when the state is
 *                      <code>CBPeripheralManagerStatePoweredOn</code>. A state below <code>CBPeripheralManagerStatePoweredOn</code>
 *                      implies that advertisement has paused and any connected centrals have been disconnected. If the state moves below
 *                      <code>CBPeripheralManagerStatePoweredOff</code>, advertisement is stopped and must be explicitly restarted, and the
 *                      local database is cleared and all services must be re-added.
 *
 *  @see                state
 *
 */
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSLog(@"peripheralManager DidUpdateState %d",peripheral.state);

    if(peripheral.state == CBPeripheralManagerStatePoweredOn)
    {
        //services and characteristics
        CBUUID *myCustomServiceUUID = [CBUUID UUIDWithString:@"71DA3FD1-7E10-41C1-B16F-4430B506CDE7"];
        CBUUID *myCharacteristicUUID = [CBUUID UUIDWithString:@"473CAEE9-6B16-4982-95DD-A87F57044B3F"];
        CBMutableCharacteristic* myCharacteristic = [[CBMutableCharacteristic alloc] initWithType:myCharacteristicUUID
                                                                                       properties:CBCharacteristicPropertyRead
                                                                                            value:[[NSData alloc] init]
                                                                                      permissions:CBAttributePermissionsReadable];
        CBMutableService* myService = [[CBMutableService alloc] initWithType:myCustomServiceUUID
                                                                     primary:YES];
        myService.characteristics = @[myCharacteristic];

        [self.myPeripheralManager addService:myService];

        //publishing the services and characteristics
        [self.myPeripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[myService.UUID],
                                                      CBAdvertisementDataLocalNameKey : @"XXXXX"}];
            self.statusLabel.text = @"";
        
    }
}

/*!
 *  @method peripheralManager:willRestoreState:
 *
 *  @param peripheral	The peripheral manager providing this information.
 *  @param dict			A dictionary containing information about <i>peripheral</i> that was preserved by the system at the time the app was terminated.
 *
 *  @discussion			For apps that opt-in to state preservation and restoration, this is the first method invoked when your app is relaunched into
 *						the background to complete some Bluetooth-related task. Use this method to synchronize your app's state with the state of the
 *						Bluetooth system.
 *
 *  @seealso            CBPeripheralManagerRestoredStateServicesKey;
 *  @seealso            CBPeripheralManagerRestoredStateAdvertisementDataKey;
 *
 */
//- (void)peripheralManager:(CBPeripheralManager *)peripheral willRestoreState:(NSDictionary *)dict
//{
//  complains if uncommented
//}

/*!
 *  @method peripheralManagerDidStartAdvertising:error:
 *
 *  @param peripheral   The peripheral manager providing this information.
 *  @param error        If an error occurred, the cause of the failure.
 *
 *  @discussion         This method returns the result of a @link startAdvertising: @/link call. If advertisement could
 *                      not be started, the cause will be detailed in the <i>error</i> parameter.
 *
 */
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    self.statusLabel.text = @"Advertizing!";
    NSLog(@"peripheralManager DidStartAdvertising");
    if (error)
    {
        NSLog(@"Error advertising: %@", [error localizedDescription]);
    }
}

/*!
 *  @method peripheralManager:didAddService:error:
 *
 *  @param peripheral   The peripheral manager providing this information.
 *  @param service      The service that was added to the local database.
 *  @param error        If an error occurred, the cause of the failure.
 *
 *  @discussion         This method returns the result of an @link addService: @/link call. If the service could
 *                      not be published to the local database, the cause will be detailed in the <i>error</i> parameter.
 *
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
{
    self.statusLabel.text = @"added service!";
    NSLog(@"peripheralManager didAddService");
    if (error)
    {
        NSLog(@"Error publishing service: %@", [error localizedDescription]);
    }
}

/*!
 *  @method peripheralManager:central:didSubscribeToCharacteristic:
 *
 *  @param peripheral       The peripheral manager providing this update.
 *  @param central          The central that issued the command.
 *  @param characteristic   The characteristic on which notifications or indications were enabled.
 *
 *  @discussion             This method is invoked when a central configures <i>characteristic</i> to notify or indicate.
 *                          It should be used as a cue to start sending updates as the characteristic value changes.
 *
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"peripheralManager didSubscribeToCharacteristic");
}

/*!
 *  @method peripheralManager:central:didUnsubscribeFromCharacteristic:
 *
 *  @param peripheral       The peripheral manager providing this update.
 *  @param central          The central that issued the command.
 *  @param characteristic   The characteristic on which notifications or indications were disabled.
 *
 *  @discussion             This method is invoked when a central removes notifications/indications from <i>characteristic</i>.
 *
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"peripheralManager didUnsubscribeFromCharacteristic");
}

/*!
 *  @method peripheralManager:didReceiveReadRequest:
 *
 *  @param peripheral   The peripheral manager requesting this information.
 *  @param request      A <code>CBATTRequest</code> object.
 *
 *  @discussion         This method is invoked when <i>peripheral</i> receives an ATT request for a characteristic with a dynamic value.
 *                      For every invocation of this method, @link respondToRequest:withResult: @/link must be called.
 *
 *  @see                CBATTRequest
 *
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request
{
   NSLog(@"peripheralManager didReceiveReadRequest");
}

/*!
 *  @method peripheralManager:didReceiveWriteRequests:
 *
 *  @param peripheral   The peripheral manager requesting this information.
 *  @param requests     A list of one or more <code>CBATTRequest</code> objects.
 *
 *  @discussion         This method is invoked when <i>peripheral</i> receives an ATT request or command for one or more characteristics with a dynamic value.
 *                      For every invocation of this method, @link respondToRequest:withResult: @/link should be called exactly once. If <i>requests</i> contains
 *                      multiple requests, they must be treated as an atomic unit. If the execution of one of the requests would cause a failure, the request
 *                      and error reason should be provided to <code>respondToRequest:withResult:</code> and none of the requests should be executed.
 *
 *  @see                CBATTRequest
 *
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests
{
    NSLog(@"peripheralManager didReceiveWriteRequests");
}

/*!
 *  @method peripheralManagerIsReadyToUpdateSubscribers:
 *
 *  @param peripheral   The peripheral manager providing this update.
 *
 *  @discussion         This method is invoked after a failed call to @link updateValue:forCharacteristic:onSubscribedCentrals: @/link, when <i>peripheral</i> is again
 *                      ready to send characteristic value updates.
 *
 */
- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral
{
    NSLog(@"peripheralManager IsReadyToUpdateSubscribers");
}
@end
