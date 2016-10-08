package Net::Amazon::S3::Request:Restore;

use Moose 0.85;
use MooseX::StrictConstructor 0.16;
extends 'Net::Amazon::S3::Request';

# ABSTRACT: An internal class to set an object's access control

has 'bucket'    => ( is => 'ro', isa => 'BucketName',      required => 1 );
has 'key'       => ( is => 'ro', isa => 'Str',             required => 1 );
has 'days'      => ( is => 'ro', isa => 'Int', required => 0, default => 14 );

__PACKAGE__->meta->make_immutable;

sub http_request {
    my $self = shift;

    my $days = $self->days || 14;
    my $xml = <<_;
<RestoreRequest xmlns="http://s3.amazonaws.com/doc/2006-3-01">
   <Days>$days</Days>
</RestoreRequest> 
_

    return Net::Amazon::S3::HTTPRequest->new(
        s3      => $self->s3,
        method  => 'POST',
        path    => $self->_uri( $self->key ) . '?restore',
        headers => $headers,
        content => $xml,
    )->http_request;
}

1;

__END__

=for test_synopsis
no strict 'vars'

=head1 SYNOPSIS

  my $http_request = Net::Amazon::S3::Request::Restore->new(
    s3        => $s3,
    bucket    => $bucket,
    key       => $key,
    days      => $days,
  )->http_request;

=head1 DESCRIPTION

This module requests a restore of the object from Glacier

=head1 METHODS

=head2 http_request

This method returns a HTTP::Request object.

