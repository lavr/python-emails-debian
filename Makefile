#!/usr/bin/make -f

.PHONY: deb upload

#DPKGSIG_KEYID=B47640B7
#export DPKGSIG_KEYID
EMAILS_VERSION=0.1.10


usage:
	echo "Usage: make clean|deb|deb3|upload"

test:
	set -e
	for D in lucid pecise raring; do \
		echo $$D;\
	done

deb:
	# don't forget to apt-get install debhelper python-support build-essential checkinstall devscripts
	set -e
	rm -rf python-emails-${EMAILS_VERSION}* emails-${EMAILS_VERSION}*
	curl -O https://pypi.python.org/packages/source/e/emails/emails-${EMAILS_VERSION}.tar.gz
	tar xzf emails-${EMAILS_VERSION}.tar.gz
	mv emails-${EMAILS_VERSION} python3-emails-${EMAILS_VERSION}
	# oneiric - obsolete on launchpad
	# maverick - obsolte
	# natty - obsolete
	for D in lucid precise quantal raring saucy; do \
		cd python2; \
                dch -M -b -v ${EMAILS_VERSION}-ppa1~$$D --distribution $$D --package python-emails || exit 1 \
		cd ..; \
		cp -r python2/debian python-emails-${EMAILS_VERSION}; \
		cd python-emails-${EMAILS_VERSION}; \
		dpkg-buildpackage -S -rfakeroot -kB47640B7; \
		cd ..; \
	done
	# now do: make upload

deb3:
	set -e
	rm -rf python3-emails-${EMAILS_VERSION}* emails-${EMAILS_VERSION}*
	curl -O https://pypi.python.org/packages/source/e/emails/emails-${EMAILS_VERSION}.tar.gz
	tar xzf emails-${EMAILS_VERSION}.tar.gz
	mv emails-${EMAILS_VERSION} python3-emails-${EMAILS_VERSION}
	for D in saucy; do \
		cd python3; \
                dch -M -b -v ${EMAILS_VERSION}-ppa1~$$D --distribution $$D --package python3-emails || exit 1 \
		echo "Current dir is", `pwd` ;\
		cd ..; \
		echo "Current dir is", `pwd` ;\
                cp -r python3/debian python3-emails-${EMAILS_VERSION}; \
                cd python3-emails-${EMAILS_VERSION}; \
                dpkg-buildpackage -S -rfakeroot -kB47640B7; \
                cd ..; \
	done
	# now do: make upload

upload:
	set -e
	for name in `dir *.changes`; do \
		echo $$name; \
		dput ppa:lavrme/python-emails-ppa $$name; \
	done
	#dput ppa:lavrme/python-emails-ppa python-emails_${EMAILS_VERSION}-1_source.changes 
	
clean:
	set -e
	rm -rf python-emails-* emails-* python-emails_*
	
