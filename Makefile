PREFIX ?= /usr
MANDIR ?= $(PREFIX)/share/man
DOCDIR ?= $(PREFIX)/share/doc/fff

all:
	@echo Run \'make install\' to install fff.

install:
	@mkdir -p $(DESTDIR)$(PREFIX)/bin
	@mkdir -p $(DESTDIR)$(MANDIR)/man1
	@mkdir -p $(DESTDIR)$(DOCDIR)
	@cp -p fff $(DESTDIR)$(PREFIX)/bin/fff
	@cp -p fff.1 $(DESTDIR)$(MANDIR)/man1
	@cp -p README.md $(DESTDIR)$(DOCDIR)
	@chmod 755 $(DESTDIR)$(PREFIX)/bin/fff

uninstall:
	@rm -rf $(DESTDIR)$(PREFIX)/bin/fff
	@rm -rf $(DESTDIR)$(MANDIR)/man1/fff.1
	@rm -rf $(DESTDIR)$(DOCDIR)
