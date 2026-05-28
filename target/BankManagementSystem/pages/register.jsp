<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Bank MS — Register</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="login-page">
  <div class="login-card" style="max-width:500px">
    <div class="login-logo">
      <div style="font-size:2.5rem;margin-bottom:0.5rem">🏦</div>
      <h1>Open an Account</h1>
      <p>Join BankMS today</p>
    </div>

    <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-danger">✗ <%= request.getAttribute("error") %></div>
    <% } %>

    <form method="post" action="${pageContext.request.contextPath}/register">
      <div class="form-row">
        <div class="form-group">
          <label class="form-label">Full Name</label>
          <input type="text" name="fullName" class="form-control" placeholder="John Doe" required>
        </div>
        <div class="form-group">
          <label class="form-label">Username</label>
          <input type="text" name="username" class="form-control" placeholder="johndoe" required>
        </div>
      </div>
      <div class="form-group">
        <label class="form-label">Email Address</label>
        <input type="email" name="email" class="form-control" placeholder="john@example.com" required>
      </div>
      <div class="form-row">
        <div class="form-group">
          <label class="form-label">Phone Number</label>
          <input type="tel" name="phone" class="form-control" placeholder="9876543210">
        </div>
        <div class="form-group">
          <label class="form-label">Password</label>
          <input type="password" name="password" class="form-control" placeholder="Min 6 chars" required minlength="6">
        </div>
      </div>
      <button type="submit" class="btn btn-primary w-full" style="justify-content:center;margin-top:0.5rem">
        Create Account →
      </button>
    </form>

    <p class="text-center mt-2" style="font-size:0.85rem">
      Already have an account?
      <a href="${pageContext.request.contextPath}/login" style="color:var(--gold)">Sign In</a>
    </p>
  </div>
</div>
</body>
</html>
