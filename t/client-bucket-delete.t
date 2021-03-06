
use strict;
use warnings;

use Test::More tests => 1 + 4;
use Test::Deep;
use Test::Warnings;

use Shared::Examples::Net::Amazon::S3::Client (
    qw[ expect_client_bucket_delete ],
);

use Shared::Examples::Net::Amazon::S3::Error (
    qw[ fixture_error_access_denied ],
    qw[ fixture_error_bucket_not_empty ],
    qw[ fixture_error_no_such_bucket ],
);

expect_client_bucket_delete 'delete bucket' => (
    with_bucket             => 'some-bucket',
    expect_request          => { DELETE => 'https://some-bucket.s3.amazonaws.com/' },
    expect_data             => bool (1),
);

expect_client_bucket_delete 'error access denied' => (
    with_bucket             => 'some-bucket',
    fixture_error_access_denied,
    expect_request          => { DELETE => 'https://some-bucket.s3.amazonaws.com/' },
    expect_request_content  => '',
    throws                  => qr/^AccessDenied: Access denied error message/,
);

expect_client_bucket_delete 'error bucket not empty' => (
    with_bucket             => 'some-bucket',
    fixture_error_bucket_not_empty,
    expect_request          => { DELETE => 'https://some-bucket.s3.amazonaws.com/' },
    expect_request_content  => '',
    throws                  => qr/^BucketNotEmpty: Bucket not empty error message/,
);

expect_client_bucket_delete 'error no such bucket' => (
    with_bucket             => 'some-bucket',
    fixture_error_no_such_bucket,
    expect_request          => { DELETE => 'https://some-bucket.s3.amazonaws.com/' },
    expect_request_content  => '',
    throws                  => qr/^NoSuchBucket: No such bucket error message/,
);

