# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Brian Kernighan's pattern scanning and processing language"
HOMEPAGE="https://github.com/onetrueawk/awk"
SRC_URI="https://github.com/onetrueawk/awk/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/awk-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux"

BDEPEND="
	app-alternatives/yacc
"

DOCS=( README.md FIXES )

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		HOSTCC="$(tc-getBUILD_CC)" \
		CFLAGS="${CFLAGS}" \
		CPPFLAGS="${CPPFLAGS} -DHAS_ISBLANK" \
		ALLOC="${LDFLAGS}" \
		YACC=$(command -v yacc) \
		YFLAGS="-d -b awkgram"
}

src_install() {
	newbin a.out "${PN}"
	sed \
		-e 's/awk/nawk/g' \
		-e 's/AWK/NAWK/g' \
		-e 's/Awk/Nawk/g' \
		awk.1 > "${PN}".1 || die "manpage patch failed"
	doman "${PN}.1"
	einstalldocs
}

pkg_postinst() {
	if has_version app-admin/eselect && has_version app-eselect/eselect-awk
	then
		eselect awk update ifunset
	fi
}

pkg_postrm() {
	if has_version app-admin/eselect && has_version app-eselect/eselect-awk
	then
		eselect awk update ifunset
	fi
}
