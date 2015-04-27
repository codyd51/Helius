ARCHS = armv7 armv7s arm64
GO_EASY_ON_ME = 1
include theos/makefiles/common.mk

TWEAK_NAME = Helius
Helius_FILES = SBBlurryArtworkView.m  BlurImage.xm Tweak.xm
Helius_FRAMEWORKS = UIKit CoreGraphics MediaPlayer QuartzCore Foundation CoreGraphics
Helius_PRIVATE_FRAMEWORKS = MediaPlayerUI
Helius_CFLAGS = -fobjc-arc
Helius_ADDITIONAL_LDFLAGS += -Wl,-map,$@.map -g -x c /dev/null -x none

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += helius
include $(THEOS_MAKE_PATH)/aggregate.mk
