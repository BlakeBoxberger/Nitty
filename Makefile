TARGET = iphone:11.0:10.1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Nitty
Nitty_FILES = Tweak.xm
Nitty_EXTRA_FRAMEWORKS = Cephei

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

SUBPROJECTS += settings

include $(THEOS_MAKE_PATH)/aggregate.mk
