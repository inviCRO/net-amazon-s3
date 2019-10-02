package Net::Amazon::S3::Request::Role::HTTP::Method::PUT;
# ABSTRACT: HTTP PUT method role

use Moose::Role;

with 'Net::Amazon::S3::Request::Role::HTTP::Method' => { method => 'PUT' };

1;

