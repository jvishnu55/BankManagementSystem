package com.bank.servlet;

import com.bank.dao.*;
import com.bank.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/action")
public class AdminActionServlet extends HttpServlet {

    private final LoanDAO    loanDAO    = new LoanDAO();
    private final AccountDAO accountDAO = new AccountDAO();
    private final UserDAO    userDAO    = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(((User) session.getAttribute("user")).getRole())) {
            res.sendRedirect(req.getContextPath() + "/login"); return;
        }

        String action = req.getParameter("action");
        String msg    = "Action completed.";

        try {
            switch (action == null ? "" : action) {
                case "approveLoan":
                    loanDAO.updateLoanStatus(Integer.parseInt(req.getParameter("loanId")), "APPROVED");
                    msg = "Loan approved."; break;
                case "rejectLoan":
                    loanDAO.updateLoanStatus(Integer.parseInt(req.getParameter("loanId")), "REJECTED");
                    msg = "Loan rejected."; break;
                case "freezeAccount":
                    accountDAO.updateStatus(req.getParameter("accNum"), "FROZEN");
                    msg = "Account frozen."; break;
                case "activateAccount":
                    accountDAO.updateStatus(req.getParameter("accNum"), "ACTIVE");
                    msg = "Account activated."; break;
                case "toggleUser":
                    userDAO.toggleStatus(Integer.parseInt(req.getParameter("userId")));
                    msg = "User status toggled."; break;
            }
        } catch (Exception e) {
            req.getSession().setAttribute("actionError", e.getMessage());
            res.sendRedirect(req.getContextPath() + "/admin/dashboard"); return;
        }

        req.getSession().setAttribute("actionSuccess", msg);
        res.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }
}
