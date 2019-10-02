package Shared::Examples::Net::Amazon::S3::Request;
# ABSTRACT: used for testing and as example

use strict;
use warnings;

use parent qw[ Exporter::Tiny ];

use Test::More;
use Test::Deep;

use Moose qw[];
use Moose::Object;
use Moose::Util;
use XML::LibXML;

use Net::Amazon::S3;
use Net::Amazon::S3::Bucket;

our @EXPORT_OK = (
    qw[ behaves_like_net_amazon_s3_request ],
    qw[ expect_request_class ],
    qw[ expect_request_instance ],
);

sub _canonical_xml {
    my ($xml) = @_;

    return $xml unless $xml;
    return $xml if ref $xml;

    my $canonical = eval {
        XML::LibXML->load_xml (
            string => $xml,
            no_blanks => 1,
        )->toStringC14N
    };

    return $xml unless defined $canonical;
    return $canonical;
}

sub _test_meta_build_http_request {
    my ($self, %params) = @_;

    return $self->_build_signed_request (%params);
}

sub _test_class {
    my ($request_class, %params) = @_;

    $params{superclasses} ||= [];
    $params{methods}{_build_http_request} = \& _test_meta_build_http_request;

    push @{ $params{superclasses} }, $request_class;

    return Moose::Meta::Class->create_anon_class (%params);
}

sub expect_request_class {
    my ($request_class) = @_;

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    return use_ok $request_class;
}

sub expect_request_instance {
    my (%params) = @_;

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my %with = map +( substr ($_, 5) => delete $params{$_} ),
        grep m/^with_/,
        keys %params
        ;

    $with{s3} = bless {}, 'Net::Amazon::S3';

    my $test_class = _test_class $params{request_class},
        map +( $_ => $params{$_} ),
        grep exists $params{$_},
        qw [ roles ],
        ;

    my $request = eval { $test_class->name->new (%with) };
    my $error = $@;

    if (exists $params{throws}) {
        if (defined $request) {
            fail "create instance should fail";
        } else {
            cmp_deeply $error, $params{throws}, "create instance should fail";
        }
    } else {
        ok defined $request, "should create (mocked) instance of $params{request_class}"
            or diag $error;
    }

    return $request;
}

sub expect_request_path {
    my ($request, $expected) = @_;

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    return cmp_deeply
        $request->http_request->path,
        $expected,
        "it builds expected request path"
        ;
}

sub expect_request_method {
    my ($request, $expected) = @_;

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    return cmp_deeply
        $request->http_request->method,
        $expected,
        "it builds expected request method"
        ;
}

sub expect_request_headers {
    my ($request, $expected) = @_;

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    return cmp_deeply
        $request->http_request->headers,
        $expected,
        "it builds expected request headers"
        ;
}

sub expect_request_content {
    my ($request, $expected) = @_;

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    # XML builders doesn't need to produce whitespaces for readability
    # wherease test expectation should be as readable as possible
    # compare canonicalized xml strings than

    return is
        _canonical_xml ($request->http_request->content),
        _canonical_xml ($expected),
        "it builds expected request XML content"
        ;
}

sub behaves_like_net_amazon_s3_request {
    my ($title, %params) = @_;

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    subtest $title => sub {
        plan tests => 2 + scalar grep exists $params{$_},
            qw[ expect_request_path ],
            qw[ expect_request_method ],
            qw[ expect_request_headers ],
            qw[ expect_request_content ],
            ;

        expect_request_class $params{request_class};
        my $request = expect_request_instance %params;

        expect_request_path $request => $params{expect_request_path}
            if exists  $params{expect_request_path};

        expect_request_method $request => $params{expect_request_method}
            if exists  $params{expect_request_method};

        expect_request_headers $request => $params{expect_request_headers}
            if exists  $params{expect_request_headers};

        expect_request_content $request => $params{expect_request_content}
            if exists  $params{expect_request_content};
    };
}

1;
