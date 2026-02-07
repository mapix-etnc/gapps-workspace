/**
 * Google Sheets Add-on Template
 * 
 * @author m4p1x
 * @version 1.0.0
 * @description Custom functionality for Google Sheets with menu and sidebar
 */

/**
 * onOpen trigger - creates custom menu when spreadsheet opens
 * This function runs automatically when the spreadsheet is opened
 */
function onOpen() {
  const ui = SpreadsheetApp.getUi();
  
  ui.createMenu('Custom Tools')
    .addItem('Process Data', 'processSheetData')
    .addItem('Show Sidebar', 'showSidebar')
    .addSeparator()
    .addItem('About', 'showAbout')
    .addToUi();
}

/**
 * Process data in the active sheet
 * Example: Read data, transform it, write results
 */
function processSheetData() {
  const sheet = SpreadsheetApp.getActiveSheet();
  const ui = SpreadsheetApp.getUi();
  
  try {
    // Get all data from sheet
    const data = sheet.getDataRange().getValues();
    Logger.log(`Processing ${data.length} rows`);
    
    // Your processing logic here
    // Example: filter, transform, calculate
    
    ui.alert('Success', 'Data processed successfully!', ui.ButtonSet.OK);
  } catch (error) {
    Logger.log(`Error: ${error.message}`);
    ui.alert('Error', `Failed to process data: ${error.message}`, ui.ButtonSet.OK);
  }
}

/**
 * Show custom sidebar with HTML UI
 */
function showSidebar() {
  const html = HtmlService.createHtmlOutputFromFile('Sidebar')
    .setTitle('Custom Sidebar')
    .setWidth(300);
  
  SpreadsheetApp.getUi().showSidebar(html);
}

/**
 * Show about dialog
 */
function showAbout() {
  const ui = SpreadsheetApp.getUi();
  ui.alert(
    'About',
    'Custom Sheets Add-on v1.0.0\n\nCreated by m4p1x',
    ui.ButtonSet.OK
  );
}

/**
 * Get data for sidebar (called from HTML)
 * 
 * @returns {Object} Data object with sheet info
 */
function getSheetData() {
  const sheet = SpreadsheetApp.getActiveSheet();
  
  return {
    name: sheet.getName(),
    rows: sheet.getLastRow(),
    columns: sheet.getLastColumn(),
  };
}
