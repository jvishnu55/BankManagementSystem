<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Bank MS — Login</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="login-page">
  <div class="login-card">
    <div class="login-logo">
      <div style="font-size:3rem;margin-bottom:0.5rem">🏦</div>
      <h1>BankMS</h1>
      <p>Secure Banking Management System</p>
    </div>

    <% if (request.getParameter("success") != null) { %>
      <div class="alert alert-success">✓ Registration successful! Please sign in.</div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-danger">✗ <%= request.getAttribute("error") %></div>
    <% } %>

    <form method="post" action="${pageContext.request.contextPath}/login">
      <div class="form-group">
        <label class="form-label">Username</label>
        <input type="text" name="username" class="form-control" placeholder="Enter username" required autofocus>
      </div>
      <div class="form-group">
        <label class="form-label">Password</label>
        <input type="password" name="password" class="form-control" placeholder="Enter password" required>
      </div>
      <button type="submit" class="btn btn-primary w-full" style="justify-content:center;margin-top:0.5rem">
        Sign In →
      </button>
    </form>

    <p class="text-center mt-2" style="font-size:0.85rem">
      New customer?
      <a href="${pageContext.request.contextPath}/register" style="color:var(--gold)">Open an Account</a>
    </p>

    <div style="margin-top:1.5rem;padding-top:1rem;border-top:1px solid var(--border)">
      <p style="font-size:0.75rem;color:var(--text-muted);text-align:center">
        Demo: <strong style="color:var(--gold)">admin / admin123</strong> &nbsp;|&nbsp;
        <strong style="color:var(--gold)">john_doe / pass1234</strong>
      </p>
    </div>
  </div>
</div>
</body>
</html>
