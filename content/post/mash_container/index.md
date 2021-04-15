---
# Documentation: https://wowchemy.com/docs/managing-content/

title: "A container of mixed-up Mash"
subtitle: ""
summary: ""
authors: []
tags: []
categories: []
date: 2021-04-14T19:06:48+01:00
lastmod: 2021-04-14T19:06:48+01:00
featured: false
draft: false

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
# Focal points: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight.
image:
  caption: ""
  focal_point: ""
  preview_only: false

# Projects (optional).
#   Associate this post with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `projects = ["internal-project"]` references `content/project/deep-learning/index.md`.
#   Otherwise, set `projects = []`.
projects: []
---

I've been trying to write a k-mer sketching based pipeline to do fast QC of the *population structure* of read data. The idea is this will be a [nextflow](https://www.nextflow.io/) pipeline that I could run on large collections of reads and check that the data roughly make sense in terms of e.g. if I think they should come from two populations, there are differences between these two groups. 

As part of this, I want to count kmers in just the subset of hash functions shared by two sketches, but I can't see how to do that with the existing tools. While many of the k-mer sketching tools have an interchange format in json that lets you see which hash functions are used, but you can't get the count of times each function is observed (some info on the json format is linked in a discussion on github [here](https://github.com/marbl/Mash/issues/44). Its what is output by [mash](https://mash.readthedocs.io/en/latest/index.html) using `mash info -d`. I've hacked the source code of Mash a bit to make it output what I think I need. This is slightly painful, as you need [Cap'n Proto](https://capnproto.org/) and lots of other dependencies to compile it, so I had to do this in a virtual machine where I could install the various dependencies. 

Anyway - on my github fork of MASH [here](https://github.com/jacotton/Mash) is a version that has a new `mash info -t` command that dumps a text format of the hash functions alongside the count for each in a sketch. 

Along the way, I've also made a [singularity](https://sylabs.io/singularity/) container, so I don't have to ever go through the process of building mash again.. and as it might be useful to other people to also avoid doing that, i've put it on github too [here](https://github.com/jacotton/Mash/blob/master/mash-2.3-jacotton.simg), together with the [definition file](https://github.com/jacotton/Mash/blob/master/mash-2.3-jacotton.def).   

Update (15/4/2021) -- I've just noticed that [sourmash](https://sourmash.readthedocs.io) has commands to perform intersections of sketches etc. in `sourmash siganture intersect`. Not sure if they are new and or if they were always there and I missed them. I still don't think i've *quite* wasted my life, though, as these commands work with flattened sketches - i.e. without abundance information.
