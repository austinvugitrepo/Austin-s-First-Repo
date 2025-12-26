EAPI=8

DESCRIPTION="Game of Trees version control system"
HOMEPAGE="https://gameoftrees.org/"
SRC_URI="https://gameoftrees.org/releases/portable/got-portable-${PV}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/libbsd
	dev-libs/libevent
	dev-libs/libretls
	sys-libs/ncurses
	app-crypt/libmd
	sys-apps/util-linux
	sys-libs/zlib
"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/bison
	virtual/pkgconfig
	sys-apps/ed
"

S="${WORKDIR}/got-portable-${PV}"

src_configure() {
	econf
}

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${D}" install
}
