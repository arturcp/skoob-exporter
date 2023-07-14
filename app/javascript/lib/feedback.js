import RestClient from 'lib/rest-client';

export default class Feedback {
  constructor() {
    const sendFeedbackButton = document.querySelector('[data-send-feedback-message]');
    if (sendFeedbackButton) {
      sendFeedbackButton.addEventListener('click', () => {
        const name = document.getElementById('name_for_feedback');
        const email = document.getElementById('email_for_feedback');
        const message = document.getElementById('message_for_feedback');

        if (message.value.trim().length === 0) {
          message.classList.add('required');
        } else {
          message.classList.remove('required');
          this.sendFeedback(name.value, email.value, message.value);
        }
      });
    }
  }

  sendFeedback(name, email, message) {
    const client = new RestClient({ successCode: 204 });
    const data = {
      feedback: {
        name,
        email,
        message,
      }
    }

    client.post('/feedbacks', data, () => {
      const myModalEl = document.getElementById('feedbackModal');
      const modal = bootstrap.Modal.getInstance(myModalEl);
      modal.hide();

      const feedbackAlert = document.getElementById('feedback-success-message');
      feedbackAlert.classList.remove('puff-out-center');
      feedbackAlert.style.display = 'block';

      setTimeout(() => {
        feedbackAlert.classList.add('puff-out-center');
      }, 3000);
    });
  }
}
