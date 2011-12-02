#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
     require 'rubygems'
     require 'axlsx.rb'


#A Simple Workbook
if ARGV.size == 0 || ARGV.include?("1")
      p = Axlsx::Package.new
      p.workbook.add_worksheet do |sheet|
        sheet.add_row ["First", "Second", "Third"]
        sheet.add_row [1, 2, Time.now]
      end
      p.serialize("example1.xlsx")
end
#Generating A Bar Chart
if ARGV.size==0 || ARGV.include?("2")

     p = Axlsx::Package.new
     p.workbook.add_worksheet do |sheet|
       sheet.add_row ["First", "Second", "Third"]
       sheet.add_row [1, 2, 3]
       sheet.add_chart(Axlsx::Bar3DChart, :start_at => [0,2], :end_at => [5, 15], :title=>"example 2: Chart") do |chart|
         chart.add_series :data=>sheet.rows.last.cells, :labels=> sheet.rows.first.cells
       end
     end  
     p.serialize("example2.xlsx")
end
#Generating A Pie Chart
if ARGV.size==0 || ARGV.include?("3")

     p = Axlsx::Package.new
     p.workbook.add_worksheet do |sheet|
       sheet.add_row ["First", "Second", "Third"]
       sheet.add_row [1, 2, 3]
       sheet.add_chart(Axlsx::Pie3DChart, :start_at => [0,2], :end_at => [5, 15], :title=>"example 3: Pie Chart") do |chart|
         chart.add_series :data=>sheet.rows.last.cells, :labels=> sheet.rows.first.cells
       end
     end  
     p.serialize("example3.xlsx")
end

#Using Custom Styles
if ARGV.size==0 || ARGV.include?("4")

     p = Axlsx::Package.new
     wb = p.workbook
     black_cell = wb.styles.add_style :bg_color => "FF000000", :fg_color => "FFFFFFFF", :sz=>14, :alignment => { :horizontal=> :center }
     blue_cell = wb.styles.add_style  :bg_color => "FF0000FF", :fg_color => "FFFFFFFF", :sz=>14, :alignment => { :horizontal=> :center }
     wb.add_worksheet do |sheet|
       sheet.add_row ["Text Autowidth", "Second", "Third"], :style => [black_cell, blue_cell, black_cell]
       sheet.add_row [1, 2, 3], :style => Axlsx::STYLE_THIN_BORDER
     end
     p.serialize("example4.xlsx")
end
#Using Custom Formatting and date1904
if ARGV.size==0 || ARGV.include?("5")

     p = Axlsx::Package.new
     wb = p.workbook
     date = wb.styles.add_style :format_code=>"yyyy-mm-dd", :border => Axlsx::STYLE_THIN_BORDER
     padded = wb.styles.add_style :format_code=>"00#", :border => Axlsx::STYLE_THIN_BORDER
     percent = wb.styles.add_style :format_code=>"0%", :border => Axlsx::STYLE_THIN_BORDER
     wb.date1904 = true # required for generation on mac
     wb.add_worksheet do |sheet|
       sheet.add_row ["Custom Formatted Date", "Percent Formatted Float", "Padded Numbers"], :style => Axlsx::STYLE_THIN_BORDER
       sheet.add_row [Time.now, 0.2, 32], :style => [date, percent, padded]
     end
     p.serialize("example5.xlsx")
end
#Validation
if ARGV.size==0 || ARGV.include?("6")

     p = Axlsx::Package.new
     p.workbook.add_worksheet do |sheet|
       sheet.add_row ["First", "Second", "Third"]
       sheet.add_row [1, 2, 3]
     end

     p.validate.each do |error|
       puts error.inspect
     end
end      
#Generating A Line Chart
if ARGV.size==0 || ARGV.include?("7")

     p = Axlsx::Package.new
     p.workbook.add_worksheet do |sheet|
       sheet.add_row ["First", 1, 5, 7, 9]
       sheet.add_row ["Second", 5, 2, 14, 9]
       sheet.add_chart(Axlsx::Line3DChart, :title=>"example 6: Line Chart") do |chart|
         chart.start_at 0, 2
         chart.end_at 10, 15
         chart.add_series :data=>sheet.rows.first.cells[(1..-1)], :title=> sheet.rows.first.cells.first
         chart.add_series :data=>sheet.rows.last.cells[(1..-1)], :title=> sheet.rows.last.cells.first
       end
       
     end  
     p.serialize("example7.xlsx")
end

#Add an Image
if ARGV.size==0 || ARGV.include?("8")

     p = Axlsx::Package.new
     p.workbook.add_worksheet do |sheet|
       img = File.expand_path('examples/image1.jpeg') 
       sheet.add_image(:image_src => img, :noSelect=>true, :noMove=>true) do |image|
         image.width=720
         image.height=666
         image.start_at 2, 2
       end
     end  
     p.serialize("example8.xlsx")
end

#Asian Language Support
if ARGV.size==0 || ARGV.include?("9")

     p = Axlsx::Package.new
     p.workbook.add_worksheet do |sheet|
       sheet.add_row ["日本語"]
       sheet.add_row ["华语/華語"]
       sheet.add_row ["한국어/조선말"]
     end  
     p.serialize("example9.xlsx")
end


#Styling Columns
if ARGV.size==0 || ARGV.include?("10")
     p = Axlsx::Package.new
     percent = p.workbook.styles.add_style :num_fmt => 9
     p.workbook.add_worksheet do |sheet|
       sheet.add_row ['col 1', 'col 2', 'col 3', 'col 4']
       sheet.add_row [1, 2, 0.3, 4]
       sheet.add_row [1, 2, 0.2, 4]
       sheet.add_row [1, 2, 0.1, 4]
     end
     p.workbook.worksheets.first.col_style 2, percent, :row_offset=>1
     p.serialize("example10.xlsx")
end

#Styling Rows
if ARGV.size==0 || ARGV.include?("11")
     p = Axlsx::Package.new
     p.workbook.add_worksheet do |sheet|
       sheet.add_row ['col 1', 'col 2', 'col 3', 'col 4']
       sheet.add_row [1, 2, 0.3, 4]
       sheet.add_row [1, 2, 0.2, 4]
       sheet.add_row [1, 2, 0.1, 4]
     end
     head = p.workbook.styles.add_style :bg_color => "FF000000", :fg_color=>"FFFFFFFF"
     percent = p.workbook.styles.add_style :num_fmt => 9
     p.workbook.worksheets.first.col_style 2, percent, :row_offset=>1
     p.workbook.worksheets.first.row_style 0, head
     p.serialize("example11.xlsx")
end

#Rails 3
      
     #  class MyModel < ActiveRecord::Base
     #    acts_as_axlsx
     #  end
     #
     # class MyModelController <  ApplicationController
     #
     #   GET /posts/xlsx
     #   def xlsx
     #     p = Post.to_xlsx
     #     p.serialize('posts.xlsx')
     #     send_file 'posts.xlsx', :type=>"application/xlsx", :x_sendfile=>true
     #   end

     
