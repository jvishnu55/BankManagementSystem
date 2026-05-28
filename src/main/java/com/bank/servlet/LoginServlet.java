package com.bank.servlet;

import com.bank.dao.UserDAO;
import com.bank.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        // Already logged in?
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User u = (User) session.getAttribute("user");
            res.sendRedirect("ADMIN".equals(u.getRole()) ? "admin/dashboard" : "customer/dashboard");
            return;
        }
        req.getRequestDispatcher("/pages/login.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try {
            User user = userDAO.authenticate(username, password);
            if (user != null) {
                HttpSession session = req.getSession(true);
                session.setAttribute("user", user);
                session.setMaxInactiveInterval(30 * 60);
                res.sendRedirect("ADMIN".equals(user.getRole()) ? "admin/dashboard" : "customer/dashboard");
            } else {
                req.setAttribute("error", "Invalid username or password.");
                req.getRequestDispatcher("/pages/login.jsp").forward(req, res);
            }
        } catch (Exception e) {
            req.setAttribute("error", "Server error: " + e.getMessage());
            req.getRequestDispatcher("/pages/login.jsp").forward(req, res);
        }
    }
}
