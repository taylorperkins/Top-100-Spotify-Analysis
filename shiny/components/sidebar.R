# Sidebar UI
library(shinydashboard)

echo_columns <- readRDS('../data/r-objects/shiny/general/echo_columns.rds')


sidebar <- dashboardSidebar(
	sidebarMenu(
	  
		# Page Handling
		h4("Page Selection"),
		sidebarMenu( menuItemOutput("sidebar_dashboard") ),
		sidebarMenu( menuItemOutput("sidebar_artists") ),
		sidebarMenu( menuItemOutput("sidebar_coorelation_art") ),

		hr(),

		h4("Plot Filters"),
		dateRangeInput(
			'sidebar_dateRange',
			label = 'Date range input: yyyy-mm-dd',
			start = as.Date(min(sra$date)), 
			end = as.Date(max(sra$date))
		),

		  # Input inside of menuSubItem		  
		selectInput(
			"sidebar_inputField",
			"Echoprint fields:",
			choices = echo_columns
		 )
		  
	)
)
