include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = NittySettings
NittySettings_FILES = NittyRootListController.m
NittySettings_INSTALL_PATH = /Library/PreferenceBundles
NittySettings_FRAMEWORKS = UIKit
NittySettings_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
NittySettings_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/NittySettings.plist$(ECHO_END)
