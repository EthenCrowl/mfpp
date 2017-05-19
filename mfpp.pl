use Text::Balanced qw/extract_multiple extract_bracketed/;

 LINE: while (<>) {
     s/if\s*(\(.+?\))\s*</<if\1/g;

     s/else\s*</<else/g;

     $file_clean = "${file_clean}$_";
}
push @bracketed, extract_multiple(
    $file_clean,
    [ sub{extract_bracketed($_[0], '<>')},],
    undef,
    1
    );
$fileno = 0;
for my $i (0 .. $#bracketed) {
    $_ = $bracketed[$i];
    push @bracketed_orig, $_;
    if(/<if/) {
	open(my $CURFILE, ">${ARGV}.0.mcfunction");
        /<if\((.+?)\)(.+)>/s;
	$if_sel = $1;
	print $CURFILE $2;
	close(CURFILE);
	$bracketed[$i] =~ s!<if\s*\(\s*(\w+|@\w\[.*?\])\s*\)\n?(.+?)>!/function mfpp:${ARGV}.${fileno} if \1!s;
	$fileno++;
    }
    elsif (/<else/) {
	open(my $CURFILE, ">${ARGV}.0.mcfunction");
        /else(.+)>/s;
	print $CURFILE $1;
	close(CURFILE);
	$bracketed[$i] =~ s!<else\s*(.+)>!/function mfpp:${ARGV}.${fileno} unless ${if_sel}!m;
	$fileno++;
    }
}
$file_changed = $file_clean;
for my $i (0 .. $#bracketed) {
    $file_changed =~ s/\Q${bracketed_orig[$i]}/${bracketed[$i]}/;
}
open(my $OFILE, ">${ARGV}.mcfunction");
print $OFILE $file_changed;
