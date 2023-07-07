// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
document.addEventListener('DOMContentLoaded', function() {
  const loading = document.querySelector('[data-loading-url]');

  if (loading) {
    checkImportStatus(loading.getAttribute('data-loading-url'));
  }
});

function checkImportStatus(url) {
  console.log("checking status...");
  const xhr = new XMLHttpRequest();
  xhr.open('GET', url, true);

  xhr.onload = function() {
    if (xhr.status === 200) {
      const data = JSON.parse(xhr.responseText);
      const countElement = document.querySelector('[data-count]');

      if (countElement) {
        countElement.textContent = data.count + ' / ' + data.total;

        const progressBar = document.querySelector('.progress-bar');
        const percentage = Math.ceil(data.count * 100 / data.total);
        progressBar.style.width = percentage + '%';
        progressBar.querySelector('.sr-only').textContent = percentage + '% completed';

        if (data.duplicated.length > 0) {
          const duplicatedElement = document.querySelector('[data-duplicated]');
          duplicatedElement.classList.remove('hidden');

          const ul = document.createElement('ul');
          data.duplicated.forEach(function(item) {
            const li = document.createElement('li');
            li.innerHTML = '<span>[ISBN: ' + item.isbn + '] </span>' + item.title + ' - de ' + item.author;
            ul.appendChild(li);
          });

          const ddElement = duplicatedElement.querySelector('dd');
          ddElement.innerHTML = '';
          ddElement.appendChild(ul);
        }
      }

      if (data.status === 0) {
        const downloadElement = document.getElementById('download');
        downloadElement.classList.remove('hidden');

        const importingIndicator = document.querySelector('.importing-indicator');
        importingIndicator.style.display = 'none';

        const importedIndicator = document.querySelector('.imported-indicator');
        importedIndicator.style.display = 'block';

        const importingCard = document.querySelector('.importing-card');
        importingCard.style.display = 'none';

        const tableBody = document.querySelector('[data-table-card-body]');
        data.books.forEach((item) => {
          const tr = document.createElement('tr');
          tr.innerHTML = '<td>' + item.title + '</td><td>' + item.author + '</td><td>' + item.isbn + '</td><td>' + item.publisher + '</td><td>';
          tableBody.appendChild(tr);
        });

        const tableTitle = document.querySelector('[data-table-card-title]');
        tableTitle.textContent = `Livros importados: ${data.books.length}`;

        const resultsTable = document.querySelector('.results-table');
        resultsTable.style.display = 'block';
      } else {
        setTimeout(() => {
          checkImportStatus(url);
        }, 7000);
      }
    }
  };

  xhr.send();
}
