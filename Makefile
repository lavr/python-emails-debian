#!/usr/bin/make -f

.PHONY: deb upload

DPKGSIG_KEYID=B47640B7
export DPKGSIG_KEYID
EMAILS_VERSION=0.1.10

deb:
	# don't forget to apt-get install debhelper python-support build-essential checkinstall devscripts
	set -e
	rm -rf python-emails-* emails-* python-emails_*
	curl -O https://pypi.python.org/packages/source/e/emails/emails-${EMAILS_VERSION}.tar.gz
	tar -xzf emails-${EMAILS_VERSION}.tar.gz
	mv emails-${EMAILS_VERSION} python-emails-${EMAILS_VERSION}
	dch -M -b -v ${EMAILS_VERSION} --package python-emails
	cp -r debian python-emails-${EMAILS_VERSION}
	cd python-emails-${EMAILS_VERSION} && dpkg-buildpackage -S -rfakeroot
	#cd python-emails && dpkg-buildpackage -rfakeroot -uc -us
	# now upload python-emails_${EMAILS_VERSION}-1_all.deb to PPA

upload:
	set -e
	dput ppa:lavrme/python-emails-ppa python-emails_${EMAILS_VERSION}-1_source.changes 
	
clean:
	set -e
	rm -rf python-emails-* emails-* python-emails_*
	
