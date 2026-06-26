PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
MANDIR ?= $(PREFIX)/share/man/man1
LICENSEDIR ?= $(PREFIX)/share/licenses/ghops
BASHCOMPDIR ?= $(PREFIX)/share/bash-completion/completions
ZSHCOMPDIR ?= $(PREFIX)/share/zsh/site-functions

VERSION := 1.0.0

.PHONY: install uninstall

install:
	install -d "$(DESTDIR)$(BINDIR)"
	install -d "$(DESTDIR)$(MANDIR)"
	install -d "$(DESTDIR)$(LICENSEDIR)"
	install -d "$(DESTDIR)$(BASHCOMPDIR)"
	install -d "$(DESTDIR)$(ZSHCOMPDIR)"

	install -m755 bin/ghops "$(DESTDIR)$(BINDIR)/ghops"
	install -m644 man/man1/ghops.1 "$(DESTDIR)$(MANDIR)/ghops.1"
	gzip -9f "$(DESTDIR)$(MANDIR)/ghops.1"
	install -m644 completions/ghops.bash "$(DESTDIR)$(BASHCOMPDIR)/ghops"
	install -m644 completions/ghops.zsh "$(DESTDIR)$(ZSHCOMPDIR)/_ghops"
	install -m644 LICENSE "$(DESTDIR)$(LICENSEDIR)/LICENSE"

	@echo "ghops v$(VERSION) installed to $(DESTDIR)$(PREFIX)"

uninstall:
	rm -f "$(DESTDIR)$(BINDIR)/ghops"
	rm -f "$(DESTDIR)$(MANDIR)/ghops.1.gz"
	rm -f "$(DESTDIR)$(BASHCOMPDIR)/ghops"
	rm -f "$(DESTDIR)$(ZSHCOMPDIR)/_ghops"
	rm -rf "$(DESTDIR)$(LICENSEDIR)"

	@echo "ghops uninstalled"
