export default class Login {
  constructor() {
    const form = document.getElementById('crawler-form');
    const submitButton = document.getElementById('crawler-submit');
    const loadingInfo = document.querySelector('.loading-info');
    const alert = document.querySelector('.login-alert');

    if (form) {
      form.addEventListener('submit', () => {
        submitButton.disabled = true;
        if (alert) {
          alert.style.display = 'none';
        }
        submitButton.innerHTML = '<img class="book-loading" src="/book-loading.gif" /> Aguarde...';
        loadingInfo.style.display = 'block';
      });
    }
  }
}
