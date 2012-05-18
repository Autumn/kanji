class Kanjidict
   def initialize
      @db = Array.new      
      f = File.open("kanjidic", "r:ascii-8bit")
      f.each_line do |line|
         h = Hash.new
         h["english"] = line.scan(/{.+?}/)
         a = line.gsub(/{.+?}/, "").split
         
         h["id"] = a[1]
         h["grade"] = 0
         parseDict h, a
         h["kanji"] = getKanji h
         @db.push h
      end
   end

   def parseDict(hash, line)
      line.each do |x|
         if x.match(/^B/)
            hash["bushu"] = x.sub(/^B/, "").to_i
         elsif x.match(/^C/)
            hash["classical"] = x.sub(/^C/, "").to_i
         elsif x.match(/^F/)
            hash["freq"] = x.sub(/^F/, "").to_i
         elsif x.match(/^G/)
            hash["grade"] = x.sub(/^G/, "").to_i
         elsif x.match(/^J/)
            hash["jlpt"] = x.sub(/^J/, "").to_i
         elsif x.match(/^H/)
            hash["H"] = x.sub(/^H/, "")
         elsif x.match(/^N/)
            hash["N"] = x.sub(/^N/, "")
         elsif x.match(/^V/)
            hash["V"] = x.sub(/^V/, "")
         elsif x.match(/^P/)
            hash["P"] = x.sub(/^P/, "")
         elsif x.match(/^S/)     
            hash["strokes"] = x.sub(/^S/, "").to_i
         elsif x.match(/^U/)
            hash["unicode"] = x.sub(/^U/, "")
         elsif x.match(/^I/)
            hash["index"] = x.sub(/^I/, "").to_i
         elsif x.match(/^[ABCDEFGHIJKLMNOPQRSTUVWXYZ]/)
 
         elsif x.match(/^(MN|MP)/)

         else
            if x != hash["id"] and [x.hex].pack("U*") != hash["kanji"]
               #print "#{hash["id"]}: "
               #x.each_codepoint { |c| print "#{c} " }
	       #puts ""
            end
         end 
      end
   end

   def getKanji(h) 
      [h["unicode"].hex].pack("U*")
   end

   def each
      @db.each do |d|
         yield d
      end
   end

   def sortByGrade(*list)
      if list == []
         @db.sort_by { |a| a["grade"]}
      else 
         list[0].sort_by {|a| a["grade"]}
      end
   end

   def sortByStrokes(*list)
      if list == []
         @db.sort_by {|a| a["strokes"]}
      else 
         list[0].sort_by {|a| a["strokes"]}
      end
   end

   def sortByJlpt(*list)
      if list == []
         @db.sort_by {|a| a["jlpt"]}
      else
         list[0].sort_by {|a| a["jlpt"]}
      end
   end

   def sortByUnicode
      if list == []
         @db.sort_by {|a| a["unicode"].hex}
      else
         list[0].sort_by {|a| a["unicode"].hex}
      end
   end

   def filterByGrade(grade, *list)
      if list == []
         @db.find_all {|a| a["grade"] == grade}
      else
         list[0].find_all {|a| a["grade"] == grade}
      end
   end

   def filterByStrokes (num, *list)
      if list == []
         @db.find_all {|a| a["strokes"] == num}
      else
         list[0].find_all {|a| a["strokes"] == num}
      end
   end

   def filterByJlpt (num, *list)
      if list == []
         @db.find_all {|a| a["jlpt"] == num}
      else
         list[0].find_all {|a| a["jlpt"] == num}
      end
   end
end

kd = Kanjidict.new
result = kd.filterByGrade(3, kd.filterByStrokes(4))
result.each { |r|
   puts "#{r["kanji"]}: #{r["english"]}"
}
