package com.bank.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class AccountNumberGenerator {

    public static String generate() {
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT MAX(CAST(SUBSTRING(account_number,4) AS UNSIGNED)) FROM accounts")) {
            long last = 1000000000L;
            if (rs.next() && rs.getString(1) != null) last = rs.getLong(1) + 1;
            return "ACC" + last;
        } catch (Exception e) {
            return "ACC" + System.currentTimeMillis();
        }
    }
}
