#!/usr/bin/perl

# This script loops through a specified file that is populated with domain names and checks if the domains are still in use
# The output will be written in a new file (domains-existing.txt)
# author: https://github.com/bibz0r/
# original by: Josh Skidmore <josh@vorcado.com>

# Requirements
        use Net::DNS;

# Variables
        %VAR    =       (
                                        db => './domains.txt',
                                );

# Open file
        open (DB,$VAR{'db'});
        my (@domains) = <DB>;
        close (DB);

# Test domains
        foreach my $domain (@domains)
                {
                        chomp($domain);

                        my ($available) = &check_domain(domain => $domain);

                        if ($available)
                                {
                                        my $filename = 'domains-existing.txt';
                                        open(my $fh, '>>',  $filename);
                                        print $fh "$domain\n";
                                }
                }

sub check_domain {
        # Variables
                my (%DATA) = @_ ;
                my ($available) = 0;

        # Start Net::DNS
                my $res = Net::DNS::Resolver->new;
                $res->udp_timeout(2);
                $res->tcp_timeout(2);

                my ($domain) = $res->search($DATA{'domain'});

                if ($domain)
                        {
                                ($available) = 1;
                        }

        # Output
                return ($available);
}
