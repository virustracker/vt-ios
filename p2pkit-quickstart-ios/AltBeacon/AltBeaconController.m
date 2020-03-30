//
//  DemoViewController.m
//  AltBeacon (Renamed from Vicinity)
//
//  Created by Martin Palatnik on 12/05/2014
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014 CharruaLabs
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "AltBeaconController.h"
#import "CBUUID+Ext.h"


// contanst
#define kUuidBeaconOne @"5F22CA05-8F6C-49B6-AEAE-B278FDFE9287"
#define kUuidBeaconTwo @"9F3E9E58-5073-4F78-BD04-87050DAFB604"
#define kUuidBeaconThree @"177383C7-8347-444F-B14E-1581131A16E2"

@interface AltBeaconController ()

// properties
@property (weak, nonatomic) IBOutlet UIButton *BtnAltBOne;
@property (weak, nonatomic) IBOutlet UIButton *BtnAltBTwo;
@property (weak, nonatomic) IBOutlet UIButton *BtnAltBthree;

// IBActions
- (IBAction)StartStopAltBOne:(id)sender;
- (IBAction)StartStopAltBTwo:(id)sender;
- (IBAction)StartStopAltThree:(id)sender;

// variables
@property (assign, nonatomic) BOOL didStartAltBOne;
@property (assign, nonatomic) BOOL didStartAltBTwo;
@property (assign, nonatomic) BOOL didStartAltBThree;
@property (strong, nonatomic) AltBeacon* beaconOne;
@property (strong, nonatomic) AltBeacon* beaconTwo;
@property (strong, nonatomic) AltBeacon* beaconThree;
@property (weak, nonatomic) IBOutlet UILabel *labelDisplayResult;
@property (weak, nonatomic) IBOutlet UILabel *labelDisplayResultBeacon2;
@property (weak, nonatomic) IBOutlet UILabel *labelDisplayResultBeacon3;
@property (weak, nonatomic) IBOutlet UILabel *labelDisplayResultBeacon1;

@end

@implementation AltBeaconController

- (void)configure {
    self.didStartAltBOne=NO;
    self.didStartAltBTwo=NO;
    self.didStartAltBThree=NO;
    
    // Initialize the IBeacon UUDI@
    self.beaconOne = [[AltBeacon alloc ]initWithIdentifier:kUuidBeaconOne];
//    self.beaconTwo =  [[AltBeacon alloc ]initWithIdentifier:kUuidBeaconTwo];
//    self.beaconThree =  [[AltBeacon alloc ]initWithIdentifier:kUuidBeaconThree];
    
    [self.beaconOne addDelegate:self];
//    [self.beaconTwo addDelegate:self];
//    [self.beaconThree addDelegate:self];
}

- (void)startOrUpdateWithToken:(NSString *)token {
    NSLog(@"Start with token: %@", token);
    if (self.didStartAltBOne) {
        [self stop:self.beaconOne];
    }
    self.beaconOne = [[AltBeacon alloc ]initWithIdentifier:token];
    [self.beaconOne addDelegate:self];
    self.didStartAltBOne = YES;
    [self start:self.beaconOne];
}

- (void)stop {
    self.didStartAltBOne = NO;
    [self stop:self.beaconOne];
}

- (void)dealloc {
    [self stop];
}


- (IBAction)StartStopAltBOne:(id)sender {

    // Whe the user press one of the buttons then that beacon will start searching for anotherone
    if (self.didStartAltBOne) {
        self.didStartAltBOne = NO;
        [self setTitleButton:@"Start AltBeacon 1" andButton: self.BtnAltBOne];

        // setting the result label
        self.labelDisplayResult.text = @"";

        // stop broadcasting and discovering
        [self stop:self.beaconOne];

    } else {
        self.didStartAltBOne = YES;
        [self setTitleButton:@"Stop AltBeacon 1" andButton:self.BtnAltBOne];

        // setting the result label
        self.labelDisplayResult.text = @"Scanning...............";

        // start broadcasting and discovering
        [self start:self.beaconOne];
    }
}

- (IBAction)StartStopAltBTwo:(id)sender {

    if (self.didStartAltBTwo) {
        self.didStartAltBTwo = NO;
        [self setTitleButton:@"Start AltBeacon 2" andButton: self.BtnAltBTwo];

        // setting the result label
        self.labelDisplayResult.text = @"";

        // stop broadcasting and discovering
        [self stop:self.beaconTwo];

    } else {

        self.didStartAltBTwo = YES;
        [self setTitleButton:@"Stop AltBeacon 2" andButton:self.BtnAltBTwo];

        // setting the result label
        self.labelDisplayResult.text = @"Scanning...............";

        // start broadcasting and discovering
        [self start:self.beaconTwo];
    }

}

- (IBAction)StartStopAltThree:(id)sender {

    if (self.didStartAltBThree) {
        self.didStartAltBThree = NO;
        [self setTitleButton:@"Start AltBeacon 3" andButton: self.BtnAltBthree];

        // setting the result label
        self.labelDisplayResult.text = @"";

        // start broadcasting and discovering
        [self stop:self.beaconThree];
    }
    else {
        self.didStartAltBThree = YES;
        [self setTitleButton:@"Stop AltBeacon 3" andButton:self.BtnAltBthree];

        // setting the result label
        self.labelDisplayResult.text = @"Scanning...............";

        // start broadcasting and discovering
        [self start:self.beaconThree];
    }
}

- (void) setTitleButton:(NSString *)title andButton:(UIButton*)button {

    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];

}

- (void)start:(AltBeacon *)beacon {

    // start broadcasting
    [beacon startBroadcasting];
    [beacon startDetecting];
}

- (void)stop:(AltBeacon *)beacon {

    // start broadcasting
    [beacon stopBroadcasting];
    [beacon stopDetecting];
}


- (NSString*) convertToString:(NSNumber *)number {
    NSString *result = nil;

    switch(number.intValue) {
        case INDetectorRangeFar:
            result = @"Up to 100 meters";
            break;
        case INDetectorRangeNear:
            result = @"Up to 15 meters";
            break;
        case INDetectorRangeImmediate:
            result = @"Up to 5 meters";
            break;

        default:
            result = @"Unknown";
    }

    return result;
}

// Delegate methods
- (void)service:(AltBeacon *)service foundDevices:(NSMutableDictionary *)devices {

    for(NSString *key in devices) {
        
        if (self.peerDiscoveredCallback) {
            self.peerDiscoveredCallback(key);
        }
        
        NSNumber * range = [devices objectForKey:key];
        if (range.intValue == INDetectorRangeUnknown){
            if ([key  isEqualToString:kUuidBeaconOne]){
                self.labelDisplayResultBeacon1.text = @"";
            }
            else if ([key  isEqualToString: kUuidBeaconTwo]){
                self.labelDisplayResultBeacon2.text =  @"";
            }
            else if ([key  isEqualToString: kUuidBeaconThree]){
                self.labelDisplayResultBeacon3.text = @"";
            }
        }else{

            NSString *result = [self convertToString:range];
            NSString *beaconName = @"";
            if ([key  isEqualToString:kUuidBeaconOne]){
                beaconName = @"Beacon one!";
                self.labelDisplayResultBeacon1.text = [NSString stringWithFormat:@"%@ %@ %@ %@", beaconName, @"was found",result, @"meters away"];
            }
            else if ([key  isEqualToString: kUuidBeaconTwo]){
                beaconName = @"Beacon two!";
                self.labelDisplayResultBeacon2.text = [NSString stringWithFormat:@"%@ %@ %@ %@", beaconName, @"was found",result, @"meters away"];
            }
            else if ([key  isEqualToString: kUuidBeaconThree]){
                beaconName = @"Beacon three!";
                self.labelDisplayResultBeacon3.text = [NSString stringWithFormat:@"%@ %@ %@ %@", beaconName, @"was found",result, @"meters away"];
            }
        }
    }
}



@end
