package Net::Amazon::S3::Request::Service;
# ABSTRACT: Base class for all S3 Service operations

use Moose 0.85;
use MooseX::StrictConstructor 0.16;
extends 'Net::Amazon::S3::Request';

__PACKAGE__->meta->make_immutable;

1;

