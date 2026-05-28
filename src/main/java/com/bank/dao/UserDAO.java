package com.bank.dao;

import com.bank.model.User;
import com.bank.util.DBConnection;
import com.bank.util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // ---- Authentication ----
    public User authenticate(String username, String password) throws SQLException {
        String sql = "SELECT * FROM users WHERE username=? AND is_active=TRUE";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String storedHash = rs.getString("password");
                if (PasswordUtil.verify(password, storedHash)) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    // ---- Register new customer ----
    public boolean register(User user) throws SQLException {
        String sql = "INSERT INTO users (username,password,full_name,email,phone,role) VALUES(?,?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, PasswordUtil.hash(user.getPassword()));
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhone());
            ps.setString(6, "CUSTOMER");
            return ps.executeUpdate() > 0;
        }
    }

    // ---- Get by ID ----
    public User getUserById(int id) throws SQLException {
        String sql = "SELECT * FROM users WHERE user_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? mapRow(rs) : null;
        }
    }

    // ---- All customers (for admin) ----
    public List<User> getAllCustomers() throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role='CUSTOMER' ORDER BY created_at DESC";
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ---- Update profile ----
    public boolean updateProfile(User user) throws SQLException {
        String sql = "UPDATE users SET full_name=?, email=?, phone=? WHERE user_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setInt(4, user.getUserId());
            return ps.executeUpdate() > 0;
        }
    }

    // ---- Change password ----
    public boolean changePassword(int userId, String newPassword) throws SQLException {
        String sql = "UPDATE users SET password=? WHERE user_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, PasswordUtil.hash(newPassword));
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    // ---- Toggle active status ----
    public boolean toggleStatus(int userId) throws SQLException {
        String sql = "UPDATE users SET is_active = NOT is_active WHERE user_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        }
    }

    // ---- Count users ----
    public int countCustomers() throws SQLException {
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM users WHERE role='CUSTOMER'")) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // ---- Check username exists ----
    public boolean usernameExists(String username) throws SQLException {
        String sql = "SELECT 1 FROM users WHERE username=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, username);
            return ps.executeQuery().next();
        }
    }

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setPhone(rs.getString("phone"));
        u.setRole(rs.getString("role"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        u.setActive(rs.getBoolean("is_active"));
        return u;
    }
}
