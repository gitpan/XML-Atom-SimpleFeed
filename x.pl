#!/usr/bin/perl
use 5.010;
use strict;
use utf8;

use XML::Atom::SimpleFeed;

my $feed = XML::Atom::SimpleFeed->new(
	title   => 'Example Feed',
	link    => 'http://example.org/',
	link    => { rel => 'self', href => 'http://example.org/atom' },
	updated => '2003-12-13T18:30:02Z',
	author  => 'John Doe',
	id      => 'urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6',
);

$feed->add_entry(
	title     => 'Atom-Powered Robots Run Amok',
	link      => 'http://example.org/2003/12/13/atom03',
	id        => 'urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a',
	summary   => 'Some text.',
	content   => 'Παράδειγμα ελληνικών χαρακτήρων.',
	updated   => '2003-12-13T18:30:02Z',
	category  => 'Atom',
	category  => 'Miscellaneous',
);

say $feed->as_string;
