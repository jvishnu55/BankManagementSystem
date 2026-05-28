<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bank.model.*,java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    List<Account> accounts = (List<Account>) request.getAttribute("accounts");
    List<Transaction> txns = (List<Transaction>) request.getAttribute("transactions");
    List<Loan> loans       = (List<Loan>) request.getAttribute("loans");
    if (accounts == null) accounts = new ArrayList<>();
    if (txns     == null) txns = new ArrayList<>();
    if (loans    == null) loans = new ArrayList<>();

    java.math.BigDecimal totalBalance = java.math.BigDecimal.ZERO;
    for (Account a : accounts) if ("ACTIVE".equals(a.getStatus())) totalBalance = totalBalance.add(a.getBalance());
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>BankMS — My Dashboard</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
  <a class="navbar-brand" href="#">
    <span>🏦</span> BankMS
  </a>
  <div class="nav-links">
    <a class="nav-link active" href="#" onclick="showTab('overview')">Overview</a>
    <a class="nav-link" href="#" onclick="showTab('transactions')">Transactions</a>
    <a class="nav-link" href="#" onclick="showTab('loans')">Loans</a>
  </div>
  <div class="nav-user">
    <div class="avatar"><%= user.getFullName().charAt(0) %></div>
    <span><%= user.getFullName() %></span>
    <a class="btn-logout" href="${pageContext.request.contextPath}/logout">Logout</a>
  </div>
</nav>

<div class="page-wrapper">
  <!-- SIDEBAR -->
  <aside class="sidebar">
    <div class="sidebar-section">
      <div class="sidebar-label">Banking</div>
      <button class="sidebar-link active" onclick="showTab('overview'); setActive(this)">
        <span class="icon">📊</span> Overview
      </button>
      <button class="sidebar-link" onclick="openModal('depositModal'); setActive(this)">
        <span class="icon">⬇️</span> Deposit
      </button>
      <button class="sidebar-link" onclick="openModal('withdrawModal'); setActive(this)">
        <span class="icon">⬆️</span> Withdraw
      </button>
      <button class="sidebar-link" onclick="openModal('transferModal'); setActive(this)">
        <span class="icon">↔️</span> Transfer
      </button>
    </div>
    <div class="sidebar-section">
      <div class="sidebar-label">Accounts</div>
      <button class="sidebar-link" onclick="showTab('accounts'); setActive(this)">
        <span class="icon">💳</span> My Accounts
      </button>
      <button class="sidebar-link" onclick="openModal('openAccountModal')">
        <span class="icon">➕</span> Open Account
      </button>
    </div>
    <div class="sidebar-section">
      <div class="sidebar-label">Services</div>
      <button class="sidebar-link" onclick="showTab('transactions'); setActive(this)">
        <span class="icon">📋</span> Transactions
      </button>
      <button class="sidebar-link" onclick="showTab('loans'); setActive(this)">
        <span class="icon">🏠</span> Loans
      </button>
      <button class="sidebar-link" onclick="openModal('loanModal')">
        <span class="icon">📝</span> Apply Loan
      </button>
    </div>
  </aside>

  <!-- MAIN -->
  <main class="main-content">
    <div class="page-header">
      <h1>Welcome back, <%= user.getFullName().split(" ")[0] %></h1>
      <p class="breadcrumb">Dashboard · <%= new java.util.Date() %></p>
    </div>

    <!-- ALERTS -->
    <% if (request.getAttribute("success") != null) { %>
      <div class="alert alert-success">✓ <%= request.getAttribute("success") %></div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-danger">✗ <%= request.getAttribute("error") %></div>
    <% } %>

    <!-- TAB: OVERVIEW -->
    <div id="tab-overview" class="tab-panel active">
      <!-- Stats -->
      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-label">Total Balance</div>
          <div class="stat-value">₹<%= String.format("%,.2f", totalBalance) %></div>
          <div class="stat-icon">💰</div>
        </div>
        <div class="stat-card">
          <div class="stat-label">Accounts</div>
          <div class="stat-value"><%= accounts.size() %></div>
          <div class="stat-icon">💳</div>
        </div>
        <div class="stat-card">
          <div class="stat-label">Active Loans</div>
          <div class="stat-value"><%= loans.stream().filter(l->"APPROVED".equals(l.getStatus())).count() %></div>
          <div class="stat-icon">🏠</div>
        </div>
        <div class="stat-card">
          <div class="stat-label">Transactions</div>
          <div class="stat-value"><%= txns.size() %></div>
          <div class="stat-icon">📋</div>
        </div>
      </div>

      <!-- Quick Actions -->
      <div class="card">
        <div class="card-header"><span class="card-title">Quick Actions</span></div>
        <div style="display:flex;gap:0.75rem;flex-wrap:wrap">
          <button class="btn btn-primary" onclick="openModal('depositModal')">⬇️ Deposit</button>
          <button class="btn btn-outline" onclick="openModal('withdrawModal')">⬆️ Withdraw</button>
          <button class="btn btn-outline" onclick="openModal('transferModal')">↔️ Transfer</button>
          <button class="btn btn-outline" onclick="openModal('openAccountModal')">➕ Open Account</button>
          <button class="btn btn-outline" onclick="openModal('loanModal')">📝 Apply Loan</button>
        </div>
      </div>

      <!-- My Accounts -->
      <div class="card">
        <div class="card-header">
          <span class="card-title">My Accounts</span>
          <button class="btn btn-outline btn-sm" onclick="openModal('openAccountModal')">+ New Account</button>
        </div>
        <div class="account-cards">
          <% for (Account acc : accounts) { %>
          <div class="account-card">
            <div class="account-type-badge"><%= acc.getAccountType().replace('_',' ') %></div>
            <div class="account-number"><%= acc.getAccountNumber() %></div>
            <div class="account-balance">₹<%= String.format("%,.2f", acc.getBalance()) %> <span>INR</span></div>
            <div style="margin-top:0.75rem;display:flex;align-items:center;justify-content:space-between">
              <span class="status-badge status-<%= acc.getStatus() %>">
                ● <%= acc.getStatus() %>
              </span>
              <span style="font-size:0.75rem;color:var(--text-muted)">Since <%= acc.getOpenedDate() %></span>
            </div>
          </div>
          <% } %>
          <% if (accounts.isEmpty()) { %>
          <div style="text-align:center;padding:2rem;color:var(--text-muted)">
            No accounts found. <a href="#" onclick="openModal('openAccountModal')" style="color:var(--gold)">Open one now</a>
          </div>
          <% } %>
        </div>
      </div>

      <!-- Recent Transactions -->
      <div class="card">
        <div class="card-header">
          <span class="card-title">Recent Transactions</span>
          <button class="btn btn-outline btn-sm" onclick="showTab('transactions')">View All</button>
        </div>
        <div class="table-wrap">
          <table>
            <thead><tr>
              <th>Type</th><th>Amount</th><th>From</th><th>To</th><th>Description</th><th>Date</th>
            </tr></thead>
            <tbody>
              <% for (int i = 0; i < Math.min(5, txns.size()); i++) {
                 Transaction t = txns.get(i); %>
              <tr>
                <td><span class="txn-type txn-<%= t.getTxnType() %>"><%= t.getTxnType() %></span></td>
                <td style="color:var(--gold-light);font-weight:600">₹<%= String.format("%,.2f", t.getAmount()) %></td>
                <td style="font-size:0.8rem"><%= t.getFromAccount() != null ? t.getFromAccount() : "—" %></td>
                <td style="font-size:0.8rem"><%= t.getToAccount()   != null ? t.getToAccount()   : "—" %></td>
                <td style="color:var(--text-muted);font-size:0.82rem"><%= t.getDescription() != null ? t.getDescription() : "—" %></td>
                <td style="font-size:0.78rem;color:var(--text-muted)"><%= t.getTxnDate() %></td>
              </tr>
              <% } %>
              <% if (txns.isEmpty()) { %><tr><td colspan="6" class="text-center text-muted">No transactions yet</td></tr><% } %>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- TAB: TRANSACTIONS -->
    <div id="tab-transactions" class="tab-panel">
      <div class="card">
        <div class="card-header"><span class="card-title">All Transactions</span></div>
        <div class="table-wrap">
          <table>
            <thead><tr>
              <th>#</th><th>Type</th><th>Amount</th><th>Balance After</th><th>From</th><th>To</th><th>Description</th><th>Date</th><th>Status</th>
            </tr></thead>
            <tbody>
              <% for (Transaction t : txns) { %>
              <tr>
                <td style="color:var(--text-muted)">#<%= t.getTxnId() %></td>
                <td><span class="txn-type txn-<%= t.getTxnType() %>"><%= t.getTxnType() %></span></td>
                <td style="color:var(--gold-light);font-weight:600">₹<%= String.format("%,.2f", t.getAmount()) %></td>
                <td>₹<%= String.format("%,.2f", t.getBalanceAfter()) %></td>
                <td style="font-size:0.8rem"><%= t.getFromAccount() != null ? t.getFromAccount() : "—" %></td>
                <td style="font-size:0.8rem"><%= t.getToAccount()   != null ? t.getToAccount()   : "—" %></td>
                <td style="font-size:0.82rem;color:var(--text-muted)"><%= t.getDescription() != null ? t.getDescription() : "—" %></td>
                <td style="font-size:0.78rem;color:var(--text-muted)"><%= t.getTxnDate() %></td>
                <td><span class="status-badge status-<%= t.getStatus() %>"><%= t.getStatus() %></span></td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- TAB: LOANS -->
    <div id="tab-loans" class="tab-panel">
      <div class="card">
        <div class="card-header">
          <span class="card-title">My Loans</span>
          <button class="btn btn-primary btn-sm" onclick="openModal('loanModal')">+ Apply Loan</button>
        </div>
        <div class="table-wrap">
          <table>
            <thead><tr>
              <th>#</th><th>Type</th><th>Principal</th><th>Rate</th><th>Tenure</th><th>EMI</th><th>Status</th><th>Applied</th>
            </tr></thead>
            <tbody>
              <% for (Loan l : loans) { %>
              <tr>
                <td style="color:var(--text-muted)">#<%= l.getLoanId() %></td>
                <td><%= l.getLoanType() %></td>
                <td>₹<%= String.format("%,.2f", l.getPrincipal()) %></td>
                <td><%= l.getInterestRate() %>%</td>
                <td><%= l.getTenureMonths() %> months</td>
                <td style="color:var(--gold-light);font-weight:600">₹<%= String.format("%,.2f", l.getEmi()) %>/mo</td>
                <td><span class="status-badge status-<%= l.getStatus() %>"><%= l.getStatus() %></span></td>
                <td style="font-size:0.8rem;color:var(--text-muted)"><%= l.getAppliedDate() %></td>
              </tr>
              <% } %>
              <% if (loans.isEmpty()) { %><tr><td colspan="8" class="text-center text-muted">No loans found</td></tr><% } %>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- TAB: ACCOUNTS -->
    <div id="tab-accounts" class="tab-panel">
      <div class="card">
        <div class="card-header">
          <span class="card-title">My Accounts</span>
          <button class="btn btn-primary btn-sm" onclick="openModal('openAccountModal')">+ Open New</button>
        </div>
        <div class="account-cards">
          <% for (Account acc : accounts) { %>
          <div class="account-card">
            <div class="account-type-badge"><%= acc.getAccountType().replace('_',' ') %></div>
            <div class="account-number"><%= acc.getAccountNumber() %></div>
            <div class="account-balance">₹<%= String.format("%,.2f", acc.getBalance()) %> <span>INR</span></div>
            <div style="margin-top:0.75rem">
              <span class="status-badge status-<%= acc.getStatus() %>">● <%= acc.getStatus() %></span>
              <p style="font-size:0.75rem;margin-top:0.4rem">Interest Rate: <%= acc.getInterestRate() %>% p.a.</p>
              <p style="font-size:0.75rem">Opened: <%= acc.getOpenedDate() %></p>
            </div>
          </div>
          <% } %>
        </div>
      </div>
    </div>
  </main>
</div>

<!-- =========== MODALS =========== -->

<!-- Deposit -->
<div class="modal-overlay" id="depositModal">
  <div class="modal">
    <div class="modal-header">
      <h3>⬇️ Deposit Funds</h3>
      <button class="modal-close" onclick="closeModal('depositModal')">✕</button>
    </div>
    <form method="post" action="${pageContext.request.contextPath}/customer/dashboard">
      <input type="hidden" name="action" value="deposit">
      <div class="form-group">
        <label class="form-label">Select Account</label>
        <select name="accountNumber" class="form-select" required>
          <% for (Account a : accounts) { if ("ACTIVE".equals(a.getStatus())) { %>
          <option value="<%= a.getAccountNumber() %>"><%= a.getAccountNumber() %> — ₹<%= String.format("%,.2f", a.getBalance()) %></option>
          <% } } %>
        </select>
      </div>
      <div class="form-group">
        <label class="form-label">Amount (₹)</label>
        <input type="number" name="amount" class="form-control" placeholder="Enter amount" min="1" required>
      </div>
      <div style="display:flex;gap:0.75rem;justify-content:flex-end">
        <button type="button" class="btn btn-outline" onclick="closeModal('depositModal')">Cancel</button>
        <button type="submit" class="btn btn-success">Deposit</button>
      </div>
    </form>
  </div>
</div>

<!-- Withdraw -->
<div class="modal-overlay" id="withdrawModal">
  <div class="modal">
    <div class="modal-header">
      <h3>⬆️ Withdraw Funds</h3>
      <button class="modal-close" onclick="closeModal('withdrawModal')">✕</button>
    </div>
    <form method="post" action="${pageContext.request.contextPath}/customer/dashboard">
      <input type="hidden" name="action" value="withdraw">
      <div class="form-group">
        <label class="form-label">Select Account</label>
        <select name="accountNumber" class="form-select" required>
          <% for (Account a : accounts) { if ("ACTIVE".equals(a.getStatus())) { %>
          <option value="<%= a.getAccountNumber() %>"><%= a.getAccountNumber() %> — ₹<%= String.format("%,.2f", a.getBalance()) %></option>
          <% } } %>
        </select>
      </div>
      <div class="form-group">
        <label class="form-label">Amount (₹)</label>
        <input type="number" name="amount" class="form-control" placeholder="Enter amount" min="1" required>
      </div>
      <div style="display:flex;gap:0.75rem;justify-content:flex-end">
        <button type="button" class="btn btn-outline" onclick="closeModal('withdrawModal')">Cancel</button>
        <button type="submit" class="btn btn-danger">Withdraw</button>
      </div>
    </form>
  </div>
</div>

<!-- Transfer -->
<div class="modal-overlay" id="transferModal">
  <div class="modal">
    <div class="modal-header">
      <h3>↔️ Fund Transfer</h3>
      <button class="modal-close" onclick="closeModal('transferModal')">✕</button>
    </div>
    <form method="post" action="${pageContext.request.contextPath}/customer/dashboard">
      <input type="hidden" name="action" value="transfer">
      <div class="form-group">
        <label class="form-label">From Account</label>
        <select name="fromAccount" class="form-select" required>
          <% for (Account a : accounts) { if ("ACTIVE".equals(a.getStatus())) { %>
          <option value="<%= a.getAccountNumber() %>"><%= a.getAccountNumber() %> — ₹<%= String.format("%,.2f", a.getBalance()) %></option>
          <% } } %>
        </select>
      </div>
      <div class="form-group">
        <label class="form-label">To Account Number</label>
        <input type="text" name="toAccount" class="form-control" placeholder="e.g. ACC1000000002" required>
      </div>
      <div class="form-group">
        <label class="form-label">Amount (₹)</label>
        <input type="number" name="amount" class="form-control" placeholder="Enter amount" min="1" required>
      </div>
      <div class="form-group">
        <label class="form-label">Description</label>
        <input type="text" name="desc" class="form-control" placeholder="Optional note">
      </div>
      <div style="display:flex;gap:0.75rem;justify-content:flex-end">
        <button type="button" class="btn btn-outline" onclick="closeModal('transferModal')">Cancel</button>
        <button type="submit" class="btn btn-primary">Transfer</button>
      </div>
    </form>
  </div>
</div>

<!-- Open Account -->
<div class="modal-overlay" id="openAccountModal">
  <div class="modal">
    <div class="modal-header">
      <h3>➕ Open New Account</h3>
      <button class="modal-close" onclick="closeModal('openAccountModal')">✕</button>
    </div>
    <form method="post" action="${pageContext.request.contextPath}/customer/dashboard">
      <input type="hidden" name="action" value="openAccount">
      <div class="form-group">
        <label class="form-label">Account Type</label>
        <select name="type" class="form-select" required>
          <option value="SAVINGS">Savings Account — 3.5% p.a.</option>
          <option value="CURRENT">Current Account — 0% p.a.</option>
          <option value="FIXED_DEPOSIT">Fixed Deposit — 6.5% p.a.</option>
        </select>
      </div>
      <div style="display:flex;gap:0.75rem;justify-content:flex-end">
        <button type="button" class="btn btn-outline" onclick="closeModal('openAccountModal')">Cancel</button>
        <button type="submit" class="btn btn-primary">Open Account</button>
      </div>
    </form>
  </div>
</div>

<!-- Apply Loan -->
<div class="modal-overlay" id="loanModal">
  <div class="modal">
    <div class="modal-header">
      <h3>📝 Apply for Loan</h3>
      <button class="modal-close" onclick="closeModal('loanModal')">✕</button>
    </div>
    <form method="post" action="${pageContext.request.contextPath}/customer/dashboard">
      <input type="hidden" name="action" value="applyLoan">
      <div class="form-row">
        <div class="form-group">
          <label class="form-label">Loan Type</label>
          <select name="loanType" class="form-select" required>
            <option value="PERSONAL">Personal</option>
            <option value="HOME">Home</option>
            <option value="VEHICLE">Vehicle</option>
            <option value="EDUCATION">Education</option>
          </select>
        </div>
        <div class="form-group">
          <label class="form-label">Principal (₹)</label>
          <input type="number" name="principal" class="form-control" placeholder="Amount" min="1000" required>
        </div>
      </div>
      <div class="form-row">
        <div class="form-group">
          <label class="form-label">Interest Rate (% p.a.)</label>
          <input type="number" name="rate" class="form-control" value="10.5" step="0.1" required>
        </div>
        <div class="form-group">
          <label class="form-label">Tenure (months)</label>
          <input type="number" name="months" class="form-control" placeholder="e.g. 24" min="1" required>
        </div>
      </div>
      <div style="display:flex;gap:0.75rem;justify-content:flex-end">
        <button type="button" class="btn btn-outline" onclick="closeModal('loanModal')">Cancel</button>
        <button type="submit" class="btn btn-primary">Submit Application</button>
      </div>
    </form>
  </div>
</div>

<script>
function openModal(id)  { document.getElementById(id).classList.add('active'); }
function closeModal(id) { document.getElementById(id).classList.remove('active'); }
function showTab(name) {
  document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
  document.getElementById('tab-' + name).classList.add('active');
}
function setActive(el) {
  document.querySelectorAll('.sidebar-link').forEach(l => l.classList.remove('active'));
  el.classList.add('active');
}
// Close modal on overlay click
document.querySelectorAll('.modal-overlay').forEach(overlay => {
  overlay.addEventListener('click', e => { if (e.target === overlay) overlay.classList.remove('active'); });
});
</script>
</body>
</html>
