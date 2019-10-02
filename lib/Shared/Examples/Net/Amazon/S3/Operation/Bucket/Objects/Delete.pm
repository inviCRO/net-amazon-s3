package Shared::Examples::Net::Amazon::S3::Operation::Bucket::Objects::Delete;
# ABSTRACT: used for testing and as example

use strict;
use warnings;

use parent qw[ Exporter::Tiny ];

our @EXPORT_OK = (
    qw[ fixture_response_quiet_without_errors ],
);

sub fixture_response_quiet_without_errors {
    with_response_data => <<'EOXML';
<?xml version="1.0" encoding="UTF-8"?>
<DeleteResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
</DeleteResult>
EOXML
}

1;

