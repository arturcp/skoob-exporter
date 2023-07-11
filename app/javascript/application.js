// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

import Feedback from "./lib/feedback";
import ImportStatus from "./lib/import-status";

document.addEventListener('DOMContentLoaded', () => {
  new Feedback();
  new ImportStatus();
});
