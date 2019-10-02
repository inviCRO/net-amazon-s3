package Net::Amazon::S3::Request::Role::Query::Action::Delete;
# ABSTRACT: delete query action role

use Moose::Role;

with 'Net::Amazon::S3::Request::Role::Query::Action' => { action => 'delete' };

1;

