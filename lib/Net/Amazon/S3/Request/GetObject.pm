package Net::Amazon::S3::Request::GetObject;

use Moose 0.85;
use MooseX::StrictConstructor 0.16;
extends 'Net::Amazon::S3::Request::Object';

with 'Net::Amazon::S3::Request::Role::HTTP::Method';

# ABSTRACT: An internal class to get an object

__PACKAGE__->meta->make_immutable;

sub query_string_authentication_uri {
    my ( $self, $expires, $query_form ) = @_;

    my $uri = URI->new( $self->_request_path );
    $uri->query_form( %$query_form ) if $query_form;

    return $self->_build_signed_request(
        path   => $uri->as_string,
    )->query_string_authentication_uri($expires);
}

1;

__END__

=for test_synopsis
no strict 'vars'

=head1 SYNOPSIS

  my $http_request = Net::Amazon::S3::Request::GetObject->new(
    s3     => $s3,
    bucket => $bucket,
    key    => $key,
    method => 'GET',
  )->http_request;

=head1 DESCRIPTION

This module gets an object.

=head1 METHODS

=head2 http_request

This method returns a HTTP::Request object.

=head2 query_string_authentication_uri

This method returns query string authentication URI.
