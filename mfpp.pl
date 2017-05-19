use Text::Balanced qw/extract_multiple extract_bracketed/;

 LINE: while (<>) {
     s/if\s*(\(.+?\))\s*</<if\1/g;

     s/else\s*</<else/g;

     s/define\s+(\w+)\s*</<define \1/g;

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
    s/<(.+)/\1/m;
    $tmp = $1;
    if(/if/) {
	open(my $CURFILE, ">${ARGV}.0.mcfunction");
        /<if\((.+?)\)(.+)>/s;
	$if_sel = $1;
	print $CURFILE $2;
	close(CURFILE);
	$bracketed[$i] =~ s!<if\s*\(\s*(\w+|@\w\[.*?\])\s*\)\n?(.+?)>!/function mfpp:${ARGV}.${fileno} if \1!s;
	$fileno++;
    }
    elsif (/else/) {
	open(my $CURFILE, ">${ARGV}.0.mcfunction");
        /else(.+)>/s;
	print $CURFILE $1;
	close(CURFILE);
	$bracketed[$i] =~ s!<else\s*(.+)>!/function mfpp:${ARGV}.${fileno} unless ${if_sel}!m;
	$fileno++;
    }
    elsif (/define\s+(\w+)(.+)>/s) {
	$macros{$1} = $2;
	$bracketed[$i] =~ s/.*//s;
    }
    elsif (exists $macros{$1 =~ s/>//nr}) {
	$macro = $tmp =~ s/>//nr;
	print $macro;
	$bracketed[$i] =~ s!<${macro}>!${macros{$macro}}!;
    }
    else {
	my $i = 0;
	my $lineno;
	for my $line (split(/\n/, $file_clean)) {
	    if($line =~ /${1}/) {
		$lineno = $i;
		last;
	    }
	    $i++;
	}
	$baddir = $1 =~ s/(\S+).*/\1/gr;
	$lineno++;
	print "FATAL: Unknown preprocessor directive \"${baddir}\" at file ${ARGV} line ${lineno}\n";
	exit(-1);
    }
}
$file_changed = $file_clean;
for my $i (0 .. $#bracketed) {
    $file_changed =~ s/\Q${bracketed_orig[$i]}/${bracketed[$i]}/;
}
open(my $OFILE, ">${ARGV}.mcfunction");
print $OFILE $file_changed;
