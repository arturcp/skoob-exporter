// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
document.addEventListener('DOMContentLoaded', function() {
  const loading = document.querySelector('[data-loading-url]');

  if (loading) {
    checkImportStatus(loading.getAttribute('data-loading-url'));
  }
});

function checkImportStatus(url) {
  setTimeout(function() {
    console.log("checking...");
    var xhr = new XMLHttpRequest();
    xhr.open('GET', url, true);

    xhr.onload = function() {
      if (xhr.status === 200) {
        var data = JSON.parse(xhr.responseText);
        var countElement = document.querySelector('[data-count]');
        countElement.textContent = data.count + ' / ' + data.total;

        var progressBar = document.querySelector('.progress-bar');
        var percentage = Math.ceil(data.count * 100 / data.total);
        progressBar.style.width = percentage + '%';
        progressBar.querySelector('.sr-only').textContent = percentage + '% completed';

        if (data.duplicated.length > 0) {
          var duplicatedElement = document.querySelector('[data-duplicated]');
          duplicatedElement.classList.remove('hidden');

          var ul = document.createElement('ul');
          data.duplicated.forEach(function(item) {
            var li = document.createElement('li');
            li.innerHTML = '<span>[ISBN: ' + item.isbn + '] </span>' + item.title + ' - de ' + item.author;
            ul.appendChild(li);
          });

          var ddElement = duplicatedElement.querySelector('dd');
          ddElement.innerHTML = '';
          ddElement.appendChild(ul);
        }

        if (data.status === 0) {
          var statusElement = document.querySelector('[data-status]');
          statusElement.classList.add('finished');
          statusElement.textContent = 'Concluído';

          var downloadElement = document.getElementById('download');
          downloadElement.classList.remove('hidden');
        } else {
          var statusElement = document.querySelector('[data-status]');
          statusElement.textContent = 'Em andamento';

          checkImportStatus(url);
        }
      }
    };

    xhr.send();
  }, 7000);
}
