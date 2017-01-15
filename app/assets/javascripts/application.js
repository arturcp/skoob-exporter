// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$(document).ready(function() {
  var loading = $('[data-loading-url]');

  if (loading.length > 0) {
    checkImportStatus(loading.data('loading-url'));
  }
});

function checkImportStatus(url) {
  setTimeout(function() {
    $.get(url, function(data) {
      $('[data-count]').text(data.count);
      if (data.duplicated.length > 0) {
        $('[data-duplicated]').removeClass('hidden');
        var ul = $('<ul>');

        $.each(data.duplicated, function(_, item) {
          var li = $('<li>').html('<span>[ISBN: ' + item.isbn + '] </span>' + item.title + ' - de ' + item.author);
          ul.append(li);
        });

        $('[data-duplicated] dd').html('').append(ul);
      }

      if (data.status === 0) {
        $('[data-status]').toggleClass('finished').text('Concluído');
        $('#download').removeClass('hidden');
      } else {
        $('[data-status]').text('Em andamento');
        checkImportStatus(url);
      }
    })
  }, 5000);
}
