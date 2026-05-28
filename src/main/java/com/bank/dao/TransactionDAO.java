package com.bank.dao;

import com.bank.model.Transaction;
import com.bank.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TransactionDAO {

    // ---- Transactions for an account ----
    public List<Transaction> getByAccount(String accNum) throws SQLException {
        List<Transaction> list = new ArrayList<>();
        String sql = "SELECT * FROM transactions WHERE from_account=? OR to_account=? ORDER BY txn_date DESC LIMIT 50";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, accNum);
            ps.setString(2, accNum);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ---- All transactions (admin) ----
    public List<Transaction> getAll() throws SQLException {
        List<Transaction> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery("SELECT * FROM transactions ORDER BY txn_date DESC LIMIT 200")) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    // ---- Count today's transactions ----
    public int countToday() throws SQLException {
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM transactions WHERE DATE(txn_date)=CURDATE()")) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private Transaction mapRow(ResultSet rs) throws SQLException {
        Transaction t = new Transaction();
        t.setTxnId(rs.getInt("txn_id"));
        t.setFromAccount(rs.getString("from_account"));
        t.setToAccount(rs.getString("to_account"));
        t.setTxnType(rs.getString("txn_type"));
        t.setAmount(rs.getBigDecimal("amount"));
        t.setBalanceAfter(rs.getBigDecimal("balance_after"));
        t.setDescription(rs.getString("description"));
        t.setTxnDate(rs.getTimestamp("txn_date"));
        t.setStatus(rs.getString("status"));
        return t;
    }
}
