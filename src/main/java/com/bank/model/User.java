package com.bank.model;

import java.sql.Timestamp;

public class User {
    private int userId;
    private String username;
    private String password;
    private String fullName;
    private String email;
    private String phone;
    private String role;       // ADMIN | CUSTOMER
    private Timestamp createdAt;
    private boolean active;

    public User() {}

    public User(int userId, String username, String fullName, String email,
                String phone, String role, boolean active) {
        this.userId = userId; this.username = username;
        this.fullName = fullName; this.email = email;
        this.phone = phone; this.role = role; this.active = active;
    }

    // ---- getters / setters ----
    public int getUserId()              { return userId; }
    public void setUserId(int v)        { userId = v; }
    public String getUsername()         { return username; }
    public void setUsername(String v)   { username = v; }
    public String getPassword()         { return password; }
    public void setPassword(String v)   { password = v; }
    public String getFullName()         { return fullName; }
    public void setFullName(String v)   { fullName = v; }
    public String getEmail()            { return email; }
    public void setEmail(String v)      { email = v; }
    public String getPhone()            { return phone; }
    public void setPhone(String v)      { phone = v; }
    public String getRole()             { return role; }
    public void setRole(String v)       { role = v; }
    public Timestamp getCreatedAt()     { return createdAt; }
    public void setCreatedAt(Timestamp v){ createdAt = v; }
    public boolean isActive()           { return active; }
    public void setActive(boolean v)    { active = v; }
}
