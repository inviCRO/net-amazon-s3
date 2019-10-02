package Net::Amazon::S3::Request::Role::Query::Action::Uploads;
# ABSTRACT: uploads query action role

use Moose::Role;

with 'Net::Amazon::S3::Request::Role::Query::Action' => { action => 'uploads' };

1;

