#!/bin/bash
set -euo pipefail

VERSION="1.0.0"
AUR_REPO="ssh://aur@aur.archlinux.org/ghops.git"
PPA="ppa:danukaji/ghops"
GITHUB_REPO="git@github.com:danukaji/ghops.git"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

msg()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; exit 1; }
header() { echo -e "\n${CYAN}${BOLD}══ $1 ══${NC}\n"; }

usage() {
    cat <<EOF
Usage: ./scripts/publish.sh [target]

Targets:
  all          Publish to GitHub, AUR, and APT/PPA
  github       Push source to GitHub and create release tag
  aur          Push PKGBUILD to AUR
  apt          Build & upload .deb to Launchpad PPA
  deb-src      Build source package only (for manual upload)
EOF
    exit 0
}

check_deps() {
    local deps=("git" "gh" "makepkg" "dpkg-buildpackage" "dput" "debuild")
    for d in "${deps[@]}"; do
        if ! command -v "$d" &>/dev/null; then
            warn "$d not found (optional - skipped)"
        fi
    done
}

publish_github() {
    header "GitHub"

    if ! git rev-parse --git-dir &>/dev/null; then
        git init && git remote add origin "$GITHUB_REPO"
    fi
    if ! git remote get-url origin &>/dev/null; then
        git remote add origin "$GITHUB_REPO"
    fi

    git add -A
    git commit -m "ghops v${VERSION}" 2>/dev/null || warn "Nothing to commit"
    git tag -f "v${VERSION}"

    git push -f origin master --tags
    msg "Pushed to GitHub"

    gh release create "v${VERSION}" \
        --title "ghops v${VERSION}" \
        --notes "See LICENSE for details." \
        bin/ghops 2>/dev/null || warn "GitHub release skipped (gh not auth'd)"
    msg "GitHub release created"
}

publish_aur() {
    header "AUR"

    local tmpdir
    tmpdir=$(mktemp -d)
    trap 'rm -rf "$tmpdir"' RETURN

    git clone "$AUR_REPO" "$tmpdir/ghops-aur" 2>/dev/null || {
        mkdir -p "$tmpdir/ghops-aur"
        cd "$tmpdir/ghops-aur"
        git init
        git remote add origin "$AUR_REPO"
    }

    cp PKGBUILD .SRCINFO ghops.install "$tmpdir/ghops-aur/"

    cd "$tmpdir/ghops-aur"
    if [[ -z "$(git log --oneline 2>/dev/null)" ]]; then
        git add -A
        git commit -m "Initial release v${VERSION}"
    else
        git add -A
        git commit -m "Update to v${VERSION}"
    fi
    git push origin master
    msg "Pushed to AUR"
}

publish_apt() {
    header "APT / Launchpad PPA"

    local tmpdir
    tmpdir=$(mktemp -d)
    trap 'rm -rf "$tmpdir"' RETURN

    cp -r . "$tmpdir/ghops-${VERSION}"
    cd "$tmpdir/ghops-${VERSION}"

    # debian/changelog must have exact version
    sed -i "1s/.*/ghops (${VERSION}-1) unstable; urgency=medium/" debian/changelog

    # Build source package
    dpkg-buildpackage -S -sa 2>&1 | tail -5

    # Upload to PPA
    cd ..
    dput "$PPA" "ghops_${VERSION}-1_source.changes"
    msg "Uploaded to Launchpad PPA: $PPA"
}

publish_deb_src() {
    header "Debian source package (manual)"

    local outdir="${1:-../build}"
    mkdir -p "$outdir"

    cp -r . "$outdir/ghops-${VERSION}"
    cd "$outdir/ghops-${VERSION}"

    sed -i "1s/.*/ghops (${VERSION}-1) unstable; urgency=medium/" debian/changelog

    dpkg-buildpackage -S -us -uc
    msg "Source package built in $outdir"
}

TARGET="${1:-all}"
case "$TARGET" in
    all)     publish_github; publish_aur; publish_apt ;;
    github)  publish_github ;;
    aur)     publish_aur ;;
    apt)     publish_apt ;;
    deb-src) publish_deb_src "${2:-}" ;;
    -h|--help) usage ;;
    *)       err "Unknown target: $TARGET"; usage ;;
esac

header "Done"
msg "ghops v${VERSION} published successfully!"
