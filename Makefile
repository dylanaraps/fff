PREFIX = /usr/local
MANPREFIX = $(PREFIX)/share/man

install:
	@mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp fff $(DESTDIR)$(PREFIX)/bin/fff
	@mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	cp fff.1 $(DESTDIR)$(MANPREFIX)/man1/fff.1

uninstall:
	rm $(DESTDIR)$(PREFIX)/bin/fff
	rm $(DESTDIR)$(MANPREFIX)/man1/fff.1
