ARCHS = armv7 armv7s armv7s
TARGET = :clang
GO_EASY_ON_ME = 1
include theos/makefiles/common.mk

TWEAK_NAME = MusicTest
MusicTest_FILES = Tweak.xm
MusicTest_FRAMEWORKS = UIKit CoreGraphics MediaPlayer QuartzCore
MusicTest_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
