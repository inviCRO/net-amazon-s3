package Net::Amazon::S3::Request::Role::HTTP::Method::DELETE;
# ABSTRACT: HTTP DELETE method role

use Moose::Role;

with 'Net::Amazon::S3::Request::Role::HTTP::Method' => { method => 'DELETE' };

1;

