/**
 * Web App Template
 * 
 * @author m4p1x
 * @version 1.0.0
 * @description Standalone web application hosted on Google Apps Script
 */

/**
 * doGet - Entry point for web app GET requests
 * This function is called when user visits the web app URL
 * 
 * @param {Object} e - Event object with query parameters
 * @returns {HtmlOutput} HTML page to display
 */
function doGet(e) {
  return HtmlService.createHtmlOutputFromFile('Index')
    .setTitle('Custom Web App')
    .setXFrameOptionsMode(HtmlService.XFrameOptionsMode.ALLOWALL);
}

/**
 * doPost - Entry point for web app POST requests
 * Handle form submissions or API calls
 * 
 * @param {Object} e - Event object with POST data
 * @returns {ContentService.TextOutput} JSON response
 */
function doPost(e) {
  try {
    const data = JSON.parse(e.postData.contents);
    const result = processRequest(data);
    
    return ContentService.createTextOutput(JSON.stringify(result))
      .setMimeType(ContentService.MimeType.JSON);
  } catch (error) {
    Logger.log(`Error: ${error.message}`);
    return ContentService.createTextOutput(
      JSON.stringify({ error: error.message })
    ).setMimeType(ContentService.MimeType.JSON);
  }
}

/**
 * Process incoming request data
 * 
 * @param {Object} data - Request data
 * @returns {Object} Response data
 */
function processRequest(data) {
  // Your business logic here
  Logger.log('Processing request:', data);
  
  return {
    success: true,
    message: 'Request processed successfully',
    timestamp: new Date().toISOString(),
  };
}

/**
 * Get data for frontend (called from client-side JavaScript)
 * 
 * @returns {Object} Data object
 */
function getData() {
  return {
    title: 'Custom Web App',
    version: '1.0.0',
    timestamp: new Date().toISOString(),
  };
}

/**
 * Save data from frontend
 * 
 * @param {Object} formData - Form data from frontend
 * @returns {Object} Result object
 */
function saveData(formData) {
  try {
    // Your save logic here
    // Example: save to Google Sheets, send email, etc.
    Logger.log('Saving data:', formData);
    
    return {
      success: true,
      message: 'Data saved successfully',
    };
  } catch (error) {
    Logger.log(`Error saving data: ${error.message}`);
    return {
      success: false,
      message: error.message,
    };
  }
}
