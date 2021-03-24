#!/usr/bin/perl
use strict;
use warnings;

my $overwrite = 0;

my $admin_name = "Cotton";

use BibTeX::Parser;
    use IO::File;
 
my $fh     = IO::File->new("all_papers_Feb2021.bibtex");
 
# Create parser object ...
my $parser = BibTeX::Parser->new($fh);
 
my %month_translate = ( "Jan" => "01", "Feb" => "02", "Mar" => "03", "Apr" => "04", "May" => "05", "Jun" => "06", "Jul" => "07", "Aug" => "08", "Sep" => "09", "Oct" => "10", "Nov" => "11", "Dec" => "12" );
# ... and iterate over entries
while (my $entry = $parser->next ) {
        if ($entry->parse_ok) {
                if ( ! -e "content/publication/".$entry->key."/index.md" || $overwrite ) { 
		#print $entry->key;
		#print "___\n";
		my $mkdir_command = "mkdir content/publication/".$entry->key."\n";
		print `$mkdir_command`;
		open(F,">","content/publication/".$entry->key."/index.md") or die("error");
		print F "---\n";
		my $title = $entry->field("title");
		$title =~ s/[\{\}]//g;
		print F "title: \"".$title."\"\n";
		print F "\n";
		print F "authors:\n";
		 my @authors = $entry->author;
                # or:
                #my @editors = $entry->editor;
		foreach my $author (@authors) {
						
		if ($author->last eq $admin_name ) { 
			print F "- admin\n";
		
		} else {		
			my @author_bits;
			push(@author_bits,$author->first);
			if ($author->von) { push(@author_bits,$author->von); }
			push (@author_bits,$author->last);
			if ($author->jr) { push(@author_bits,$author->jr); }
			print F "- ".join(" ",@author_bits)."\n"; 
                }
		}	
		if (!  $entry->field("year") ) { print "no year! for ".$entry->key."\n"; }
		if (! $entry->field("month") ) { print "no month for ".$entry->key."\n"; 
			 print F "\ndate: \"".$entry->field("year")."-01-01T00:00:00Z\"\ndoi: \"\"\n"
		} else {	
			
			if ( exists $month_translate{$entry->field("month")} ) { 
				print F "\ndate: \"".$entry->field("year")."-".$month_translate{$entry->field("month")}."-01T00:00:00Z\"\ndoi: \"\"\n";
  			} else {
				print F "\ndate: \"".$entry->field("year")."-".$entry->field("month")."-01T00:00:00Z\"\ndoi: \"\"\n";
				print ("what is month '".$entry->field("month")."'\n"); 	
			}
		}
			
		
		my $type    = $entry->type;
                if ($type eq "ARTICLE" ) { 
			print F "\npublication_types: [\"2\"]\n";	
		} elsif ($type eq "BOOK" ) { 
			 print F "\npublication_types: [\"5\"]\n";
		} else { print "UKNOWN TYPE ".$type."\n"; } 

		
		if ( $entry->field("Journal") ) { 
			print F "publication: In *".$entry->field("Journal")."* ".$entry->field("Volume");
			if ($entry->field("Pages") ) { 
				print F "\\:".$entry->field("Pages")."\n";
			} else { print F "\n"; }
			print F "#publication_short: In *ICW*\n";
		}
		print "\n";
		if ( $entry->field("Abstract") ) { 
			my $abs = $entry->field("Abstract");
			$abs =~ s|\\{2}||g;
			print F "abstract: >\n";
			print F "  ".$abs."\n";
		}
		
		print F "\ntags: []\n";
		print F "\nfeatured: false\n";
		print F "\n";
		print F "url_pdf: ''\nurl_code: ''\nurl_dataset: ''\nurl_poster: ''\nurl_project: ''\nurl_slides: ''\nurl_source: ''\nurl_video: ''\n";
		print F "\n";
			
		print F "# Featured image\n";
		print F "# To use, add an image named `featured.jpg/png` to your page's folder.\n";
		print F "image:\n";
  		print F "caption: ''\n";
  		print F "focal_point: \"\"\n";
  		print F "preview_only: false\n";
		print F "\n";
		
		print F "projects: []\n";
		print F "#- example woudl ref. project in contents/project/example/index.md\n";	

		print F "\n";
		print F "slides: \"\"\n";
		print F "---\n";
		
		close F;
		} else { 
			print "NO GOING TO OVERWRITE content/publication/".$entry->key."/index.md\n";
		}
        } else {
                warn "Error parsing file: " . $entry->error;
        }
}



=begin comment
---
title: "An example conference paper"

# Authors
# If you created a profile for a user (e.g. the default `admin` user), write the username (folder name) here 
# and it will be replaced with their full name and linked to their profile.
authors:
- admin
- Robert Ford

# Author notes (optional)
author_notes:
- "Equal contribution"
- "Equal contribution"

date: "2013-07-01T00:00:00Z"
doi: ""

# Schedule page publish date (NOT publication's date).
publishDate: "2017-01-01T00:00:00Z"

# Publication type.
# Legend: 0 = Uncategorized; 1 = Conference paper; 2 = Journal article;
# 3 = Preprint / Working Paper; 4 = Report; 5 = Book; 6 = Book section;
# 7 = Thesis; 8 = Patent
publication_types: ["1"]

# Publication name and optional abbreviated publication name.
publication: In *Wowchemy Conference*
publication_short: In *ICW*

abstract: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis posuere tellus ac convallis placerat. Proin tincidunt magna sed ex sollicitudin condimentum. Sed ac faucibus dolor, scelerisque sollicitudin nisi. Cras purus urna, suscipit quis sapien eu, pulvinar tempor diam. Quisque risus orci, mollis id ante sit amet, gravida egestas nisl. Sed ac tempus magna. Proin in dui enim. Donec condimentum, sem id dapibus fringilla, tellus enim condimentum arcu, nec volutpat est felis vel metus. Vestibulum sit amet erat at nulla eleifend gravida.

# Summary. An optional shortened abstract.
summary: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis posuere tellus ac convallis placerat. Proin tincidunt magna sed ex sollicitudin condimentum.

tags: []

# Display this page in the Featured widget?
featured: true

# Custom links (uncomment lines below)
# links:
# - name: Custom Link
#   url: http://example.org

url_pdf: ''
url_code: ''
url_dataset: ''
url_poster: ''
url_project: ''
url_slides: ''
url_source: ''
url_video: ''

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder. 
image:
  caption: 'Image credit: [**Unsplash**](https://unsplash.com/photos/pLCdAaMFLTE)'
  focal_point: ""
  preview_only: false

# Associated Projects (optional).
#   Associate this publication with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `internal-project` references `content/project/internal-project/index.md`.
#   Otherwise, set `projects: []`.
projects:
- example

# Slides (optional).
#   Associate this publication with Markdown slides.
#   Simply enter your slide deck's filename without extension.
#   E.g. `slides: "example"` references `content/slides/example/index.md`.
#   Otherwise, set `slides: ""`.
slides: example
---

{{% callout note %}}
Click the *Cite* button above to demo the feature to enable visitors to import publication metadata into their reference management software.
{{% /callout %}}

{{% callout note %}}
Create your slides in Markdown - click the *Slides* button to check out the example.
{{% /callout %}}

Supplementary notes can be added here, including [code, math, and images](https://wowchemy.com/docs/writing-markdown-latex/).
==end comment
