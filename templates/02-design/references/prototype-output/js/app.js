/**
 * Reusable Prototype Interactivity Script
 * Provides shared UI behaviors across all prototype screens in docs/design/screens/
 */

document.addEventListener('DOMContentLoaded', () => {
  initActiveNav();
  initStateSwitcher();
  initFormGuardrails();
});

/**
 * 1. Automatically highlight the active sidebar & navbar link
 * based on current window location filename
 */
function initActiveNav() {
  const currentPath = window.location.pathname;
  const currentFile = currentPath.substring(currentPath.lastIndexOf('/') + 1) || 'index.html';

  const navLinks = document.querySelectorAll('.sidebar-link, .nav-link');
  navLinks.forEach(link => {
    const href = link.getAttribute('href');
    if (href && (href === currentFile || href.endsWith('/' + currentFile))) {
      link.classList.add('active');
    } else {
      link.classList.remove('active');
    }
  });
}

/**
 * 2. 5-State Matrix Switcher
 * Allows the reviewer to test Default, Loading Skeleton, Empty, Error, and Success states
 */
function initStateSwitcher() {
  const switcher = document.getElementById('state-switcher');
  if (!switcher) return;

  switcher.addEventListener('change', (e) => {
    const targetState = e.target.value;
    const statePanels = document.querySelectorAll('[data-state-panel]');
    
    statePanels.forEach(panel => {
      if (panel.getAttribute('data-state-panel') === targetState) {
        panel.classList.add('active');
      } else {
        panel.classList.remove('active');
      }
    });

    showToast(`Viewing state: ${targetState}`, 'info');
  });
}

/**
 * 3. Form Submission Guardrail Simulation
 * Prevents double submissions and simulates pending state
 */
function initFormGuardrails() {
  const forms = document.querySelectorAll('form[data-guardrail]');
  forms.forEach(form => {
    form.addEventListener('submit', (e) => {
      e.preventDefault();
      const submitBtn = form.querySelector('button[type="submit"]');
      if (!submitBtn || submitBtn.disabled) return;

      const originalText = submitBtn.innerHTML;
      submitBtn.disabled = true;
      submitBtn.innerHTML = `
        <svg class="animate-spin" style="width: 16px; height: 16px; animation: spin 1s linear infinite;" viewBox="0 0 24 24" fill="none" stroke="currentColor">
          <circle cx="12" cy="12" r="10" stroke-width="4" stroke-dasharray="30 60"></circle>
        </svg>
        <span>Processing...</span>
      `;

      setTimeout(() => {
        submitBtn.disabled = false;
        submitBtn.innerHTML = originalText;
        showToast('Action completed successfully!', 'success');
      }, 1200);
    });
  });
}

/**
 * 4. Shared Toast Notification System
 * @param {string} message
 * @param {'info' | 'success' | 'warning' | 'destructive'} type
 */
window.showToast = function(message, type = 'info') {
  let container = document.getElementById('toast-container');
  if (!container) {
    container = document.createElement('div');
    container.id = 'toast-container';
    container.className = 'toast-container';
    document.body.appendChild(container);
  }

  const toast = document.createElement('div');
  toast.className = `toast toast-${type}`;
  toast.innerHTML = `<span>${message}</span>`;

  container.appendChild(toast);

  setTimeout(() => {
    toast.style.opacity = '0';
    toast.style.transition = 'opacity 0.2s ease-out';
    setTimeout(() => toast.remove(), 200);
  }, 3000);
};

/**
 * 5. Accessible Modal Dialog System
 */
window.openModal = function(modalId) {
  const modal = document.getElementById(modalId);
  if (!modal) return;
  modal.classList.add('active');
  document.body.style.overflow = 'hidden';
};

window.closeModal = function(modalId) {
  const modal = document.getElementById(modalId);
  if (!modal) return;
  modal.classList.remove('active');
  document.body.style.overflow = '';
};

// Close modal on Escape
document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape') {
    const activeModals = document.querySelectorAll('.modal-backdrop.active');
    activeModals.forEach(m => m.classList.remove('active'));
    document.body.style.overflow = '';
  }
});
