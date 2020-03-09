GPFSDIR=$(shell dirname $(shell which mmlscluster))
CURDIR=$(shell pwd)
LOCLDIR=/usr/local/bin

install: acls

update: acls

acls:   .FORCE
	cp -fp $(CURDIR)/acls $(LOCLDIR)/acls

clean:
	rm -f $(LOCLDIR)/acls

.FORCE:


