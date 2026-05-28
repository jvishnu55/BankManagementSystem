<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bank.model.*,java.util.*" %>
<%
    User user      = (User) session.getAttribute("user");
    List<User>        customers = (List<User>)        request.getAttribute("allCustomers");
    List<Account>     accounts  = (List<Account>)     request.getAttribute("allAccounts");
    List<Transaction> txns      = (List<Transaction>) request.getAttribute("recentTxns");
    List<Loan>        loans     = (List<Loan>)        request.getAttribute("allLoans");
    if (customers == null) customers = new ArrayList<>();
    if (accounts  == null) accounts  = new ArrayList<>();
    if (txns      == null) txns      = new ArrayList<>();
    if (loans     == null) loans     = new ArrayList<>();
    String actionSuccess = (String) session.getAttribute("actionSuccess");
    String actionError   = (String) session.getAttribute("actionError");
    session.removeAttribute("actionSuccess");
    session.removeAttribute("actionError");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>BankMS — Admin Dashboard</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
  <a class="navbar-brand" href="#">
    <span>🏦</span> BankMS <span style="font-size:0.7rem;color:var(--gold);margin-left:0.4rem;background:rgba(201,168,76,0.15);padding:0.15rem 0.5rem;border-radius:20px">ADMIN</span>
  </a>
  <div class="nav-links">
    <a class="nav-link" href="#" onclick="showTab('overview')">Overview</a>
    <a class="nav-link" href="#" onclick="showTab('customers')">Customers</a>
    <a class="nav-link" href="#" onclick="showTab('accounts')">Accounts</a>
    <a class="nav-link" href="#" onclick="showTab('loans')">Loans</a>
    <a class="nav-link" href="#" onclick="showTab('transactions')">Transactions</a>
  </div>
  <div class="nav-user">
    <div class="avatar">A</div>
    <span>Administrator</span>
    <a class="btn-logout" href="${pageContext.request.contextPath}/logout">Logout</a>
  </div>
</nav>

<div class="page-wrapper">
  <!-- SIDEBAR -->
  <aside class="sidebar">
    <div class="sidebar-section">
      <div class="sidebar-label">Administration</div>
      <button class="sidebar-link active" onclick="showTab('overview'); setActive(this)"><span class="icon">📊</span> Overview</button>
      <button class="sidebar-link" onclick="showTab('customers'); setActive(this)"><span class="icon">👥</span> Customers</button>
      <button class="sidebar-link" onclick="showTab('accounts'); setActive(this)"><span class="icon">💳</span> Accounts</button>
    </div>
    <div class="sidebar-section">
      <div class="sidebar-label">Operations</div>
      <button class="sidebar-link" onclick="showTab('loans'); setActive(this)"><span class="icon">🏠</span> Loan Approvals <% int pending = (Integer)(request.getAttribute("pendingLoans") != null ? request.getAttribute("pendingLoans") : 0); if (pending > 0) { %><span style="background:var(--danger);color:white;border-radius:20px;padding:0 0.4rem;font-size:0.7rem;margin-left:auto"><%= pending %></span><% } %></button>
      <button class="sidebar-link" onclick="showTab('transactions'); setActive(this)"><span class="icon">📋</span> Transactions</button>
    </div>
  </aside>

  <!-- MAIN -->
  <main class="main-content">
    <% if (actionSuccess != null) { %><div class="alert alert-success">✓ <%= actionSuccess %></div><% } %>
    <% if (actionError   != null) { %><div class="alert alert-danger">✗ <%= actionError %></div><% } %>

    <!-- TAB: OVERVIEW -->
    <div id="tab-overview" class="tab-panel active">
      <div class="page-header">
        <h1>Admin Dashboard</h1>
        <p class="breadcrumb">System overview · <%= new java.util.Date() %></p>
      </div>
      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-label">Total Customers</div>
          <div class="stat-value"><%= request.getAttribute("totalCustomers") %></div>
          <div class="stat-icon">👥</div>
        </div>
        <div class="stat-card">
          <div class="stat-label">Active Accounts</div>
          <div class="stat-value"><%= request.getAttribute("totalAccounts") %></div>
          <div class="stat-icon">💳</div>
        </div>
        <div class="stat-card">
          <div class="stat-label">Total Deposits</div>
          <div class="stat-value" style="font-size:1.3rem">₹<%= String.format("%,.0f", request.getAttribute("totalDeposits")) %></div>
          <div class="stat-icon">💰</div>
        </div>
        <div class="stat-card">
          <div class="stat-label">Pending Loans</div>
          <div class="stat-value" style="color:<%= ((Integer)request.getAttribute("pendingLoans") > 0) ? "var(--warning)" : "var(--gold-light)" %>"><%= request.getAttribute("pendingLoans") %></div>
          <div class="stat-icon">📝</div>
        </div>
        <div class="stat-card">
          <div class="stat-label">Today's Transactions</div>
          <div class="stat-value"><%= request.getAttribute("todayTxns") %></div>
          <div class="stat-icon">📋</div>
        </div>
      </div>

      <!-- Recent transactions -->
      <div class="card">
        <div class="card-header">
          <span class="card-title">Recent Transactions</span>
          <button class="btn btn-outline btn-sm" onclick="showTab('transactions')">View All</button>
        </div>
        <div class="table-wrap">
          <table>
            <thead><tr><th>#</th><th>Type</th><th>Amount</th><th>From</th><th>To</th><th>Date</th><th>Status</th></tr></thead>
            <tbody>
              <% for (int i = 0; i < Math.min(8, txns.size()); i++) { Transaction t = txns.get(i); %>
              <tr>
                <td style="color:var(--text-muted)">#<%= t.getTxnId() %></td>
                <td><span class="txn-type txn-<%= t.getTxnType() %>"><%= t.getTxnType() %></span></td>
                <td style="color:var(--gold-light);font-weight:600">₹<%= String.format("%,.2f", t.getAmount()) %></td>
                <td style="font-size:0.8rem"><%= t.getFromAccount() != null ? t.getFromAccount() : "—" %></td>
                <td style="font-size:0.8rem"><%= t.getToAccount()   != null ? t.getToAccount()   : "—" %></td>
                <td style="font-size:0.78rem;color:var(--text-muted)"><%= t.getTxnDate() %></td>
                <td><span class="status-badge status-<%= t.getStatus() %>"><%= t.getStatus() %></span></td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- TAB: CUSTOMERS -->
    <div id="tab-customers" class="tab-panel">
      <div class="page-header"><h1>Customers</h1></div>
      <div class="card">
        <div class="card-header"><span class="card-title">All Customers (<%= customers.size() %>)</span></div>
        <div class="table-wrap">
          <table>
            <thead><tr><th>#</th><th>Name</th><th>Username</th><th>Email</th><th>Phone</th><th>Joined</th><th>Status</th><th>Actions</th></tr></thead>
            <tbody>
              <% for (User c : customers) { %>
              <tr>
                <td style="color:var(--text-muted)">#<%= c.getUserId() %></td>
                <td>
                  <div style="display:flex;align-items:center;gap:0.5rem">
                    <div class="avatar" style="width:28px;height:28px;font-size:0.75rem"><%= c.getFullName().charAt(0) %></div>
                    <%= c.getFullName() %>
                  </div>
                </td>
                <td style="color:var(--text-muted)">@<%= c.getUsername() %></td>
                <td style="font-size:0.85rem"><%= c.getEmail() %></td>
                <td style="font-size:0.85rem"><%= c.getPhone() != null ? c.getPhone() : "—" %></td>
                <td style="font-size:0.78rem;color:var(--text-muted)"><%= c.getCreatedAt() != null ? c.getCreatedAt().toString().substring(0,10) : "" %></td>
                <td><span class="status-badge <%= c.isActive() ? "status-ACTIVE" : "status-CLOSED" %>"><%= c.isActive() ? "ACTIVE" : "INACTIVE" %></span></td>
                <td>
                  <form method="post" action="${pageContext.request.contextPath}/admin/action" style="display:inline">
                    <input type="hidden" name="action" value="toggleUser">
                    <input type="hidden" name="userId" value="<%= c.getUserId() %>">
                    <button type="submit" class="btn btn-outline btn-xs"><%= c.isActive() ? "Freeze" : "Activate" %></button>
                  </form>
                </td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- TAB: ACCOUNTS -->
    <div id="tab-accounts" class="tab-panel">
      <div class="page-header"><h1>All Accounts</h1></div>
      <div class="card">
        <div class="table-wrap">
          <table>
            <thead><tr><th>Account No.</th><th>Owner</th><th>Type</th><th>Balance</th><th>Status</th><th>Opened</th><th>Actions</th></tr></thead>
            <tbody>
              <% for (Account a : accounts) { %>
              <tr>
                <td style="font-size:0.82rem"><%= a.getAccountNumber() %></td>
                <td><%= a.getOwnerName() %></td>
                <td><span class="account-type-badge" style="font-size:0.7rem"><%= a.getAccountType() %></span></td>
                <td style="color:var(--gold-light);font-weight:600">₹<%= String.format("%,.2f", a.getBalance()) %></td>
                <td><span class="status-badge status-<%= a.getStatus() %>"><%= a.getStatus() %></span></td>
                <td style="font-size:0.78rem;color:var(--text-muted)"><%= a.getOpenedDate() %></td>
                <td>
                  <% if ("ACTIVE".equals(a.getStatus())) { %>
                  <form method="post" action="${pageContext.request.contextPath}/admin/action" style="display:inline">
                    <input type="hidden" name="action" value="freezeAccount">
                    <input type="hidden" name="accNum" value="<%= a.getAccountNumber() %>">
                    <button type="submit" class="btn btn-outline btn-xs">Freeze</button>
                  </form>
                  <% } else if ("FROZEN".equals(a.getStatus())) { %>
                  <form method="post" action="${pageContext.request.contextPath}/admin/action" style="display:inline">
                    <input type="hidden" name="action" value="activateAccount">
                    <input type="hidden" name="accNum" value="<%= a.getAccountNumber() %>">
                    <button type="submit" class="btn btn-success btn-xs">Activate</button>
                  </form>
                  <% } %>
                </td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- TAB: LOANS -->
    <div id="tab-loans" class="tab-panel">
      <div class="page-header"><h1>Loan Applications</h1></div>
      <div class="card">
        <div class="table-wrap">
          <table>
            <thead><tr><th>#</th><th>Applicant</th><th>Type</th><th>Principal</th><th>Rate</th><th>EMI</th><th>Status</th><th>Applied</th><th>Actions</th></tr></thead>
            <tbody>
              <% for (Loan l : loans) { %>
              <tr>
                <td style="color:var(--text-muted)">#<%= l.getLoanId() %></td>
                <td><%= l.getApplicantName() %></td>
                <td><span style="font-size:0.78rem;color:var(--text-muted)"><%= l.getLoanType() %></span></td>
                <td>₹<%= String.format("%,.2f", l.getPrincipal()) %></td>
                <td><%= l.getInterestRate() %>%</td>
                <td style="color:var(--gold-light)">₹<%= String.format("%,.2f", l.getEmi()) %>/mo</td>
                <td><span class="status-badge status-<%= l.getStatus() %>"><%= l.getStatus() %></span></td>
                <td style="font-size:0.78rem;color:var(--text-muted)"><%= l.getAppliedDate() %></td>
                <td>
                  <% if ("PENDING".equals(l.getStatus())) { %>
                  <form method="post" action="${pageContext.request.contextPath}/admin/action" style="display:inline">
                    <input type="hidden" name="action" value="approveLoan">
                    <input type="hidden" name="loanId" value="<%= l.getLoanId() %>">
                    <button type="submit" class="btn btn-success btn-xs">Approve</button>
                  </form>
                  <form method="post" action="${pageContext.request.contextPath}/admin/action" style="display:inline;margin-left:0.4rem">
                    <input type="hidden" name="action" value="rejectLoan">
                    <input type="hidden" name="loanId" value="<%= l.getLoanId() %>">
                    <button type="submit" class="btn btn-danger btn-xs">Reject</button>
                  </form>
                  <% } else { %>
                  <span style="color:var(--text-muted);font-size:0.8rem"><%= l.getApprovedDate() != null ? "Processed" : "—" %></span>
                  <% } %>
                </td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- TAB: TRANSACTIONS -->
    <div id="tab-transactions" class="tab-panel">
      <div class="page-header"><h1>All Transactions</h1></div>
      <div class="card">
        <div class="table-wrap">
          <table>
            <thead><tr><th>#</th><th>Type</th><th>Amount</th><th>Balance After</th><th>From</th><th>To</th><th>Description</th><th>Date</th><th>Status</th></tr></thead>
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

  </main>
</div>

<script>
function showTab(name) {
  document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
  document.getElementById('tab-' + name).classList.add('active');
}
function setActive(el) {
  document.querySelectorAll('.sidebar-link').forEach(l => l.classList.remove('active'));
  el.classList.add('active');
}
</script>
</body>
</html>
