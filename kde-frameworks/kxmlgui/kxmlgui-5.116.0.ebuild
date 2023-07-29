# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
PVCUT=$(ver_cut 1-2)
QTMIN=5.15.9
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for managing menu and toolbar actions in an abstract way"

LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm arm64 ~loong ppc64 ~riscv x86"
IUSE="+dbus"

# slot op: includes QtCore/private/qlocale_p.h
DEPEND="
	dbus? (
		>=dev-qt/qtdbus-${QTMIN}:5
		=kde-frameworks/kglobalaccel-${PVCUT}*:5
	)
	>=dev-qt/qtcore-${QTMIN}:5=
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5[ssl]
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	=kde-frameworks/kconfig-${PVCUT}*:5
	=kde-frameworks/kconfigwidgets-${PVCUT}*:5
	=kde-frameworks/kcoreaddons-${PVCUT}*:5
	=kde-frameworks/kguiaddons-${PVCUT}*:5
	=kde-frameworks/ki18n-${PVCUT}*:5
	=kde-frameworks/kiconthemes-${PVCUT}*:5
	=kde-frameworks/kitemviews-${PVCUT}*:5
	=kde-frameworks/kwidgetsaddons-${PVCUT}*:5
"
RDEPEND="${DEPEND}"

CMAKE_SKIP_TESTS=(
	# bug 668198: files are missing; whatever.
	ktoolbar_unittest
	# bug 650290
	kxmlgui_unittest
	# bug 808216
	ktooltiphelper_unittest
)

src_prepare() {
	if use !dbus; then
		sed -i '/if(NOT ANDROID)/,/endif()/d' CMakeLists.txt || die
	fi

	ecm_src_prepare
}
