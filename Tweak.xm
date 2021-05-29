#import <Cephei/HBPreferences.h>

#import "Interfaces.h"
#include "Time+Date.m"
#include "Weather.m"
#include "WorldClock.m"
#include "Uptime.m"
#include "NtSpeed.m"
#include "Battery.m"
#include "Volume.m"
#include "Compass.m"

ClockMode mode = kTime;

BOOL timeEnabled;
BOOL dateEnabled;
BOOL weatherEnabled;
BOOL worldClockEnabled;
BOOL uptimeEnabled;
BOOL networkEnabled;
BOOL batteryEnabled;
BOOL volumeEnabled;
BOOL compassEnabled;
BOOL nameEnabled;

NSString *_Nonnull name = @"Name";

float animationDuration;
float updateRate;

static void iterateMode() {
	if(mode != lastMode) {
		mode++;
	}
	else {
		mode = firstMode;
	}
}

static NSString *getModeString() {
	start:
	if(mode == kTime && timeEnabled) {
		return getTimeString();
	}
	else if(mode == kDate && dateEnabled){
		return getDateString();
	}
	else if(mode == kWeather && weatherEnabled) {
		return getWeatherString();
	}
	else if(mode == kWorldClock && worldClockEnabled){
		return getWorldClockString();
	}
	else if(mode == kUptime && uptimeEnabled) {
		return getUptimeString();
	}
	else if(mode == kNetwork && networkEnabled) {
		return getNetworkSpeedString();
	}
	else if(mode == kBattery && batteryEnabled) {
		return getBatteryString();
	}
	else if(mode == kVolume && volumeEnabled) {
		return getVolumeString();
	}
	else if(mode == kCompass && compassEnabled) {
		return getCompassString();
	}
	else if(mode == kName && nameEnabled) {
		return name;
	}
	else {
		// If no elements are enabled, return an empty string I guess ¯\_(ツ)_/¯
		if(!timeEnabled && !dateEnabled && !weatherEnabled && !worldClockEnabled && !uptimeEnabled && !networkEnabled && !volumeEnabled && !compassEnabled && !nameEnabled) {
			return @"";
		}
		// If some elements are enabled, then we need to iterate to the next mode and try again.
		iterateMode();
		goto start;
	}
	return @"";
}

// Start iPhone X Code
%hook _UIStatusBarStringView

- (void)setText:(NSString *)text {
	if([text containsString:@":"]) {
		NSString *newText;
		@try {
			newText = getModeString();
		}
		@catch (NSException *exception) {
			newText = getTimeString();
		}
		%orig(newText);
	}
	else {
		%orig(text);
	}
}

%end


%hook _UIStatusBarTimeItem
%property (nonatomic, retain) NSTimer *transitionTimer;

- (instancetype)init {
	%orig;

	self.shortTimeView.text = @":";
	self.pillTimeView.text = @":";

	self.shortTimeView.adjustsFontSizeToFitWidth = YES;
	self.pillTimeView.adjustsFontSizeToFitWidth = YES;

	self.transitionTimer = [self getTransitionTimer];
	[[NSRunLoop mainRunLoop] addTimer:self.transitionTimer forMode:NSRunLoopCommonModes];
	return self;
}

%new - (NSTimer *)getTransitionTimer {
	return [NSTimer scheduledTimerWithTimeInterval:updateRate repeats:YES block:^(NSTimer *timer) {
		[UIView animateWithDuration:animationDuration
						delay: 0.0
						options: nil
						animations: ^{
							self.shortTimeView.alpha = 0.0;
							self.shortTimeView.transform = CGAffineTransformMakeScale(0.5, 0.5);
							self.pillTimeView.alpha = 0.0;
							self.pillTimeView.transform = CGAffineTransformMakeScale(0.5, 0.5);
						}
						completion: ^(BOOL finished) {
							self.shortTimeView.text = @":";
							self.pillTimeView.text = @":";
							[UIView animateWithDuration:animationDuration
											delay: 0.0
											options: nil
											animations: ^{
												self.shortTimeView.alpha = 1.0;
												self.shortTimeView.transform = CGAffineTransformIdentity;
												self.pillTimeView.alpha = 1.0;
												self.pillTimeView.transform = CGAffineTransformIdentity;
											}
											completion: nil
							];
		}];
	}];
}

- (id)applyUpdate:(_UIStatusBarItemUpdate *)arg1 toDisplayItem:(id)arg2 {
	// Prevents time changing from changing the text
	arg1.dataChanged = NO;
	return %orig(arg1, arg2);
}

%end


%hook _UIStatusBarIndicatorLocationItem

- (id)applyUpdate:(id)arg1 toDisplayItem:(id)arg2 {
	// Removes location indicator
	return nil;
}

%end
// End iPhone X Code

// Start iOS 11 Devices Code

UIStatusBarComposedData *data;
int actions;

%hook UIStatusBarTimeItemView

%property (nonatomic, retain) NSTimer *transitionTimer;

- (instancetype)initWithItem:(id)arg1 data:(id)arg2 actions:(int)arg3 style:(id)arg4 {
	%orig;

	self.transitionTimer = [self getTransitionTimer];
	[[NSRunLoop mainRunLoop] addTimer:self.transitionTimer forMode:NSRunLoopCommonModes];

	return self;
}

%new - (NSTimer *)getTransitionTimer {
	return [NSTimer scheduledTimerWithTimeInterval:updateRate repeats:YES block:^(NSTimer *timer) {
		[UIView animateWithDuration:animationDuration
						delay: 0.0
						options: nil
						animations: ^{
							self.alpha = 0.0;
							self.transform = CGAffineTransformMakeScale(0.5, 0.5);
						}
						completion: ^(BOOL finished) {
							[self updateForNewData:data actions:actions];
							[UIView animateWithDuration:animationDuration
											delay: 0.0
											options: nil
											animations: ^{
												self.alpha = 1.0;
												self.transform = CGAffineTransformIdentity;
											}
											completion: nil
							];
		}];
	}];
}

- (BOOL)updateForNewData:(UIStatusBarComposedData *)arg1 actions:(int)arg2 {
	data = arg1;
	actions = arg2;

	[[self valueForKey:@"_timeString"] release];
	[self setValue:[getModeString() retain] forKey:@"_timeString"];

	return %orig;
}

%end

// End of iOS 11 Devices Code

%ctor {
	// Fix rejailbreak bug
	if (![NSBundle.mainBundle.bundleURL.lastPathComponent.pathExtension isEqualToString:@"app"]) {
		return;
	}

	HBPreferences *settings = [[HBPreferences alloc] initWithIdentifier:@"com.neinzedd9.nittysettings"];
	[settings registerDefaults:@{
															 @"enabled": @YES,
															 @"timeEnabled": @YES,
															 @"dateEnabled": @YES,
															 @"weatherEnabled": @YES,
															 @"worldClockEnabled": @NO,
															 @"uptimeEnabled": @NO,
															 @"networkEnabled": @NO,
															 @"batteryEnabledn": @NO,
															 @"volumeEnabled": @NO,
															 @"compassEnabled": @NO,
															 @"nameEnabled": @NO,
															 @"name": @"Name",
															 @"animationDuration": @0.125,
															 @"updateRate": @3.0,
															 }];

	BOOL enabled = [settings boolForKey:@"enabled"];

	[settings registerBool:&timeEnabled default:YES forKey:@"timeEnabled"];
	[settings registerBool:&dateEnabled default:YES forKey:@"dateEnabled"];
	[settings registerBool:&weatherEnabled default:YES forKey:@"weatherEnabled"];
	[settings registerBool:&worldClockEnabled default:NO forKey:@"worldClockEnabled"];
	[settings registerBool:&uptimeEnabled default:NO forKey:@"uptimeEnabled"];
	[settings registerBool:&networkEnabled default:NO forKey:@"networkEnabled"];
	[settings registerBool:&batteryEnabled default:NO forKey:@"batteryEnabled"];
	[settings registerBool:&volumeEnabled default:NO forKey:@"volumeEnabled"];
	[settings registerBool:&compassEnabled default:NO forKey:@"compassEnabled"];
	[settings registerBool:&nameEnabled default:NO forKey:@"nameEnabled"];
	[settings registerObject:&name default:@"Name" forKey:@"name"];

	animationDuration = [settings floatForKey:@"animationDuration"];
	updateRate = [settings floatForKey:@"updateRate"];

	initializeDateFormatters();
	initializeWorldClockDateFormatter();
	if(compassEnabled) { [locationManager startUpdatingHeading]; }

	NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:updateRate repeats:YES block:^(NSTimer *timer) { iterateMode(); }];
	[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

	if(enabled) { %init; }

}
