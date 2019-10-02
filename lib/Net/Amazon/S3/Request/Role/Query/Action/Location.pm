package Net::Amazon::S3::Request::Role::Query::Action::Location;
# ABSTRACT: location query action role

use Moose::Role;

with 'Net::Amazon::S3::Request::Role::Query::Action' => { action => 'location' };

1;

