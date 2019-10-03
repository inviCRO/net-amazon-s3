package Net::Amazon::S3::Request::Restore;

use Moose 0.85;
use MooseX::StrictConstructor 0.16;
extends 'Net::Amazon::S3::Request::Object';

with 'Net::Amazon::S3::Request::Role::HTTP::Method::POST';

# ABSTRACT: An internal class to set an object's access control

has 'days'      => ( is => 'ro', isa => 'Int', required => 0, default => 14 );
has 'tier'      => ( is => 'ro', isa => 'Str', required => 0, default => 'Standard' );

__PACKAGE__->meta->make_immutable;

sub http_request {
    my $self = shift;

    my $days = $self->days || 14;
    my $tier = $self->tier || 'Standard';
    my $xml = <<_;
<RestoreRequest xmlns="http://s3.amazonaws.com/doc/2006-3-01">
   <Days>$days</Days>
    <GlacierJobParameters>
        <Tier>$tier</Tier>
    </GlacierJobParameters> 
</RestoreRequest> 
_

    return $self->_build_http_request(
        path    => $self->_request_path . '?restore',
        content => $xml,
    );
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

