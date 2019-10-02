package Net::Amazon::S3::Request::GetBucketAccessControl;

use Moose 0.85;
use MooseX::StrictConstructor 0.16;
extends 'Net::Amazon::S3::Request::Bucket';

# ABSTRACT: An internal class to get a bucket's access control

with 'Net::Amazon::S3::Request::Role::Query::Action::Acl';
with 'Net::Amazon::S3::Request::Role::HTTP::Method::GET';

__PACKAGE__->meta->make_immutable;

1;

__END__

=for test_synopsis
no strict 'vars'

=head1 SYNOPSIS

  my $http_request = Net::Amazon::S3::Request::GetBucketAccessControl->new(
    s3     => $s3,
    bucket => $bucket,
  )->http_request;

=head1 DESCRIPTION

This module gets a bucket's access control.

=head1 METHODS

=head2 http_request

This method returns a HTTP::Request object.

