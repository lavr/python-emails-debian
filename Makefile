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
	curl -O https://pypi.python.org/packages/source/e/emails/emails-${EMAILS_VERSION}.tar.gz
	tar xzf emails-${EMAILS_VERSION}.tar.gz
	# oneiric - obsolete on launchpad
	# maverick - obsolte
	# natty - obsolete
	# supported: lucid precise quantal raring saucy
	for D in precise quantal saucy; do \
		echo `pwd`; \
                dch -M -b -v ${EMAILS_VERSION}-ppa${PPA_VERSION}~$$D --distribution $$D --package emails; \
		cp -r debian emails-${EMAILS_VERSION}; \
		ls emails-${EMAILS_VERSION}/debian; \
		cd emails-${EMAILS_VERSION}; \
		debuild -S -kB47640B7; \
		cd ..; \
	done
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
	
