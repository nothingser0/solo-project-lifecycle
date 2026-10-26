/**
 * Reusable Prototype Interactivity Script
 * Provides shared UI behaviors, 5-state matrix preview, and interactive multi-role RBAC simulation
 * across all prototype screens in docs/design/screens/
 */

document.addEventListener('DOMContentLoaded', () => {
  initActiveNav();
  initStateSwitcher();
  initRoleSwitcher();
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
 * 3. Interactive Multi-Role Simulation (RBAC Simulator)
 * Allows reviewing the prototype as Guest, User/Tenant, Staff, Manager, or Owner.
 * Persists across page navigations via localStorage.
 */
function initRoleSwitcher() {
  const roleSelect = document.getElementById('role-switcher');
  const savedRole = localStorage.getItem('proto_simulated_role') || 'all';

  if (roleSelect) {
    roleSelect.value = savedRole;
    roleSelect.addEventListener('change', (e) => {
      const selectedRole = e.target.value;
      localStorage.setItem('proto_simulated_role', selectedRole);
      applyRolePermissions(selectedRole);
      showToast(`Simulating Role: ${selectedRole.toUpperCase()}`, 'info');
    });
  }

  applyRolePermissions(savedRole);
}

function applyRolePermissions(role) {
  // 1. Role-restricted elements (data-roles="owner,manager")
  const roleElements = document.querySelectorAll('[data-roles]');
  roleElements.forEach(el => {
    const allowedRoles = el.getAttribute('data-roles').split(',').map(r => r.trim().toLowerCase());
    if (role === 'all' || allowedRoles.includes(role.toLowerCase())) {
      el.style.display = '';
    } else {
      el.style.display = 'none';
    }
  });

  // 2. Sensitive data masking (e.g. data-role-mask="staff" hides revenue from staff)
  const maskedElements = document.querySelectorAll('[data-role-mask]');
  maskedElements.forEach(el => {
    const maskedFor = el.getAttribute('data-role-mask').split(',').map(r => r.trim().toLowerCase());
    if (!el.hasAttribute('data-original-val')) {
      el.setAttribute('data-original-val', el.innerHTML);
    }

    if (role !== 'all' && maskedFor.includes(role.toLowerCase())) {
      el.innerHTML = '<span class="text-muted" style="font-size: 0.8em; letter-spacing: 2px;">••••••••</span> <span class="badge badge-warning" style="font-size: 0.65rem; padding: 2px 4px;">Restricted</span>';
    } else {
      el.innerHTML = el.getAttribute('data-original-val');
    }
  });

  // 3. Update active role badge if present
  const roleBadge = document.getElementById('active-role-badge');
  if (roleBadge) {
    roleBadge.textContent = role === 'all' ? 'All Roles' : role.toUpperCase();
  }
}

/**
 * 4. Form Submission Guardrail Simulation
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
 * 5. Shared Toast Notification System
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
 * 6. Accessible Modal Dialog System
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
