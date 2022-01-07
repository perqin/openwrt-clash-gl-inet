include $(TOPDIR)/rules.mk

PKG_NAME:=clash
PKG_VERSION:=1.9.0
PKG_RELEASE:=1

PKG_SOURCE:=clash-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/Dreamacro/clash/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=a276b1e7247e847fe44fe336a67bdecbb442748a1e7fa01d9c1ce0d52f9168ef

PKG_LICENSE:=GPL-3.0-only
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Perqin Xie <perqinxie@gmail.com>

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

GO_PKG:=github.com/Dreamacro/clash
GO_PKG_LDFLAGS:=-s -w
GO_PKG_LDFLAGS_X:= \
	github.com/Dreamacro/clash/constant.Version=$(PKG_VERSION) \
	github.com/Dreamacro/clash/constant.BuildTime=$(shell date -u)

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/clash
  SECTION:=net
  CATEGORY:=Network
  TITLE:=A rule-based tunnel in Go.
  URL:=https://github.com/Dreamacro/clash
  DEPENDS:=$(GO_ARCH_DEPENDS)
endef

define Package/clash/description
  A rule-based tunnel in Go.
endef

define Build/Prepare
	$(call Build/Prepare/Default)
endef

define Build/Compile
	$(eval GO_PKG_BUILD_PKG:=github.com/Dreamacro/clash)
	$(call GoPackage/Build/Compile)
endef

define Package/clash/install
	$(call GoPackage/Package/Install/Bin,$(PKG_INSTALL_DIR))

	$(INSTALL_DIR) $(1)/usr/bin

	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/clash $(1)/usr/bin

	$(INSTALL_DIR) $(1)/usr/share/clash
endef

$(eval $(call GoBinPackage,clash))
$(eval $(call BuildPackage,clash))
