# Sidebar UI
library(shinydashboard)


sidebar <- dashboardSidebar(
  sidebarMenu(
    
    ########################
    # Sidebar Menu Options
    ########################
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Widgets", tabName = "widgets", icon = icon("th"))
    
  )
)
