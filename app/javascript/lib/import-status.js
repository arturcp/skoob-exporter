import RestClient from './rest-client';

const PUBLICATION_TYPES = {
  'book': 'Livro',
  'comic': 'HQ',
  'magazine': 'Revista',
};

export default class ImportStatus {
  constructor() {
    this.checkDelay = 7000;

    const loading = document.querySelector('[data-loading-url]');

    if (loading) {
      this.checkImportStatus(loading.getAttribute('data-loading-url'));
    }
  }

  checkImportStatus(url) {
    const client = new RestClient();
    client.get(url, (data) => {
      this.onStatusChecked(data, url);
    });
  }

  onStatusChecked(data, url) {
    const countElement = document.querySelector('[data-count]');

    if (countElement) {
      countElement.textContent = data.count + ' / ' + data.total;

      this.updateProgressBar(data);

      if (data.duplicated.length > 0) {
        this.showDuplicatedPublications(data);
      }
    }

    if (data.status === 0) {
      this.showImportedPublications(data.publications);
    } else {
      setTimeout(() => {
        this.checkImportStatus(url);
      }, this.checkDelay);
    }
  }

  showDuplicatedPublications(duplicated) {
    const duplicatedElement = document.querySelector('[data-duplicated]');
    duplicatedElement.classList.remove('hidden');

    const ul = document.createElement('ul');
    duplicated.forEach((item) => {
      const li = document.createElement('li');
      li.innerHTML = '<span>[ISBN: ' + item.isbn + '] </span>' + item.title + ' - de ' + item.author;
      ul.appendChild(li);
    });

    const ddElement = duplicatedElement.querySelector('dd');
    ddElement.innerHTML = '';
    ddElement.appendChild(ul);
  }

  showImportedPublications(publications) {
    const downloadElement = document.getElementById('download');
    downloadElement.classList.remove('hidden');

    const importingIndicator = document.querySelector('.importing-indicator');
    importingIndicator.style.display = 'none';

    const importedIndicator = document.querySelector('.imported-indicator');
    importedIndicator.style.display = 'block';

    const importingCard = document.querySelector('.importing-card');
    importingCard.style.display = 'none';

    const tableBody = document.querySelector('[data-table-card-body]');
    publications.forEach((item) => {
      const tr = document.createElement('tr');
      tr.innerHTML = `<td>${item.title}</td><td>${item.author}</td><td>${item.isbn}</td><td>${item.publisher}</td><td>${PUBLICATION_TYPES[item.publication_type] || ''}</td>`
      tableBody.appendChild(tr);
    });

    const tableTitle = document.querySelector('[data-table-card-title]');
    tableTitle.textContent = `Publicações importadas: ${publications.length}`;

    const resultsTable = document.querySelector('.results-table');
    resultsTable.style.display = 'block';
  }

  updateProgressBar(data) {
    const progressBar = document.querySelector('.progress-bar');
    const percentage = Math.ceil(data.count * 100 / data.total);
    progressBar.style.width = percentage + '%';
  }
}
