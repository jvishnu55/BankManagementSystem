package com.bank.dao;

import com.bank.model.Account;
import com.bank.util.AccountNumberGenerator;
import com.bank.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AccountDAO {

    private static final String SELECT_FULL =
        "SELECT a.*, u.full_name AS owner_name FROM accounts a " +
        "JOIN users u ON a.user_id = u.user_id ";

    // ---- Create account ----
    public Account createAccount(int userId, String type) throws SQLException {
        String accNum = AccountNumberGenerator.generate();
        String sql = "INSERT INTO accounts (account_number,user_id,account_type,balance,opened_date) VALUES(?,?,?,0.00,CURDATE())";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, accNum);
            ps.setInt(2, userId);
            ps.setString(3, type);
            ps.executeUpdate();
        }
        return getByAccountNumber(accNum);
    }

    // ---- Get by account number ----
    public Account getByAccountNumber(String accNum) throws SQLException {
        String sql = SELECT_FULL + "WHERE a.account_number=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, accNum);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? mapRow(rs) : null;
        }
    }

    // ---- Accounts for a user ----
    public List<Account> getAccountsByUser(int userId) throws SQLException {
        List<Account> list = new ArrayList<>();
        String sql = SELECT_FULL + "WHERE a.user_id=? ORDER BY a.opened_date DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ---- All accounts (admin) ----
    public List<Account> getAllAccounts() throws SQLException {
        List<Account> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(SELECT_FULL + "ORDER BY a.account_id DESC")) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ---- Update balance (within transaction - pass Connection) ----
    public void updateBalance(Connection c, String accNum, BigDecimal newBalance) throws SQLException {
        String sql = "UPDATE accounts SET balance=? WHERE account_number=?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setBigDecimal(1, newBalance);
            ps.setString(2, accNum);
            ps.executeUpdate();
        }
    }

    // ---- Deposit ----
    public boolean deposit(String accNum, BigDecimal amount, String desc) throws SQLException {
        try (Connection c = DBConnection.getConnection()) {
            c.setAutoCommit(false);
            try {
                Account acc = getByAccountNumber(accNum);
                if (acc == null || !"ACTIVE".equals(acc.getStatus())) throw new SQLException("Account not active");
                BigDecimal newBal = acc.getBalance().add(amount);
                updateBalance(c, accNum, newBal);
                recordTxn(c, null, accNum, "DEPOSIT", amount, newBal, desc);
                c.commit();
                return true;
            } catch (Exception e) { c.rollback(); throw e; }
        }
    }

    // ---- Withdraw ----
    public boolean withdraw(String accNum, BigDecimal amount, String desc) throws SQLException {
        try (Connection c = DBConnection.getConnection()) {
            c.setAutoCommit(false);
            try {
                Account acc = getByAccountNumber(accNum);
                if (acc == null || !"ACTIVE".equals(acc.getStatus())) throw new SQLException("Account not active");
                if (acc.getBalance().compareTo(amount) < 0) throw new SQLException("Insufficient balance");
                BigDecimal newBal = acc.getBalance().subtract(amount);
                updateBalance(c, accNum, newBal);
                recordTxn(c, accNum, null, "WITHDRAWAL", amount, newBal, desc);
                c.commit();
                return true;
            } catch (Exception e) { c.rollback(); throw e; }
        }
    }

    // ---- Transfer ----
    public boolean transfer(String fromAcc, String toAcc, BigDecimal amount, String desc) throws SQLException {
        try (Connection c = DBConnection.getConnection()) {
            c.setAutoCommit(false);
            try {
                Account from = getByAccountNumber(fromAcc);
                Account to   = getByAccountNumber(toAcc);
                if (from == null || !"ACTIVE".equals(from.getStatus())) throw new SQLException("Source account not active");
                if (to   == null || !"ACTIVE".equals(to.getStatus()))   throw new SQLException("Destination account not active");
                if (from.getBalance().compareTo(amount) < 0) throw new SQLException("Insufficient balance");
                BigDecimal newFrom = from.getBalance().subtract(amount);
                BigDecimal newTo   = to.getBalance().add(amount);
                updateBalance(c, fromAcc, newFrom);
                updateBalance(c, toAcc,   newTo);
                recordTxn(c, fromAcc, toAcc, "TRANSFER", amount, newFrom, desc);
                c.commit();
                return true;
            } catch (Exception e) { c.rollback(); throw e; }
        }
    }

    // ---- Update status ----
    public boolean updateStatus(String accNum, String status) throws SQLException {
        String sql = "UPDATE accounts SET status=? WHERE account_number=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, accNum);
            return ps.executeUpdate() > 0;
        }
    }

    // ---- Total deposits (admin stat) ----
    public BigDecimal getTotalDeposits() throws SQLException {
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery("SELECT COALESCE(SUM(balance),0) FROM accounts WHERE status='ACTIVE'")) {
            return rs.next() ? rs.getBigDecimal(1) : BigDecimal.ZERO;
        }
    }

    // ---- Count active accounts ----
    public int countActiveAccounts() throws SQLException {
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM accounts WHERE status='ACTIVE'")) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // ---- Helper: insert transaction record ----
    private void recordTxn(Connection c, String from, String to, String type,
                           BigDecimal amount, BigDecimal balAfter, String desc) throws SQLException {
        String sql = "INSERT INTO transactions(from_account,to_account,txn_type,amount,balance_after,description) VALUES(?,?,?,?,?,?)";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, from);
            ps.setString(2, to);
            ps.setString(3, type);
            ps.setBigDecimal(4, amount);
            ps.setBigDecimal(5, balAfter);
            ps.setString(6, desc);
            ps.executeUpdate();
        }
    }

    private Account mapRow(ResultSet rs) throws SQLException {
        Account a = new Account();
        a.setAccountId(rs.getInt("account_id"));
        a.setAccountNumber(rs.getString("account_number"));
        a.setUserId(rs.getInt("user_id"));
        a.setOwnerName(rs.getString("owner_name"));
        a.setAccountType(rs.getString("account_type"));
        a.setBalance(rs.getBigDecimal("balance"));
        a.setInterestRate(rs.getBigDecimal("interest_rate"));
        a.setStatus(rs.getString("status"));
        a.setOpenedDate(rs.getDate("opened_date"));
        return a;
    }
}
