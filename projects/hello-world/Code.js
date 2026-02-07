/**
 * Standalone Google Apps Script Template
 *
 * @author m4p1x
 * @version 1.0.0
 * @description Basic standalone script template for automation tasks
 */

/**
 * Main entry point - triggered manually or by time-based trigger
 */
function main() {
  Logger.log('Starting execution...');

  try {
    const result = processData();
    Logger.log(`Completed successfully: ${result}`);
  } catch (error) {
    Logger.log(`Error: ${error.message}`);
    throw error;
  }
}

/**
 * Example function - replace with your business logic
 *
 * @returns {string} Result message
 */
function processData() {
  // Implement your business logic here
  // Example: fetch data, process it, send notifications

  return 'Data processed successfully';
}

/**
 * Test function - for manual testing in Apps Script editor
 * Run this function to test your main logic
 */
function test() {
  Logger.log('Running test...');
  main();
}
