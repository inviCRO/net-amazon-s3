package Net::Amazon::S3::Request::Role::HTTP::Header::Copy_source;
# ABSTRACT: x-amz-copy-source header role

use Moose::Role;

with 'Net::Amazon::S3::Request::Role::HTTP::Header' => {
    name => '_copy_source',
    header => 'x-amz-copy-source',
    isa => 'Maybe[Str]',
    required => 0,
    default => sub {
        my ($self) = @_;
        defined $self->copy_source_bucket && defined $self->copy_source_key
            ? $self->copy_source_bucket.'/'.$self->copy_source_key
            : undef;
    },
};

has 'copy_source_bucket'    => ( is => 'ro', isa => 'Str',     required => 0 );
has 'copy_source_key'       => ( is => 'ro', isa => 'Str',     required => 0 );

1;

