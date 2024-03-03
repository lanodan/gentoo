# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer-meson

DESCRIPION="V4L2 source/sink plugin for GStreamer"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="elibc_musl udev"

# libv4l uses an ioctl function signature not matching musl's / posix
RDEPEND="
	!elibc_musl? ( >=media-libs/libv4l-0.9.5[${MULTILIB_USEDEP}] )
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	udev? ( >=dev-libs/libgudev-208:=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	virtual/os-headers
"

PATCHES=(
	"${FILESDIR}/gst-plugins-v4l2-1.23.90-fix_ioctl_glibc-ism.patch"
)

GST_PLUGINS_ENABLED="v4l2"

multilib_src_configure() {
	local emesonargs=(
		-Dv4l2-gudev=$(usex udev enabled disabled)
		-Dv4l2-libv4l2=$(usex elibc_musl disabled enabled)
	)

	gstreamer_multilib_src_configure
}
