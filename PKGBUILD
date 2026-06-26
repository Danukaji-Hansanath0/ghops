# Maintainer: danukaji <danukaji@example.com>
# Contributor: danukaji

pkgname=ghops
pkgver=1.0.0
pkgrel=1
pkgdesc="GitHub Multi-Repo Secret Manager - Bulk set secrets across repositories"
arch=('any')
url="https://github.com/danukaji/ghops"
license=('MIT')
depends=('github-cli')
makedepends=()
optdepends=()
source=("${pkgname}-${pkgver}.tar.gz::https://github.com/danukaji/${pkgname}/archive/v${pkgver}.tar.gz")
sha256sums=('SKIP')
install="${pkgname}.install"

package() {
    cd "${srcdir}/${pkgname}-${pkgver}"

    install -Dm755 bin/ghops "${pkgdir}/usr/bin/ghops"

    install -Dm644 LICENSE "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"

    install -Dm644 man/man1/ghops.1 -t "${pkgdir}/usr/share/man/man1/"
    gzip -9f "${pkgdir}/usr/share/man/man1/ghops.1"

    install -Dm644 completions/ghops.bash "${pkgdir}/usr/share/bash-completion/completions/ghops"
    install -Dm644 completions/ghops.zsh "${pkgdir}/usr/share/zsh/site-functions/_ghops"
}
