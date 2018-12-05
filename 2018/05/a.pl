#!/usr/bin/perl -pl
$r=join"|",map{$_.uc$_,(uc$_).$_}a..z;while(s/$r//go){}$_=y///c
