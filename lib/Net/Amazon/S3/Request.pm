package Net::Amazon::S3::Request;

use Moose 0.85;
use MooseX::StrictConstructor 0.16;
use Moose::Util::TypeConstraints;
use Regexp::Common qw /net/;

# ABSTRACT: Base class for request objects

enum 'AclShort' =>
    [ qw(private public-read public-read-write authenticated-read) ];
enum 'LocationConstraint' => [
    # https://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region
    'ap-northeast-1',
    'ap-northeast-2',
    'ap-northeast-3',
    'ap-south-1',
    'ap-southeast-1',
    'ap-southeast-2',
    'ca-central-1',
    'cn-north-1',
    'cn-northwest-1',
    'eu-central-1',
    'eu-north-1',
    'eu-west-1',
    'eu-west-2',
    'eu-west-3',
    'sa-east-1',
    'us-east-1',
    'us-east-2',
    'us-west-1',
    'us-west-2',
];

subtype 'MaybeLocationConstraint'
    => as 'Maybe[LocationConstraint]'
    ;

# maintain backward compatiblity with 'US' and 'EU' values
my %location_constraint_alias = (
    US => 'us-east-1',
    EU => 'eu-west-1',
);

enum 'LocationConstraintAlias' => [ keys %location_constraint_alias ];

coerce 'LocationConstraint'
    => from 'LocationConstraintAlias'
    => via { $location_constraint_alias{$_} }
    ;

coerce 'MaybeLocationConstraint'
    => from 'LocationConstraintAlias'
    => via { $location_constraint_alias{$_} }
    ;

# To comply with Amazon S3 requirements, bucket names must:
# Contain lowercase letters, numbers, periods (.), underscores (_), and dashes (-)
# Start with a number or letter
# Be between 3 and 255 characters long
# Not be in an IP address style (e.g., "192.168.5.4")

subtype 'BucketName1' => as 'Str' => where {
    $_ =~ /^[a-zA-Z0-9._-]+$/;
} => message {
    "Bucket name ($_) must contain lowercase letters, numbers, periods (.), underscores (_), and dashes (-)";
};

subtype 'BucketName2' => as 'BucketName1' => where {
    $_ =~ /^[a-zA-Z0-9]/;
} => message {
    "Bucket name ($_) must start with a number or letter";
};

subtype 'BucketName3' => as 'BucketName2' => where {
    length($_) >= 3 && length($_) <= 255;
} => message {
    "Bucket name ($_) must be between 3 and 255 characters long";
};

subtype 'BucketName' => as 'BucketName3' => where {
    $_ !~ /^$RE{net}{IPv4}$/;
} => message {
    "Bucket name ($_) must not be in an IP address style (e.g., '192.168.5.4')";
};

has 's3' => ( is => 'ro', isa => 'Net::Amazon::S3', required => 1 );

has '_http_request_content' => (
    is => 'ro',
    init_arg => undef,
    isa => 'Maybe[Str]',
    lazy => 1,
    builder => '_request_content',
);

__PACKAGE__->meta->make_immutable;

sub _request_content {
    '';
}

sub _request_path {
    '';
}

sub _request_headers {
}

sub _request_query_action {
}

sub _request_query_params {
}

sub _request_query_string {
    my ($self) = @_;

    my %query_params = $self->_request_query_params;

    my @parts = (
        ($self->_request_query_action) x!! $self->_request_query_action,
        map "$_=${\ $self->s3->_urlencode( $query_params{$_} ) }", sort keys %query_params,
    );

    return '' unless @parts;
    return '?' . join '&', @parts;
}

sub _http_request_path {
    my ($self) = @_;

    return $self->_request_path . $self->_request_query_string;
}

sub _http_request_headers {
    my ($self) = @_;

    return +{ $self->_request_headers };
}

sub _build_signed_request {
    my ($self, %params) = @_;

    $params{path}       = $self->_http_request_path     unless exists $params{path};
    $params{method}     = $self->_http_request_method   unless exists $params{method};
    $params{headers}    = $self->_http_request_headers  unless exists $params{headers};
    $params{content}    = $self->_http_request_content  unless exists $params{content} or ! defined $self->_http_request_content;

    # Although Amazon's Signature 4 test suite explicitely handles // it appears
    # it's inconsistent with their implementation so removing it here
    $params{path} =~ s{//+}{/}g;

    return Net::Amazon::S3::HTTPRequest->new(
        %params,
        s3 => $self->s3,
        $self->can( 'bucket' ) ? (bucket => $self->bucket) : (),
    );
}

sub _build_http_request {
    my ($self, %params) = @_;

    return $self->_build_signed_request( %params )->http_request;
}

sub http_request {
    my $self = shift;

    return $self->_build_http_request;
}

1;

__END__

=head1 SYNOPSIS

  # do not instantiate directly

=head1 DESCRIPTION

This module is a base class for all the Net::Amazon::S3::Request::*
classes.
