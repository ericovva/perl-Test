package Mod;
use strict;
use warnings;
use Mouse;

use DBI;
use List::Util qw(shuffle);
use POSIX qw(strftime);

has 'connect_str' => (is => 'ro', isa => 'Str');
has 'user'        => (is => 'ro', isa => 'Str');
has 'password'    => (is => 'ro', isa => 'Str');
has 'dbh'         => (is => 'rw', isa => 'Any', builder => '_connect');

sub _connect {
    my $self = shift;
    $self->dbh(DBI->connect($self->connect_str, $self->user, $self->password));
}

sub create_rows {
    my ($self, $count) = @_;
    my @alphabet  = ('A'..'Z');
    my $step = int($count / 3000 ) || 1;
    my $rows = [];
    my $i = 0;
    my $dbh = $self->dbh;
    for (1..$count) {
        my @rand;
        push @rand, int(rand(10)) for 1..12;
        my $name = join '', map { my $n = ($_ * int(int(rand(3))) + int(rand(8))); int(rand(2)) ? lc $alphabet[$n] : $alphabet[$n] } shuffle(@rand);
        pop @rand;
        my $phone = join '', @rand;
        my $now = strftime "%Y-%m-%d %H:%M:%S", localtime;
        push @$rows, "( '$name', '$phone', '$now' )";
        if (++$i == $step ) {
            my $values = join ', ', @$rows;
            $dbh->do("INSERT INTO telephones (name, phone, created) VALUES $values");
            $i = 0; $rows = [];
        }
    }
}

sub _make_query {
    my ($self, $query, @params) = @_;
    my $sth = $self->dbh->prepare($query);
    $sth->execute(@params);
    my $res = []; my @row;
    push @$res, [@row] while(@row = $sth->fetchrow_array());
    return $res;
}

sub get_items {
    my ($self, $limit, $offset) = @_;
    $limit||= 100;
    $offset||=0;
    return $self->_make_query('SELECT * FROM telephones limit ? offset ?', $limit, $offset);
}

sub select_by_phone {
    my ($self, $phone)  = @_;
    return [] unless $phone;
    return $self->_make_query('SELECT * FROM telephones WHERE phone = ?', $phone);
}
1;   
