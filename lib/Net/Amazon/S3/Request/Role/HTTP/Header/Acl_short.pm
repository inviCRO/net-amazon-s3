package Net::Amazon::S3::Request::Role::HTTP::Header::Acl_short;
# ABSTRACT: x-amz-acl header role

use Moose::Role;

with 'Net::Amazon::S3::Request::Role::HTTP::Header' => {
    name => 'acl_short',
    header => 'x-amz-acl',
    isa => 'Maybe[AclShort]',
    required => 0,
};

1;
