export default class Login {
  constructor() {
    const form = document.getElementById('crawler-form');
    const submitButton = document.getElementById('crawler-submit');

    if (form) {
      form.addEventListener('submit', () => {
        submitButton.disabled = true;
        submitButton.value = 'Aguarde...';
      });
    }
  }
}
