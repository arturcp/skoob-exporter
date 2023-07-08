// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

function getAuthenticityToken() {
  const metaTag = document.querySelector('meta[name="csrf-token"]');
  if (metaTag) {
    return metaTag.content;
  } else {
    console.error('CSRF meta tag not found.');
    return null;
  }
}

function sendFeedback(name, email, message) {
  const xhr = new XMLHttpRequest();
  xhr.open('POST', '/feedbacks', true);
  xhr.setRequestHeader('Content-Type', 'application/json');

  const authenticityToken = getAuthenticityToken();
  if (authenticityToken) {
    xhr.setRequestHeader('X-CSRF-Token', authenticityToken);
  }

  xhr.onload = function() {
    if (xhr.status === 204) {
      const myModalEl = document.getElementById('feedbackModal');
      const modal = bootstrap.Modal.getInstance(myModalEl);
      modal.hide();

      const feedbackAlert = document.getElementById('feedback-success-message');
      feedbackAlert.classList.remove('puff-out-center');
      feedbackAlert.style.display = 'block';

      setTimeout(() => {
        feedbackAlert.classList.add('puff-out-center');
      }, 3000);
    }
  };

  const data = {
    feedback: {
      name: name,
      email: email,
      message: message,
    }
  };

  xhr.send(JSON.stringify(data));
};

document.addEventListener('DOMContentLoaded', function() {
  const sendFeedbackButton = document.querySelector('[data-send-feedback-message]');
  if (sendFeedbackButton) {
    sendFeedbackButton.addEventListener('click', function() {
      const name = document.getElementById('name');
      const email = document.getElementById('email');
      const message = document.getElementById('message');

      if (message.value.trim().length === 0) {
        message.classList.add('required');
      } else {
        message.classList.remove('required');
        sendFeedback(name.value, email.value, message.value);
      }
    });
  }

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
