# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

MY_P=DevIL-${PV}

DESCRIPTION="DevIL image library"
HOMEPAGE="https://openil.sourceforge.net/"
SRC_URI="mirror://sourceforge/openil/${MY_P}.tar.gz"
S="${WORKDIR}/DevIL/DevIL"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~x86"
IUSE="jasper jpeg lcms png tiff"

# jasper isn't required but is automagic
RDEPEND="
	jasper? media-libs/jasper:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	lcms? ( media-libs/lcms )
	mng? ( media-libs/libmng:= )
	png? (
		media-libs/libpng:=
		sys-libs/zlib:=
	)
	tiff? ( media-libs/tiff:= )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/devil-1.8.0-jasper-function-signatures.patch"
)

src_configure() {
	local mycmakeargs=(
		-DIL_NO_JP2=$(usex !jasper)
		-DIL_NO_JPG=$(usex !jpeg)
		-DIL_NO_LCMS=$(usex !lcms)
		-DIL_NO_MNG=$(usex !mng)
		-DIL_NO_PNG=$(usex !png)
		-DIL_NO_TIF=$(usex !tiff)
	)

	#   Taken from Alpine which also has the following comment:
	# "register" storage class specifier is no longer allowed in modern C++
	# standards. Until upstream removes the qualifier, we can just ignore the
	# warning.
	append-cxxflags -Wno-register

	cmake_src_configure
}
