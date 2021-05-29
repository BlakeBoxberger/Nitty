#include "NittyRootListController.h"
#import <Cephei/HBRespringController.h>
#import <Cephei/HBPreferences.h>

@interface HBPreferences ()
- (void)_preferencesChanged;
@end

@implementation NittyRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

+ (NSString *)hb_shareText {
	return @"I'm using #Nitty by @NeinZedd9 to give life to my iPhone X's status bar clock!!";
}

- (void)respring {
	[HBRespringController respringAndReturnTo:[NSURL URLWithString:@"prefs:root=Nitty"]];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
  [super setPreferenceValue:value specifier:specifier];
  [[HBPreferences preferencesForIdentifier:@"com.neinzedd9.nitty"] _preferencesChanged];
}

@end
