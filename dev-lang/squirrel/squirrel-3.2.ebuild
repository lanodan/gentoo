# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A interpreted language mainly used for games"
HOMEPAGE="http://squirrel-lang.org/"
SRC_URI="https://github.com/albertodemichelis/squirrel/archive/refs/tags/v3.2.tar.gz -> ${P}.gh.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples static-libs"

RDEPEND=""
DEPEND="${RDEPEND}"

PATCHES=(
	# Fixed in master
	"${FILESDIR}/${P}-CVE-2022-30292.patch"
	"${FILESDIR}/squirrel-3.2-pkg_config_pr264.patch"
)

src_configure() {
	local mycmakeargs=(
		$(usex static-libs '' -DDISABLE_STATIC=YES)
		# /usr/bin/sq is used by app-text/ispell
		# /usr/lib/libsquirrel.so is used by app-shells/squirrelsh
		-DLONG_OUTPUT_NAMES=YES
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	dodoc HISTORY

	if use examples; then
		docompress -x /usr/share/doc/${PF}/samples
		dodoc -r samples
	fi
}
