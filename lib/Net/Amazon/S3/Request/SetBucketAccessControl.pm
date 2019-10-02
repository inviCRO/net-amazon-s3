package Net::Amazon::S3::Request::SetBucketAccessControl;

use Moose 0.85;
use MooseX::StrictConstructor 0.16;
extends 'Net::Amazon::S3::Request::Bucket';

# ABSTRACT: An internal class to set a bucket's access control

with 'Net::Amazon::S3::Request::Role::HTTP::Header::Acl_short';

has 'acl_xml'   => ( is => 'ro', isa => 'Maybe[Str]',      required => 0 );

with 'Net::Amazon::S3::Request::Role::Query::Action::Acl';
with 'Net::Amazon::S3::Request::Role::HTTP::Method::PUT';

__PACKAGE__->meta->make_immutable;

sub _request_content {
    my ($self) = @_;

    return $self->acl_xml || '';
}

sub BUILD {
    my ($self) = @_;

    unless ( $self->acl_xml || $self->acl_short ) {
        confess "need either acl_xml or acl_short";
    }

    if ( $self->acl_xml && $self->acl_short ) {
        confess "can not provide both acl_xml and acl_short";
    }
}

1;

__END__

=for test_synopsis
no strict 'vars'

=head1 SYNOPSIS

  my $http_request = Net::Amazon::S3::Request::SetBucketAccessControl->new(
    s3        => $s3,
    bucket    => $bucket,
    acl_short => $acl_short,
    acl_xml   => $acl_xml,
  )->http_request;

=head1 DESCRIPTION

This module sets a bucket's access control.

=head1 METHODS

=head2 http_request

This method returns a HTTP::Request object.

