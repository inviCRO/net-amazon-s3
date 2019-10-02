package Net::Amazon::S3::Request::Role::Query::Action::Acl;
# ABSTRACT: acl query action role

use Moose::Role;

with 'Net::Amazon::S3::Request::Role::Query::Action' => { action => 'acl' };

1;

