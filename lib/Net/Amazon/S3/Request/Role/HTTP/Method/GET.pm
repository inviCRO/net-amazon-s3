package Net::Amazon::S3::Request::Role::HTTP::Method::GET;
# ABSTRACT: HTTP GET method role

use Moose::Role;

with 'Net::Amazon::S3::Request::Role::HTTP::Method' => { method => 'GET' };

1;

