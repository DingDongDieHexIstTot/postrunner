#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = ViewWidgets.rb -- PostRunner - Manage the data from your Garmin sport devices.
#
# Copyright (c) 2014 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

module PostRunner

  module ViewWidgets

    def view_widgets_style(doc)
      doc.style(<<EOT
.titlebar {
  width: 100%;
  height: 50px;
  margin: 0px;
	background: linear-gradient(#7FA1FF 0, #002EAC 50px);
}
.title {
  float: left;
  font-size: 24pt;
  font-style: italic;
  font-weight: bold;
  color: #F8F8F8;
  text-shadow: -1px -1px 0 #5C5C5C,
                1px -1px 0 #5C5C5C,
               -1px  1px 0 #5C5C5C,
                1px  1px 0 #5C5C5C;
  padding: 3px 30px;
}
.navigator {
  float: right;
  padding: 3px 30px;
}
.active_button {
  padding: 5px;
}
.inactive_button {
  padding: 5px;
  opacity: 0.4;
}
.widget_frame {
	box-sizing: border-box;
	width: 600px;
	padding: 10px 15px 15px 15px;
	margin: 15px auto 15px auto;
	border: 1px solid #ddd;
	background: #fff;
	background: linear-gradient(#f6f6f6 0, #fff 50px);
	background: -o-linear-gradient(#f6f6f6 0, #fff 50px);
	background: -ms-linear-gradient(#f6f6f6 0, #fff 50px);
	background: -moz-linear-gradient(#f6f6f6 0, #fff 50px);
	background: -webkit-linear-gradient(#f6f6f6 0, #fff 50px);
	box-shadow: 0 3px 10px rgba(0,0,0,0.15);
	-o-box-shadow: 0 3px 10px rgba(0,0,0,0.1);
	-ms-box-shadow: 0 3px 10px rgba(0,0,0,0.1);
	-moz-box-shadow: 0 3px 10px rgba(0,0,0,0.1);
	-webkit-box-shadow: 0 3px 10px rgba(0,0,0,0.1);
}
.widget_frame_title {
  font-size:13pt;
  padding-bottom: 5px;
  text-align: left;
}
.flexitable {
  width: 100%;
  border: 2px solid #545454;
  border-collapse: collapse;
  font-size:11pt;
}
.ft_head_row {
  background-color: #DEDEDE
}
.ft_even_row {
  background-color: #FCFCFC
}
.ft_odd_row {
  background-color: #F1F1F1
}
.ft_cell {
  border: 1px solid #CCCCCC;
  padding: 1px 3px;
}
.footer {
  clear: both;
  width: 100%;
  height: 30px;
  padding: 15px;
  text-align: center;
  font-size: 9pt;
}
EOT
               )
    end

    def frame(doc, title)
      doc.div({ 'class' => 'widget_frame' }) {
        doc.div({ 'class' => 'widget_frame_title' }) {
          doc.b(title)
        }
        doc.div {
          yield if block_given?
        }
      }
    end

    def titlebar(doc, first_page = nil, prev_page = nil, home_page = nil,
                 next_page = nil, last_page = nil)
      # The top title bar.
      doc.div({ :class => 'titlebar' }) {
        doc.div('PostRunner', { :class => 'title' })
        doc.div({ :class => 'navigator' }) {
          button(doc, first_page, 'first.png')
          button(doc, prev_page, 'back.png')
          button(doc, home_page, 'home.png')
          button(doc, next_page, 'forward.png')
          button(doc, last_page, 'last.png')
        }
      }
    end

    def button(doc, link, icon)
      if link
        doc.a({ :href => link }) {
          doc.img({ :src => "icons/#{icon}", :class => 'active_button' })
        }
      else
        doc.img({ :src => "icons/#{icon}", :class => 'inactive_button' })
      end
    end

    def footer(doc)
      doc.div({ :class => 'footer' }){
        doc.hr
        doc.div({ :class => 'copyright' }) {
          doc.text("Generated by ")
          doc.a('PostRunner',
                { :href => 'https://github.com/scrapper/postrunner' })
          doc.text(" #{VERSION} on #{Time.now}")
        }
      }
    end

  end

end

