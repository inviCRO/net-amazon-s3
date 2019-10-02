package Shared::Examples::Net::Amazon::S3::Operation::Bucket::Create;
# ABSTRACT: used for testing and as example

use strict;
use warnings;

use parent qw[ Exporter::Tiny ];

our @EXPORT_OK = (
    qw[ create_bucket_in_ca_central_1_content_xml ],
);

sub create_bucket_in_ca_central_1_content_xml {
    <<'EOXML';
<CreateBucketConfiguration>
  <LocationConstraint>ca-central-1</LocationConstraint>
</CreateBucketConfiguration>
EOXML
}

1;
