export default class RestClient {
  constructor(options = {}) {
    this.successCode = options.successCode || 200;
  }

  get(url, callback) {
    const xhr = new XMLHttpRequest();
    xhr.open('GET', url, true);

    xhr.onload = () => {
      if (xhr.status === this.successCode) {
        const response = JSON.parse(xhr.responseText);
        callback(response);
      }
    };

    xhr.send();
  }

  post(url, data, callback) {
    const xhr = new XMLHttpRequest();
    xhr.open('POST', url, true);
    xhr.setRequestHeader('Content-Type', 'application/json');

    const authenticityToken = this.getAuthenticityToken();
    if (authenticityToken) {
      xhr.setRequestHeader('X-CSRF-Token', authenticityToken);
    }

    xhr.onload = () => {
      if (xhr.status === this.successCode) {
        const response = xhr.responseText ? JSON.parse(xhr.responseText) : null;
        callback(response);
      }
    };

    xhr.send(JSON.stringify(data));
  }

  getAuthenticityToken() {
    const metaTag = document.querySelector('meta[name="csrf-token"]');
    if (metaTag) {
      return metaTag.content;
    } else {
      console.error('CSRF meta tag not found.');
      return null;
    }
  }
}
