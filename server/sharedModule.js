// sharedModule.js
const { ipcRenderer } = require('electron');

function openFile() {
  ipcRenderer.send('open-file');
}

module.exports = {
  openFile,
};
