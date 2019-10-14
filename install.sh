#!/bin/sh

rsync -vaP lib/Net/Amazon/S3* /opt/invicro/lib/perl5/site_perl/5.16.2/Net/Amazon/
cd /opt/invicro
git add lib/perl5/site_perl/5.16.2/Net/Amazon/S3/
git commit -v -m "Updated from upstream"
git push
