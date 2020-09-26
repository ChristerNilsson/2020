setwd(file.path("/Lab/2020/014-R"))

arr = read.csv(file = 'colors.csv', header = FALSE, stringsAsFactors = FALSE)
#pal <- function(n) { return(arr$V2[1:n]) }
get_group_color_palette <- function() return(function(n) return(arr$V2[1:n]) ) 

get_group_color_palette()(1) # returns "#FF3030"
get_group_color_palette()(2) # returns "#FF3030" "#00EE76"
get_group_color_palette()(3) # returns "#FF3030" "#00EE76" "#8B4726"


# head(arr)
# str(arr)
# arr$V2[1]
# arr[1, ]
# library(draw)
# drawSettings(pageWidth = 5, pageHeight = 5, units = "inches")
# drawPage()
# drawBox(x = 2.5, y = 2.5, width = 1, height = 1)
# drawCircle(x = 2.5, y = 2.5, radius = 0.5, lineColor = arr$V2[2], fillColor = arr$V2[1])
# drawLine(x = c(1, 4), y = c(1 ,1))
# drawText(x = 2.5, y = 2.5, text = "TEXT")
# drawExport("draw.pdf")
# drawExport("draw.jpeg", ppi = 300)
# pal <- colorRampPalette(c("red", "yellow", "green"))
# pal <- colorRampPalette(arr$V2)
# pal(3)
#get_group_color_palette = pal 
