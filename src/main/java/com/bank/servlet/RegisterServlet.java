package com.bank.servlet;

import com.bank.dao.UserDAO;
import com.bank.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/pages/register.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String username  = req.getParameter("username");
        String password  = req.getParameter("password");
        String fullName  = req.getParameter("fullName");
        String email     = req.getParameter("email");
        String phone     = req.getParameter("phone");

        try {
            if (userDAO.usernameExists(username)) {
                req.setAttribute("error", "Username already taken.");
                req.getRequestDispatcher("/pages/register.jsp").forward(req, res);
                return;
            }
            User u = new User();
            u.setUsername(username); u.setPassword(password);
            u.setFullName(fullName); u.setEmail(email); u.setPhone(phone);
            userDAO.register(u);
            res.sendRedirect("login?success=registered");
        } catch (Exception e) {
            req.setAttribute("error", "Registration failed: " + e.getMessage());
            req.getRequestDispatcher("/pages/register.jsp").forward(req, res);
        }
    }
}
