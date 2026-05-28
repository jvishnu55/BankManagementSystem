package com.bank.servlet;

import com.bank.dao.*;
import com.bank.model.*;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/customer/dashboard")
public class CustomerDashboardServlet extends HttpServlet {

    private final AccountDAO     accountDAO = new AccountDAO();
    private final TransactionDAO txnDAO     = new TransactionDAO();
    private final LoanDAO        loanDAO    = new LoanDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect(req.getContextPath() + "/login"); return;
        }
        User user = (User) session.getAttribute("user");
        loadData(req, user);
        req.getRequestDispatcher("/pages/customer-dashboard.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");
        String action = req.getParameter("action");

        try {
            switch (action == null ? "" : action) {
                case "deposit": {
                    String acc = req.getParameter("accountNumber");
                    BigDecimal amt = new BigDecimal(req.getParameter("amount"));
                    accountDAO.deposit(acc, amt, "Customer deposit");
                    req.setAttribute("success", "₹" + amt + " deposited successfully.");
                    break;
                }
                case "withdraw": {
                    String acc = req.getParameter("accountNumber");
                    BigDecimal amt = new BigDecimal(req.getParameter("amount"));
                    accountDAO.withdraw(acc, amt, "Customer withdrawal");
                    req.setAttribute("success", "₹" + amt + " withdrawn successfully.");
                    break;
                }
                case "transfer": {
                    String from = req.getParameter("fromAccount");
                    String to   = req.getParameter("toAccount");
                    BigDecimal amt = new BigDecimal(req.getParameter("amount"));
                    accountDAO.transfer(from, to, amt, req.getParameter("desc"));
                    req.setAttribute("success", "Transfer of ₹" + amt + " successful.");
                    break;
                }
                case "openAccount": {
                    accountDAO.createAccount(user.getUserId(), req.getParameter("type"));
                    req.setAttribute("success", "New account opened successfully.");
                    break;
                }
                case "applyLoan": {
                    BigDecimal principal = new BigDecimal(req.getParameter("principal"));
                    BigDecimal rate      = new BigDecimal(req.getParameter("rate"));
                    int months           = Integer.parseInt(req.getParameter("months"));
                    loanDAO.applyLoan(user.getUserId(), req.getParameter("loanType"), principal, rate, months);
                    req.setAttribute("success", "Loan application submitted.");
                    break;
                }
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }

        loadData(req, user);
        req.getRequestDispatcher("/pages/customer-dashboard.jsp").forward(req, res);
    }

    private void loadData(HttpServletRequest req, User user) {
        try {
            List<Account> accounts = accountDAO.getAccountsByUser(user.getUserId());
            req.setAttribute("accounts", accounts);
            req.setAttribute("loans",    loanDAO.getLoansByUser(user.getUserId()));
            // Transactions for first account
            if (!accounts.isEmpty()) {
                req.setAttribute("transactions", txnDAO.getByAccount(accounts.get(0).getAccountNumber()));
                req.setAttribute("primaryAccount", accounts.get(0));
            }
        } catch (Exception e) {
            req.setAttribute("dbError", e.getMessage());
        }
    }
}
