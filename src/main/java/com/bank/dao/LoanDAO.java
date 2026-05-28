package com.bank.dao;

import com.bank.model.Loan;
import com.bank.util.DBConnection;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LoanDAO {

    private static final String SELECT_FULL =
        "SELECT l.*, u.full_name AS applicant_name FROM loans l " +
        "JOIN users u ON l.user_id = u.user_id ";

    // ---- Apply for loan ----
    public boolean applyLoan(int userId, String type, BigDecimal principal,
                             BigDecimal rate, int months) throws SQLException {
        BigDecimal emi = calcEMI(principal, rate, months);
        String sql = "INSERT INTO loans(user_id,loan_type,principal,interest_rate,tenure_months,emi,applied_date) VALUES(?,?,?,?,?,?,CURDATE())";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, type);
            ps.setBigDecimal(3, principal);
            ps.setBigDecimal(4, rate);
            ps.setInt(5, months);
            ps.setBigDecimal(6, emi);
            return ps.executeUpdate() > 0;
        }
    }

    // ---- Loans by user ----
    public List<Loan> getLoansByUser(int userId) throws SQLException {
        List<Loan> list = new ArrayList<>();
        String sql = SELECT_FULL + "WHERE l.user_id=? ORDER BY l.applied_date DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ---- All loans (admin) ----
    public List<Loan> getAllLoans() throws SQLException {
        List<Loan> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(SELECT_FULL + "ORDER BY l.applied_date DESC")) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ---- Approve / Reject loan ----
    public boolean updateLoanStatus(int loanId, String status) throws SQLException {
        String sql = status.equals("APPROVED")
            ? "UPDATE loans SET status=?, approved_date=CURDATE() WHERE loan_id=?"
            : "UPDATE loans SET status=? WHERE loan_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, loanId);
            return ps.executeUpdate() > 0;
        }
    }

    // ---- Count pending loans ----
    public int countPending() throws SQLException {
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM loans WHERE status='PENDING'")) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // ---- EMI = P * r*(1+r)^n / ((1+r)^n - 1) ----
    public static BigDecimal calcEMI(BigDecimal principal, BigDecimal annualRate, int months) {
        double P = principal.doubleValue();
        double r = annualRate.doubleValue() / (12 * 100);
        double emi = P * r * Math.pow(1 + r, months) / (Math.pow(1 + r, months) - 1);
        return BigDecimal.valueOf(emi).setScale(2, RoundingMode.HALF_UP);
    }

    private Loan mapRow(ResultSet rs) throws SQLException {
        Loan l = new Loan();
        l.setLoanId(rs.getInt("loan_id"));
        l.setUserId(rs.getInt("user_id"));
        l.setApplicantName(rs.getString("applicant_name"));
        l.setLoanType(rs.getString("loan_type"));
        l.setPrincipal(rs.getBigDecimal("principal"));
        l.setInterestRate(rs.getBigDecimal("interest_rate"));
        l.setTenureMonths(rs.getInt("tenure_months"));
        l.setEmi(rs.getBigDecimal("emi"));
        l.setStatus(rs.getString("status"));
        l.setAppliedDate(rs.getDate("applied_date"));
        l.setApprovedDate(rs.getDate("approved_date"));
        return l;
    }
}
