#!/usr/bin/make -f

.PHONY: deb upload

#DPKGSIG_KEYID=B47640B7
#export DPKGSIG_KEYID

EMAILS_VERSION=0.1.11
PPA_VERSION=1

usage:
	echo "Usage: make clean|deb|upload"

deb:
	# don't forget to apt-get install debhelper python-support build-essential checkinstall devscripts
	set -e
	rm -rf emails-${EMAILS_VERSION}*
	curl -O https://pypi.python.org/packages/source/e/emails/emails-${EMAILS_VERSION}.tar.gz || exit 1
	tar xzf emails-${EMAILS_VERSION}.tar.gz
	dch -M -b -v ${EMAILS_VERSION}-ppa${PPA_VERSION}~lucid --distribution lucid --package emails
	cp -r debian emails-${EMAILS_VERSION}
	cd emails-${EMAILS_VERSION}
	exit 1
	debuild -S -kB47640B7
	# now do: make upload

upload:
	set -e
	for name in `dir emails*.changes`; do \
		echo $$name; \
		dput ppa:lavrme/python-emails-ppa $$name; \
	done
	#dput ppa:lavrme/python-emails-ppa python-emails_${EMAILS_VERSION}-1_source.changes 
	
clean:
	set -e
	rm -rf python-emails-* emails-* python-emails_*
	
