name             "ec2-linux"
maintainer       "knakayama"
maintainer_email "knakayama.sh@gmail.com"
license          "All rights reserved"
description      "Installs/Configures ec2-linux"
long_description IO.read(File.join(File.dirname(__FILE__), "README.md"))
version          "0.1.0"

recipe "ec2-linux::change_mta_to_postfix", "Change default MTA(sendmail) to postfix"
recipe "ec2-linux::create_swap_file", "Create swap file on ec2"

