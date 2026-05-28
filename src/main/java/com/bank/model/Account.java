package com.bank.model;

import java.math.BigDecimal;
import java.sql.Date;

public class Account {
    private int accountId;
    private String accountNumber;
    private int userId;
    private String ownerName;       // joined from users
    private String accountType;     // SAVINGS | CURRENT | FIXED_DEPOSIT
    private BigDecimal balance;
    private BigDecimal interestRate;
    private String status;          // ACTIVE | FROZEN | CLOSED
    private Date openedDate;

    public Account() {}

    // ---- getters / setters ----
    public int getAccountId()               { return accountId; }
    public void setAccountId(int v)         { accountId = v; }
    public String getAccountNumber()        { return accountNumber; }
    public void setAccountNumber(String v)  { accountNumber = v; }
    public int getUserId()                  { return userId; }
    public void setUserId(int v)            { userId = v; }
    public String getOwnerName()            { return ownerName; }
    public void setOwnerName(String v)      { ownerName = v; }
    public String getAccountType()          { return accountType; }
    public void setAccountType(String v)    { accountType = v; }
    public BigDecimal getBalance()          { return balance; }
    public void setBalance(BigDecimal v)    { balance = v; }
    public BigDecimal getInterestRate()     { return interestRate; }
    public void setInterestRate(BigDecimal v){ interestRate = v; }
    public String getStatus()              { return status; }
    public void setStatus(String v)        { status = v; }
    public Date getOpenedDate()            { return openedDate; }
    public void setOpenedDate(Date v)      { openedDate = v; }
}
