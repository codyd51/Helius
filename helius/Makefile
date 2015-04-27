ARCHS = armv7 armv7s arm64
include theos/makefiles/common.mk

BUNDLE_NAME = Helius
Helius_FILES = Helius.mm
Helius_INSTALL_PATH = /Library/PreferenceBundles
Helius_FRAMEWORKS = UIKit
Helius_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Helius.plist$(ECHO_END)
