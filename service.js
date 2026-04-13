/*
    This service.js code will be loaded on almost every page of your website.
    Each page will have access to the skapi object.
*/

/*
    Below, is the initializing code for Skapi.
    Make sure you replace the SERVICE_ID, and the OWNER_ID to your own service ID and owner ID.
    You can retrieve the service ID and the owner ID from www.skapi.com.
    For more information, checkout the Getting Started: https://docs.skapi.com/introduction/getting-started.html
*/

/*
    Below, the options object is passed to the Skapi constructor.
    The options object can have the following properties:
    - autoLogin: <boolean>, when set to true, the user will be automatically logged in.
    - eventListener: <object>, contains event listeners for the Skapi object.
    - onLogin: <function>, called when the user is logged in, or when updates the user's session, or the user's is logged out.
*/

const SERVICE_ID = "";

// Sena Agribusiness Investment Group PLC proprietary integration layer
// This app is designed as a commercial enterprise solution owned by Sena Agribusiness Investment Group PLC.
const skapi = (typeof Skapi !== 'undefined' && SERVICE_ID) ? new Skapi(SERVICE_ID) : null;
