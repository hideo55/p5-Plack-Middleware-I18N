package Plack::Middleware::Static::I18N;

use strict;
use warnings;
use parent qw(Plack::Middleware::Static);
use I18N::AcceptLanguage;

use Plack::Util::Accessor qw(accept_lang_handler supported_language default_language);

our $VERSION = '0.01';

sub prepare_app {
    my $self = shift;

    my $supported = $self->supported_language;
    if ( !defined $supported ) {
        $supported = [];
    }
    elsif ( ( ref($supported) || q{} ) ne 'ARRAY' ) {
        die "";
    }
    
    my $options = {};
    $options->{defaultLanguage} = $self->default_language if $self->default_language;

    $self->accept_lang_handler( I18N::AcceptLanguage->new($options) );

}

sub call {
    my $self = shift;
    my $env  = shift;

    my $accept_language = $env->{'HTTP_ACCEPT_LANGUAGE'} || 'en';
    my $accept = $self->accept_lang_handler->accepts($accept_language, $self->supported_language);

    {
        my $path_info = $env->{PATH_INFO};

        $path_info =~ s/\.(.+)$/.$accept.$1/;

        local $env->{PATH_INFO} = $path_info;

        my $res = $self->_handle_static($env);

        if ( $res && !( $self->pass_through && $res->[0] == 404 ) ) {
            return $res;
        }
    }
    
    my $res = $self->_handle_static($env);

    if ( $res && !( $self->pass_through && $res->[0] == 404 ) ) {
        return $res;
    }

    return $self->app($env);

}

1;
__END__

=head1 NAME

Plack::Middleware::Static::I18N -

=head1 SYNOPSIS

  use Plack::Builder;
  
  builder{
  	enable 'Static::I18N', 
  		path => qr{^/(image|html)}, root => '/path/to/static', 
  		supported_language => [qw(en fr)];
  	sub{
  		...
  	};
  }

=head1 DESCRIPTION

Plack::Middleware::Static::I18N is

=head1 AUTHOR

Hideaki Ohno E<lt>hide_o_j55@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
