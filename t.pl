#!/usr/bin/perl
use 5.010;
use strict;
use warnings;
no warnings qw( once qw );

use URI;
use XML::LibXML;
use Web::Scraper::LibXML;
use XML::Atom::SimpleFeed;

use constant SOURCE_URI => 'http://slackware.com/';

sub trim($) { my $_ = shift; s!\A\s+!!; s!\s+\z!!; $_ }

my $p = XML::LibXML->new;

my $posts = scraper {
	process 'center > table[width="100%"]', 'posts[]' => scraper {
		process 'table[cellpadding="14"] td[bgcolor="#fefefe"]', body => sub {
			my $c = $_->as_XML;
			$c =~ s/&#13;/ /g;
			$c =~ s/\s+/ /g;
			$c = $p->parse_string( trim $c );
			trim join '', map $_->toString, $c->documentElement->childNodes;
		};
		process 'td > b', title => 'TEXT';
		process 'td > center > font[size="-1"] > b', date => 'TEXT';
	};
};

my $res = $posts->scrape( URI->new( SOURCE_URI ) );

my $f = XML::Atom::SimpleFeed->new(
	title  => 'Slackware.com',
	id     => 'urn:uuid:ce386280-61e7-11da-9fcb-dd680b0526e0',
	icon   => 'http://www.slackware.com/favicon.ico',
	link   => SOURCE_URI,
	author => 'The Slackware Team',
);

$f->add_entry(
	title     => trim $_->{title},
	content   => trim $_->{body},
	id        => 'tag:plasmasturm.org,2005:Slackware-News-' . trim $_->{date},
	updated   => trim( $_->{date} ) . 'T12:00:00Z',
) for @{ $res->{posts} };

$f->print;
