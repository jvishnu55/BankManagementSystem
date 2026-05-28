package com.bank.servlet;

import com.bank.dao.*;
import com.bank.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final UserDAO    userDAO    = new UserDAO();
    private final AccountDAO accountDAO = new AccountDAO();
    private final LoanDAO    loanDAO    = new LoanDAO();
    private final TransactionDAO txnDAO = new TransactionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect(req.getContextPath() + "/login"); return;
        }
        User user = (User) session.getAttribute("user");
        if (!"ADMIN".equals(user.getRole())) {
            res.sendRedirect(req.getContextPath() + "/customer/dashboard"); return;
        }
        try {
            req.setAttribute("totalCustomers",  userDAO.countCustomers());
            req.setAttribute("totalAccounts",   accountDAO.countActiveAccounts());
            req.setAttribute("totalDeposits",   accountDAO.getTotalDeposits());
            req.setAttribute("pendingLoans",    loanDAO.countPending());
            req.setAttribute("todayTxns",       txnDAO.countToday());
            req.setAttribute("recentTxns",      txnDAO.getAll());
            req.setAttribute("allCustomers",    userDAO.getAllCustomers());
            req.setAttribute("allAccounts",     accountDAO.getAllAccounts());
            req.setAttribute("allLoans",        loanDAO.getAllLoans());
        } catch (Exception e) {
            req.setAttribute("dbError", e.getMessage());
        }
        req.getRequestDispatcher("/pages/admin-dashboard.jsp").forward(req, res);
    }
}
