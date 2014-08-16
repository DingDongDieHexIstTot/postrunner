#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = ActivityView.rb -- PostRunner - Manage the data from your Garmin sport devices.
#
# Copyright (c) 2014 by Chris Schlaeger <cs@taskjuggler.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'fit4ruby'

require 'postrunner/HTMLBuilder'
require 'postrunner/ActivityReport'
require 'postrunner/ViewWidgets'
require 'postrunner/TrackView'
require 'postrunner/ChartView'

module PostRunner

  class ActivityView

    include ViewWidgets

    def initialize(activity)
      @activity = activity
      @output_dir = activity.html_dir
      @output_file = nil

      ensure_output_dir

      @doc = HTMLBuilder.new
      generate_html(@doc)
      write_file
    end

    private

    def ensure_output_dir
      unless Dir.exists?(@output_dir)
        begin
          Dir.mkdir(@output_dir)
        rescue SystemCallError
          Log.fatal "Cannot create output directory '#{@output_dir}': #{$!}"
        end
      end
      create_symlink('jquery')
      create_symlink('flot')
      create_symlink('openlayers')
    end

    def create_symlink(dir)
      # This file should be in lib/postrunner. The 'misc' directory should be
      # found in '../../misc'.
      misc_dir = File.realpath(File.join(File.dirname(__FILE__),
                                         '..', '..', 'misc'))
      unless Dir.exists?(misc_dir)
        Log.fatal "Cannot find 'misc' directory under '#{misc_dir}': #{$!}"
      end
      src_dir = File.join(misc_dir, dir)
      unless Dir.exists?(src_dir)
        Log.fatal "Cannot find '#{src_dir}': #{$!}"
      end
      dst_dir = File.join(@output_dir, dir)
      unless File.exists?(dst_dir)
        begin
          FileUtils.ln_s(src_dir, dst_dir)
        rescue IOError
          Log.fatal "Cannot create symbolic link to '#{dst_dir}': #{$!}"
        end
      end
    end


    def generate_html(doc)
      @report = ActivityReport.new(@activity)
      @track_view = TrackView.new(@activity)
      @chart_view = ChartView.new(@activity)

      doc.html {
        head(doc)
        body(doc)
      }
    end

    def head(doc)
      doc.head {
        doc.meta({ 'http-equiv' => 'Content-Type',
                   'content' => 'text/html; charset=utf-8' })
        doc.meta({ 'name' => 'viewport',
                   'content' => 'width=device-width, ' +
                                'initial-scale=1.0, maximum-scale=1.0, ' +
                                'user-scalable=0' })
        doc.title("PostRunner Activity: #{@activity.name}")
        style(doc)
        view_widgets_style(doc)
        @chart_view.head(doc)
        @track_view.head(doc)
      }
    end

    def style(doc)
      doc.style(<<EOT
.body {
  font-family: verdana,arial,sans-serif;
}
.main {
  width: 1210px;
  margin: 0 auto;
}
.left_col {
  float: left;
  width: 400px;
}
.right_col {
  float: right;
  width: 600px;
}
.flexitable {
  width: 100%;
  border: 1px solid #CCCCCC;
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
EOT
               )
    end

    def body(doc)
      doc.body({ 'onload' => 'init()' }) {
        doc.div({ 'class' => 'main' }) {
          doc.div({ 'class' => 'left_col' }) {
            @report.to_html(doc)
            @track_view.div(doc)
          }
          doc.div({ 'class' => 'right_col' }) {
            @chart_view.div(doc)
          }
        }
      }
    end

    def write_file
      @output_file = File.join(@output_dir, "#{@activity.fit_file[0..-5]}.html")
      begin
        File.write(@output_file, @doc.to_html)
      rescue IOError
        Log.fatal "Cannot write activity view file '#{@output_file}: #{$!}"
      end
    end

  end

end

